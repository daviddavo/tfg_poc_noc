`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2022 12:11:03
// Design Name: 
// Module Name: crossbar
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Implementation of a crossbar with multicast 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   Based on https://stackoverflow.com/questions/70606907/reduction-or-with-stride/70608835#70608835
//////////////////////////////////////////////////////////////////////////////////
module crossbar #(
          parameter PORTS = 2,
          parameter WIDTH = 8
          )(
            input [WIDTH-1:0]        data_i[PORTS],
            input [PORTS-1:0]        dest[PORTS],
            input            dest_en[PORTS],

            output logic [WIDTH-1:0] data_o[PORTS],
            output logic [PORTS-1:0] ack
            );

   always_comb begin 
      logic used[PORTS];

      // First resetting to 0
      for ( int j = 0; j < PORTS; j++ ) begin
        used[j] = 0;
        data_o[j] = 0;
      end
      
      // For each input port
      for ( int i = 0; i < PORTS; i++ ) begin
        if (dest_en[i] && !used[dest[i]]) begin
          ack[i] = 1;
          used[dest[i]] = 1;
          data_o[dest[i]] = data_i[i];
        end
      end
   end
endmodule
