`define MESH_WIDTH 2
`define MESH_HEIGHT 2
`define FLIT_WIDTH 16

`define MESH_ADDR_X $clog2(`MESH_HEIGHT+2)
`define MESH_ADDR_Y $clog2(`MESH_WIDTH+2)
// TODO: Assert equals $clog2(`FLIT_ADDR_SPACE)
`define FLIT_ADDR_WIDTH MESH_ADDR_X+MESH_ADDR_Y

`define NODE_PORTS 4
typedef enum logic [1:0] { NORTH = 0, SOUTH = 1, EAST = 2, WEST = 3 } e_dir;

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

// size should be `FLIT_ADDR_WIDTH
typedef struct packed {
    logic [`MESH_ADDR_X-1:0] x;
    logic [`MESH_ADDR_Y-1:0] y;
} addr_t;

// Header type payload
// size should be less than FLIT_DATA_WIDTH
`define FLIT_TAIL_LENGTH_WIDTH $clog2(`FLIT_DATA_WIDTH)
typedef struct packed
{
    addr_t dst_addr; // Destination address
    logic [`FLIT_TAIL_LENGTH_WIDTH-1:0] tail_length; // Length in bits of the tail flit
} control_hdr_t;

// if ($bits(control_hdr_t) > `FLIT_DATA_WIDTH) begin
//     $error("%m ** Illegal flit width ** Control_header size is %d, Flit width is %d", $bits(control_hdr_t), `FLIT_WIDTH); 
// end
