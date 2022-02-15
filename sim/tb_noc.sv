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

module tb_noc;
    logic clk, rst;

    node_port west_up[`MESH_HEIGHT]();
    node_port west_down[`MESH_HEIGHT]();
    node_port east_up[`MESH_HEIGHT]();
    node_port east_down[`MESH_HEIGHT]();    
    node_port north_up[`MESH_WIDTH]();
    node_port north_down[`MESH_WIDTH]();
    node_port south_up[`MESH_WIDTH] ();
    node_port south_down[`MESH_WIDTH]();
  
    // From generator to dispatcher  
    mailbox src_mbx [int][int];
    // From dispatcher to scoreboard
    mailbox dst_mbx [int][int];
    
    mesh #(`MESH_HEIGHT, `MESH_WIDTH) DUT (.*);
    
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
            src_mbx[x][y].put(pkt);
            dst_mbx[pkt.dst_x][pkt.dst_y].put(pkt);
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
        localparam portn = 0;
        
        forever begin
            int ncycles = 0;
            
            // TODO: Eliminate hardcoding
            west_down[portn].enable = 0;
            west_down[portn].flit = 0;
            
            src_mbx[x][y].get(p);
            if (p == null) break; // Exit when no more data available
            
            @(negedge clk); // Waiting until clk = 0
            $display("> Sending from %0d, %0d: %s", x, y, p.toString());
            
            // Try sending header
            west_down[portn].enable = 1;
            west_down[portn].flit = p.flits[0];
            
            // Wait for ack
            while (!west_down[portn].ack) begin
                @(negedge clk);
                ncycles++;
                
                if (ncycles % 10 == 0)
                    $warning("> Sending packet %0d has been waiting for %0d cycles (possible lock)", p.id, ncycles);
            end
            
            for (int i = 1; i < p.flits.size; i++) begin
                west_down[portn].flit = p.flits[i];
                @(negedge clk);
            end            
        end
        
        $display("Finished sending packets from %0d,%0d", x, y);
    endtask : send_packets
    
    task automatic recv_packets(int x, int y);
        localparam max_wait = 10;
        localparam portn = 0;
        
        Packet to_chk[$];
        
        forever begin
            flit_t flits[$];
            Packet p;
            int to_wait = max_wait;
            logic found = 0;
        
            while (to_wait > 0) begin
                if (north_up[0].enable && north_up[0].flit.flit_type == HEADER) begin
                    to_wait = -1;
                end
                
                @(posedge clk);
                to_wait--;
            end
            
            // No more packets to receive
            if (to_wait == 0) break;
            
            // $display("Receiving packet at %0d,%0d", x, y);
            do begin
                @(posedge clk);
                flits.push_back(north_up[0].flit);
            end while (north_up[0].flit.flit_type != TAIL);
            
            // TODO: Check that the packet has been sent
            // and print the source and id of the packet
            while (dst_mbx[x][y].try_peek(p) != 0) begin
                dst_mbx[x][y].get(p);
                to_chk.push_back(p);
            end
            
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
                $error("< Received unknown packet %p", flits); 
            end
            
            @(posedge clk);
        end
        
        assert (to_chk.size() == 0) $warning("Exiting while some packets were not received at %0d,%0d", x, y);
        $display("Finished receiving packets to %0d,%0d", x, y);
    endtask : recv_packets
    
    always #5 clk = ~clk;
    
    // TODO: Assyncly: Process items in mailbox and send packets
    
    generate
        genvar gi;
        for ( gi = 0; gi < `MESH_HEIGHT; gi++) begin
            assign west_up[gi].ack = 1;
            assign east_up[gi].ack = 1;
        end
        
        for ( gi = 0; gi < `MESH_WIDTH; gi++) begin
            assign north_up[gi].ack = 1;
            assign south_up[gi].ack = 1;
        end
    endgenerate
    
    initial begin
        clk = 0;
        
        init_mbox();
        apply_reset();

        // Generate random packets
        fork
            generate_packets();
            // TODO: One per each port
            send_packets(1, 0); // west_edge
            recv_packets(0, 1); // north_edge
            // wait fork;
        join
        
        // Check that there are no more packets to process
        foreach (src_mbx[i,j]) if (src_mbx[i][j].try_get(null) != 0)
            $display("ERROR: source mailbox %0d,%0d is not empty!", i, j);
        foreach (dst_mbx[i,j]) if (dst_mbx[i][j].try_get(null) != 0)
            $display("ERROR: Destin mailbox %0d,%0d is not empty!", i, j);

        #150 $finish;
    end
    
    
endmodule
