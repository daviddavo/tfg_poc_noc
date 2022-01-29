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
`define MESH_HEIGHT 2
`define MESH_WIDTH 2

function flit_t build_header(int dst_x, int dst_y);
    flit_hdr_t hdr = '{ '{dst_x, dst_y}, 0};
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
        
        // Keep in the same column, but go SOUTH
        north_down[0].flit = build_header(`MESH_HEIGHT+1, 1);
        north_down[0].enable = 1;
        
        // TODO: The simulation gets stuck when two flits are entered to the network the same cycle
        east_down[0].flit = build_header(1, 0);
        east_down[0].enable = 1;
        #10
        assert(north_down[0].ack);
        assert(south_up[0].enable && north_up[0].flit == south_down[0].flit);
//        ports_down[WEST].enable = 1;
//        $strobe("> ack[WEST] is %b", ports_down[WEST].ack);
//        $strobe("> enable[EAST] is %b", ports_up[EAST].ack);
//        $strobe("> dest[WEST] is %s", n.dest[WEST]);
//        $strobe("> bp_data_i[EAST] is %b", n.bp_data_i[EAST]);
//        $strobe("> bp_data_o[WEST] is %b", n.bp_data_o[WEST]); 
                
//        #10
//        // Going SOUTH
//        hdr.dst_addr.x = 2;
//        hdr.dst_addr.y = 1;
//        ports_down[NORTH].flit.flit_type = HEADER;
//        ports_down[NORTH].flit.payload = hdr;
//        ports_down[NORTH].enable = 1;
        
//        $display("> ports_down[NORTH].ack is %b",ports_down[NORTH].ack);
//        $strobe("> ports_down[NORTH].ack is %b",ports_down[NORTH].ack); 
//        assert(ports_down[NORTH].ack);
        
//        #30
//        ports_down[WEST].flit.flit_type = TAIL;

        #20 $finish;
    end
    
    
endmodule
