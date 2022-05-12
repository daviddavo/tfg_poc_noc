`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2022 22:07:06
// Design Name: 
// Module Name: noc_serial_sender
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
module noc_serial_sender import noc_types::*; #(
    parameter PACKET_BITS=16,
    parameter PADDING_BITS=0
) (
    input                    clk,
    input                    rst,
    input                    enable,  // I: Enable padding/packet
    input                    flush,   // I: Allows another transmission  
    input addr_t             dst_addr,
    input [PADDING_BITS-1:0] padding,
    input [PACKET_BITS-1:0]  packet ,
    
    output logic             ack,     // O: padding/packet have been sent and can be changed
    node_port.up             up       // Output to NoC
    );
    import noc_functions::*;
    
    localparam N_FLITS   = ( PACKET_BITS + `FLIT_DATA_WIDTH - 1) / `FLIT_DATA_WIDTH;
    
    typedef enum { IDLE, ESTABLISHING, SENDING, SENT } e_div_state;

    logic [$clog2(N_FLITS-1):0] cnt, next_cnt;    
    e_div_state state, nextstate;
    logic [`FLIT_DATA_WIDTH*N_FLITS-1:0] packet_pad;
    
    assign packet_pad = { '0, packet };
    
    always_ff @ (posedge clk, posedge rst) begin: fsm
        if (rst) begin
            state <= IDLE;
            cnt   <= 0;
        end else if (clk) begin
            state <= nextstate;
            cnt   <= next_cnt;
        end
    end
    
    always_comb begin : fsm_nextstate
        up.enable = 0;
        up.flit = 0;
        ack = 0;
        next_cnt = 0;
        
        nextstate = IDLE;
        
        case (state)
          IDLE:
            if (enable) begin
              up.enable = 1;
              up.flit = build_header2(dst_addr, padding);
              
              if (up.ack)
                nextstate = SENDING;
              else
                nextstate = ESTABLISHING;
            end
          ESTABLISHING:
            begin
              up.enable = 1;
              // We need to propagate the same flit
              up.flit = build_header2(dst_addr, padding);
              
              if (up.ack)
                nextstate = SENDING;
              else if (up.rej)
                nextstate = IDLE;
              else
                nextstate = ESTABLISHING;
            end
          SENDING:
            begin
              assert (up.ack);
              up.enable = 1;
              next_cnt = cnt+1;
              nextstate = SENDING;
              
              up.flit.flit_type = DATA;
              up.flit.payload = packet_pad[cnt*`FLIT_DATA_WIDTH +: `FLIT_DATA_WIDTH];
              
              if ( cnt >= N_FLITS-1) begin
                  up.flit.flit_type = TAIL;
                  next_cnt = 0;
                  nextstate = SENT;
              end
            end
          SENT:
            begin
              ack = 1;
              next_cnt = 0;
              
              if ( flush )
                nextstate = IDLE;
              else
                nextstate = SENT;
            end  
        endcase
    end : fsm_nextstate
endmodule
