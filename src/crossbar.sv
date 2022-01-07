`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.01.2022 12:11:03
// Design Name: 
// Module Name: crossbar
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Implementation of a crossbar with multicast 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//   Based on https://stackoverflow.com/questions/70606907/reduction-or-with-stride/70608835#70608835
//////////////////////////////////////////////////////////////////////////////////
module crossbar #(
    parameter PORTS = 2,
    parameter WIDTH = 8
)(
     input        [WIDTH-1:0] data_i[PORTS],
     input        [PORTS-1:0] dest[PORTS],
     
     output logic [WIDTH-1:0] data_o[PORTS],
     output logic [PORTS-1:0] ack[PORTS]
);

always_comb begin 
    logic used[PORTS];

    // First resetting to 0
    for ( int j = 0; j < PORTS; j++ )
    begin
        used[j] = 0;
        data_o[j] = 0;
    end
       
    // For each input port
    for ( int i = 0; i < PORTS; i++ )
    begin
        // For each output port
        for ( int j = 0; j < PORTS; j++)
        begin
            ack[i][j] = dest[i][j] && !used[j];
            used[j] = used[j] | ack[i][j];
            
            if (ack[i][j])
            begin
                assert (data_o[j] == 0);
                data_o[j] = data_i[i];
            end
        end
    end
    
    // Verification
end

// ---------------------------
// IMPLEMENTATION USING ASSIGN
// ---------------------------
// Auxiliar for the ack
//logic used[PORTS][PORTS];

//generate
//    genvar i, j;
    
//    // For each input port
//    for ( i = 0; i < PORTS; i++ )
//    begin
//        // For each possible output
//        for ( j = 0; j < PORTS; j++) 
//        begin
//            assign ack[i][j] = dest[i][j] && !used[i-1][j]; // que queramos escribir y no haya ya nadie asignado
//            assign used[i][j] = i == 0 ? 1'b0 : ack [i][j] | used[i-1][j];
//            assign data_o[j] = ack[i][j] ? data_i[i] : 0;
//        end
//    end
//endgenerate
endmodule
