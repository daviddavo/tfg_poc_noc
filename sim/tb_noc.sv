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
`include "common_defines.vh" // Data types are automatically imported. `defines aren't
`define MESH_HEIGHT 5
`define MESH_WIDTH 5

import noc_types::*;

class Packet;
    flit_t flits[];
    
    // data should be packed array of unknown dimension?
    function new(int dst_x, int dst_y, bit data []); // data can be = empty
        // Divide data into multiple flits
        // Make the last one a tail flit
        int n_flits = data.size() / `FLIT_DATA_WIDTH;
        int tail_length = data.size() % `FLIT_DATA_WIDTH;
        
        if (n_flits == 0) begin
            // Special case: no data. (TAIL still needed)
            this.flits = new[2];
            this.flits[1] = '{TAIL, 0};
        end else begin
            // +1 because of the HEADER
            this.flits = new[n_flits+1];

            // Divide data into multiple flits
            for (int i = 1; i <= n_flits; i++) begin
                this.flits[i].flit_type = i==n_flits?TAIL:DATA;
                
                // Little hack: If we access in a dyn array to an undefined index, it returns 0
                // So we don't need to add the special case for tail flits
                for (int j = 0; j < `FLIT_DATA_WIDTH; j++)
                    this.flits[i].payload[j] = data[(i-1)*`FLIT_DATA_WIDTH + j];
            end
        end
        
        // Put header in the front
        this.flits[0] = Packet::build_header(dst_x, dst_y, tail_length);
    endfunction: new
    
    static function flit_t build_header(int dst_x, int dst_y, int tail_length = 0);
        static flit_hdr_t hdr;
        hdr.dst_addr = '{dst_x, dst_y};
        hdr.tail_length = tail_length;
        return '{ HEADER, hdr };
    endfunction
endclass: Packet
    
module tb_noc;
    logic clk, rst;
    // {>>{ }} is the streaming operator to pack/unpack data
    // addr_t  addr_t https://www.amiq.com/consulting/2017/05/29/how-to-pack-data-using-systemverilog-streaming-operators/
    bit data [] = {>>{"Hello World!"}};
    Packet p;

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
        p = new(1, `MESH_WIDTH+1, data);
        west_down[0].enable = 1;
        foreach(p.flits[i]) begin
            #10
            west_down[0].flit = p.flits[i];
        end
        west_down[0].enable = 0;

        #20 $finish;
    end
    
    
endmodule
