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

	`ifndef POST_SYNTHESIS
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
        wire [$bits(e_flit)-1:0] \north_up[0]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \north_up[0]\.flit[payload] ;
        wire \north_up[0]\.enable ;
        wire \north_up[0]\.ack ;
        wire \north_up[0]\.rej ;

        wire [$bits(e_flit)-1:0] \north_down[0]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \north_down[0]\.flit[payload] ;
        wire \north_down[0]\.enable ;
        wire \north_down[0]\.ack ;
        wire \north_down[0]\.rej ;

        wire [$bits(e_flit)-1:0] \south_up[0]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \south_up[0]\.flit[payload] ;
        wire \south_up[0]\.enable ;
        wire \south_up[0]\.ack ;
        wire \south_up[0]\.rej ;

        wire [$bits(e_flit)-1:0] \south_down[0]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \south_down[0]\.flit[payload] ;
        wire \south_down[0]\.enable ;
        wire \south_down[0]\.ack ;
        wire \south_down[0]\.rej ;

        wire [$bits(e_flit)-1:0] \east_up[0]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \east_up[0]\.flit[payload] ;
        wire \east_up[0]\.enable ;
        wire \east_up[0]\.ack ;
        wire \east_up[0]\.rej ;

        wire [$bits(e_flit)-1:0] \east_down[0]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \east_down[0]\.flit[payload] ;
        wire \east_down[0]\.enable ;
        wire \east_down[0]\.ack ;
        wire \east_down[0]\.rej ;

        wire [$bits(e_flit)-1:0] \west_up[0]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \west_up[0]\.flit[payload] ;
        wire \west_up[0]\.enable ;
        wire \west_up[0]\.ack ;
        wire \west_up[0]\.rej ;

        wire [$bits(e_flit)-1:0] \west_down[0]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \west_down[0]\.flit[payload] ;
        wire \west_down[0]\.enable ;
        wire \west_down[0]\.ack ;
        wire \west_down[0]\.rej ;

        wire [$bits(e_flit)-1:0] \north_up[1]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \north_up[1]\.flit[payload] ;
        wire \north_up[1]\.enable ;
        wire \north_up[1]\.ack ;
        wire \north_up[1]\.rej ;

        wire [$bits(e_flit)-1:0] \north_down[1]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \north_down[1]\.flit[payload] ;
        wire \north_down[1]\.enable ;
        wire \north_down[1]\.ack ;
        wire \north_down[1]\.rej ;

        wire [$bits(e_flit)-1:0] \south_up[1]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \south_up[1]\.flit[payload] ;
        wire \south_up[1]\.enable ;
        wire \south_up[1]\.ack ;
        wire \south_up[1]\.rej ;

        wire [$bits(e_flit)-1:0] \south_down[1]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \south_down[1]\.flit[payload] ;
        wire \south_down[1]\.enable ;
        wire \south_down[1]\.ack ;
        wire \south_down[1]\.rej ;

        wire [$bits(e_flit)-1:0] \east_up[1]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \east_up[1]\.flit[payload] ;
        wire \east_up[1]\.enable ;
        wire \east_up[1]\.ack ;
        wire \east_up[1]\.rej ;

        wire [$bits(e_flit)-1:0] \east_down[1]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \east_down[1]\.flit[payload] ;
        wire \east_down[1]\.enable ;
        wire \east_down[1]\.ack ;
        wire \east_down[1]\.rej ;

        wire [$bits(e_flit)-1:0] \west_up[1]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \west_up[1]\.flit[payload] ;
        wire \west_up[1]\.enable ;
        wire \west_up[1]\.ack ;
        wire \west_up[1]\.rej ;

        wire [$bits(e_flit)-1:0] \west_down[1]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \west_down[1]\.flit[payload] ;
        wire \west_down[1]\.enable ;
        wire \west_down[1]\.ack ;
        wire \west_down[1]\.rej ;

        wire [$bits(e_flit)-1:0] \north_up[2]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \north_up[2]\.flit[payload] ;
        wire \north_up[2]\.enable ;
        wire \north_up[2]\.ack ;
        wire \north_up[2]\.rej ;

        wire [$bits(e_flit)-1:0] \north_down[2]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \north_down[2]\.flit[payload] ;
        wire \north_down[2]\.enable ;
        wire \north_down[2]\.ack ;
        wire \north_down[2]\.rej ;

        wire [$bits(e_flit)-1:0] \south_up[2]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \south_up[2]\.flit[payload] ;
        wire \south_up[2]\.enable ;
        wire \south_up[2]\.ack ;
        wire \south_up[2]\.rej ;

        wire [$bits(e_flit)-1:0] \south_down[2]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \south_down[2]\.flit[payload] ;
        wire \south_down[2]\.enable ;
        wire \south_down[2]\.ack ;
        wire \south_down[2]\.rej ;

        wire [$bits(e_flit)-1:0] \east_up[2]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \east_up[2]\.flit[payload] ;
        wire \east_up[2]\.enable ;
        wire \east_up[2]\.ack ;
        wire \east_up[2]\.rej ;

        wire [$bits(e_flit)-1:0] \east_down[2]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \east_down[2]\.flit[payload] ;
        wire \east_down[2]\.enable ;
        wire \east_down[2]\.ack ;
        wire \east_down[2]\.rej ;

        wire [$bits(e_flit)-1:0] \west_up[2]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \west_up[2]\.flit[payload] ;
        wire \west_up[2]\.enable ;
        wire \west_up[2]\.ack ;
        wire \west_up[2]\.rej ;

        wire [$bits(e_flit)-1:0] \west_down[2]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \west_down[2]\.flit[payload] ;
        wire \west_down[2]\.enable ;
        wire \west_down[2]\.ack ;
        wire \west_down[2]\.rej ;

        wire [$bits(e_flit)-1:0] \north_up[3]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \north_up[3]\.flit[payload] ;
        wire \north_up[3]\.enable ;
        wire \north_up[3]\.ack ;
        wire \north_up[3]\.rej ;

        wire [$bits(e_flit)-1:0] \north_down[3]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \north_down[3]\.flit[payload] ;
        wire \north_down[3]\.enable ;
        wire \north_down[3]\.ack ;
        wire \north_down[3]\.rej ;

        wire [$bits(e_flit)-1:0] \south_up[3]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \south_up[3]\.flit[payload] ;
        wire \south_up[3]\.enable ;
        wire \south_up[3]\.ack ;
        wire \south_up[3]\.rej ;

        wire [$bits(e_flit)-1:0] \south_down[3]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \south_down[3]\.flit[payload] ;
        wire \south_down[3]\.enable ;
        wire \south_down[3]\.ack ;
        wire \south_down[3]\.rej ;

        wire [$bits(e_flit)-1:0] \east_up[3]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \east_up[3]\.flit[payload] ;
        wire \east_up[3]\.enable ;
        wire \east_up[3]\.ack ;
        wire \east_up[3]\.rej ;

        wire [$bits(e_flit)-1:0] \east_down[3]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \east_down[3]\.flit[payload] ;
        wire \east_down[3]\.enable ;
        wire \east_down[3]\.ack ;
        wire \east_down[3]\.rej ;

        wire [$bits(e_flit)-1:0] \west_up[3]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \west_up[3]\.flit[payload] ;
        wire \west_up[3]\.enable ;
        wire \west_up[3]\.ack ;
        wire \west_up[3]\.rej ;

        wire [$bits(e_flit)-1:0] \west_down[3]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \west_down[3]\.flit[payload] ;
        wire \west_down[3]\.enable ;
        wire \west_down[3]\.ack ;
        wire \west_down[3]\.rej ;

        wire [$bits(e_flit)-1:0] \north_up[4]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \north_up[4]\.flit[payload] ;
        wire \north_up[4]\.enable ;
        wire \north_up[4]\.ack ;
        wire \north_up[4]\.rej ;

        wire [$bits(e_flit)-1:0] \north_down[4]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \north_down[4]\.flit[payload] ;
        wire \north_down[4]\.enable ;
        wire \north_down[4]\.ack ;
        wire \north_down[4]\.rej ;

        wire [$bits(e_flit)-1:0] \south_up[4]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \south_up[4]\.flit[payload] ;
        wire \south_up[4]\.enable ;
        wire \south_up[4]\.ack ;
        wire \south_up[4]\.rej ;

        wire [$bits(e_flit)-1:0] \south_down[4]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \south_down[4]\.flit[payload] ;
        wire \south_down[4]\.enable ;
        wire \south_down[4]\.ack ;
        wire \south_down[4]\.rej ;

        wire [$bits(e_flit)-1:0] \east_up[4]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \east_up[4]\.flit[payload] ;
        wire \east_up[4]\.enable ;
        wire \east_up[4]\.ack ;
        wire \east_up[4]\.rej ;

        wire [$bits(e_flit)-1:0] \east_down[4]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \east_down[4]\.flit[payload] ;
        wire \east_down[4]\.enable ;
        wire \east_down[4]\.ack ;
        wire \east_down[4]\.rej ;

        wire [$bits(e_flit)-1:0] \west_up[4]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \west_up[4]\.flit[payload] ;
        wire \west_up[4]\.enable ;
        wire \west_up[4]\.ack ;
        wire \west_up[4]\.rej ;

        wire [$bits(e_flit)-1:0] \west_down[4]\.flit[flit_type] ;
        wire [`FLIT_DATA_WIDTH-1:0] \west_down[4]\.flit[payload] ;
        wire \west_down[4]\.enable ;
        wire \west_down[4]\.ack ;
        wire \west_down[4]\.rej ;


        //--------------------
        // Generating assigns 
        //--------------------
    if ( MESH_WIDTH >= 1 ) begin
        assign { north_up[0].flit.flit_type } = \north_up[0]\.flit[flit_type] ;
        assign { north_up[0].flit.payload } = \north_up[0]\.flit[payload] ;
        assign { north_up[0].enable } = \north_up[0]\.enable ;
        assign { \north_up[0]\.ack } = north_up[0].ack;
        assign { \north_up[0]\.rej } = north_up[0].rej;
        assign { \north_down[0]\.flit[flit_type] } = north_down[0].flit.flit_type;
        assign { \north_down[0]\.flit[payload] } = north_down[0].flit.payload;
        assign { \north_down[0]\.enable } = north_down[0].enable;
        assign { north_down[0].ack } = \north_down[0]\.ack ;
        assign { north_down[0].rej } = \north_down[0]\.rej ;
    end

    if ( MESH_WIDTH >= 1 ) begin
        assign { south_up[0].flit.flit_type } = \south_up[0]\.flit[flit_type] ;
        assign { south_up[0].flit.payload } = \south_up[0]\.flit[payload] ;
        assign { south_up[0].enable } = \south_up[0]\.enable ;
        assign { \south_up[0]\.ack } = south_up[0].ack;
        assign { \south_up[0]\.rej } = south_up[0].rej;
        assign { \south_down[0]\.flit[flit_type] } = south_down[0].flit.flit_type;
        assign { \south_down[0]\.flit[payload] } = south_down[0].flit.payload;
        assign { \south_down[0]\.enable } = south_down[0].enable;
        assign { south_down[0].ack } = \south_down[0]\.ack ;
        assign { south_down[0].rej } = \south_down[0]\.rej ;
    end

    if ( MESH_HEIGHT >= 1 ) begin
        assign { east_up[0].flit.flit_type } = \east_up[0]\.flit[flit_type] ;
        assign { east_up[0].flit.payload } = \east_up[0]\.flit[payload] ;
        assign { east_up[0].enable } = \east_up[0]\.enable ;
        assign { \east_up[0]\.ack } = east_up[0].ack;
        assign { \east_up[0]\.rej } = east_up[0].rej;
        assign { \east_down[0]\.flit[flit_type] } = east_down[0].flit.flit_type;
        assign { \east_down[0]\.flit[payload] } = east_down[0].flit.payload;
        assign { \east_down[0]\.enable } = east_down[0].enable;
        assign { east_down[0].ack } = \east_down[0]\.ack ;
        assign { east_down[0].rej } = \east_down[0]\.rej ;
    end

    if ( MESH_HEIGHT >= 1 ) begin
        assign { west_up[0].flit.flit_type } = \west_up[0]\.flit[flit_type] ;
        assign { west_up[0].flit.payload } = \west_up[0]\.flit[payload] ;
        assign { west_up[0].enable } = \west_up[0]\.enable ;
        assign { \west_up[0]\.ack } = west_up[0].ack;
        assign { \west_up[0]\.rej } = west_up[0].rej;
        assign { \west_down[0]\.flit[flit_type] } = west_down[0].flit.flit_type;
        assign { \west_down[0]\.flit[payload] } = west_down[0].flit.payload;
        assign { \west_down[0]\.enable } = west_down[0].enable;
        assign { west_down[0].ack } = \west_down[0]\.ack ;
        assign { west_down[0].rej } = \west_down[0]\.rej ;
    end

    if ( MESH_WIDTH >= 2 ) begin
        assign { north_up[1].flit.flit_type } = \north_up[1]\.flit[flit_type] ;
        assign { north_up[1].flit.payload } = \north_up[1]\.flit[payload] ;
        assign { north_up[1].enable } = \north_up[1]\.enable ;
        assign { \north_up[1]\.ack } = north_up[1].ack;
        assign { \north_up[1]\.rej } = north_up[1].rej;
        assign { \north_down[1]\.flit[flit_type] } = north_down[1].flit.flit_type;
        assign { \north_down[1]\.flit[payload] } = north_down[1].flit.payload;
        assign { \north_down[1]\.enable } = north_down[1].enable;
        assign { north_down[1].ack } = \north_down[1]\.ack ;
        assign { north_down[1].rej } = \north_down[1]\.rej ;
    end

    if ( MESH_WIDTH >= 2 ) begin
        assign { south_up[1].flit.flit_type } = \south_up[1]\.flit[flit_type] ;
        assign { south_up[1].flit.payload } = \south_up[1]\.flit[payload] ;
        assign { south_up[1].enable } = \south_up[1]\.enable ;
        assign { \south_up[1]\.ack } = south_up[1].ack;
        assign { \south_up[1]\.rej } = south_up[1].rej;
        assign { \south_down[1]\.flit[flit_type] } = south_down[1].flit.flit_type;
        assign { \south_down[1]\.flit[payload] } = south_down[1].flit.payload;
        assign { \south_down[1]\.enable } = south_down[1].enable;
        assign { south_down[1].ack } = \south_down[1]\.ack ;
        assign { south_down[1].rej } = \south_down[1]\.rej ;
    end

    if ( MESH_HEIGHT >= 2 ) begin
        assign { east_up[1].flit.flit_type } = \east_up[1]\.flit[flit_type] ;
        assign { east_up[1].flit.payload } = \east_up[1]\.flit[payload] ;
        assign { east_up[1].enable } = \east_up[1]\.enable ;
        assign { \east_up[1]\.ack } = east_up[1].ack;
        assign { \east_up[1]\.rej } = east_up[1].rej;
        assign { \east_down[1]\.flit[flit_type] } = east_down[1].flit.flit_type;
        assign { \east_down[1]\.flit[payload] } = east_down[1].flit.payload;
        assign { \east_down[1]\.enable } = east_down[1].enable;
        assign { east_down[1].ack } = \east_down[1]\.ack ;
        assign { east_down[1].rej } = \east_down[1]\.rej ;
    end

    if ( MESH_HEIGHT >= 2 ) begin
        assign { west_up[1].flit.flit_type } = \west_up[1]\.flit[flit_type] ;
        assign { west_up[1].flit.payload } = \west_up[1]\.flit[payload] ;
        assign { west_up[1].enable } = \west_up[1]\.enable ;
        assign { \west_up[1]\.ack } = west_up[1].ack;
        assign { \west_up[1]\.rej } = west_up[1].rej;
        assign { \west_down[1]\.flit[flit_type] } = west_down[1].flit.flit_type;
        assign { \west_down[1]\.flit[payload] } = west_down[1].flit.payload;
        assign { \west_down[1]\.enable } = west_down[1].enable;
        assign { west_down[1].ack } = \west_down[1]\.ack ;
        assign { west_down[1].rej } = \west_down[1]\.rej ;
    end

    if ( MESH_WIDTH >= 3 ) begin
        assign { north_up[2].flit.flit_type } = \north_up[2]\.flit[flit_type] ;
        assign { north_up[2].flit.payload } = \north_up[2]\.flit[payload] ;
        assign { north_up[2].enable } = \north_up[2]\.enable ;
        assign { \north_up[2]\.ack } = north_up[2].ack;
        assign { \north_up[2]\.rej } = north_up[2].rej;
        assign { \north_down[2]\.flit[flit_type] } = north_down[2].flit.flit_type;
        assign { \north_down[2]\.flit[payload] } = north_down[2].flit.payload;
        assign { \north_down[2]\.enable } = north_down[2].enable;
        assign { north_down[2].ack } = \north_down[2]\.ack ;
        assign { north_down[2].rej } = \north_down[2]\.rej ;
    end

    if ( MESH_WIDTH >= 3 ) begin
        assign { south_up[2].flit.flit_type } = \south_up[2]\.flit[flit_type] ;
        assign { south_up[2].flit.payload } = \south_up[2]\.flit[payload] ;
        assign { south_up[2].enable } = \south_up[2]\.enable ;
        assign { \south_up[2]\.ack } = south_up[2].ack;
        assign { \south_up[2]\.rej } = south_up[2].rej;
        assign { \south_down[2]\.flit[flit_type] } = south_down[2].flit.flit_type;
        assign { \south_down[2]\.flit[payload] } = south_down[2].flit.payload;
        assign { \south_down[2]\.enable } = south_down[2].enable;
        assign { south_down[2].ack } = \south_down[2]\.ack ;
        assign { south_down[2].rej } = \south_down[2]\.rej ;
    end

    if ( MESH_HEIGHT >= 3 ) begin
        assign { east_up[2].flit.flit_type } = \east_up[2]\.flit[flit_type] ;
        assign { east_up[2].flit.payload } = \east_up[2]\.flit[payload] ;
        assign { east_up[2].enable } = \east_up[2]\.enable ;
        assign { \east_up[2]\.ack } = east_up[2].ack;
        assign { \east_up[2]\.rej } = east_up[2].rej;
        assign { \east_down[2]\.flit[flit_type] } = east_down[2].flit.flit_type;
        assign { \east_down[2]\.flit[payload] } = east_down[2].flit.payload;
        assign { \east_down[2]\.enable } = east_down[2].enable;
        assign { east_down[2].ack } = \east_down[2]\.ack ;
        assign { east_down[2].rej } = \east_down[2]\.rej ;
    end

    if ( MESH_HEIGHT >= 3 ) begin
        assign { west_up[2].flit.flit_type } = \west_up[2]\.flit[flit_type] ;
        assign { west_up[2].flit.payload } = \west_up[2]\.flit[payload] ;
        assign { west_up[2].enable } = \west_up[2]\.enable ;
        assign { \west_up[2]\.ack } = west_up[2].ack;
        assign { \west_up[2]\.rej } = west_up[2].rej;
        assign { \west_down[2]\.flit[flit_type] } = west_down[2].flit.flit_type;
        assign { \west_down[2]\.flit[payload] } = west_down[2].flit.payload;
        assign { \west_down[2]\.enable } = west_down[2].enable;
        assign { west_down[2].ack } = \west_down[2]\.ack ;
        assign { west_down[2].rej } = \west_down[2]\.rej ;
    end

    if ( MESH_WIDTH >= 4 ) begin
        assign { north_up[3].flit.flit_type } = \north_up[3]\.flit[flit_type] ;
        assign { north_up[3].flit.payload } = \north_up[3]\.flit[payload] ;
        assign { north_up[3].enable } = \north_up[3]\.enable ;
        assign { \north_up[3]\.ack } = north_up[3].ack;
        assign { \north_up[3]\.rej } = north_up[3].rej;
        assign { \north_down[3]\.flit[flit_type] } = north_down[3].flit.flit_type;
        assign { \north_down[3]\.flit[payload] } = north_down[3].flit.payload;
        assign { \north_down[3]\.enable } = north_down[3].enable;
        assign { north_down[3].ack } = \north_down[3]\.ack ;
        assign { north_down[3].rej } = \north_down[3]\.rej ;
    end

    if ( MESH_WIDTH >= 4 ) begin
        assign { south_up[3].flit.flit_type } = \south_up[3]\.flit[flit_type] ;
        assign { south_up[3].flit.payload } = \south_up[3]\.flit[payload] ;
        assign { south_up[3].enable } = \south_up[3]\.enable ;
        assign { \south_up[3]\.ack } = south_up[3].ack;
        assign { \south_up[3]\.rej } = south_up[3].rej;
        assign { \south_down[3]\.flit[flit_type] } = south_down[3].flit.flit_type;
        assign { \south_down[3]\.flit[payload] } = south_down[3].flit.payload;
        assign { \south_down[3]\.enable } = south_down[3].enable;
        assign { south_down[3].ack } = \south_down[3]\.ack ;
        assign { south_down[3].rej } = \south_down[3]\.rej ;
    end

    if ( MESH_HEIGHT >= 4 ) begin
        assign { east_up[3].flit.flit_type } = \east_up[3]\.flit[flit_type] ;
        assign { east_up[3].flit.payload } = \east_up[3]\.flit[payload] ;
        assign { east_up[3].enable } = \east_up[3]\.enable ;
        assign { \east_up[3]\.ack } = east_up[3].ack;
        assign { \east_up[3]\.rej } = east_up[3].rej;
        assign { \east_down[3]\.flit[flit_type] } = east_down[3].flit.flit_type;
        assign { \east_down[3]\.flit[payload] } = east_down[3].flit.payload;
        assign { \east_down[3]\.enable } = east_down[3].enable;
        assign { east_down[3].ack } = \east_down[3]\.ack ;
        assign { east_down[3].rej } = \east_down[3]\.rej ;
    end

    if ( MESH_HEIGHT >= 4 ) begin
        assign { west_up[3].flit.flit_type } = \west_up[3]\.flit[flit_type] ;
        assign { west_up[3].flit.payload } = \west_up[3]\.flit[payload] ;
        assign { west_up[3].enable } = \west_up[3]\.enable ;
        assign { \west_up[3]\.ack } = west_up[3].ack;
        assign { \west_up[3]\.rej } = west_up[3].rej;
        assign { \west_down[3]\.flit[flit_type] } = west_down[3].flit.flit_type;
        assign { \west_down[3]\.flit[payload] } = west_down[3].flit.payload;
        assign { \west_down[3]\.enable } = west_down[3].enable;
        assign { west_down[3].ack } = \west_down[3]\.ack ;
        assign { west_down[3].rej } = \west_down[3]\.rej ;
    end

    if ( MESH_WIDTH >= 5 ) begin
        assign { north_up[4].flit.flit_type } = \north_up[4]\.flit[flit_type] ;
        assign { north_up[4].flit.payload } = \north_up[4]\.flit[payload] ;
        assign { north_up[4].enable } = \north_up[4]\.enable ;
        assign { \north_up[4]\.ack } = north_up[4].ack;
        assign { \north_up[4]\.rej } = north_up[4].rej;
        assign { \north_down[4]\.flit[flit_type] } = north_down[4].flit.flit_type;
        assign { \north_down[4]\.flit[payload] } = north_down[4].flit.payload;
        assign { \north_down[4]\.enable } = north_down[4].enable;
        assign { north_down[4].ack } = \north_down[4]\.ack ;
        assign { north_down[4].rej } = \north_down[4]\.rej ;
    end

    if ( MESH_WIDTH >= 5 ) begin
        assign { south_up[4].flit.flit_type } = \south_up[4]\.flit[flit_type] ;
        assign { south_up[4].flit.payload } = \south_up[4]\.flit[payload] ;
        assign { south_up[4].enable } = \south_up[4]\.enable ;
        assign { \south_up[4]\.ack } = south_up[4].ack;
        assign { \south_up[4]\.rej } = south_up[4].rej;
        assign { \south_down[4]\.flit[flit_type] } = south_down[4].flit.flit_type;
        assign { \south_down[4]\.flit[payload] } = south_down[4].flit.payload;
        assign { \south_down[4]\.enable } = south_down[4].enable;
        assign { south_down[4].ack } = \south_down[4]\.ack ;
        assign { south_down[4].rej } = \south_down[4]\.rej ;
    end

    if ( MESH_HEIGHT >= 5 ) begin
        assign { east_up[4].flit.flit_type } = \east_up[4]\.flit[flit_type] ;
        assign { east_up[4].flit.payload } = \east_up[4]\.flit[payload] ;
        assign { east_up[4].enable } = \east_up[4]\.enable ;
        assign { \east_up[4]\.ack } = east_up[4].ack;
        assign { \east_up[4]\.rej } = east_up[4].rej;
        assign { \east_down[4]\.flit[flit_type] } = east_down[4].flit.flit_type;
        assign { \east_down[4]\.flit[payload] } = east_down[4].flit.payload;
        assign { \east_down[4]\.enable } = east_down[4].enable;
        assign { east_down[4].ack } = \east_down[4]\.ack ;
        assign { east_down[4].rej } = \east_down[4]\.rej ;
    end

    if ( MESH_HEIGHT >= 5 ) begin
        assign { west_up[4].flit.flit_type } = \west_up[4]\.flit[flit_type] ;
        assign { west_up[4].flit.payload } = \west_up[4]\.flit[payload] ;
        assign { west_up[4].enable } = \west_up[4]\.enable ;
        assign { \west_up[4]\.ack } = west_up[4].ack;
        assign { \west_up[4]\.rej } = west_up[4].rej;
        assign { \west_down[4]\.flit[flit_type] } = west_down[4].flit.flit_type;
        assign { \west_down[4]\.flit[payload] } = west_down[4].flit.payload;
        assign { \west_down[4]\.enable } = west_down[4].enable;
        assign { west_down[4].ack } = \west_down[4]\.ack ;
        assign { west_down[4].rej } = \west_down[4]\.rej ;
    end

endgenerate

		mesh mesh (.*);
	`endif
endmodule