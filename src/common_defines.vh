`define MESH_WIDTH 2
`define MESH_HEIGHT 2
`define FLIT_WIDTH 8

typedef struct {
    logic [`FLIT_WIDTH-1:0] data;
} flit;