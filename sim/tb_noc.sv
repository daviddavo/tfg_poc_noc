`timescale 1ns / 100ps
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
`include "common_defines.vh" // Data types are automatically imported. `defines aren't
`define MESH_HEIGHT 2
`define MESH_WIDTH 2

import noc_types::*;

class Packet;
    static int nextid = 0;
    
    int id;
    flit_t flits[];
    rand int dst_x;
    rand int dst_y;
    rand bit data[];
    int src_x;
    int src_y;
    
    constraint dst {
                   // Going to horizontal edge
                   ((dst_x == 0 || dst_x == `MESH_HEIGHT+1) && dst_y inside {[1:`MESH_WIDTH]}) ||
                   // or Going to vertical edge
                   ((dst_y == 0 || dst_y == `MESH_WIDTH+1) && dst_x inside {[1:`MESH_HEIGHT]});
                   };

    // Maximum size: 10 flits
    constraint data_size { data.size() inside {[1:10*`FLIT_DATA_WIDTH]}; };
                       
    function new(int dst_x=1, int dst_y=0, bit data []={});
        this.id = nextid;
        nextid++;
        
        this.dst_x = dst_x;
        this.dst_y = dst_y;
        this.data = data;
        
        this.genflits();
    endfunction: new
    
    function void genflits();
        // Divide data into multiple flits
        // Make the last one a tail flit

        int n_flits = this.data.size() / `FLIT_DATA_WIDTH;
        int tail_length = this.data.size() % `FLIT_DATA_WIDTH;
        
        if (n_flits == 0) begin
            // Special case: no data. (TAIL still needed)
            this.flits = new[2];
            this.flits[1] = '{TAIL, 0};
        end else begin
            // +1 because of the HEADER
            flits = new[n_flits+1];

            // Divide data into multiple flits
            for (int i = 1; i <= n_flits; i++) begin
                this.flits[i].flit_type = i==n_flits?TAIL:DATA;
                
                // Little hack: If we access in a dyn array to an undefined index, it returns 0
                // So we don't need to add the special case for tail flits
                for (int j = 0; j < `FLIT_DATA_WIDTH; j++)
                    this.flits[i].payload[j] = this.data[(i-1)*`FLIT_DATA_WIDTH + j];
            end
        end
        
        // Put header in the front
        this.flits[0] = this.build_header(this.dst_x, this.dst_y, tail_length);
    endfunction: genflits
    
    // Not supported by verilator...
    function void post_randomize();   
        this.genflits();
    endfunction: post_randomize
    
    function string toString();
        return $sformatf("Packet %3d, to %0d,%0d with data size: %3d (%0d flits)",
            this.id,
            this.dst_x, this.dst_y, 
            this.data.size(),
            this.flits.size());
    endfunction: toString
    
    function void set_src(int x, int y);
        src_x = x;
        src_y = y;
    endfunction: set_src
    
    function addr_t get_dst();
        return '{dst_x, dst_y};
    endfunction: get_dst
    
    static function flit_t build_header(int dst_x, int dst_y, int tail_length = 0);
        static flit_hdr_t hdr;
        hdr.dst_addr = '{dst_x, dst_y};
        hdr.tail_length = tail_length;
        return '{ HEADER, hdr };
    endfunction
endclass: Packet

class Sender;
    virtual node_port.down port;
    int x; int y;

    function new(virtual node_port.down port, int x, int y);
        this.port = port;
        this.x = this.y;
    endfunction: new
endclass: Sender

module tb_noc;
    logic clk, rst;
    int nclk = 0;
    
    localparam EDGE_NORTH = 0;
    localparam EDGE_SOUTH = `MESH_HEIGHT+1;
    localparam EDGE_EAST = `MESH_WIDTH+1;
    localparam EDGE_WEST = 0;
    
    node_port north_up [`MESH_WIDTH]();
    node_port north_down [`MESH_WIDTH]();
    node_port south_up[`MESH_WIDTH]();
    node_port south_down[`MESH_WIDTH]();
    node_port east_up[`MESH_HEIGHT]();
    node_port east_down[`MESH_HEIGHT]();
    node_port west_up[`MESH_HEIGHT]();
    node_port west_down[`MESH_HEIGHT]();
    
    virtual node_port.up vnorth_up[`MESH_WIDTH] = north_up;
    virtual node_port.down vnorth_down[`MESH_WIDTH] = north_down;
    virtual node_port.up vsouth_up[`MESH_WIDTH] = south_up;
    virtual node_port.down vsouth_down[`MESH_WIDTH] = south_down;
    virtual node_port.up veast_up[`MESH_HEIGHT] = east_up;
    virtual node_port.down veast_down[`MESH_HEIGHT] = east_down;
    virtual node_port.up vwest_up[`MESH_HEIGHT] = west_up;
    virtual node_port.down vwest_down[`MESH_HEIGHT] = west_down;
    
    // Easier access
    virtual node_port.down mesh_in  [EDGE_EAST:EDGE_WEST][EDGE_SOUTH:EDGE_NORTH];
    virtual node_port.up   mesh_out [EDGE_EAST:EDGE_WEST][EDGE_SOUTH:EDGE_NORTH];
  
    // From generator to dispatcher  
    mailbox src_mbx [int][int];
    // From dispatcher to scoreboard
    mailbox dst_mbx [int][int];
    
    mesh #(`MESH_HEIGHT, `MESH_WIDTH) DUT (.*);
    
    function string pos2portstring(string suf, int x, int y);
        if (x == 0)
            return $sformatf("north_%s[%0d]", suf, y-1);
        else if (x == `MESH_HEIGHT+1)
            return $sformatf("south_%s[%0d]", suf, y-1);
        else if (y == 0)
            return $sformatf("west_%s[%0d]", suf, x-1);
        else if (y == `MESH_WIDTH+1)
            return $sformatf("east_%s[%0d]", suf, x-1);
        else
            $error("Unknown port at %0d,%0d", x, y);
            return "";
    endfunction
    
    task apply_reset();
        rst <= 1;
        @(negedge clk);
        @(negedge clk);
        rst <= 0;
    endtask : apply_reset
    
    task init_mbox();        
        for (int i = 1; i <= `MESH_HEIGHT; i++) begin
            src_mbx[i][0] = new;
            src_mbx[i][`MESH_WIDTH+1] = new;
            dst_mbx[i][0] = new;
            dst_mbx[i][`MESH_WIDTH+1] = new;
        end
        
        for (int j = 1; j <= `MESH_WIDTH; j++) begin
            src_mbx[0][j] = new;
            src_mbx[`MESH_HEIGHT+1][j] = new;
            dst_mbx[0][j] = new;
            dst_mbx[`MESH_HEIGHT+1][j] = new;
        end
    endtask: init_mbox
    
    // There is a small probability of generating a packet
    task automatic tryGenPck(int x, int y, real prob = 0.1);
        real randr = $urandom_range(0, 1000000) / 1000000.0;
        
        if (randr < prob) begin
            Packet pkt = new();
            pkt.randomize();
            pkt.set_src(x, y);
            
            dst_mbx[pkt.dst_x][pkt.dst_y].put(pkt);
            src_mbx[x][y].put(pkt);
            // $display("Generating... %s", pkt.toString());
        end
    endtask: tryGenPck
    
    task generate_packets();
        repeat (50) begin
            // For each clock cycle
            @(posedge clk);
            
            foreach (src_mbx[i,j]) begin
                tryGenPck(i, j);
            end
        end
        
        // Sending the finish signal
        foreach (src_mbx[i,j]) begin
            src_mbx[i][j].put(null);
        end
    endtask : generate_packets
    
    // This task simulates a NIC that has a buffer
    // and sends data as its being generated
    task automatic send_packets(int x, int y);
        Packet p;
        flit_t flits[];
        
        forever begin
            int ncycles = 0;
            
            // TODO: Eliminate hardcoding
            mesh_in[x][y].enable = 0;
            mesh_in[x][y].flit = 0;
            
            src_mbx[x][y].get(p);
            if (p == null) break; // Exit when no more data available
            
            @(negedge clk); // Waiting until clk = 0
            $display("> Sending from %0d, %0d at cycle %2d (%0tns): %s", x, y, nclk, $realtime/1000, p.toString());
            
            // Try sending header
            mesh_in[x][y].enable = 1;
            mesh_in[x][y].flit = p.flits[0];
            
            // Wait for ack
            while (!mesh_in[x][y].ack) begin
                @(negedge clk);
                ncycles++;
                
                if (ncycles % 10 == 0)
                    $warning("> Sending packet %0d has been waiting for %0d cycles (possible lock)", p.id, ncycles);
            end
            
            for (int i = 1; i < p.flits.size; i++) begin
                mesh_in[x][y].flit = p.flits[i];
                @(negedge clk);
            end            
        end
        
        $display("Finished sending packets from %0d,%0d", x, y);
    endtask : send_packets
    
    task automatic recv_packets(int x, int y);
        localparam max_wait = 100;
        localparam portn = 0;
        
        Packet to_chk[$];
        
        forever begin
            flit_t flits[$];
            Packet p;
            int to_wait = max_wait;
            logic found = 0;
        
            // ---- BEGIN READ FLITS ----
            // TODO: Remove to_wait and add some kind of event
            while (to_wait > 0) begin
                @(posedge clk);
                if (mesh_out[x][y].enable && mesh_out[x][y].flit.flit_type == HEADER) begin
                    flits.push_back(mesh_out[x][y].flit);
                    to_wait = -1;
                    break;
                end
                
                to_wait--;
            end
            
            // No more packets to receive
            if (to_wait == 0) break;
            
            // $display("Receiving packet at %0d,%0d", x, y);
            do begin
                @(posedge clk);
                flits.push_back(mesh_out[x][y].flit);
            end while (mesh_out[x][y].flit.flit_type != TAIL);
            // ---- END READ FLITS ----
            
            // ---- BEGIN CHECK FLITS ----
            // to_chk can't be empty (there should always be at least a sent packet to check)
            while (dst_mbx[x][y].try_peek(p) != 0 || to_chk.size() == 0) begin
                dst_mbx[x][y].get(p);
                to_chk.push_back(p);
            end
            
            assert(to_chk.size() != 0);
            
            found = 0;
            foreach (to_chk[i]) begin
                logic equal = to_chk[i].flits.size() == flits.size();
                int j = 0;
                
                while (equal && j < flits.size()) begin
                    equal = to_chk[i].flits[j] == flits[j];
                    j++;
                end
                
                if (equal) begin
                    assert(to_chk[i].dst_x == x && to_chk[i].dst_y == y);
                    $display("< Received packet %3d from %0d,%0d at %0d,%0d",
                        to_chk[i].id, to_chk[i].src_x, to_chk[i].src_y, x, y); 
                    to_chk.delete(i);
                    found = 1;
                    break;
                end
            end
            
            if (!found) begin
                automatic flit_hdr_t hdr = flits[0].payload;
                $error("< Received unknown packet %p at %0d,%0d (%s). Header: %p", flits, x, y, pos2portstring("up", x, y), hdr); 
            end
            // ---- END CHECK FLITS ----
        end
        
        if (to_chk.size() > 0) $warning("Exiting while some packets were not received at %0d,%0d", x, y);
        $display("Finished receiving packets to %0d,%0d", x, y);
    endtask : recv_packets
    
    task automatic init_vifaces();        
        for (int i = 1; i <= `MESH_HEIGHT; i++) begin
            mesh_in[i][EDGE_WEST] = vwest_down[i-1];
            mesh_in[i][EDGE_EAST] = veast_down[i-1];
            
            mesh_out[i][EDGE_WEST] = vwest_up[i-1];
            mesh_out[i][EDGE_EAST] = veast_up[i-1];

            // Accept responses on the outputs            
            mesh_out[i][EDGE_WEST].ack = 1;
            mesh_out[i][EDGE_EAST].ack = 1;
        end
        
        for (int i = 1; i <= `MESH_WIDTH; i++) begin
            mesh_in[EDGE_NORTH][i] = vnorth_down[i-1];
            mesh_in[EDGE_SOUTH][i] = vsouth_down[i-1];
            
            mesh_out[EDGE_NORTH][i] = vnorth_up[i-1];
            mesh_out[EDGE_SOUTH][i] = vsouth_up[i-1];
            
            // Accept responses on the outputs
            mesh_out[EDGE_NORTH][i].ack = 1;
            mesh_out[EDGE_SOUTH][i].ack = 1;
        end
    endtask: init_vifaces

    always #5 clk = ~clk;
    always_ff @(posedge clk) nclk <= nclk + 1;
    
    initial begin
        clk = 0;
        
        init_vifaces();
        init_mbox();
        apply_reset();

        // Generate random packets
        fork
            generate_packets();
            // TODO: One per each port
            begin : gen_threads
                // The int i in the loop is static, so we need
                // an automatic aux to be able to use it in multiple threads
                for (int i = 0; i < `MESH_WIDTH; i++) begin
                    automatic int aux = i;
                    fork
                        send_packets(EDGE_NORTH, aux+1);
                        send_packets(EDGE_SOUTH, aux+1);
                        recv_packets(EDGE_NORTH, aux+1);
                        recv_packets(EDGE_SOUTH, aux+1);
                    join_none;
                end
                
                for (int i = 0; i < `MESH_HEIGHT; i++) begin
                    automatic int aux = i;
                    fork
                        send_packets(aux+1, EDGE_WEST);
                        send_packets(aux+1, EDGE_EAST);
                        recv_packets(aux+1, EDGE_WEST);
                        recv_packets(aux+1, EDGE_SOUTH);
                    join_none;
                end
                wait fork;
            end : gen_threads
        join
        
        // Check that there are no more packets to process
        foreach (src_mbx[i,j]) if (src_mbx[i][j].try_get(null) != 0)
            $display("ERROR: source mailbox %0d,%0d is not empty!", i, j);
        foreach (dst_mbx[i,j]) if (dst_mbx[i][j].try_get(null) != 0)
            $display("ERROR: Destin mailbox %0d,%0d is not empty!", i, j);

        #150 $finish;
    end
    
    
endmodule
