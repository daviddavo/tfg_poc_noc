`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2021 18:14:30
// Design Name: 
// Module Name: mesh
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

module mesh_wrapper #(
              parameter MESH_HEIGHT = 2,
              parameter MESH_WIDTH = 2
              )(
                // Port List
                input clk,
                input rst,

                node_port.up west_up[MESH_HEIGHT],
                node_port.down west_down[MESH_HEIGHT],

                node_port.up east_up[MESH_HEIGHT],
                node_port.down east_down[MESH_HEIGHT],

                node_port.up north_up [MESH_WIDTH],
                node_port.down north_down [MESH_WIDTH],

                node_port.up south_up[MESH_WIDTH],
                node_port.down south_down[MESH_WIDTH]
                );

	`ifdef POST_SYNTHESIS
		mesh #(
            .MESH_HEIGHT(MESH_HEIGHT),
            .MESH_WIDTH(MESH_WIDTH)
        ) mesh (.*);
    `else
		// Step 1: Generate the assigns.
		//   Careful: interfaces are accesed like if[attr] on post-synth but like if.attr on elaboration
		// Step 2: Replace "input" and "output" with logic
generate
        //--------------------
        // Generating signals 
        //--------------------
        logic [$bits(e_flit)-1:0] \north_up[0]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \north_up[0]\.flit[payload] ;
        logic \north_up[0]\.enable ;
        logic \north_up[0]\.ack ;

        logic [$bits(e_flit)-1:0] \north_down[0]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \north_down[0]\.flit[payload] ;
        logic \north_down[0]\.enable ;
        logic \north_down[0]\.ack ;

        logic [$bits(e_flit)-1:0] \south_up[0]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \south_up[0]\.flit[payload] ;
        logic \south_up[0]\.enable ;
        logic \south_up[0]\.ack ;

        logic [$bits(e_flit)-1:0] \south_down[0]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \south_down[0]\.flit[payload] ;
        logic \south_down[0]\.enable ;
        logic \south_down[0]\.ack ;

        logic [$bits(e_flit)-1:0] \east_up[0]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \east_up[0]\.flit[payload] ;
        logic \east_up[0]\.enable ;
        logic \east_up[0]\.ack ;

        logic [$bits(e_flit)-1:0] \east_down[0]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \east_down[0]\.flit[payload] ;
        logic \east_down[0]\.enable ;
        logic \east_down[0]\.ack ;

        logic [$bits(e_flit)-1:0] \west_up[0]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \west_up[0]\.flit[payload] ;
        logic \west_up[0]\.enable ;
        logic \west_up[0]\.ack ;

        logic [$bits(e_flit)-1:0] \west_down[0]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \west_down[0]\.flit[payload] ;
        logic \west_down[0]\.enable ;
        logic \west_down[0]\.ack ;

        logic [$bits(e_flit)-1:0] \north_up[1]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \north_up[1]\.flit[payload] ;
        logic \north_up[1]\.enable ;
        logic \north_up[1]\.ack ;

        logic [$bits(e_flit)-1:0] \north_down[1]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \north_down[1]\.flit[payload] ;
        logic \north_down[1]\.enable ;
        logic \north_down[1]\.ack ;

        logic [$bits(e_flit)-1:0] \south_up[1]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \south_up[1]\.flit[payload] ;
        logic \south_up[1]\.enable ;
        logic \south_up[1]\.ack ;

        logic [$bits(e_flit)-1:0] \south_down[1]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \south_down[1]\.flit[payload] ;
        logic \south_down[1]\.enable ;
        logic \south_down[1]\.ack ;

        logic [$bits(e_flit)-1:0] \east_up[1]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \east_up[1]\.flit[payload] ;
        logic \east_up[1]\.enable ;
        logic \east_up[1]\.ack ;

        logic [$bits(e_flit)-1:0] \east_down[1]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \east_down[1]\.flit[payload] ;
        logic \east_down[1]\.enable ;
        logic \east_down[1]\.ack ;

        logic [$bits(e_flit)-1:0] \west_up[1]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \west_up[1]\.flit[payload] ;
        logic \west_up[1]\.enable ;
        logic \west_up[1]\.ack ;

        logic [$bits(e_flit)-1:0] \west_down[1]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \west_down[1]\.flit[payload] ;
        logic \west_down[1]\.enable ;
        logic \west_down[1]\.ack ;

        logic [$bits(e_flit)-1:0] \north_up[2]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \north_up[2]\.flit[payload] ;
        logic \north_up[2]\.enable ;
        logic \north_up[2]\.ack ;

        logic [$bits(e_flit)-1:0] \north_down[2]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \north_down[2]\.flit[payload] ;
        logic \north_down[2]\.enable ;
        logic \north_down[2]\.ack ;

        logic [$bits(e_flit)-1:0] \south_up[2]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \south_up[2]\.flit[payload] ;
        logic \south_up[2]\.enable ;
        logic \south_up[2]\.ack ;

        logic [$bits(e_flit)-1:0] \south_down[2]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \south_down[2]\.flit[payload] ;
        logic \south_down[2]\.enable ;
        logic \south_down[2]\.ack ;

        logic [$bits(e_flit)-1:0] \east_up[2]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \east_up[2]\.flit[payload] ;
        logic \east_up[2]\.enable ;
        logic \east_up[2]\.ack ;

        logic [$bits(e_flit)-1:0] \east_down[2]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \east_down[2]\.flit[payload] ;
        logic \east_down[2]\.enable ;
        logic \east_down[2]\.ack ;

        logic [$bits(e_flit)-1:0] \west_up[2]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \west_up[2]\.flit[payload] ;
        logic \west_up[2]\.enable ;
        logic \west_up[2]\.ack ;

        logic [$bits(e_flit)-1:0] \west_down[2]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \west_down[2]\.flit[payload] ;
        logic \west_down[2]\.enable ;
        logic \west_down[2]\.ack ;

        logic [$bits(e_flit)-1:0] \north_up[3]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \north_up[3]\.flit[payload] ;
        logic \north_up[3]\.enable ;
        logic \north_up[3]\.ack ;

        logic [$bits(e_flit)-1:0] \north_down[3]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \north_down[3]\.flit[payload] ;
        logic \north_down[3]\.enable ;
        logic \north_down[3]\.ack ;

        logic [$bits(e_flit)-1:0] \south_up[3]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \south_up[3]\.flit[payload] ;
        logic \south_up[3]\.enable ;
        logic \south_up[3]\.ack ;

        logic [$bits(e_flit)-1:0] \south_down[3]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \south_down[3]\.flit[payload] ;
        logic \south_down[3]\.enable ;
        logic \south_down[3]\.ack ;

        logic [$bits(e_flit)-1:0] \east_up[3]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \east_up[3]\.flit[payload] ;
        logic \east_up[3]\.enable ;
        logic \east_up[3]\.ack ;

        logic [$bits(e_flit)-1:0] \east_down[3]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \east_down[3]\.flit[payload] ;
        logic \east_down[3]\.enable ;
        logic \east_down[3]\.ack ;

        logic [$bits(e_flit)-1:0] \west_up[3]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \west_up[3]\.flit[payload] ;
        logic \west_up[3]\.enable ;
        logic \west_up[3]\.ack ;

        logic [$bits(e_flit)-1:0] \west_down[3]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \west_down[3]\.flit[payload] ;
        logic \west_down[3]\.enable ;
        logic \west_down[3]\.ack ;

        logic [$bits(e_flit)-1:0] \north_up[4]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \north_up[4]\.flit[payload] ;
        logic \north_up[4]\.enable ;
        logic \north_up[4]\.ack ;

        logic [$bits(e_flit)-1:0] \north_down[4]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \north_down[4]\.flit[payload] ;
        logic \north_down[4]\.enable ;
        logic \north_down[4]\.ack ;

        logic [$bits(e_flit)-1:0] \south_up[4]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \south_up[4]\.flit[payload] ;
        logic \south_up[4]\.enable ;
        logic \south_up[4]\.ack ;

        logic [$bits(e_flit)-1:0] \south_down[4]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \south_down[4]\.flit[payload] ;
        logic \south_down[4]\.enable ;
        logic \south_down[4]\.ack ;

        logic [$bits(e_flit)-1:0] \east_up[4]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \east_up[4]\.flit[payload] ;
        logic \east_up[4]\.enable ;
        logic \east_up[4]\.ack ;

        logic [$bits(e_flit)-1:0] \east_down[4]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \east_down[4]\.flit[payload] ;
        logic \east_down[4]\.enable ;
        logic \east_down[4]\.ack ;

        logic [$bits(e_flit)-1:0] \west_up[4]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \west_up[4]\.flit[payload] ;
        logic \west_up[4]\.enable ;
        logic \west_up[4]\.ack ;

        logic [$bits(e_flit)-1:0] \west_down[4]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \west_down[4]\.flit[payload] ;
        logic \west_down[4]\.enable ;
        logic \west_down[4]\.ack ;

        logic [$bits(e_flit)-1:0] \north_up[5]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \north_up[5]\.flit[payload] ;
        logic \north_up[5]\.enable ;
        logic \north_up[5]\.ack ;

        logic [$bits(e_flit)-1:0] \north_down[5]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \north_down[5]\.flit[payload] ;
        logic \north_down[5]\.enable ;
        logic \north_down[5]\.ack ;

        logic [$bits(e_flit)-1:0] \south_up[5]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \south_up[5]\.flit[payload] ;
        logic \south_up[5]\.enable ;
        logic \south_up[5]\.ack ;

        logic [$bits(e_flit)-1:0] \south_down[5]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \south_down[5]\.flit[payload] ;
        logic \south_down[5]\.enable ;
        logic \south_down[5]\.ack ;

        logic [$bits(e_flit)-1:0] \east_up[5]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \east_up[5]\.flit[payload] ;
        logic \east_up[5]\.enable ;
        logic \east_up[5]\.ack ;

        logic [$bits(e_flit)-1:0] \east_down[5]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \east_down[5]\.flit[payload] ;
        logic \east_down[5]\.enable ;
        logic \east_down[5]\.ack ;

        logic [$bits(e_flit)-1:0] \west_up[5]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \west_up[5]\.flit[payload] ;
        logic \west_up[5]\.enable ;
        logic \west_up[5]\.ack ;

        logic [$bits(e_flit)-1:0] \west_down[5]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \west_down[5]\.flit[payload] ;
        logic \west_down[5]\.enable ;
        logic \west_down[5]\.ack ;

        logic [$bits(e_flit)-1:0] \north_up[6]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \north_up[6]\.flit[payload] ;
        logic \north_up[6]\.enable ;
        logic \north_up[6]\.ack ;

        logic [$bits(e_flit)-1:0] \north_down[6]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \north_down[6]\.flit[payload] ;
        logic \north_down[6]\.enable ;
        logic \north_down[6]\.ack ;

        logic [$bits(e_flit)-1:0] \south_up[6]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \south_up[6]\.flit[payload] ;
        logic \south_up[6]\.enable ;
        logic \south_up[6]\.ack ;

        logic [$bits(e_flit)-1:0] \south_down[6]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \south_down[6]\.flit[payload] ;
        logic \south_down[6]\.enable ;
        logic \south_down[6]\.ack ;

        logic [$bits(e_flit)-1:0] \east_up[6]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \east_up[6]\.flit[payload] ;
        logic \east_up[6]\.enable ;
        logic \east_up[6]\.ack ;

        logic [$bits(e_flit)-1:0] \east_down[6]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \east_down[6]\.flit[payload] ;
        logic \east_down[6]\.enable ;
        logic \east_down[6]\.ack ;

        logic [$bits(e_flit)-1:0] \west_up[6]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \west_up[6]\.flit[payload] ;
        logic \west_up[6]\.enable ;
        logic \west_up[6]\.ack ;

        logic [$bits(e_flit)-1:0] \west_down[6]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \west_down[6]\.flit[payload] ;
        logic \west_down[6]\.enable ;
        logic \west_down[6]\.ack ;

        logic [$bits(e_flit)-1:0] \north_up[7]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \north_up[7]\.flit[payload] ;
        logic \north_up[7]\.enable ;
        logic \north_up[7]\.ack ;

        logic [$bits(e_flit)-1:0] \north_down[7]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \north_down[7]\.flit[payload] ;
        logic \north_down[7]\.enable ;
        logic \north_down[7]\.ack ;

        logic [$bits(e_flit)-1:0] \south_up[7]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \south_up[7]\.flit[payload] ;
        logic \south_up[7]\.enable ;
        logic \south_up[7]\.ack ;

        logic [$bits(e_flit)-1:0] \south_down[7]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \south_down[7]\.flit[payload] ;
        logic \south_down[7]\.enable ;
        logic \south_down[7]\.ack ;

        logic [$bits(e_flit)-1:0] \east_up[7]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \east_up[7]\.flit[payload] ;
        logic \east_up[7]\.enable ;
        logic \east_up[7]\.ack ;

        logic [$bits(e_flit)-1:0] \east_down[7]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \east_down[7]\.flit[payload] ;
        logic \east_down[7]\.enable ;
        logic \east_down[7]\.ack ;

        logic [$bits(e_flit)-1:0] \west_up[7]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \west_up[7]\.flit[payload] ;
        logic \west_up[7]\.enable ;
        logic \west_up[7]\.ack ;

        logic [$bits(e_flit)-1:0] \west_down[7]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \west_down[7]\.flit[payload] ;
        logic \west_down[7]\.enable ;
        logic \west_down[7]\.ack ;

        logic [$bits(e_flit)-1:0] \north_up[8]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \north_up[8]\.flit[payload] ;
        logic \north_up[8]\.enable ;
        logic \north_up[8]\.ack ;

        logic [$bits(e_flit)-1:0] \north_down[8]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \north_down[8]\.flit[payload] ;
        logic \north_down[8]\.enable ;
        logic \north_down[8]\.ack ;

        logic [$bits(e_flit)-1:0] \south_up[8]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \south_up[8]\.flit[payload] ;
        logic \south_up[8]\.enable ;
        logic \south_up[8]\.ack ;

        logic [$bits(e_flit)-1:0] \south_down[8]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \south_down[8]\.flit[payload] ;
        logic \south_down[8]\.enable ;
        logic \south_down[8]\.ack ;

        logic [$bits(e_flit)-1:0] \east_up[8]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \east_up[8]\.flit[payload] ;
        logic \east_up[8]\.enable ;
        logic \east_up[8]\.ack ;

        logic [$bits(e_flit)-1:0] \east_down[8]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \east_down[8]\.flit[payload] ;
        logic \east_down[8]\.enable ;
        logic \east_down[8]\.ack ;

        logic [$bits(e_flit)-1:0] \west_up[8]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \west_up[8]\.flit[payload] ;
        logic \west_up[8]\.enable ;
        logic \west_up[8]\.ack ;

        logic [$bits(e_flit)-1:0] \west_down[8]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \west_down[8]\.flit[payload] ;
        logic \west_down[8]\.enable ;
        logic \west_down[8]\.ack ;

        logic [$bits(e_flit)-1:0] \north_up[9]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \north_up[9]\.flit[payload] ;
        logic \north_up[9]\.enable ;
        logic \north_up[9]\.ack ;

        logic [$bits(e_flit)-1:0] \north_down[9]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \north_down[9]\.flit[payload] ;
        logic \north_down[9]\.enable ;
        logic \north_down[9]\.ack ;

        logic [$bits(e_flit)-1:0] \south_up[9]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \south_up[9]\.flit[payload] ;
        logic \south_up[9]\.enable ;
        logic \south_up[9]\.ack ;

        logic [$bits(e_flit)-1:0] \south_down[9]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \south_down[9]\.flit[payload] ;
        logic \south_down[9]\.enable ;
        logic \south_down[9]\.ack ;

        logic [$bits(e_flit)-1:0] \east_up[9]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \east_up[9]\.flit[payload] ;
        logic \east_up[9]\.enable ;
        logic \east_up[9]\.ack ;

        logic [$bits(e_flit)-1:0] \east_down[9]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \east_down[9]\.flit[payload] ;
        logic \east_down[9]\.enable ;
        logic \east_down[9]\.ack ;

        logic [$bits(e_flit)-1:0] \west_up[9]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \west_up[9]\.flit[payload] ;
        logic \west_up[9]\.enable ;
        logic \west_up[9]\.ack ;

        logic [$bits(e_flit)-1:0] \west_down[9]\.flit[flit_type] ;
        logic [`FLIT_DATA_WIDTH-1:0] \west_down[9]\.flit[payload] ;
        logic \west_down[9]\.enable ;
        logic \west_down[9]\.ack ;


        //--------------------
        // Generating assigns 
        //--------------------
    if ( MESH_WIDTH >= 1 ) begin
        assign { north_up[0].flit.flit_type } = \north_up[0]\.flit[flit_type] ;
        assign { north_up[0].flit.payload } = \north_up[0]\.flit[payload] ;
        assign { north_up[0].enable } = \north_up[0]\.enable ;
        assign { \north_up[0]\.ack } = north_up[0].ack;
        assign { \north_down[0]\.flit[flit_type] } = north_down[0].flit.flit_type;
        assign { \north_down[0]\.flit[payload] } = north_down[0].flit.payload;
        assign { \north_down[0]\.enable } = north_down[0].enable;
        assign { north_down[0].ack } = \north_down[0]\.ack ;
    end

    if ( MESH_WIDTH >= 1 ) begin
        assign { south_up[0].flit.flit_type } = \south_up[0]\.flit[flit_type] ;
        assign { south_up[0].flit.payload } = \south_up[0]\.flit[payload] ;
        assign { south_up[0].enable } = \south_up[0]\.enable ;
        assign { \south_up[0]\.ack } = south_up[0].ack;
        assign { \south_down[0]\.flit[flit_type] } = south_down[0].flit.flit_type;
        assign { \south_down[0]\.flit[payload] } = south_down[0].flit.payload;
        assign { \south_down[0]\.enable } = south_down[0].enable;
        assign { south_down[0].ack } = \south_down[0]\.ack ;
    end

    if ( MESH_HEIGHT >= 1 ) begin
        assign { east_up[0].flit.flit_type } = \east_up[0]\.flit[flit_type] ;
        assign { east_up[0].flit.payload } = \east_up[0]\.flit[payload] ;
        assign { east_up[0].enable } = \east_up[0]\.enable ;
        assign { \east_up[0]\.ack } = east_up[0].ack;
        assign { \east_down[0]\.flit[flit_type] } = east_down[0].flit.flit_type;
        assign { \east_down[0]\.flit[payload] } = east_down[0].flit.payload;
        assign { \east_down[0]\.enable } = east_down[0].enable;
        assign { east_down[0].ack } = \east_down[0]\.ack ;
    end

    if ( MESH_HEIGHT >= 1 ) begin
        assign { west_up[0].flit.flit_type } = \west_up[0]\.flit[flit_type] ;
        assign { west_up[0].flit.payload } = \west_up[0]\.flit[payload] ;
        assign { west_up[0].enable } = \west_up[0]\.enable ;
        assign { \west_up[0]\.ack } = west_up[0].ack;
        assign { \west_down[0]\.flit[flit_type] } = west_down[0].flit.flit_type;
        assign { \west_down[0]\.flit[payload] } = west_down[0].flit.payload;
        assign { \west_down[0]\.enable } = west_down[0].enable;
        assign { west_down[0].ack } = \west_down[0]\.ack ;
    end

    if ( MESH_WIDTH >= 2 ) begin
        assign { north_up[1].flit.flit_type } = \north_up[1]\.flit[flit_type] ;
        assign { north_up[1].flit.payload } = \north_up[1]\.flit[payload] ;
        assign { north_up[1].enable } = \north_up[1]\.enable ;
        assign { \north_up[1]\.ack } = north_up[1].ack;
        assign { \north_down[1]\.flit[flit_type] } = north_down[1].flit.flit_type;
        assign { \north_down[1]\.flit[payload] } = north_down[1].flit.payload;
        assign { \north_down[1]\.enable } = north_down[1].enable;
        assign { north_down[1].ack } = \north_down[1]\.ack ;
    end

    if ( MESH_WIDTH >= 2 ) begin
        assign { south_up[1].flit.flit_type } = \south_up[1]\.flit[flit_type] ;
        assign { south_up[1].flit.payload } = \south_up[1]\.flit[payload] ;
        assign { south_up[1].enable } = \south_up[1]\.enable ;
        assign { \south_up[1]\.ack } = south_up[1].ack;
        assign { \south_down[1]\.flit[flit_type] } = south_down[1].flit.flit_type;
        assign { \south_down[1]\.flit[payload] } = south_down[1].flit.payload;
        assign { \south_down[1]\.enable } = south_down[1].enable;
        assign { south_down[1].ack } = \south_down[1]\.ack ;
    end

    if ( MESH_HEIGHT >= 2 ) begin
        assign { east_up[1].flit.flit_type } = \east_up[1]\.flit[flit_type] ;
        assign { east_up[1].flit.payload } = \east_up[1]\.flit[payload] ;
        assign { east_up[1].enable } = \east_up[1]\.enable ;
        assign { \east_up[1]\.ack } = east_up[1].ack;
        assign { \east_down[1]\.flit[flit_type] } = east_down[1].flit.flit_type;
        assign { \east_down[1]\.flit[payload] } = east_down[1].flit.payload;
        assign { \east_down[1]\.enable } = east_down[1].enable;
        assign { east_down[1].ack } = \east_down[1]\.ack ;
    end

    if ( MESH_HEIGHT >= 2 ) begin
        assign { west_up[1].flit.flit_type } = \west_up[1]\.flit[flit_type] ;
        assign { west_up[1].flit.payload } = \west_up[1]\.flit[payload] ;
        assign { west_up[1].enable } = \west_up[1]\.enable ;
        assign { \west_up[1]\.ack } = west_up[1].ack;
        assign { \west_down[1]\.flit[flit_type] } = west_down[1].flit.flit_type;
        assign { \west_down[1]\.flit[payload] } = west_down[1].flit.payload;
        assign { \west_down[1]\.enable } = west_down[1].enable;
        assign { west_down[1].ack } = \west_down[1]\.ack ;
    end

    if ( MESH_WIDTH >= 3 ) begin
        assign { north_up[2].flit.flit_type } = \north_up[2]\.flit[flit_type] ;
        assign { north_up[2].flit.payload } = \north_up[2]\.flit[payload] ;
        assign { north_up[2].enable } = \north_up[2]\.enable ;
        assign { \north_up[2]\.ack } = north_up[2].ack;
        assign { \north_down[2]\.flit[flit_type] } = north_down[2].flit.flit_type;
        assign { \north_down[2]\.flit[payload] } = north_down[2].flit.payload;
        assign { \north_down[2]\.enable } = north_down[2].enable;
        assign { north_down[2].ack } = \north_down[2]\.ack ;
    end

    if ( MESH_WIDTH >= 3 ) begin
        assign { south_up[2].flit.flit_type } = \south_up[2]\.flit[flit_type] ;
        assign { south_up[2].flit.payload } = \south_up[2]\.flit[payload] ;
        assign { south_up[2].enable } = \south_up[2]\.enable ;
        assign { \south_up[2]\.ack } = south_up[2].ack;
        assign { \south_down[2]\.flit[flit_type] } = south_down[2].flit.flit_type;
        assign { \south_down[2]\.flit[payload] } = south_down[2].flit.payload;
        assign { \south_down[2]\.enable } = south_down[2].enable;
        assign { south_down[2].ack } = \south_down[2]\.ack ;
    end

    if ( MESH_HEIGHT >= 3 ) begin
        assign { east_up[2].flit.flit_type } = \east_up[2]\.flit[flit_type] ;
        assign { east_up[2].flit.payload } = \east_up[2]\.flit[payload] ;
        assign { east_up[2].enable } = \east_up[2]\.enable ;
        assign { \east_up[2]\.ack } = east_up[2].ack;
        assign { \east_down[2]\.flit[flit_type] } = east_down[2].flit.flit_type;
        assign { \east_down[2]\.flit[payload] } = east_down[2].flit.payload;
        assign { \east_down[2]\.enable } = east_down[2].enable;
        assign { east_down[2].ack } = \east_down[2]\.ack ;
    end

    if ( MESH_HEIGHT >= 3 ) begin
        assign { west_up[2].flit.flit_type } = \west_up[2]\.flit[flit_type] ;
        assign { west_up[2].flit.payload } = \west_up[2]\.flit[payload] ;
        assign { west_up[2].enable } = \west_up[2]\.enable ;
        assign { \west_up[2]\.ack } = west_up[2].ack;
        assign { \west_down[2]\.flit[flit_type] } = west_down[2].flit.flit_type;
        assign { \west_down[2]\.flit[payload] } = west_down[2].flit.payload;
        assign { \west_down[2]\.enable } = west_down[2].enable;
        assign { west_down[2].ack } = \west_down[2]\.ack ;
    end

    if ( MESH_WIDTH >= 4 ) begin
        assign { north_up[3].flit.flit_type } = \north_up[3]\.flit[flit_type] ;
        assign { north_up[3].flit.payload } = \north_up[3]\.flit[payload] ;
        assign { north_up[3].enable } = \north_up[3]\.enable ;
        assign { \north_up[3]\.ack } = north_up[3].ack;
        assign { \north_down[3]\.flit[flit_type] } = north_down[3].flit.flit_type;
        assign { \north_down[3]\.flit[payload] } = north_down[3].flit.payload;
        assign { \north_down[3]\.enable } = north_down[3].enable;
        assign { north_down[3].ack } = \north_down[3]\.ack ;
    end

    if ( MESH_WIDTH >= 4 ) begin
        assign { south_up[3].flit.flit_type } = \south_up[3]\.flit[flit_type] ;
        assign { south_up[3].flit.payload } = \south_up[3]\.flit[payload] ;
        assign { south_up[3].enable } = \south_up[3]\.enable ;
        assign { \south_up[3]\.ack } = south_up[3].ack;
        assign { \south_down[3]\.flit[flit_type] } = south_down[3].flit.flit_type;
        assign { \south_down[3]\.flit[payload] } = south_down[3].flit.payload;
        assign { \south_down[3]\.enable } = south_down[3].enable;
        assign { south_down[3].ack } = \south_down[3]\.ack ;
    end

    if ( MESH_HEIGHT >= 4 ) begin
        assign { east_up[3].flit.flit_type } = \east_up[3]\.flit[flit_type] ;
        assign { east_up[3].flit.payload } = \east_up[3]\.flit[payload] ;
        assign { east_up[3].enable } = \east_up[3]\.enable ;
        assign { \east_up[3]\.ack } = east_up[3].ack;
        assign { \east_down[3]\.flit[flit_type] } = east_down[3].flit.flit_type;
        assign { \east_down[3]\.flit[payload] } = east_down[3].flit.payload;
        assign { \east_down[3]\.enable } = east_down[3].enable;
        assign { east_down[3].ack } = \east_down[3]\.ack ;
    end

    if ( MESH_HEIGHT >= 4 ) begin
        assign { west_up[3].flit.flit_type } = \west_up[3]\.flit[flit_type] ;
        assign { west_up[3].flit.payload } = \west_up[3]\.flit[payload] ;
        assign { west_up[3].enable } = \west_up[3]\.enable ;
        assign { \west_up[3]\.ack } = west_up[3].ack;
        assign { \west_down[3]\.flit[flit_type] } = west_down[3].flit.flit_type;
        assign { \west_down[3]\.flit[payload] } = west_down[3].flit.payload;
        assign { \west_down[3]\.enable } = west_down[3].enable;
        assign { west_down[3].ack } = \west_down[3]\.ack ;
    end

    if ( MESH_WIDTH >= 5 ) begin
        assign { north_up[4].flit.flit_type } = \north_up[4]\.flit[flit_type] ;
        assign { north_up[4].flit.payload } = \north_up[4]\.flit[payload] ;
        assign { north_up[4].enable } = \north_up[4]\.enable ;
        assign { \north_up[4]\.ack } = north_up[4].ack;
        assign { \north_down[4]\.flit[flit_type] } = north_down[4].flit.flit_type;
        assign { \north_down[4]\.flit[payload] } = north_down[4].flit.payload;
        assign { \north_down[4]\.enable } = north_down[4].enable;
        assign { north_down[4].ack } = \north_down[4]\.ack ;
    end

    if ( MESH_WIDTH >= 5 ) begin
        assign { south_up[4].flit.flit_type } = \south_up[4]\.flit[flit_type] ;
        assign { south_up[4].flit.payload } = \south_up[4]\.flit[payload] ;
        assign { south_up[4].enable } = \south_up[4]\.enable ;
        assign { \south_up[4]\.ack } = south_up[4].ack;
        assign { \south_down[4]\.flit[flit_type] } = south_down[4].flit.flit_type;
        assign { \south_down[4]\.flit[payload] } = south_down[4].flit.payload;
        assign { \south_down[4]\.enable } = south_down[4].enable;
        assign { south_down[4].ack } = \south_down[4]\.ack ;
    end

    if ( MESH_HEIGHT >= 5 ) begin
        assign { east_up[4].flit.flit_type } = \east_up[4]\.flit[flit_type] ;
        assign { east_up[4].flit.payload } = \east_up[4]\.flit[payload] ;
        assign { east_up[4].enable } = \east_up[4]\.enable ;
        assign { \east_up[4]\.ack } = east_up[4].ack;
        assign { \east_down[4]\.flit[flit_type] } = east_down[4].flit.flit_type;
        assign { \east_down[4]\.flit[payload] } = east_down[4].flit.payload;
        assign { \east_down[4]\.enable } = east_down[4].enable;
        assign { east_down[4].ack } = \east_down[4]\.ack ;
    end

    if ( MESH_HEIGHT >= 5 ) begin
        assign { west_up[4].flit.flit_type } = \west_up[4]\.flit[flit_type] ;
        assign { west_up[4].flit.payload } = \west_up[4]\.flit[payload] ;
        assign { west_up[4].enable } = \west_up[4]\.enable ;
        assign { \west_up[4]\.ack } = west_up[4].ack;
        assign { \west_down[4]\.flit[flit_type] } = west_down[4].flit.flit_type;
        assign { \west_down[4]\.flit[payload] } = west_down[4].flit.payload;
        assign { \west_down[4]\.enable } = west_down[4].enable;
        assign { west_down[4].ack } = \west_down[4]\.ack ;
    end

    if ( MESH_WIDTH >= 6 ) begin
        assign { north_up[5].flit.flit_type } = \north_up[5]\.flit[flit_type] ;
        assign { north_up[5].flit.payload } = \north_up[5]\.flit[payload] ;
        assign { north_up[5].enable } = \north_up[5]\.enable ;
        assign { \north_up[5]\.ack } = north_up[5].ack;
        assign { \north_down[5]\.flit[flit_type] } = north_down[5].flit.flit_type;
        assign { \north_down[5]\.flit[payload] } = north_down[5].flit.payload;
        assign { \north_down[5]\.enable } = north_down[5].enable;
        assign { north_down[5].ack } = \north_down[5]\.ack ;
    end

    if ( MESH_WIDTH >= 6 ) begin
        assign { south_up[5].flit.flit_type } = \south_up[5]\.flit[flit_type] ;
        assign { south_up[5].flit.payload } = \south_up[5]\.flit[payload] ;
        assign { south_up[5].enable } = \south_up[5]\.enable ;
        assign { \south_up[5]\.ack } = south_up[5].ack;
        assign { \south_down[5]\.flit[flit_type] } = south_down[5].flit.flit_type;
        assign { \south_down[5]\.flit[payload] } = south_down[5].flit.payload;
        assign { \south_down[5]\.enable } = south_down[5].enable;
        assign { south_down[5].ack } = \south_down[5]\.ack ;
    end

    if ( MESH_HEIGHT >= 6 ) begin
        assign { east_up[5].flit.flit_type } = \east_up[5]\.flit[flit_type] ;
        assign { east_up[5].flit.payload } = \east_up[5]\.flit[payload] ;
        assign { east_up[5].enable } = \east_up[5]\.enable ;
        assign { \east_up[5]\.ack } = east_up[5].ack;
        assign { \east_down[5]\.flit[flit_type] } = east_down[5].flit.flit_type;
        assign { \east_down[5]\.flit[payload] } = east_down[5].flit.payload;
        assign { \east_down[5]\.enable } = east_down[5].enable;
        assign { east_down[5].ack } = \east_down[5]\.ack ;
    end

    if ( MESH_HEIGHT >= 6 ) begin
        assign { west_up[5].flit.flit_type } = \west_up[5]\.flit[flit_type] ;
        assign { west_up[5].flit.payload } = \west_up[5]\.flit[payload] ;
        assign { west_up[5].enable } = \west_up[5]\.enable ;
        assign { \west_up[5]\.ack } = west_up[5].ack;
        assign { \west_down[5]\.flit[flit_type] } = west_down[5].flit.flit_type;
        assign { \west_down[5]\.flit[payload] } = west_down[5].flit.payload;
        assign { \west_down[5]\.enable } = west_down[5].enable;
        assign { west_down[5].ack } = \west_down[5]\.ack ;
    end

    if ( MESH_WIDTH >= 7 ) begin
        assign { north_up[6].flit.flit_type } = \north_up[6]\.flit[flit_type] ;
        assign { north_up[6].flit.payload } = \north_up[6]\.flit[payload] ;
        assign { north_up[6].enable } = \north_up[6]\.enable ;
        assign { \north_up[6]\.ack } = north_up[6].ack;
        assign { \north_down[6]\.flit[flit_type] } = north_down[6].flit.flit_type;
        assign { \north_down[6]\.flit[payload] } = north_down[6].flit.payload;
        assign { \north_down[6]\.enable } = north_down[6].enable;
        assign { north_down[6].ack } = \north_down[6]\.ack ;
    end

    if ( MESH_WIDTH >= 7 ) begin
        assign { south_up[6].flit.flit_type } = \south_up[6]\.flit[flit_type] ;
        assign { south_up[6].flit.payload } = \south_up[6]\.flit[payload] ;
        assign { south_up[6].enable } = \south_up[6]\.enable ;
        assign { \south_up[6]\.ack } = south_up[6].ack;
        assign { \south_down[6]\.flit[flit_type] } = south_down[6].flit.flit_type;
        assign { \south_down[6]\.flit[payload] } = south_down[6].flit.payload;
        assign { \south_down[6]\.enable } = south_down[6].enable;
        assign { south_down[6].ack } = \south_down[6]\.ack ;
    end

    if ( MESH_HEIGHT >= 7 ) begin
        assign { east_up[6].flit.flit_type } = \east_up[6]\.flit[flit_type] ;
        assign { east_up[6].flit.payload } = \east_up[6]\.flit[payload] ;
        assign { east_up[6].enable } = \east_up[6]\.enable ;
        assign { \east_up[6]\.ack } = east_up[6].ack;
        assign { \east_down[6]\.flit[flit_type] } = east_down[6].flit.flit_type;
        assign { \east_down[6]\.flit[payload] } = east_down[6].flit.payload;
        assign { \east_down[6]\.enable } = east_down[6].enable;
        assign { east_down[6].ack } = \east_down[6]\.ack ;
    end

    if ( MESH_HEIGHT >= 7 ) begin
        assign { west_up[6].flit.flit_type } = \west_up[6]\.flit[flit_type] ;
        assign { west_up[6].flit.payload } = \west_up[6]\.flit[payload] ;
        assign { west_up[6].enable } = \west_up[6]\.enable ;
        assign { \west_up[6]\.ack } = west_up[6].ack;
        assign { \west_down[6]\.flit[flit_type] } = west_down[6].flit.flit_type;
        assign { \west_down[6]\.flit[payload] } = west_down[6].flit.payload;
        assign { \west_down[6]\.enable } = west_down[6].enable;
        assign { west_down[6].ack } = \west_down[6]\.ack ;
    end

    if ( MESH_WIDTH >= 8 ) begin
        assign { north_up[7].flit.flit_type } = \north_up[7]\.flit[flit_type] ;
        assign { north_up[7].flit.payload } = \north_up[7]\.flit[payload] ;
        assign { north_up[7].enable } = \north_up[7]\.enable ;
        assign { \north_up[7]\.ack } = north_up[7].ack;
        assign { \north_down[7]\.flit[flit_type] } = north_down[7].flit.flit_type;
        assign { \north_down[7]\.flit[payload] } = north_down[7].flit.payload;
        assign { \north_down[7]\.enable } = north_down[7].enable;
        assign { north_down[7].ack } = \north_down[7]\.ack ;
    end

    if ( MESH_WIDTH >= 8 ) begin
        assign { south_up[7].flit.flit_type } = \south_up[7]\.flit[flit_type] ;
        assign { south_up[7].flit.payload } = \south_up[7]\.flit[payload] ;
        assign { south_up[7].enable } = \south_up[7]\.enable ;
        assign { \south_up[7]\.ack } = south_up[7].ack;
        assign { \south_down[7]\.flit[flit_type] } = south_down[7].flit.flit_type;
        assign { \south_down[7]\.flit[payload] } = south_down[7].flit.payload;
        assign { \south_down[7]\.enable } = south_down[7].enable;
        assign { south_down[7].ack } = \south_down[7]\.ack ;
    end

    if ( MESH_HEIGHT >= 8 ) begin
        assign { east_up[7].flit.flit_type } = \east_up[7]\.flit[flit_type] ;
        assign { east_up[7].flit.payload } = \east_up[7]\.flit[payload] ;
        assign { east_up[7].enable } = \east_up[7]\.enable ;
        assign { \east_up[7]\.ack } = east_up[7].ack;
        assign { \east_down[7]\.flit[flit_type] } = east_down[7].flit.flit_type;
        assign { \east_down[7]\.flit[payload] } = east_down[7].flit.payload;
        assign { \east_down[7]\.enable } = east_down[7].enable;
        assign { east_down[7].ack } = \east_down[7]\.ack ;
    end

    if ( MESH_HEIGHT >= 8 ) begin
        assign { west_up[7].flit.flit_type } = \west_up[7]\.flit[flit_type] ;
        assign { west_up[7].flit.payload } = \west_up[7]\.flit[payload] ;
        assign { west_up[7].enable } = \west_up[7]\.enable ;
        assign { \west_up[7]\.ack } = west_up[7].ack;
        assign { \west_down[7]\.flit[flit_type] } = west_down[7].flit.flit_type;
        assign { \west_down[7]\.flit[payload] } = west_down[7].flit.payload;
        assign { \west_down[7]\.enable } = west_down[7].enable;
        assign { west_down[7].ack } = \west_down[7]\.ack ;
    end

    if ( MESH_WIDTH >= 9 ) begin
        assign { north_up[8].flit.flit_type } = \north_up[8]\.flit[flit_type] ;
        assign { north_up[8].flit.payload } = \north_up[8]\.flit[payload] ;
        assign { north_up[8].enable } = \north_up[8]\.enable ;
        assign { \north_up[8]\.ack } = north_up[8].ack;
        assign { \north_down[8]\.flit[flit_type] } = north_down[8].flit.flit_type;
        assign { \north_down[8]\.flit[payload] } = north_down[8].flit.payload;
        assign { \north_down[8]\.enable } = north_down[8].enable;
        assign { north_down[8].ack } = \north_down[8]\.ack ;
    end

    if ( MESH_WIDTH >= 9 ) begin
        assign { south_up[8].flit.flit_type } = \south_up[8]\.flit[flit_type] ;
        assign { south_up[8].flit.payload } = \south_up[8]\.flit[payload] ;
        assign { south_up[8].enable } = \south_up[8]\.enable ;
        assign { \south_up[8]\.ack } = south_up[8].ack;
        assign { \south_down[8]\.flit[flit_type] } = south_down[8].flit.flit_type;
        assign { \south_down[8]\.flit[payload] } = south_down[8].flit.payload;
        assign { \south_down[8]\.enable } = south_down[8].enable;
        assign { south_down[8].ack } = \south_down[8]\.ack ;
    end

    if ( MESH_HEIGHT >= 9 ) begin
        assign { east_up[8].flit.flit_type } = \east_up[8]\.flit[flit_type] ;
        assign { east_up[8].flit.payload } = \east_up[8]\.flit[payload] ;
        assign { east_up[8].enable } = \east_up[8]\.enable ;
        assign { \east_up[8]\.ack } = east_up[8].ack;
        assign { \east_down[8]\.flit[flit_type] } = east_down[8].flit.flit_type;
        assign { \east_down[8]\.flit[payload] } = east_down[8].flit.payload;
        assign { \east_down[8]\.enable } = east_down[8].enable;
        assign { east_down[8].ack } = \east_down[8]\.ack ;
    end

    if ( MESH_HEIGHT >= 9 ) begin
        assign { west_up[8].flit.flit_type } = \west_up[8]\.flit[flit_type] ;
        assign { west_up[8].flit.payload } = \west_up[8]\.flit[payload] ;
        assign { west_up[8].enable } = \west_up[8]\.enable ;
        assign { \west_up[8]\.ack } = west_up[8].ack;
        assign { \west_down[8]\.flit[flit_type] } = west_down[8].flit.flit_type;
        assign { \west_down[8]\.flit[payload] } = west_down[8].flit.payload;
        assign { \west_down[8]\.enable } = west_down[8].enable;
        assign { west_down[8].ack } = \west_down[8]\.ack ;
    end

    if ( MESH_WIDTH >= 10 ) begin
        assign { north_up[9].flit.flit_type } = \north_up[9]\.flit[flit_type] ;
        assign { north_up[9].flit.payload } = \north_up[9]\.flit[payload] ;
        assign { north_up[9].enable } = \north_up[9]\.enable ;
        assign { \north_up[9]\.ack } = north_up[9].ack;
        assign { \north_down[9]\.flit[flit_type] } = north_down[9].flit.flit_type;
        assign { \north_down[9]\.flit[payload] } = north_down[9].flit.payload;
        assign { \north_down[9]\.enable } = north_down[9].enable;
        assign { north_down[9].ack } = \north_down[9]\.ack ;
    end

    if ( MESH_WIDTH >= 10 ) begin
        assign { south_up[9].flit.flit_type } = \south_up[9]\.flit[flit_type] ;
        assign { south_up[9].flit.payload } = \south_up[9]\.flit[payload] ;
        assign { south_up[9].enable } = \south_up[9]\.enable ;
        assign { \south_up[9]\.ack } = south_up[9].ack;
        assign { \south_down[9]\.flit[flit_type] } = south_down[9].flit.flit_type;
        assign { \south_down[9]\.flit[payload] } = south_down[9].flit.payload;
        assign { \south_down[9]\.enable } = south_down[9].enable;
        assign { south_down[9].ack } = \south_down[9]\.ack ;
    end

    if ( MESH_HEIGHT >= 10 ) begin
        assign { east_up[9].flit.flit_type } = \east_up[9]\.flit[flit_type] ;
        assign { east_up[9].flit.payload } = \east_up[9]\.flit[payload] ;
        assign { east_up[9].enable } = \east_up[9]\.enable ;
        assign { \east_up[9]\.ack } = east_up[9].ack;
        assign { \east_down[9]\.flit[flit_type] } = east_down[9].flit.flit_type;
        assign { \east_down[9]\.flit[payload] } = east_down[9].flit.payload;
        assign { \east_down[9]\.enable } = east_down[9].enable;
        assign { east_down[9].ack } = \east_down[9]\.ack ;
    end

    if ( MESH_HEIGHT >= 10 ) begin
        assign { west_up[9].flit.flit_type } = \west_up[9]\.flit[flit_type] ;
        assign { west_up[9].flit.payload } = \west_up[9]\.flit[payload] ;
        assign { west_up[9].enable } = \west_up[9]\.enable ;
        assign { \west_up[9]\.ack } = west_up[9].ack;
        assign { \west_down[9]\.flit[flit_type] } = west_down[9].flit.flit_type;
        assign { \west_down[9]\.flit[payload] } = west_down[9].flit.payload;
        assign { \west_down[9]\.enable } = west_down[9].enable;
        assign { west_down[9].ack } = \west_down[9]\.ack ;
    end

endgenerate

		mesh mesh (.*);
	`endif
endmodule
