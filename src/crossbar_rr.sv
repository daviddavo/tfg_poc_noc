`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: David Davó
// 
// Create Date: 02.02.2022 18:15:34
// Design Name: 
// Module Name: crossbar_rr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Implementation of 2-way crossbar with round-robin priority
// Every clock the prioritized input will change to the next one
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
module crossbar_rr #(
          parameter PORTS = 2,
          parameter WIDTH = 8,
          parameter BP_WIDTH = 1
          )(
            input                       clk,
            input                       rst,
            input [WIDTH-1:0]           data_i[PORTS],
            input [BP_WIDTH-1:0]        bp_i[PORTS],
            input [$clog2(PORTS)-1:0]   dest[PORTS],
            input                       dest_en[PORTS],

            output logic [WIDTH-1:0] data_o[PORTS],
            output logic data_o_en[PORTS],
            output logic [BP_WIDTH-1:0] bp_o[PORTS],
            output logic ack[PORTS]
            );
   
   reg [$clog2(PORTS)-1:0] offset_reg;
   reg [$clog2(PORTS)-1:0] used [PORTS];
   reg used_valid[PORTS];
   
   function logic is_used(int dst2chk);
       for (int i = 0; i < PORTS; i++) begin
           if (dest[i] == dst2chk && ack[i]) return 1;
       end
       
       return 0;
   endfunction: is_used
            
   always_ff @ (posedge clk, posedge rst) begin
       if (rst) begin
         offset_reg <= 0;
       end else if (clk) begin
         offset_reg <= offset_reg + 1;
       end
   end
   
   always_comb begin : set_used
      // First resetting to 0
      for ( int i = 0; i < PORTS; i++ ) begin
        used_valid[i] = 0;
      end
      
      // For each input port
      for ( int j = 0; j < PORTS; j++ ) begin
        // The one with highest j has priority
        automatic int i = (j+offset_reg)%PORTS;
        if (dest_en[i]) begin
          used[dest[i]] = i;
          used_valid[dest[i]] = 1;
        end
      end
   end : set_used

   always_comb begin : assign_output
      // First resetting to 0
      for ( int j = 0; j < PORTS; j++ ) begin
        ack[j] = 0;
        data_o[j] = 0;
        bp_o[j] = 0;
        data_o_en[j] = 0;
      end
      
      // For each used destination port
      for ( int j = 0; j < PORTS; j++ ) begin
        automatic int i = (j+offset_reg)%PORTS;
        // automatic int i = j;
        if (used_valid[i]) begin
          assert(dest[used[i]] == i);
          ack[used[i]] = 1;
          data_o[dest[used[i]]] = data_i[used[i]];
          data_o_en[dest[used[i]]] = 1;
          bp_o[used[i]] = bp_i[dest[used[i]]];
        end
      end
   end : assign_output
endmodule
