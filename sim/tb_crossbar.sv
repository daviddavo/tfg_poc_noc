`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/02/2022 07:01:31 PM
// Design Name: 
// Module Name: tb_crossbar
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
module tb_crossbar;
    localparam PORTS = 4;
    localparam WIDTH = 8;
    localparam BP_WIDTH = 1;

    logic clk, rst;
    
    logic [WIDTH-1:0]           data_i[PORTS];
    logic [BP_WIDTH-1:0]        bp_i[PORTS];
    logic [$clog2(PORTS)-1:0]   dest[PORTS];
    logic                       dest_en[PORTS];
    logic [WIDTH-1:0] data_o[PORTS];
    logic [BP_WIDTH-1:0] bp_o[PORTS];
    logic ack[PORTS];
    
    always #5 clk = ~clk;
    
    crossbar_rr #(PORTS, WIDTH, BP_WIDTH) cb (.*);
    
    initial begin
        clk <= 0;
        rst <= 1;
        
        for (int i = 0; i < PORTS; i++) begin
            data_i[i] <= i+1;
            bp_i[i] <= 1;
            dest_en[i] <= 0;
        end
        
        #20
        rst <= 0;
        dest[0] <= 3;
        dest_en[0] <= 1;
        dest[1] <= 3;
        dest_en[1] <= 1;
        
        #40
        for (int i = 0; i < PORTS; i++) begin
            dest[i] <= 1;
            dest_en[i] <= 1;
        end
        
        #40
        dest[0] <= 2;
        dest[2] <= 2;
        
        #40
        for (int i = 0; i < PORTS; i++) begin
            dest[i] <= i;
        end
    end
endmodule
