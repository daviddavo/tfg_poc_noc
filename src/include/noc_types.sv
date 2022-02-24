`timescale 1ns / 1ps
`include "common_defines.vh"

package noc_types;

typedef enum logic [1:0] { NORTH = 0, SOUTH = 1, EAST = 2, WEST = 3 } e_dir;

typedef enum logic[1:0]
{
    HEADER,
    DATA,
    TAIL
    // Reserved
} e_flit;


`assertsize_EQ(addr_t, `FLIT_ADDR_WIDTH);
typedef struct packed {
    logic [`MESH_ADDR_X-1:0] x;
    logic [`MESH_ADDR_Y-1:0] y;
} addr_t;

// Header type payload
`assertsize_EQ(flit_hdr_t, `FLIT_DATA_WIDTH);
typedef struct packed
{
    addr_t dst_addr; // Destination address
    logic [`FLIT_TAIL_LENGTH_WIDTH-1:0] tail_length; // Length in bits of the tail flit
    logic [`FLIT_DATA_WIDTH-$bits(addr_t)-`FLIT_TAIL_LENGTH_WIDTH-1:0] padding;
} flit_hdr_t;

`assertsize_EQ(flit_payload_t, `FLIT_DATA_WIDTH);
typedef union packed {
    flit_hdr_t hdr;
    logic [`FLIT_DATA_WIDTH-1:0] data;
} flit_payload_t;

`assertsize_EQ(flit_t, `FLIT_WIDTH);
typedef struct packed {
    e_flit flit_type;
    flit_payload_t payload;
    // logic [`FLIT_DATA_WIDTH-1:0] payload;
} flit_t;
endpackage
