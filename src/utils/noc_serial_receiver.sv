`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.05.2022 22:07:06
// Design Name: 
// Module Name: noc_serial_receiver
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
module noc_serial_receiver
import noc_types::*; 
#(
    parameter PACKET_BITS=16,
    parameter PADDING_BITS=0
) (
    input                     clk,
    input                     rst,
    input                     flush,  // I: Frees the buffers (like a soft rst)  
    node_port.down            down,   // I: From NoC
    
    output logic              valid,  // O: Whether padding and packet are valid
    output [PADDING_BITS-1:0] padding,
    output [PACKET_BITS-1:0]  packet 
    );
    
    localparam N_FLITS   = ( PACKET_BITS + `FLIT_DATA_WIDTH - 1 ) / `FLIT_DATA_WIDTH;
    
    typedef enum { IDLE, RECEIVING, VALID } e_div_state;
    
    e_div_state                          state, nextstate;
    flit_hdr_t                           hdr_reg;
    logic                                hdr_reg_en;
    logic [`FLIT_DATA_WIDTH-1:0]         payload_regs [N_FLITS];
    logic [N_FLITS*`FLIT_DATA_WIDTH-1:0] payload_regs_unpack;
    logic [N_FLITS-1:0]                  payload_regs_en;
    logic [$clog2(N_FLITS)-1:0]          cnt, nextcnt;
    
    // We quiet the output bus if is not valid
    
    generate if (PADDING_BITS > 0)
        assign padding = {PADDING_BITS{valid}} & hdr_reg.free;
    endgenerate
    // payload_regs[0] has the less significant bits
    assign payload_regs_unpack = {<<`FLIT_DATA_WIDTH{payload_regs}};
    // We quiet the output bus if is not valid
    assign packet = {PACKET_BITS{valid}} & payload_regs_unpack[PACKET_BITS-1:0];
    
    always_ff @ (posedge clk, posedge rst) begin: fsm
        if (rst) begin
            state <= IDLE;
            cnt <= 0;
            hdr_reg <= 0;
              
            for ( int i = 0; i < N_FLITS; i++)
                payload_regs[i] <= 0;
        end else if (clk) begin
            state <= nextstate;
            cnt <= nextcnt;
            
            if (hdr_reg_en) hdr_reg <= down.flit.payload.hdr;
              
            for ( int i = 0; i < N_FLITS; i++) begin
                if (payload_regs_en[i]) payload_regs[i] <= down.flit.payload;
            end
        end
    end : fsm
    
    always_comb begin : fsm_nextstate
        automatic flit_t flit = down.flit;
        
        down.ack = 1;
        down.rej = 0;
  
        nextstate = IDLE;
        payload_regs_en = 0;
        hdr_reg_en = 0;
        nextcnt = 0;
        valid = 0;
      
        case (state)
          IDLE:
            if (down.enable && flit.flit_type == HEADER) begin
              nextstate = RECEIVING;
              hdr_reg_en = 1;
            end
          RECEIVING:
            if (flit.flit_type == HEADER) begin
              // The header can be repeated
              nextstate = RECEIVING;
            end else if (flit.flit_type == DATA || flit.flit_type == TAIL) begin
              // cnt -> DECIMAL DECODER -> payload_regs_en
              // payload_regs_en[cnt] = 1;
              
              payload_regs_en = 'b1 << cnt; 
              nextstate = RECEIVING;
              nextcnt = cnt + 1;
              
              if (flit.flit_type == TAIL) begin
                // nextcnt may overflow
                assert (cnt == N_FLITS - 1);
                nextstate = VALID;
              end
            end
          VALID:
            begin
              // Waiting for flush
              down.ack = 0;
              valid = 1;
              if (flush) begin
                  nextstate = IDLE;
                  nextcnt = 0;
              end else
                  nextstate = VALID;
            end
        endcase
    end: fsm_nextstate
endmodule
