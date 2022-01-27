`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 26.01.2022 12:11:03
// Design Name: 
// Module Name: crossbar_bp
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Implementation of 2-way crossbar 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
module crossbar_bp #(
          parameter PORTS = 2,
          parameter WIDTH = 8,
          parameter BP_WIDTH = 1
          )(
            input [WIDTH-1:0]           data_i[PORTS],
            input [BP_WIDTH-1:0]        bp_i[PORTS],
            input [$clog2(PORTS)-1:0]   dest[PORTS],
            input                       dest_en[PORTS],

            output logic [WIDTH-1:0] data_o[PORTS],
            output logic [BP_WIDTH-1:0] bp_o[PORTS],
            output logic ack[PORTS]
            );

   always_comb begin 
      logic used[PORTS];

      // First resetting to 0
      for ( int j = 0; j < PORTS; j++ ) begin
        ack[j] = 0;
        used[j] = 0;
        data_o[j] = 0;
        bp_o[j] = 0;
      end
      
      // For each input port
      for ( int i = 0; i < PORTS; i++ ) begin
        if (dest_en[i] && !used[dest[i]]) begin
          ack[i] = 1;
          used[dest[i]] = 1;
          
          data_o[dest[i]] = data_i[i];
          bp_o[i] = bp_i[dest[i]];
        end
      end
   end
endmodule
