`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.02.2022 18:09:10
// Design Name: 
// Module Name: node_link
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// The link between two ports from two different nodes
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module node_link(
                 // Input
                 node_port.down down,
                 // Output
                 node_port.up up
                 );
   assign up.flit = down.flit;
   assign up.enable = down.enable;
   assign down.ack = up.ack;
endmodule
