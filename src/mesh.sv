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
              parameter MESH_HEIGHT = 3,
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
      genvar          i, j;
      
      // Generating nodes
      // TODO: Flatten into one array
      for ( i = 0; i < MESH_HEIGHT; i++ ) begin: nodes_h
         for ( j = 0; j < MESH_WIDTH; j++ ) begin: nodes_w
            // TODO: Use `NODE_PORTS
            node_port ports_up[4]();
            node_port ports_down[4]();
            
            node #(
                   .X(i+1),
                   .Y(j+1),
                   .X_EDGE(MESH_HEIGHT+1),
                   .Y_EDGE(MESH_WIDTH+1)
                   ) node (
                           .clk(clk),
                           .rst(rst),
                           .ports_up(ports_up),
                           .ports_down(ports_down)
                           );
         end
      end
      
      // Connects node to next node horizontally
      for ( i = 0; i < MESH_HEIGHT; i++) begin
         for ( j = 0; j < MESH_WIDTH-1; j++) begin
            // East to West
            node_link east2west (
                                 .down(nodes_h[i].nodes_w[j].ports_up[EAST]),
                                 .up(nodes_h[i].nodes_w[j+1].ports_down[WEST])
                                 );
            // West to East
            node_link west2east (
                                .down(nodes_h[i].nodes_w[j+1].ports_up[WEST]),
                                .up(nodes_h[i].nodes_w[j].ports_down[EAST])
                                );
         end
      end
      
      // Connects node to next node vertically
      for ( j = 0; j < MESH_WIDTH; j++) begin
         for ( i = 0; i < MESH_HEIGHT-1; i++) begin
            // South to North
            node_link south2north (
                                   .down(nodes_h[i].nodes_w[j].ports_up[SOUTH]),
                                   .up(nodes_h[i+1].nodes_w[j].ports_down[NORTH])
                                   );

            // North to South
            node_link north2south (
                                   .down(nodes_h[i+1].nodes_w[j].ports_up[NORTH]),
                                   .up(nodes_h[i].nodes_w[j].ports_down[SOUTH])
                                   );
         end
      end
      
      // Connect east and west edges
      for ( i = 0; i < MESH_HEIGHT; i++) begin
            // Conencting west mesh input to west node input
            node_link westIn (
                              .down(west_down[i]),
                              .up(nodes_h[i].nodes_w[EDGE_WEST].ports_down[WEST])
                              );
                              
            // Connecting west node output to west mesh output
            node_link westOut (
                              .down(nodes_h[i].nodes_w[EDGE_WEST].ports_up[WEST]),
                              .up(west_up[i])
                              );
                              
            // Connecting east mesh input to east node input
            node_link eastIn (
                             .down(east_down[i]),
                             .up(nodes_h[i].nodes_w[EDGE_EAST].ports_down[EAST])
                             );
                              
            // Connecting east node output to west mesh output
            node_link eastOut (
                               .down(nodes_h[i].nodes_w[EDGE_EAST].ports_up[EAST]),
                               .up(east_up[i])
                               );
      end
      
      // Connect north and south edges
      for ( j = 0; j < MESH_WIDTH; j++) begin
            // Connecting north mesh input to north node input
            node_link northIn (
                               .down(north_down[j]),
                               .up(nodes_h[EDGE_NORTH].nodes_w[j].ports_down[NORTH])
                               );
                               
            // Connecting north node output to north mesh output
            node_link northOut (
                                .down(nodes_h[EDGE_NORTH].nodes_w[j].ports_up[NORTH]),
                                .up(north_up[j])
                                );
                                
            // Connecting south mesh input to south node input
            node_link southIn (
                               .down(south_down[j]),
                               .up(nodes_h[EDGE_SOUTH].nodes_w[j].ports_down[SOUTH])
                               );
                               
            // Connecting south node output to south mesh output
            node_link southOut (
                                .down(nodes_h[EDGE_SOUTH].nodes_w[j].ports_up[SOUTH]),
                                .up(south_up[j])
                                );
      end
   endgenerate
endmodule
