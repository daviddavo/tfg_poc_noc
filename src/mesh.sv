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
    parameter MESH_HEIGHT = 1,
    parameter MESH_WIDTH = 3
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

    localparam EDGE_NORTH = 0;
    localparam EDGE_SOUTH = MESH_HEIGHT-1;
    localparam EDGE_EAST = MESH_WIDTH-1;
    localparam EDGE_WEST = 0;
    
    generate
    genvar i, j;
    
    // Generating nodes
    // TODO: Flatten into one array
    for ( i = 0; i < MESH_HEIGHT; i++ )
    begin: nodes_h
        for ( j = 0; j < MESH_WIDTH; j++ )
        begin: nodes_w
            node_port north_up();
            node_port south_up();
            node_port east_up();
            node_port west_up();
            
            node_port north_down();
            node_port south_down();
            node_port east_down();
            node_port west_down();
        
            node node (
                .clk(clk),
                .rst(rst),
                // up
                .n_u(north_up),
                .s_u(south_up),
                .e_u(east_up),
                .w_u(west_up),
                // down
                .n_d(north_down),
                .s_d(south_down),
                .e_d(east_down),
                .w_d(west_down)
            );
        end
    end
    
    // Connects node to next node horizontally
    for ( i = 0; i < MESH_HEIGHT; i++)
    begin
        for ( j = 0; j < MESH_WIDTH-1; j++) 
        begin
            // West to East
            node_link west2east (
                .up(nodes_h[i].nodes_w[j].west_up),
                .down(nodes_h[i].nodes_w[(j+1)%MESH_WIDTH].east_down)
            );
            // East to West
            node_link east2west (
                .up(nodes_h[i].nodes_w[(j+1)%MESH_WIDTH].east_up), 
                .down(nodes_h[i].nodes_w[j].west_down)
            );
        end
    end
    
    // Connects node to next node vertically
    for ( j = 0; j < MESH_WIDTH; j++)
    begin
        for ( i = 0; i < MESH_HEIGHT-1; i++)
        begin
            // North to South
            node_link north2south (
                .up(nodes_h[i].nodes_w[j].north_up),
                .down(nodes_h[i+1].nodes_w[j].south_down)
            );
            
            // South to North
            node_link south2north (
                .up(nodes_h[i+1].nodes_w[j].south_up),
                .down(nodes_h[i].nodes_w[j].north_down)
            );
        end
    end
    
    // Connect east and west edges
    for ( i = 0; i < MESH_HEIGHT; i++)
    begin
        node_link westOut (
            .up(nodes_h[i].nodes_w[EDGE_WEST].west_up),
            .down(west_down[i])
        );
        
        node_link westIn (
            .up(west_up[i]),
            .down(nodes_h[i].nodes_w[EDGE_WEST].west_down)
        );
        
        node_link eastOut (
            .up(nodes_h[i].nodes_w[EDGE_EAST].east_up),
            .down(east_down[i])
        );
        
        node_link eastIn (
            .up(east_up[i]),
            .down(nodes_h[i].nodes_w[EDGE_EAST].east_down)
        );
    end
    
    // Connect north and south edges
    for ( j = 0; j < MESH_WIDTH; j++)
    begin
        node_link northOut (
            .up(nodes_h[EDGE_NORTH].nodes_w[j].north_up),
            .down(north_down[j])
        );
        
        node_link northIn (
            .up(north_up[j]),
            .down(nodes_h[EDGE_NORTH].nodes_w[j].north_down)
        );
        
        node_link southOut (
            .up(nodes_h[EDGE_SOUTH].nodes_w[j].south_up),
            .down(south_down[j])
        );
        
        node_link southIn (
            .up(south_up[j]),
            .down(nodes_h[EDGE_SOUTH].nodes_w[j].south_down)
        );
    end
    endgenerate
endmodule
