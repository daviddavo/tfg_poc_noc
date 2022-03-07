`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: David Davó
// 
// Create Date: 02.02.2022 18:15:34
// Design Name: 
// Module Name: crossbar_rr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Implementation of 2-way crossbar with round-robin priority
// Every clock the prioritized input will change to the next one
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
//////////////////////////////////////////////////////////////////////////////////
module crossbar_rr #(
          parameter PORTS = 2,
          parameter WIDTH = 8,
          parameter BP_WIDTH = 1
          )(
            input                       clk,
            input                       rst,
            input [WIDTH-1:0]           data_i[PORTS],
            input [BP_WIDTH-1:0]        bp_i[PORTS],
            input [$clog2(PORTS)-1:0]   dest[PORTS],
            input                       dest_en[PORTS],

            output logic [WIDTH-1:0] data_o[PORTS],
            output logic data_o_en[PORTS],
            output logic [BP_WIDTH-1:0] bp_o[PORTS],
            output logic ack[PORTS]
            );
   
   reg [$clog2(PORTS)-1:0] offset_reg;
            
   always_ff @ (posedge clk, posedge rst) begin
       if (rst) begin
         offset_reg <= 0;
       end else if (clk) begin
         offset_reg <= offset_reg + 1;
       end
   end

   always_comb begin : assign_output
      // internas 
      logic [$clog2(PORTS)-1:0] req [PORTS];
      logic req_valid[PORTS];
      logic [WIDTH-1:0] aux_data_o[PORTS];
      logic aux_data_o_en[PORTS];
      logic [BP_WIDTH-1:0] aux_bp_o[PORTS];
      logic aux_ack[PORTS];
   
      // First resetting to 0 to avoid latches
      for ( int j = 0; j < PORTS; j++ ) begin
//        ack[j] = 0;
//        data_o[j] = 0;
//        bp_o[j] = 0;
//        data_o_en[j] = 0;
        aux_ack[j] = 0;
        aux_data_o[j] = 0;
        aux_bp_o[j] = 0;
        aux_data_o_en[j] = 0;
        req_valid[j] = 0;
        req[j] = 0;
      end
      
      // For each requested dest
      for (int j = 0; j < PORTS; j++ ) begin
        automatic int i = (j+offset_reg)%PORTS;
        if (dest_en[i]) begin
            req[dest[i]] = i;
            req_valid[dest[i]] = 1;
        end
      end
      
      // For each used destination port
      for ( int j = 0; j < PORTS; j++ ) begin
        automatic int i = (j+offset_reg)%PORTS;
        // automatic int i = j;
        if (req_valid[i]) begin
          assert(dest[req[i]] == i);
          aux_ack[req[i]] = 1;
          aux_data_o[dest[req[i]]] = data_i[req[i]];
          aux_data_o_en[dest[req[i]]] = 1;
          aux_bp_o[req[i]] = bp_i[dest[req[i]]];
        end
      end
      
      // This forces it to set the data_o AFTER the new dest is calculated
      ack <= aux_ack;
      data_o <= aux_data_o;
      data_o_en <= aux_data_o_en;
      bp_o <= aux_bp_o;
   end : assign_output
endmodule
