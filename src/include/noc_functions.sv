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
endpackage
