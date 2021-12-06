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
    flit flit;
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
    
    node_port.up   e_u,
    node_port.up   w_u,
    node_port.down e_d,
    node_port.down w_d
    );
    
    flit out_w;
    flit out_e;
    reg out_e_enable;
    reg out_w_enable;
    
    always_comb begin
        e_u.flit <= out_e;
        e_u.enable <= out_e_enable;
        w_u.flit <= out_w;
        w_u.enable <= out_w_enable;
    end
    
    always @ (posedge clk) begin
      if (rst) begin
        out_w.data <= 7'b0;
        out_e.data <= 7'b0;
        out_e_enable <= 0;
        out_e_enable <= 0;
      end else if (clk) begin
        if (e_d.enable) begin
            out_w <= e_d.flit;
            out_w_enable <= 1;
        end else
            out_w_enable <= 0;
        
        if (w_d.enable) begin
            out_e <= w_d.flit;
            out_e_enable <= 1;
        end else
            out_e_enable <= 0;
      end
   end
endmodule
