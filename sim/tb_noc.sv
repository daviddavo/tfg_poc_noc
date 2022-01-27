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
`define MESH_HEIGHT 1
`define MESH_WIDTH 2

module tb_noc;
    flit_t flit;
    flit_hdr_t hdr;
    logic clk, rst;
    
    // node_port ports_up[4]();

//    node_port west_up[`MESH_HEIGHT]();
//    node_port west_down[`MESH_HEIGHT]();

//    node_port east_up[`MESH_HEIGHT]();
//    node_port east_down[`MESH_HEIGHT]();
    
//    node_port north_up [`MESH_WIDTH]();
//    node_port north_down [`MESH_WIDTH]();

//    node_port south_up[`MESH_WIDTH] ();
//    node_port south_down[`MESH_WIDTH]() ;
    
//    mesh #(`MESH_HEIGHT, `MESH_WIDTH) mesh (.*);

    node_port ports_up[4] ();
    node_port ports_down[4] ();
    node n (.*);
    
    always #5 clk = ~clk;
    
    initial begin
        rst = 1;
        clk = 0;
        
        // i is NoT A CoNStANT >:(
        // so we have to do it manually
        
        // every port is willing to receive data
        ports_up[NORTH].ack = 1;
        ports_up[SOUTH].ack = 1;
        ports_up[EAST].ack = 1;
        ports_up[WEST].ack = 1;
        
        #10 rst = 0;

        // Keep in the same line, but go EAST
        hdr.dst_addr.x = 1;
        hdr.dst_addr.y = `MESH_WIDTH+1;
        hdr.tail_length = 3;
        
        ports_down[NORTH].flit = 0;
        ports_down[NORTH].enable = 0;
        ports_down[SOUTH].flit = 0;
        ports_down[SOUTH].enable = 0;
        ports_down[EAST].flit = 0;
        ports_down[EAST].enable = 0;
        
        ports_down[WEST].flit.flit_type = HEADER;
        ports_down[WEST].flit.payload = hdr;
        ports_down[WEST].enable = 1;
        $strobe("> ack[WEST] is %b", ports_down[WEST].ack);
        $strobe("> enable[EAST] is %b", ports_up[EAST].ack);
        $strobe("> dest[WEST] is %s", n.dest[WEST]);
        $strobe("> bp_data_i[EAST] is %b", n.bp_data_i[EAST]);
        $strobe("> bp_data_o[WEST] is %b", n.bp_data_o[WEST]); 
                
        #10
        // Going SOUTH
        hdr.dst_addr.x = 2;
        hdr.dst_addr.y = 1;
        ports_down[NORTH].flit.flit_type = HEADER;
        ports_down[NORTH].flit.payload = hdr;
        ports_down[NORTH].enable = 1;
        
        $display("> ports_down[NORTH].ack is %b",ports_down[NORTH].ack);
        $strobe("> ports_down[NORTH].ack is %b",ports_down[NORTH].ack); 
        assert(ports_down[NORTH].ack);
        
        #30
        ports_down[WEST].flit.flit_type = TAIL;

        #100 $finish;
    end
    
    
endmodule
