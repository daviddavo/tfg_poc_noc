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
            output logic [BP_WIDTH-1:0] bp_o[PORTS],
            output logic ack[PORTS]
            );
   
   reg [$clog2(PORTS)-1:0] offset_reg;
            
   always_ff @ (posedge clk, posedge rst) begin
       if (rst) begin
         offset_reg <= 0;
       end else if (clk) begin
         offset_reg <= offset_reg + 1;
       end
   end

   always_comb begin 
      logic used[PORTS];

      // First resetting to 0
      for ( int i = 0; i < PORTS; i++ ) begin
        ack[i] = 0;
        used[i] = 0;
        data_o[i] = 0;
        bp_o[i] = 0;
      end
      
      // For each input port
      for ( int j = 0; j < PORTS; j++ ) begin
        // The jth one has priority
        // btw, this takes a while to synth
        int i = (j+offset_reg)%PORTS;
        if (dest_en[i] && !used[dest[i]]) begin
          ack[i] = 1;
          used[dest[i]] = 1;
          
          data_o[dest[i]] = data_i[i];
          bp_o[i] = bp_i[dest[i]];
        end
      end
   end
endmodule
