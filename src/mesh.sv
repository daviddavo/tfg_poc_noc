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
module mesh #(
    parameter MESH_WIDTH = 2
)(
    // Port List
    input clk,
    input rst,
    input flit sample_msg,
    input sample_en
    );

    genvar j;
        for ( j = 0; j < MESH_WIDTH; j++) 
        begin: nodes
            node_port east_up();
            node_port west_up();
            node_port east_down();
            node_port west_down();
        
            node node (
                .clk(clk),
                .rst(rst),
                // up
                .e_u(east_up),
                .w_u(west_up),
                // down
                .e_d(east_down),
                .w_d(west_down)
            );
        end
        
        // Connects node to next node
        for ( j = 0; j < MESH_WIDTH-1; j++) 
        begin: links
            // Left to right
            node_link west2east (
                .up(nodes[j].west_up),
                .down(nodes[(j+1)%MESH_WIDTH].east_down)
            );
            // Right to left
            node_link east2west (
                .up(nodes[(j+1)%MESH_WIDTH].east_up), 
                .down(nodes[j].west_down)
            );
        end
        
        assign nodes[0].east_down.flit = sample_en ? sample_msg : nodes[MESH_WIDTH-1].west_up.flit;
        assign nodes[0].east_down.enable = sample_en | nodes[MESH_WIDTH-1].west_up.enable;
         
        assign nodes[MESH_WIDTH-1].west_down.flit = sample_en ? sample_msg: nodes[0].east_up.flit; 
        assign nodes[MESH_WIDTH-1].west_down.enable = sample_en | nodes[0].east_up.enable;
endmodule
