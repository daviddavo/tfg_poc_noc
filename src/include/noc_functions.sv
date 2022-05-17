`timescale 1ns / 1ps

package noc_functions;
    import noc_types::*;
    
	function flit_t build_header(int dst_x, int dst_y, flit_hdr_free free = 0);
	    return build_header2('{dst_x, dst_y}, free);
    endfunction
    
    function flit_t build_header2(addr_t dst_addr, flit_hdr_free free = 0);
        automatic flit_hdr_t hdr;
        hdr.dst_addr = dst_addr;
        hdr.free = free;
        return '{ HEADER, hdr };
    endfunction
    
    function flit_t build_header_info(int dst_x, int dst_y, int tail_length = 0, int rem = 0);
        automatic flit_hdr_info hdri;
        hdri.tail_length = tail_length;
        hdri.rem = rem;
        return build_header(dst_x, dst_y, hdri);
    endfunction
    
    // Priority: HORIZONTAL > VERTICAL
    function e_dir dimensional_order_routing_h(int x, int y, addr_t dst);
       // This is the desired column
       if (dst.y == y) begin
          if (dst.x == x) begin
             // This should not happen
             $display("Illegal state: Node received flit with himself as the destination");
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
    endfunction
    
    function e_dir dimensional_order_routing_v(int x, int y, addr_t dst);
        if (dst.x == x) begin
            if (dst.y == y) begin
                $display("Illegal state: Node received flit with himself as the destination");
            end else if (dst.y > y) begin
                return EAST;
            end else begin
                return WEST;
            end
        end else if (dst. x > x) begin
            return SOUTH;
        end else begin
            return NORTH;
        end
    endfunction
    
    // DOR but only in the directions that does not make the package fall out of the edge
    // - do horizontal priority on north and south edges
    // - do vertical priority on east and west edges
    // - on corners, be mindful of the "default edge"
    //   i.e: on bottom corners, be careful if the destination is south edge
    function e_dir dimensional_order_routing_edgeaware(int x, int y, int x_max, int y_max, addr_t dst);
        // left edge
        if ( y == 1 && dst.y == 0 ) return dimensional_order_routing_v(x, y, dst);
        // right edge
        if ( y == y_max-1 && dst.y == y_max ) return dimensional_order_routing_v(x, y, dst);
        
        return dimensional_order_routing_h(x, y, dst);
    endfunction
endpackage
