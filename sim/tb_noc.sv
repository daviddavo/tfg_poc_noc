`timescale 1ns / 100ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.11.2021 18:23:34
// Design Name: 
// Module Name: tb_noc
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
`define MESH_HEIGHT 5
`define MESH_WIDTH 5

function flit_t build_header(int dst_x, int dst_y);
    static flit_hdr_t hdr;
    hdr.dst_addr = '{dst_x, dst_y};
    hdr.tail_length = 0;
    return '{ HEADER, hdr };
endfunction

module tb_noc;
    logic clk, rst;

    node_port west_up[`MESH_HEIGHT]();
    node_port west_down[`MESH_HEIGHT]();
    node_port east_up[`MESH_HEIGHT]();
    node_port east_down[`MESH_HEIGHT]();    
    node_port north_up [`MESH_WIDTH]();
    node_port north_down [`MESH_WIDTH]();
    node_port south_up[`MESH_WIDTH] ();
    node_port south_down[`MESH_WIDTH]() ;
    
    mesh #(`MESH_HEIGHT, `MESH_WIDTH) mesh (.*);
    
    always #5 clk = ~clk;
    
    generate
        genvar gi;
        for ( gi = 0; gi < `MESH_HEIGHT; gi++) begin
            assign west_up[gi].ack = 1;
            assign east_up[gi].ack = 1;
        end
        
        for ( gi = 0; gi < `MESH_WIDTH; gi++) begin
            assign north_up[gi].ack = 1;
            assign south_up[gi].ack = 1;
        end
    endgenerate
    
    initial begin
        rst = 1;
        clk = 0;
        
        #10 rst = 0;

        // Keep in the same line, but go EAST
        west_down[0].flit = build_header(1, `MESH_WIDTH+1);
        west_down[0].enable = 1;
        
        #10
        assert(west_down[0].ack);
        assert(east_up[0].enable && east_up[0].flit == west_down[0].flit);
        west_down[0].flit.flit_type = TAIL;
        
        #10
        west_down[0].enable = 0;
        assert(!west_down[0].ack);
        
        // Keep in the same column, but go NORTH
        south_down[0].flit = build_header(0, 1);
        south_down[0].enable = 1;

        // At the same time, EAST -> WEST
        // note: this causes vivado to hang
        // east_down[0].flit = build_header(1, 0);
        // east_down[0].enable = 1;
        
        #10
        south_down[0].flit.flit_type = TAIL;
        east_down[0].flit.flit_type = TAIL;
        
        #10
        south_down[0].enable = 0;
        east_down[0].enable = 0;
        assert(!south_down[0].ack);
        assert(!east_down[0].ack);
        
        // Now, to check a diagonal west, NORTH -> east, SOUTH
        north_down[0].flit = build_header(`MESH_HEIGHT+1, `MESH_WIDTH);
        north_down[0].enable = 1;
        
        #10
        assert(south_up[`MESH_WIDTH-1].enable && south_up[`MESH_WIDTH-1].flit == north_down[0].flit);

        #20 $finish;
    end
    
    
endmodule
