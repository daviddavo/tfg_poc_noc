`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2021 18:13:09
// Design Name: 
// Module Name: top_noc
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
module top_noc(
           input clk,
           input rst
           );
   
   node_port west_up[1] ();
   node_port west_down[1] ();
   
   node_port east_up[1] ();
   node_port east_down[1] ();
   
   node_port north_up [3] ();
   node_port north_down [3] ();
   
   node_port south_up[3] ();
   node_port south_down[3] ();
   
   mesh mesh( .rst (rst),
              .clk (clk),
              .west_up(west_up),
              .west_down(west_down),
              .east_up(east_up),
              .east_down(east_down),
              .north_up(north_up),
              .north_down(north_down),
              .south_up(south_up),
              .south_down(south_down)
              );
endmodule
