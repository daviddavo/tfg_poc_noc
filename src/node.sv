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
import noc_types::*;

// Priority: HORIZONTAL > VERTICAL
function e_dir dimensional_order_routing_h(int x, int y, addr_t dst);
   // This is the desired column
   if (dst.y == y) begin
      if (dst.x == x) begin
         // This should not happen
         $display("Illegal state: Node received flit with himself as the destination");
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

function e_dir dimensional_order_routing_v(int x, int y, addr_t dst);
    if (dst.x == x) begin
        if (dst.y == y) begin
            $display("Illegal state: Node received flit with himself as the destination");
        end else if (dst.y > y) begin
            return EAST;
        end else begin
            return WEST;
        end
    end else if (dst. x > x) begin
        return SOUTH;
    end else begin
        return NORTH;
    end
endfunction

// DOR but only in the directions that does not make the package fall out of the edge
// - do horizontal priority on north and south edges
// - do vertical priority on east and west edges
// - on corners, be mindful of the "default edge"
//   i.e: on bottom corners, be careful if the destination is south edge
function e_dir dimensional_order_routing_edgeaware(int x, int y, int x_max, int y_max, addr_t dst);
    // top corners
    if ( x == 1 && ( y == 1 || y == y_max-1 ) && dst.x != 0) return dimensional_order_routing_v(x, y, dst);
    // bot corners
    if ( x == x_max-1 && ( y == 1 || y == y_max-1) && dst.x != x_max) return dimensional_order_routing_v(x, y, dst);
    
    // If we are on an horizontal (NORTH | SOUTH) edge, we do horizontal prioritized DOR
    if ( x == 1 || x == x_max-1 )
        return dimensional_order_routing_h(x, y, dst);
    // Otherwise we do vertically prioritized DOR    
    else
        return dimensional_order_routing_v(x, y, dst);
endfunction

module node #(
              parameter X = 1,
              parameter Y = 1,
              parameter X_EDGE = 1,
              parameter Y_EDGE = 1,
              localparam PORTS = 4
              ) (
                 input clk,
                 input rst,

                 node_port.up ports_up[PORTS],
                 node_port.down ports_down[PORTS]
                 );
   
   
   // Definitions
   typedef enum logic [1:0] { IDLE, ESTABLISHED } e_state;
   
   // Crossbar things
   // dest[NORTH] = EAST -> NORTH input is connected to EAST
   var e_dir dest[PORTS];
   logic               dest_en[PORTS];
   logic cb_ack[PORTS];
   
   // `FLIT_WIDTH + enable + ack
   localparam CB_WIDTH = $bits(flit_t)+1;
   logic [CB_WIDTH-1:0] data_i[PORTS];
   logic                bp_data_i[PORTS];
   logic [CB_WIDTH-1:0] data_o[PORTS];
   logic                bp_data_o[PORTS];
   
   // Node state
   var e_state state[PORTS];
   var e_dir         dest_reg[PORTS];
   
   crossbar_rr #(
              .PORTS(PORTS),
              .WIDTH(CB_WIDTH)
              ) cb (
                    // Input
                    .clk(clk), 
                    .rst(rst),
                    .data_i(data_i),
                    .bp_i(bp_data_i),
                    .dest(dest),
                    .dest_en(dest_en),
                    // Output
                    .data_o(data_o),
                    .bp_o(bp_data_o),
                    .ack(cb_ack)
                    );
                    
   function automatic logic dest_established(e_dir dst2chk);
       for (int i = 0; i < PORTS; i++)
           if (dest_reg[i] == dst2chk && state[i] == ESTABLISHED)
               return 1;
       
       return 0;
   endfunction: dest_established
   
   genvar                  gi;
   generate
      // Connect crossbar to data input/output
      for (gi = 0; gi < PORTS; gi++) begin
         // flits and enable crossbar
         assign data_i[gi] = { ports_down[gi].flit, ports_down[gi].enable };
         assign { ports_up[gi].flit, ports_up[gi].enable } = data_o[gi];
         
         // ack for way back crossbar
         assign bp_data_i[gi] = ports_up[gi].ack;
         assign ports_down[gi].ack = bp_data_o[gi]; 
      end

      for (gi = 0; gi < PORTS; gi++) begin
         always_ff @ (posedge clk, posedge rst) begin
            if (rst) begin
               state[gi] <= IDLE;
               dest_reg[gi] <= NORTH;
            end else if (clk) begin
               automatic flit_t flit = ports_down[gi].flit;
               case (state[gi])
                 IDLE:
                   // If there is a header trying to enter and the comb logic gave us the ack
                   if (ports_down[gi].ack && flit.flit_type == HEADER) begin                      
                      state[gi] <= ESTABLISHED;
                      dest_reg[gi] <= dest[gi];
                   end
                 ESTABLISHED:
                   begin
                      // If we received the ack in the past, we keep it while we are stablished
                      noSteal: assert(ports_down[gi].ack);
                      
                      // Free resources
                      if (flit.flit_type == TAIL) begin
                         state[gi] <= IDLE;
                         dest_reg[gi] <= NORTH;
                      end
                   end
               endcase
            end
         end
         
         // combinational loop
         // always @(ports_down[gi].flit, ports_down[gi].enable, dest[gi], dest_reg, state) begin
         always_comb begin
            // Common signals and defaults
            automatic flit_t flit = ports_down[gi].flit;
            automatic flit_hdr_t hdr = flit.payload;
            dest[gi] = NORTH;
            dest_en[gi] = 0;
            
            case( state[gi] )
              IDLE:
                if (ports_down[gi].enable && flit.flit_type == HEADER) begin
                   dest[gi] = dimensional_order_routing_edgeaware(X, Y, X_EDGE, Y_EDGE, hdr.dst_addr);
                   dest_en[gi] = !dest_established(dest[gi]); // THIS CREATES THE CONFLICT!!
                end 
              ESTABLISHED:
                begin
                   dest[gi] = dest_reg[gi];
                   dest_en[gi] = 1;
                end
            endcase
            // TODO: assert no two have the same destination allocated (if it is enabled) 
         end
      end
   endgenerate
endmodule
