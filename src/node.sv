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
    // left edge
    if ( y == 1 && dst.y == 0 ) return dimensional_order_routing_v(x, y, dst);
    // right edge
    if ( y == y_max-1 && dst.y == y_max ) return dimensional_order_routing_v(x, y, dst);
    
    return dimensional_order_routing_h(x, y, dst);
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
   typedef enum { IDLE, ESTABLISHED, ESTABLISHING, TAIL_WAIT } e_state;
   
   // Crossbar things
   // dest[NORTH] = EAST -> NORTH input is connected to EAST
   var e_dir dest[PORTS];
   logic               dest_en[PORTS];
   logic cb_ack[PORTS];
   
   // `FLIT_WIDTH + enable + ack
   localparam CB_WIDTH = $bits(flit_t)+1;
   wire  [CB_WIDTH-1:0] data_i[PORTS];
   wire  [1:0]          bp_data_i[PORTS];
   wire  [CB_WIDTH-1:0] data_o[PORTS];
   reg   [CB_WIDTH-1:0] data_o_reg[PORTS];
   wire                 data_o_en[PORTS];
   reg   [CB_WIDTH-1:0] data_o_en_reg[PORTS];
   wire  [1:0]          bp_data_o[PORTS];
   wire                 bp_ack[PORTS];
   wire                 bp_rej[PORTS];
   
   // Node state
   var e_state state[PORTS];
   var e_state nextstate[PORTS];
   var e_dir   dest_reg[PORTS];
   
   crossbar_rr #(
              .PORTS(PORTS),
              .WIDTH(CB_WIDTH),
              .BP_WIDTH(2) // ack
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
                    .data_o_en(data_o_en),
                    .bp_o(bp_data_o),
                    .ack(cb_ack)
                    );
        
   // Returns 0 if there is someone using the required port            
   function automatic logic dest_idle(e_dir dst2chk, int i_skip = -1);
       for (int i = 0; i < PORTS; i++)
           if (i != i_skip && dest_reg[i] == dst2chk && state[i] != IDLE)
               return 0;
       
       return 1;
   endfunction: dest_idle
   
   function automatic logic is_loopback(e_dir dst, e_dir src);
       if (dst == NORTH && X == 1) return 0;
       if (dst == SOUTH && X == X_EDGE-1) return 0;
       if (dst == WEST && Y == 1) return 0;
       if (dst == EAST && Y == Y_EDGE-1) return 0;
   
       return dst == src;
   endfunction: is_loopback
   
   genvar                  gi;
   generate
      // Connect crossbar to data input/output
      for (gi = 0; gi < PORTS; gi++) begin
         // flits and enable crossbar
         // assign data_i[gi] = { ports_down[gi].flit, ports_down[gi].enable };
         assign data_i[gi] = ports_down[gi].flit;
         // assign { ports_up[gi].flit, ports_up[gi].enable } = data_o[gi];
         assign ports_up[gi].flit = data_o_reg[gi];
         assign ports_up[gi].enable = data_o_en_reg[gi];
         
         // ack for way back crossbar
         assign bp_data_i[gi] = { ports_up[gi].ack, ports_up[gi].rej };
         assign { bp_ack[gi], bp_rej[gi] } = bp_data_o[gi];
      end

      for (gi = 0; gi < PORTS; gi++) begin
         always_ff @ (posedge clk, posedge rst) begin
            if (rst) begin
               state[gi] <= IDLE;
               dest_reg[gi] <= NORTH;
                data_o_reg[gi] <= 0;
                data_o_en_reg[gi] <= 0;
            end else if (clk) begin
               state[gi] <= nextstate[gi];
               dest_reg[gi] <= dest[gi];
                data_o_reg[gi] <= data_o[gi];
                data_o_en_reg[gi] <= data_o_en[gi];
            end
         end
         
         // TODO: solve combinatiorial loop
         always_comb begin
            // Common signals and default
            automatic flit_t flit = ports_down[gi].flit;
            automatic flit_hdr_t hdr = flit.payload;
            
            dest[gi] = NORTH;
            dest_en[gi] = 0;
            nextstate[gi] = state[gi];
            ports_down[gi].ack = 0;
            ports_down[gi].rej = 0;
            
            // When rst, keep everything to zero
            if (!rst) begin
                case( state[gi] )
                  IDLE:
                    begin
                        automatic e_dir aux_dst = dimensional_order_routing_edgeaware(X, Y, X_EDGE, Y_EDGE, hdr.dst_addr);
                        automatic logic is_available = !is_loopback(aux_dst, e_dir'(gi)) && dest_idle(aux_dst, gi);
                        
                        if (ports_down[gi].enable && flit.flit_type == HEADER && is_available) begin
                            dest[gi] = aux_dst;
                            dest_en[gi] = 1;
                            
                            if (cb_ack[gi])
                                nextstate[gi] = ESTABLISHING;
                        end
                    end
                  ESTABLISHING:
                    if (bp_rej[gi]) begin
                      nextstate[gi] = IDLE;
                      ports_down[gi].rej = 1;
                    end else begin
                      assert(dimensional_order_routing_edgeaware(X, Y, X_EDGE, Y_EDGE, hdr.dst_addr) == dest_reg[gi]);
                      dest[gi] = dest_reg[gi];
                      dest_en[gi] = 1;

                      if (bp_ack[gi]) begin
                        nextstate[gi] = ESTABLISHED;
                        ports_down[gi].ack = 1;
                      end else begin
                        nextstate[gi] = ESTABLISHING;
                      end
                    end
                  ESTABLISHED:
                    begin
                       // TODO: What if state is stablished but the packet has "already" passed
                       assert(ports_down[gi].enable);
                       assert property (@ (posedge clk) clk |=> flit.flit_type != HEADER);
                       assert property (@ (posedge clk) clk |=> bp_ack[gi]);
                       
                       ports_down[gi].ack = 1;
                       dest[gi] = dest_reg[gi];
                       dest_en[gi] = 1;
                       
                       if (flit.flit_type == TAIL)
                           nextstate[gi] = TAIL_WAIT;
                       else
                           nextstate[gi] = ESTABLISHED;
                    end
                  // Makes the test more readable. Perhaps it could be eliminated.
                  TAIL_WAIT:
                    begin
                       dest[gi] = dest_reg[gi];
                       nextstate[gi] = IDLE;
                    end
                endcase 
            end
         end
      end
   endgenerate
endmodule
