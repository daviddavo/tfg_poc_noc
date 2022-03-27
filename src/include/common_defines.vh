`define MESH_HEIGHT 3
`define MESH_WIDTH 3

`define MAX_MESH_WIDTH 6
`define MAX_MESH_HEIGHT 6
`define FLIT_WIDTH 18

`define MESH_ADDR_X $clog2(`MAX_MESH_HEIGHT+2)
`define MESH_ADDR_Y $clog2(`MAX_MESH_WIDTH+2)
`define FLIT_ADDR_WIDTH MESH_ADDR_X+MESH_ADDR_Y
`define FLIT_DATA_WIDTH (`FLIT_WIDTH-$bits(e_flit))
`define FLIT_TAIL_LENGTH_WIDTH $clog2(`FLIT_DATA_WIDTH)

// Now some functions

// asserts $bits(t) == s
`define assertsize_EQ(t,s) // TODO: Do
// asserts $bits(t) <= s
`define assertsize_LE(t,s) // TODO: Do
