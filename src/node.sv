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
    
    // Backpressure
    logic ack;
    
    modport down (
        input  flit,
        input  enable,        
        output ack
    );
    
    modport up (
        output flit,
        output enable,
        input  ack
    );
endinterface

module node_link(
    node_port.up up,
    node_port.down down
    );
    assign down.flit = up.flit;
    assign down.enable = up.enable;
    assign down.ack = up.ack;
endmodule

function dir_t dimensional_order_routing(int x, int y, addr_t dst);
    // TODO: Do this
    
    // This is the desired column
    if (dst.y == y) begin
        if (dst.x == x) begin
            // This should not happen
            $error("Illegal state: Node received flit with himself as the destination");
        end else if (dst.x > x) begin
            return SOUTH;
        end else begin
            return NORTH;
        end
    end else if (dst.y > y) begin
        return EAST;
    end else begin // dst.y < y
        return WEST;
    end
    
    return EAST;
endfunction

// TODO: Parameter con su pos dentor de la red
module node #(
    parameter X = 1,
    parameter Y = 1
) (
    input clk,
    input rst,
    
    node_port.up   ports_up[4],
    node_port.down ports_down[4]
    );
    
    localparam PORTS = 4;
    typedef enum { IDLE, ESTABLISHED } state_t;
    
    reg [PORTS-1:0] dest[PORTS];
    reg             dest_en[PORTS];
    reg state[PORTS];
    logic [PORTS-1:0] ack;
    // TODO: Use `FLIT_WIDTH
    logic [$bits(flit_t)-1:0] data_i[PORTS];
    logic [$bits(flit_t)-1:0] data_o[PORTS];
    
    crossbar #(
        .PORTS(PORTS),
        .WIDTH($bits(flit_t))
    ) cb (
        .data_i(data_i),
        .dest(dest),
        .data_o(data_o),
        .ack(ack)
    );
    
    // Connect crossbar to input/output
    genvar gi;
    generate
        for (gi = 0; gi < PORTS; gi++)
        begin
            assign data_i[gi] = ports_down[gi].flit;
            assign ports_up[gi].flit = data_o[gi];
        end
    endgenerate
    
    always @ (posedge clk) begin
      if (rst) begin
        for (int i = 0; i < 4; i++)
        begin
            dest[i] <= 0;
            dest_en[i] <= 0;
            ack[i] <= 0;
            state[i] <= IDLE;
        end
      end else if (clk) begin
        for (int i = 0; i < PORTS; i++) 
        begin
          // logic enable = ports_down[i].enable;
          // flit_t flit = ports_down[i].flit;
          case (state[i])
            IDLE:
                // If there is a header trying to enter
                if (ports_down[i].enable)
                begin
                    control_hdr_t hdr = ports_down[i].flit.payload;

                    // Get destination port from header (Dimensional Order Routing)
                    dest[i] <= dimensional_order_routing(X, Y, hdr.dst_addr);
                    
                    // Allocate output port if possible (check in dest if its used)
                    
                    // Check if output port has been allocated by the following routers (check ports_down[i].ack)
                    
                    // Enable  ACK
                    if (ack[dest[i]]) begin
                        state[i] <= ESTABLISHED;
                    end
                end
            ESTABLISHED:
                begin
                    // Just retransmit the data
                    
                    if (flit.flit_type == TAIL) begin
                        // Liberate allocated resources
                        dest_en[i] <= 0;
                        ack[i] <= 0;
                        
                        state[i] <= IDLE;
                    end
                end
          endcase
         end
      end
   end
endmodule
