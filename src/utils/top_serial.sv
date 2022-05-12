`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.05.2022 19:50:38
// Design Name: 
// Module Name: top_serial
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


module top_serial(
  input clk,
  input rst,
  input flush,
  input [3:0] sender_padding,
  input [41:0] sender_packet,
  input sender_enable,
  output sender_ack,
  output receiver_valid,
  output [3:0] receiver_padding,
  output [41:0] receiver_packet
    );
localparam MESH_HEIGHT = 3;
localparam MESH_WIDTH = 3;

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
    ) i_mesh (.*);

noc_serial_sender #(
  .PACKET_BITS(42),
  .PADDING_BITS(4)
) i_sender (.*,
  .up ( north_down[0] ),
  .enable(sender_enable),
  .ack (sender_ack),
  .dst_addr( '{MESH_HEIGHT+1,1} ), // dst: south_down[1]
  .padding (sender_padding),
  .packet (sender_packet)
);

noc_serial_receiver #(
  .PACKET_BITS(42),
  .PADDING_BITS(4)
) i_receiver (.*,
  .down ( south_up[0] ),
  .valid (receiver_valid),
  .padding (receiver_padding),
  .packet (receiver_packet)
);

endmodule
