`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2021 18:13:09
// Design Name: 
// Module Name: node
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
interface node_port;
   flit_t flit;
   logic enable;
   
   // Backpressure
   logic ack;
   
   modport down (
                 input  flit,
                 input  enable, 
                 output ack
                 );
   
   modport up (
               input  ack,
               output flit,
               output enable
               );
endinterface

module node_link(
                 node_port.up up,
                 node_port.down down
                 );
   assign down.flit = up.flit;
   assign down.enable = up.enable;
   assign up.ack = down.ack;
endmodule

function e_dir dimensional_order_routing(int x, int y, addr_t dst);
   // TODO: Do this
   
   // This is the desired column
   if (dst.y == y) begin
      if (dst.x == x) begin
         // This should not happen
         $warning("Illegal state: Node received flit with himself as the destination");
      end else if (dst.x > x) begin
         return SOUTH;
      end else begin
         return NORTH;
      end
   end else if (dst.y > y) begin
      return EAST;
   end else begin // dst.y < y
      return WEST;
   end
endfunction

// TODO: Parameter con su pos dentor de la red
module node #(
              parameter X = 1,
              parameter Y = 1
              ) (
                 input clk,
                 input rst,

                 node_port.up ports_up[4],
                 node_port.down ports_down[4]
                 );
   
   // Definitions
   localparam PORTS = 4;
   typedef enum        { IDLE, ESTABLISHED } state_t;
   
   // Crossbar things
   // dest[NORTH] = EAST -> NORTH input is connected to EAST
   var e_dir dest[PORTS];
   logic               dest_en[PORTS];
   logic cb_ack[PORTS];
   // TODO: Use `FLIT_WIDTH
   logic [$bits(flit_t):0] data_i[PORTS];
   logic [$bits(flit_t):0] data_o[PORTS];
   
   // Node state
   reg                     state[PORTS];
   var e_dir         dest_reg[PORTS];
   
   crossbar #(
              .PORTS(PORTS),
              .WIDTH($bits(flit_t)+1)
              ) cb (
                    // Input
                    .data_i(data_i),
                    .dest(dest),
                    .dest_en(dest_en),
                    // Output
                    .data_o(data_o),
                    .ack(cb_ack)
                    );
   
   logic                   bp_data_i[PORTS];
   logic                   bp_data_o[PORTS];
   // Backpressure crossbar
   crossbar #(
              .PORTS(PORTS),
              .WIDTH(1)
              ) cbback (
                        // Input
                        .data_i(bp_data_i),
                        .dest(dest),
                        .dest_en(cb_ack),
                        .data_o(bp_data_o),
                        .ack()
                        );
   
   // Connect crossbar to data input/output
   genvar                  gi;
   generate
      for (gi = 0; gi < 4; gi++) begin
         // flits and enable crossbar
         assign data_i[gi] = { ports_down[gi].flit, ports_down[gi].enable };
         assign { ports_up[gi].flit, ports_up[gi].enable} = data_o[gi];
         
         // ports_down[gi].ack = ports_up[dest[gi]].ack;
         assign ports_down[gi].ack = bp_data_o[gi]; 
         assign bp_data_i[gi] = ports_up[gi].ack;
      end

      for (gi = 0; gi < 4; gi++) begin
         always_ff @ (posedge clk, posedge rst) begin
            if (rst) begin
               state[gi] <= IDLE;
               dest_reg[gi] <= NORTH;
            end else if (clk) begin
               flit_t flit = ports_down[gi].flit;
               case (state[gi])
                 IDLE:
                   // If there is a header trying to enter and the comb logic gave us the ack
                   if (ports_down[gi].enable && flit.flit_type == HEADER && ports_down[gi].ack) begin                      
                      state[gi] <= ESTABLISHED;
                      dest_reg[gi] <= dest[gi];
                   end
                 ESTABLISHED:
                   begin
                      if (flit.flit_type == TAIL) begin
                         state[gi] <= IDLE;
                         dest_reg[gi] <= NORTH;
                      end
                   end
               endcase
            end
         end
         
         always_comb begin
            // Common signals and defaults
            flit_t flit = ports_down[gi].flit;
            control_hdr_t hdr = flit.payload;
            dest_en[gi] = 0;
            
            case( state[gi] )
              IDLE:
                if (flit.flit_type == HEADER)
                  begin
                     dest[gi] = dimensional_order_routing(X, Y, hdr.dst_addr);
                     dest_en[gi] = 1;
                     
                     // If the crossbar signals us ok
                     if (cb_ack[gi]) begin
                        // We try to connect to the next router
                        // ports_up[dest[gi]].enable = 1;
                        
                        // ports_down[gi].ack = ports_up[dest[gi]].ack;
                     end
                  end 
              ESTABLISHED:
                begin
                   dest[gi] = dest_reg[gi];
                   dest_en[gi] = 1;
                   
                   // ports_up[dest[gi]].enable = 1;
                   // ports_down[gi].ack = 1;
                end
            endcase
            
            // assert (state[gi] == ESTABLISHED -> ports_up[dest[gi]].ack);
         end
      end
   endgenerate
endmodule
