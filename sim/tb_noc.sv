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
`include "common_defines.vh" // Data types are automatically imported. `defines aren't
`define ALL_FLITS_HEADER
// Max bits in a packet data
`define MAX_PACKET_SIZE 160

// import noc_types::*;
import noc_functions::build_header_info;

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
    constraint data_size { data.size() inside {[1:`MAX_PACKET_SIZE]}; };
                       
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
                `ifdef ALL_FLITS_HEADER
                    this.flits[i] = build_header_info(this.dst_x, this.dst_y, tail_length, this.id);
                `elsif
                    // Little hack: If we access in a dyn array to an undefined index, it returns 0
                    // So we don't need to add the special case for tail flits
                    for (int j = 0; j < `FLIT_DATA_WIDTH; j++)
                        this.flits[i].payload[j] = this.data[(i-1)*`FLIT_DATA_WIDTH + j];
                `endif
                
                this.flits[i].flit_type = i==n_flits?TAIL:DATA;
            end
        end
        
        // Put header in the front
        this.flits[0] = build_header_info(this.dst_x, this.dst_y, tail_length, this.id);
    endfunction: genflits
    
    // Not supported by verilator...
    function void post_randomize();   
        this.genflits();
    endfunction: post_randomize
    
    function string toString();
        return $sformatf("Packet %3d, to %0d,%0d with data size: %3d (%0d flits), hdr: %p",
            this.id,
            this.dst_x, this.dst_y, 
            this.data.size(),
            this.flits.size(),
            this.flits[0].payload);
    endfunction: toString
    
    function void set_src(int x, int y);
        src_x = x;
        src_y = y;
    endfunction: set_src
    
    function addr_t get_dst();
        return '{dst_x, dst_y};
    endfunction: get_dst
endclass: Packet

module tb_noc;
    logic clk, rst;
    int nclk = 0;
    
    localparam EDGE_NORTH = 0;
    localparam EDGE_SOUTH = `MESH_HEIGHT+1;
    localparam EDGE_EAST = `MESH_WIDTH+1;
    localparam EDGE_WEST = 0;
    localparam LIVELOCK_CYCLES = 100;
    
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
    virtual node_port.down mesh_in  [EDGE_SOUTH:EDGE_NORTH][EDGE_EAST:EDGE_WEST];
    virtual node_port.up   mesh_out [EDGE_SOUTH:EDGE_NORTH][EDGE_EAST:EDGE_WEST];
  
    // From generator to dispatcher  
    mailbox src_mbx [int][int];
    // From dispatcher to scoreboard
    mailbox dst_mbx [int][int];
    logic sendersFinished = 0;
    
    mesh_wrapper #(`MESH_HEIGHT, `MESH_WIDTH) DUT (.*);
    
    function string pos2portstring(string suf, int x, int y);
        if (x == EDGE_NORTH)
            return $sformatf("north_%s[%0d]", suf, y-1);
        else if (x == EDGE_SOUTH)
            return $sformatf("south_%s[%0d]", suf, y-1);
        else if (y == EDGE_WEST)
            return $sformatf("west_%s[%0d]", suf, x-1);
        else if (y == EDGE_EAST)
            return $sformatf("east_%s[%0d]", suf, x-1);
        else
            $error("Unknown port at %0d,%0d", x, y);
            return "";
    endfunction
    
    task init_mbox();        
        for (int i = 1; i <= `MESH_HEIGHT; i++) begin
            src_mbx[i][EDGE_WEST] = new;
            src_mbx[i][EDGE_EAST] = new;
            dst_mbx[i][EDGE_WEST] = new;
            dst_mbx[i][EDGE_EAST] = new;
        end
        
        for (int j = 1; j <= `MESH_WIDTH; j++) begin
            src_mbx[EDGE_NORTH][j] = new;
            src_mbx[EDGE_SOUTH][j] = new;
            dst_mbx[EDGE_NORTH][j] = new;
            dst_mbx[EDGE_SOUTH][j] = new;
        end
    endtask: init_mbox
    
    // There is a small probability of generating a packet
    task automatic tryGenPck(int x, int y, real prob = 0.1, int fd = 0);
        real randr = $urandom_range(0, 1000000) / 1000000.0;
        
        if (randr < prob) begin
            Packet pkt = new();
            pkt.randomize();
            
            // DISABLE LOOPBACK (SENDING IT BACK TO THE IFACE WHO SENT IT)
            // while (pkt.dst_x == x && pkt.dst_y == y) pkt.randomize();

            pkt.set_src(x, y);
            
            dst_mbx[pkt.dst_x][pkt.dst_y].put(pkt);
            src_mbx[x][y].put(pkt);
            
            // p_id,gen_cycle,src_x,src_y,dst_x,dst_y,p_size,prob
            if (fd) $fwrite(fd, "%d,%d,%d,%d,%d,%d,%d,%f\n", pkt.id, nclk, x, y, pkt.dst_x, pkt.dst_y, pkt.data.size(),prob);
            
            // $display("Generating... %s", pkt.toString());
        end
    endtask: tryGenPck
    
    task generate_packets(int fdg);
        localparam MAX_QUEUE_SIZE = 500;
        automatic real p = 0.0001;
        automatic logic q_full = 0;
    
        while (!q_full) begin
            // For each clock cycle
            @(posedge clk);
            
            if (nclk > 30000) p += 0.000001;
            
            foreach (src_mbx[i,j]) begin
                tryGenPck(i, j, p, fdg);
                q_full = q_full || src_mbx[i][j].num() > MAX_QUEUE_SIZE;
            end
        end
        
        // "Collapse" the network sending a packet through every port
        // repeat (1000) @(posedge clk);
        // foreach (src_mbx[i,j]) begin
        //     tryGenPck(i, j, 1.0, fdg);
        // end
        
        // Sending the finish signal
        foreach (src_mbx[i,j]) begin
            src_mbx[i][j].put(null);
        end
    endtask : generate_packets
    
    // This task simulates a NIC that has a buffer
    // and sends data as its being generated
    task automatic send_packets(int fd, int x, int y);
        Packet p;
        flit_t flits[];

        forever begin
            int ncycles = 0;
            int hdrstart,flitstart;
            
            // We need to use NBA so the receive_packets can read them on non-timing simulation
            mesh_in[x][y].enable <= 0;
            mesh_in[x][y].flit <= 0;
            
            wait(!rst);
            
            src_mbx[x][y].get(p);
            if (p == null) break; // Exit when no more data available
            
            @(negedge clk); // Waiting until clk = 0
            @(negedge clk); // Needs to flush
            $display("> Sending from %0d, %0d at cycle %2d (%0t): %s", x, y, nclk, $time, p.toString());
            
            // Try sending header
            hdrstart = nclk;
            mesh_in[x][y].enable <= 1;
            mesh_in[x][y].flit <= p.flits[0];
            
            // Wait for ack
            while (mesh_in[x][y].ack !== 1) begin
                @(posedge clk);
                ncycles++;
                
                if (ncycles % LIVELOCK_CYCLES == 0)
                    $warning("> Sending packet %0d has been waiting for %0d cycles (possible lock)", p.id, ncycles);
            end
            
            flitstart = nclk;  
            
            @(negedge clk);
            for (int i = 1; i < p.flits.size; i++) begin
                mesh_in[x][y].flit <= p.flits[i];
                @(posedge clk);
                assert(mesh_in[x][y].ack);
                @(negedge clk);
            end
            
            // p_id,hdr_cycle,sending_cycle,tail_sent_cycle
            $fwrite(fd, "%d,%d,%d,%d\n", p.id, hdrstart, flitstart, nclk);
        end
        
        $display("Finished sending packets from %0d,%0d", x, y);
    endtask : send_packets
    
    task automatic recv_packets(int fd, int x, int y);
        localparam portn = 0;
        
        Packet to_chk[$];
        
        mesh_out[x][y].rej = 0;
        mesh_out[x][y].ack = 1;
        
        while (!sendersFinished) begin
            flit_t flits[$];
            flit_t deletedHdrs[$];
            automatic flit_hdr_t hdr;
            Packet p;
            logic found = 0;
            time starttime;
            int start_receiving, received;
        
            // ---- BEGIN READ FLITS ----
            while (!sendersFinished) begin
                @(posedge clk);
                if (mesh_out[x][y].enable && mesh_out[x][y].flit.flit_type == HEADER) break;
            end
            
            if (sendersFinished) break;
            
            flits.push_back(mesh_out[x][y].flit);
            hdr = flits[0].payload;
            starttime = $time;
            start_receiving = nclk;
            
            if (hdr.dst_addr.x != x || hdr.dst_addr.y != y)
                $error("< Receiving lost header at %0d,%0d (%s). Header: %p", x, y, pos2portstring("up", x, y), hdr);
            
            // $display("Receiving packet at %0d,%0d", x, y);
            do begin
                @(posedge clk);
                flits.push_back(mesh_out[x][y].flit);
            end while (mesh_out[x][y].flit.flit_type != TAIL);
            received = nclk;
            // ---- END READ FLITS ----
            
            // ---- BEGIN CHECK FLITS ----
            // Before checking, we delete repeated HEADERS because of the registered outputs
            while (flits.size() > 1 && flits[1].flit_type == HEADER) begin 
                deletedHdrs.push_back(flits.pop_front());
                
                if (deletedHdrs[$] != flits[0]) begin
                    $error("Inconsistency deleting headers. deleted %p, remaining %p", deletedHdrs[$], flits[0]);
                end
            end
            
            if (deletedHdrs.size() > `MESH_WIDTH+`MESH_HEIGHT)
                $warning("Deleted too many headers (%0d", deletedHdrs);
                        
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
                        
                    // p_id,start_receiving,received,deleted_headers
                    $fwrite(fd, "%d,%d,%d,%d\n", to_chk[i].id, start_receiving, received, deletedHdrs.size()); 
                        
                    to_chk.delete(i);
                    found = 1;
                    break;
                end
            end
            
            if (!found) begin
                $error("< Received unknown packet %p at %0d,%0d (%s). Started from %0t. Header: %p", flits, x, y, pos2portstring("up", x, y), starttime, hdr); 
            end
            // ---- END CHECK FLITS ----
        end
        
        if (to_chk.size() > 0) begin
            foreach (to_chk[i]) begin
                $display("Packet not received at %0d,%0d (%s): %s", x, y, pos2portstring("up",x,y), to_chk[i].toString()); 
            end
            $warning("Exiting while some packets were not received at %0d,%0d", x, y);
        end
        
        mesh_out[x][y].ack = 0;
        
        $display("Finished receiving packets to %0d,%0d", x, y);
    endtask : recv_packets
    
    task automatic init_vifaces();        
        for (int i = 1; i <= `MESH_HEIGHT; i++) begin
            mesh_in[i][EDGE_WEST] = vwest_down[i-1];
            mesh_in[i][EDGE_EAST] = veast_down[i-1];
            
            mesh_out[i][EDGE_WEST] = vwest_up[i-1];
            mesh_out[i][EDGE_EAST] = veast_up[i-1];
        end
        
        for (int i = 1; i <= `MESH_WIDTH; i++) begin
            mesh_in[EDGE_NORTH][i] = vnorth_down[i-1];
            mesh_in[EDGE_SOUTH][i] = vsouth_down[i-1];
            
            mesh_out[EDGE_NORTH][i] = vnorth_up[i-1];
            mesh_out[EDGE_SOUTH][i] = vsouth_up[i-1];
        end
    endtask: init_vifaces

    always #50 clk = ~clk; 
    always_ff @(posedge clk) nclk <= nclk + 1;
    
    initial begin
        int fds, fdr, fdg;
    
        clk = 0;
        sendersFinished = 0;
        $timeformat(-9, 2, " ns", 20);
        
        init_vifaces();
        init_mbox();
        
        fds = $fopen("senders.csv", "w");
        assert(fds);
        fdr = $fopen("receivers.csv", "w");
        assert(fdr);
        fdg = $fopen("packets.csv", "w");
        assert(fdg);
        
        $fwrite(fds, "p_id,hdr_cycle,sending_cycle,tail_sent_cycle\n");
        $fwrite(fdr, "p_id,start_receiving,received,deleted_headers\n");
        $fwrite(fdg, "p_id,gen_cycle,src_x,src_y,dst_x,dst_y,p_size,prob\n");
        
        // Reset while inputs are set to 0
        rst = 1;

        // Generate random packets
        fork
            begin: end_rst
                #110 rst = 0;
            end
            generate_packets(fdg);
            begin : gen_senders
                // The int i in the loop is static, so we need
                // an automatic aux to be able to use it in multiple threads
                for (int i = 0; i < `MESH_WIDTH; i++) begin
                    automatic int aux = i;
                    fork
                        send_packets(fds, EDGE_NORTH, aux+1);
                        send_packets(fds, EDGE_SOUTH, aux+1);
                    join_none;
                end
                for (int i = 0; i < `MESH_HEIGHT; i++) begin
                    automatic int aux = i;
                    fork
                        send_packets(fds, aux+1, EDGE_WEST);
                        send_packets(fds, aux+1, EDGE_EAST);
                    join_none;
                end
                wait fork;
                sendersFinished = 1;
                $display("All senders finished");
            end : gen_senders
            begin : gen_receivers
                // The int i in the loop is static, so we need
                // an automatic aux to be able to use it in multiple threads
                for (int i = 1; i <= `MESH_WIDTH; i++) begin
                    automatic int aux = i;
                    fork
                        recv_packets(fdr, EDGE_NORTH, aux);
                        recv_packets(fdr, EDGE_SOUTH, aux);
                    join_none;
                end
                
                for (int i = 1; i <= `MESH_HEIGHT; i++) begin
                    automatic int aux = i;
                    fork
                        recv_packets(fdr, aux, EDGE_WEST);
                        recv_packets(fdr, aux, EDGE_EAST);
                    join_none;
                end
                wait fork;
                $display("All receivers finished");
            end : gen_receivers          
        join
        
        // Check that there are no more packets to process
        foreach (src_mbx[i,j]) if (src_mbx[i][j].try_get(null) != 0)
            $display("ERROR: source mailbox %0d,%0d is not empty!", i, j);
        foreach (dst_mbx[i,j]) if (dst_mbx[i][j].try_get(null) != 0)
            $display("ERROR: Destin mailbox %0d,%0d is not empty!", i, j);

        $display("Simulation finished!");
        
        $fclose(fdg);
        $fclose(fdr);
        $fclose(fds);
        
        #10 $finish;
    end
    
    
endmodule
