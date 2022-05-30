`timescale 1ns / 1ps
module tb_serial;
    logic clk, rst;
    logic [3:0] sender_padding;
    logic [41:0] sender_packet;
    logic sender_enable;
    logic sender_ack;
    logic flush;
    logic receiver_valid;
    logic [3:0] receiver_padding;
    logic [41:0] receiver_packet;

    top_serial DUT (.*);
    
    always #5 clk = ~clk;
    
    initial begin : main
        $timeformat(-9, 2, " ns", 20);
    
        clk = 0;
        sender_enable = 0;
        flush = 0;
        rst = 1;
        
        #110 rst = 0;
        
        sender_padding = 4'b1011;
        sender_packet = 42'h24c65316459;
        
        #10
        sender_enable = 1;
        
        wait (receiver_valid);
        assert (sender_packet == receiver_packet);
        assert (sender_padding == receiver_padding);
        
        #50 @(negedge clk); flush = 1; @(negedge clk); flush = 0;
        assert (!receiver_valid);
        
        wait (receiver_valid);
        assert (sender_packet == receiver_packet);
        assert (sender_padding == receiver_padding);
        
        #50 $finish;
    end : main
endmodule
