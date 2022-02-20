`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.02.2022 18:10:27
// Design Name: 
// Module Name: node_port
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Interface port between two nodes
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
import noc_types::flit_t;
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

