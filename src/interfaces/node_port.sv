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
   
   // Tells whether the whole path has been established
   logic ack;
   // Reject. Inmediately cancels the propagation
   logic rej;
   
   modport down (
                 input  flit,
                 input  enable, 
                 output ack,
                 output rej
                 );
   
   modport up (
               input  ack,
               input  rej,
               output flit,
               output enable
               );
endinterface

