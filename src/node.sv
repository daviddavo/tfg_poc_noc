`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.11.2021 18:13:09
// Design Name: 
// Module Name: node
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
interface node_port;
    flit_t flit;
    logic enable;
    
    modport down (
        input flit,
        input enable
    );
    
    modport up (
        output flit,
        output enable
    );
endinterface

module node_link(
    node_port.up up,
    node_port.down down
    );
    assign down.flit = up.flit;
    assign down.enable = up.enable;
endmodule

// TODO: Use verilog interfaces
// https://www.chipverify.com/systemverilog/systemverilog-interface
module node(
    input clk,
    input rst,
    
    node_port.up   n_u,
    node_port.up   s_u,
    node_port.up   e_u,
    node_port.up   w_u,
    
    node_port.down n_d,
    node_port.down s_d,
    node_port.down e_d,
    node_port.down w_d
    );
    
    localparam PORTS = 4;
    typedef enum { IDLE, ESTABLISHED } state_t;
    typedef enum { NORTH = 0, SOUTH = 1, EAST = 2, WEST = 3 } dir_t;
    
    reg [PORTS-1:0] dest[PORTS];
    reg             dest_en[PORTS];
    reg state;
    logic [PORTS-1:0] ack;
    logic [$bits(flit_t)-1:0] data_o[PORTS];
    
    crossbar #(
        .PORTS(PORTS),
        .WIDTH($bits(flit_t))
    ) cb (
        .data_i('{n_d.flit, s_d.flit, e_d.flit, w_d.flit}),
        .dest(dest),
        .data_o('{n_u.flit, s_u.flit, e_u.flit, w_u.flit}),
        .ack(ack)
    );
    
    always @ (posedge clk) begin
      if (rst) begin
        for (int i = 0; i < 4; i++)
        begin
            dest[i] <= 0;
            dest_en[i] <= 0;
            ack[i] <= 0;
            state <= IDLE;
        end
      end else if (clk) begin 
        case (state)
        IDLE:
            begin
                // If there is a header trying to enter
                
                // Extract address from header
                dir_t dst = NORTH; 
                
                // Get destination port from header (Dimensional Order Routing)
                
                // Allocate output port if possible (check in dest if its used)
                
                // Enable  ACK
                if (ack[dst]) begin
                    state <= ESTABLISHED;
                end
            end
        ESTABLISHED:
            begin
                // Just retransmit the data
                
                if (flit_t == IDLE) begin
                    // Liberate allocated resources
                    
                    state <= IDLE;
                end
            end
        endcase
      end
   end
endmodule
