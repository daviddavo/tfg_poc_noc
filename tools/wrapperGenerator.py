import sys
import itertools as it

FLIT_TYPE_SIZE = '$bits(e_flit)'
FLIT_PAYLOAD_SIZE = '`FLIT_DATA_WIDTH'
dirs = ['north', 'south', 'east', 'west']

MAX_GEN = 3 if len(sys.argv) < 2 else int(sys.argv[1])
INDENT = " "*8


def printi(*args, **kwargs):
    """ Print with indentation """
    print(INDENT, end='')
    print(*args, **kwargs)

def assign(left, right, flip=False):
    if flip:
        left, right = right, left

    return f"assign {{ {left.strip()} }} = {right};"

def ifGenerate(i, d):
    w_or_h = "MESH_WIDTH" if d in ['north', 'south'] else "MESH_HEIGHT"
    return f"if ( {w_or_h} >= {i+1} ) begin"

print("generate")
printi("//--------------------")
printi("// Generating signals ")
printi("//--------------------")
for i, d, up_or_down in it.product(range(MAX_GEN), dirs, ["up", "down"]):
    s_name = f"{d}_{up_or_down}[{i}]"

    printi(f"wire [{FLIT_TYPE_SIZE}-1:0] \{s_name}\.flit[flit_type] ;")
    printi(f"wire [{FLIT_PAYLOAD_SIZE}-1:0] \{s_name}\.flit[payload] ;")
    printi(f"wire \{s_name}\.enable ;")
    printi(f"wire \{s_name}\.ack ;")
    print()
print()

printi("//--------------------")
printi("// Generating assigns ")
printi("//--------------------")
for i, d in it.product(range(MAX_GEN), dirs):
    print("    " + ifGenerate(i, d))
    for up_or_down in ["up", "down"]:
        flip = up_or_down == "down"
        s_name = f"{d}_{up_or_down}[{i}]"

        printi(assign(f"{s_name}.flit.flit_type", f"\{s_name}\.flit[flit_type] ", flip))
        printi(assign(f"{s_name}.flit.payload", f"\{s_name}\.flit[payload] ", flip))
        printi(assign(f"{s_name}.enable", f"\{s_name}\.enable ", flip))
        printi(assign(f"\{s_name}\.ack ", f'{s_name}.ack', flip))
    print("    end")
    print()
print("endgenerate")
