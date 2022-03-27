from pathlib import Path
import re

from pypeg2 import Enum, K, Keyword, Symbol, List, comment_cpp, parse, \
    maybe_some, endl, restline, name, indent, whitespace, Namespace, \
    separated, contiguous, optional, word, compose, attr, comment_c, \
    attributes, ignore, csl, blank

STUB_FNAME = Path('./mesh_stub.v')

anything = re.compile(r"(?m).*")

class PortName(str):
    grammar = word

class EscapedWasWord:
    grammar = name()

class EscapedWasArray:
    grammar = name(), '[', attr("port", Symbol), ']'

class EscapedWasIface:
    grammar = '.', name()

class EscapedWasIfaceStruct:
    grammar = '.', name(), '[', attr("port", Symbol), ']'

class EscapedPortName:
    grammar = attr('names', maybe_some('\\', [EscapedWasArray, EscapedWasWord, EscapedWasIfaceStruct, EscapedWasIface]))

class PortDirection(Keyword):
    grammar = Enum(K('input'), K('output'))

class PortSize(str):
    grammar = re.compile(r"\[\d+(\:\d+)?\]")

class PortDecl:
    grammar = attr("direction", PortDirection, Symbol), attr("size", optional(PortSize)), blank, attr("name", [PortName, EscapedPortName])


class PortList(str):
    grammar = re.compile(r"(?m)[^;]*;")

stubInst = [PortDecl], ';'
class StubModule(List):
    grammar = K('module'), name(), ignore(PortList), maybe_some(stubInst), K('endmodule')

class Comment(str):
    grammar = [(comment_cpp, endl), comment_c]

class TopInst(str):
    grammar = StubModule

class VFile(List):
    grammar = maybe_some(StubModule)

# ------ TESTING --------
# print(compose(parse("\south_up[42] ", EscapedPortName)))
# print(compose(parse("clk", PortName)))
# print(compose(parse("input clk", PortDecl)))
# print(compose(parse("input \south_up[42]\.ack ", PortDecl)))
# print(compose(parse("input \south_up[42]\.flit[flit_type] ", PortDecl)))
# print(compose(parse("[1:0]", PortSize)))
# print(compose(parse("output [1:0] \west_up[42]\.flit[flit_type] ", PortDecl)))
# print(compose(parse("output [1:0]\west_up[42]\.flit[flit_type] ", PortDecl)))
# print(compose(parse("input \south_up[42]\.ack ", PortDecl)))
# print(compose(parse("input ack", PortDecl)))

def printAttr(thing, **kwargs):
    for a in attributes(thing.grammar):
        print(a, **kwargs)

def makeAssignStr(left: str, right: str) -> str:
    return f"assign {left} = {right}"

def makeRegStr(thing: str, size: str = "") -> str:
    if size is None:
        return f"logic {thing}"

    return f"logic {size} {thing}"

def unEscapePortName(p) -> str:
    def unEscape(x):
        if isinstance(x, EscapedWasArray):
            return f"{x.name}[{x.port}]"
        elif isinstance(x, EscapedWasIface):
            return f".{x.name}"
        elif isinstance(x, EscapedWasIfaceStruct):
            return f".{x.name}.{x.port}"
        elif isinstance(x, str):
            return x
        else:
            raise(f"Can't unescape instance of {type(x)}")

    return "".join(map(unEscape, p.names))

def portDecl2Reg(p) -> str:
    if isinstance(p.name, EscapedPortName):
        return makeRegStr(compose(p.name) + ' ', p.size)
    elif isinstance(p.name, PortName):
        return f'// Not generating reg for unescaped name "{p.name}"'
    else:
        raise ValueError(f"Unknown name type {type(p.name)}")

def portDecl2Assign(p) -> str:
    if isinstance(p.name, EscapedPortName):
        left = compose(p.name) + ' '
        right = unEscapePortName(p.name)

        if p.direction == "output":
            left, right = right, left

        # Putting lhs in braces lets us assign to anything packed wihtout
        # caring for type
        left = f'{{{left}}}'

        return makeAssignStr(left, right)
    elif isinstance(p.name, PortName):
        return f'// Not generating assign for unescaped name "{p.name}"'
    else:
        raise ValueError(f"Unknown name type {type(p.name)}")

# TODO: Put message if file does not exist "stub file not found generate it using..."

with open(STUB_FNAME, 'r') as stub:
    f = parse(stub.read(), VFile, filename=STUB_FNAME, comment=Comment)

    module = f[0]
    print(f'// Generating stub netlist for module "{module.name}"')
    for i in module:
        print(portDecl2Reg(i) + ";")
    print()
    for i in module:
        print(portDecl2Assign(i) + ";")

