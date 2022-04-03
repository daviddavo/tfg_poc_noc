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
module top_noc #(
   parameter MESH_HEIGHT = `MESH_HEIGHT,
   parameter MESH_WIDTH = `MESH_WIDTH
) (
           input clk,
           input rst,
		   
		   // INPUT PORTS
           input  [`FLIT_WIDTH-1:0][MESH_WIDTH-1:0] north_flit_in,
           input  [MESH_WIDTH-1:0]                  north_flit_in_en,
           output [MESH_WIDTH-1:0]                  north_flit_in_ack,
           
           input [`FLIT_WIDTH-1:0] south_flit_in [MESH_WIDTH],
           input                   south_flit_in_en [MESH_WIDTH],
           output                  south_flit_in_ack [MESH_WIDTH],
           
           input [`FLIT_WIDTH-1:0] east_flit_in [MESH_HEIGHT],
           input                   east_flit_in_en [MESH_HEIGHT],
           output                  east_flit_in_ack [MESH_HEIGHT],
           
           input [`FLIT_WIDTH-1:0] west_flit_in [MESH_HEIGHT],
           input                   west_flit_in_en [MESH_HEIGHT],
           output                  west_flit_in_ack [MESH_HEIGHT],
		   
		   // OUTPUT PORTS
		   output [`FLIT_WIDTH-1:0] north_flit_out [MESH_WIDTH],
           output                   north_flit_out_en [MESH_WIDTH],
           input                    north_flit_out_ack [MESH_WIDTH],
           
           output [`FLIT_WIDTH-1:0] south_flit_out [MESH_WIDTH],
           output                   south_flit_out_en [MESH_WIDTH],
           input                    south_flit_out_ack [MESH_WIDTH],
           
           output [`FLIT_WIDTH-1:0] east_flit_out [MESH_HEIGHT],
           output                   east_flit_out_en [MESH_HEIGHT],
           input                    east_flit_out_ack [MESH_HEIGHT],
           
           output [`FLIT_WIDTH-1:0] west_flit_out [MESH_HEIGHT],
           output                   west_flit_out_en [MESH_HEIGHT],
           input                    west_flit_out_ack [MESH_HEIGHT]
           );
   
   node_port west_up[MESH_HEIGHT] ();
   node_port west_down[MESH_HEIGHT] ();
   
   node_port east_up[MESH_HEIGHT] ();
   node_port east_down[MESH_HEIGHT] ();
   
   node_port north_up [MESH_WIDTH] ();
   node_port north_down [MESH_WIDTH] ();
   
   node_port south_up[MESH_WIDTH] ();
   node_port south_down[MESH_WIDTH] ();
   
   mesh #(
     .MESH_HEIGHT(MESH_HEIGHT),
     .MESH_WIDTH(MESH_WIDTH)
   ) mesh(
     .rst (rst),
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
   
   generate
      genvar          i, j;
      for ( i = 0; i < MESH_WIDTH; i++) begin: horizontal
         assign north_down[i].enable = north_flit_in_en[i];
         assign north_down[i].flit   = north_flit_in[i];
         assign north_flit_in_ack[i] = north_down[i].ack;

		 assign south_down[i].flit   = south_flit_in[i];
         assign south_down[i].enable = south_flit_in_en[i];
         assign south_flit_in_ack[i] = south_down[i].ack;
		 
		 assign north_flit_out_en[i]  = north_up[i].enable;
		 assign north_flit_out[i]     = north_up[i].flit;
		 assign north_up[i].ack       = north_flit_out_ack[i];
		 
		 assign south_flit_out_en[i]  = south_up[i].enable;
		 assign south_flit_out[i]     = south_up[i].flit;
		 assign south_up[i].ack       = south_flit_out_ack[i];
      end
	  
	  for ( j = 0; j < MESH_HEIGHT; j++) begin: vertical
         assign east_down[j].enable = east_flit_in_en[j];
         assign east_down[j].flit   = east_flit_in[j];
         assign east_flit_in_ack[j] = east_down[j].ack;

		 assign west_down[j].flit   = west_flit_in[j];
         assign west_down[j].enable = west_flit_in_en[j];
         assign west_flit_in_ack[j] = west_down[j].ack;

		 assign east_flit_out_en[j]  = east_up[j].enable;
		 assign east_flit_out[j]     = east_up[j].flit;
		 assign east_up[j].ack       = east_flit_out_ack[j];
		 
		 assign west_flit_out_en[j]  = west_up[j].enable;
		 assign west_flit_out[j]     = west_up[j].flit;
		 assign west_up[j].ack       = west_flit_out_ack[j];
	  end
   endgenerate
endmodule
