`define MESH_WIDTH 2
`define MESH_HEIGHT 2
`define FLIT_WIDTH 8

`define FLIT_ADDR_WIDTH $clog2(`MESH_WIDTH*`MESH_HEIGHT)

typedef enum logic[1:0]
{
    HEADER,
    DATA,
    TAIL
    // Reserved
} e_flit;

`define FLIT_DATA_WIDTH (`FLIT_WIDTH-$bits(e_flit))
typedef struct packed {
    e_flit flit_type;
    logic [`FLIT_DATA_WIDTH-1:0] payload;
} flit_t;

// Header type payload
// size should be less than FLIT_DATA_WIDTH
`define FLIT_TAIL_LENGTH_WIDTH $clog2(`FLIT_DATA_WIDTH)
typedef struct packed
{
    logic [`FLIT_ADDR_WIDTH-1:0] dst_addr; // Destination address
    logic [`FLIT_TAIL_LENGTH_WIDTH-1:0] tail_length; // Length in bits of the tail flit
} control_hdr_t;

// if ($bits(control_hdr_t) > `FLIT_DATA_WIDTH) begin
//     $error("%m ** Illegal flit width ** Control_header size is %d, Flit width is %d", $bits(control_hdr_t), `FLIT_WIDTH); 
// end