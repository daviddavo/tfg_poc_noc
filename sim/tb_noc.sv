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


module tb_noc;
    reg clk;
    reg rst;
    flit sample_msg;
    reg sample_en;
    
    // Clock generation
    always #5 clk = ~clk;

    mesh #(
        .MESH_WIDTH(4)    
    ) mesh( 
        .rst(rst),
        .clk(clk),
        .sample_msg(sample_msg),
        .sample_en(sample_en)
    );
                
    initial begin
        rst = 1;
        clk = 0;
        sample_msg = '{ 8'b01000010 };
        
        #15 rst = 0;
        #10 sample_en <= 1;
        #10 sample_msg <= '{ 8'b0 };
        #10 sample_en <= 0;
        
        #100 $finish;
    end
    
    
endmodule
