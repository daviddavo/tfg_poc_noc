`timescale 1ns / 1ps
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
`define CB_PORTS 4
`define CB_WIDTH 8

module tb_noc;   
    reg [`CB_PORTS-1:0] dest[`CB_PORTS];
    reg [`CB_PORTS-1:0] ack[`CB_PORTS];
    reg [`CB_WIDTH-1:0] data_i[`CB_PORTS];
    reg [`CB_WIDTH-1:0] data_o[`CB_PORTS];
    
    
    // Clock generation
    // always #5 clk = ~clk;
    
    crossbar #(
        .PORTS(`CB_PORTS),
        .WIDTH(`CB_WIDTH)
    ) cb (.*);
                
    initial begin      
        for (int i = 0; i < `CB_PORTS; i++)
        begin
            data_i[i] <= `CB_WIDTH'b0;
            dest[i] <= `CB_PORTS'b0;
        end
        
        #5 data_i[0] <= `CB_WIDTH'h42;
           data_i[1] <= `CB_WIDTH'h20;
        #5 dest[0] <= 'b0001;
        #5 dest[0] <= 'b0010;
        #5 dest[0] <= 'b0100;
        #5 dest[0] <= 'b1000;
        #5 dest[0] <= 'b1111;
        #5 dest[1] <= 'b0101;
        #5 dest[0] <= 'b1011;
        
        #100 $finish;
    end
    
    
endmodule
