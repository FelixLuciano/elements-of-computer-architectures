from .data_models import (TYPES, Base_instruction, Expression, Instruction,
                          Line, Operation, Symbol, Value)
from .interpret import Interpret
from .link import Link
from .parse import Parse
from .serialize import Serialize

DEFAULT_LITERAL = Value(0, TYPES.literal)
DEFAULT_ADDRESS = Value(0, TYPES.address)
DEFAULT_REGISTER = Value(0, TYPES.register)
DEFAULT_LABEL = Value(0, TYPES.label)

SYMBOLS = [
    # Registers
    Symbol("%ax", 0, TYPES.register),
    Symbol("%bx", 1, TYPES.register),
    Symbol("%cx", 2, TYPES.register),
    Symbol("%dx", 3, TYPES.register),
    # Constants
    Symbol("$TRUE", 1, TYPES.literal),
    Symbol("$FALSE", 0, TYPES.literal),
    # Read-only peripherals
    Symbol("@SWR", 320, TYPES.address),
    Symbol("@SW8", 321, TYPES.address),
    Symbol("@SW9", 322, TYPES.address),
    Symbol("@KEY0", 352, TYPES.address),
    Symbol("@KEY1", 353, TYPES.address),
    Symbol("@KEY2", 354, TYPES.address),
    Symbol("@KEY3", 355, TYPES.address),
    Symbol("@KEY4", 356, TYPES.address),
    # Write-only peripherals
    Symbol("@LED9", 258, TYPES.address),
    Symbol("@LED8", 257, TYPES.address),
    Symbol("@LEDR", 256, TYPES.address),
    Symbol("@HEX0", 288, TYPES.address),
    Symbol("@HEX1", 289, TYPES.address),
    Symbol("@HEX2", 290, TYPES.address),
    Symbol("@HEX3", 291, TYPES.address),
    Symbol("@HEX4", 292, TYPES.address),
    Symbol("@HEX5", 293, TYPES.address),
    Symbol("@TC1", 384, TYPES.address),
    # Interruption Addresses
    Symbol("%INTR_KEY0", 495, TYPES.address),
    Symbol("%INTR_KEY1", 479, TYPES.address),
    Symbol("%INTR_KEY2", 463, TYPES.address),
    Symbol("%INTR_KEY3", 447, TYPES.address),
    Symbol("%INTR_KEY4", 431, TYPES.address),
    Symbol("%INTR_TC0", 415, TYPES.address),
    Symbol("%INTR_TC1", 399, TYPES.address),
    # Interruption acknowledgement addresses
    Symbol("%ACK_KEY0", 511, TYPES.address),
    Symbol("%ACK_KEY1", 510, TYPES.address),
    Symbol("%ACK_KEY2", 509, TYPES.address),
    Symbol("%ACK_KEY3", 508, TYPES.address),
    Symbol("%ACK_KEY4", 507, TYPES.address),
    Symbol("%ACK_TC0", 506, TYPES.address),
    Symbol("%ACK_TC1", 505, TYPES.address),
]

OPCODES = {
    "lda": Base_instruction(1, (DEFAULT_ADDRESS, DEFAULT_REGISTER)),
    "nop": Base_instruction(0, (DEFAULT_ADDRESS, DEFAULT_REGISTER)),
    "sta": Base_instruction(2, (DEFAULT_ADDRESS, DEFAULT_REGISTER)),
    "add": Base_instruction(3, (DEFAULT_ADDRESS, DEFAULT_REGISTER)),
    "sub": Base_instruction(4, (DEFAULT_ADDRESS, DEFAULT_REGISTER)),
    "and": Base_instruction(5, (DEFAULT_ADDRESS, DEFAULT_REGISTER)),
    "ceq": Base_instruction(6, (DEFAULT_ADDRESS, DEFAULT_REGISTER)),
    "clt": Base_instruction(7, (DEFAULT_ADDRESS, DEFAULT_REGISTER)),
    "cle": Base_instruction(8, (DEFAULT_ADDRESS, DEFAULT_REGISTER)),
    "ldi": Base_instruction(9, (DEFAULT_LITERAL, DEFAULT_REGISTER)),
    "addi": Base_instruction(10, (Value(1, TYPES.literal), DEFAULT_REGISTER)),
    "subi": Base_instruction(11, (Value(1, TYPES.literal), DEFAULT_REGISTER)),
    "andi": Base_instruction(12, (DEFAULT_LITERAL, DEFAULT_REGISTER)),
    "ceqi": Base_instruction(13, (DEFAULT_LITERAL, DEFAULT_REGISTER)),
    "clti": Base_instruction(14, (DEFAULT_LITERAL, DEFAULT_REGISTER)),
    "clei": Base_instruction(15, (DEFAULT_LITERAL, DEFAULT_REGISTER)),
    "jmp": Base_instruction(16, (DEFAULT_LABEL, DEFAULT_REGISTER)),
    "jeq": Base_instruction(17, (DEFAULT_LABEL, DEFAULT_REGISTER)),
    "jlt": Base_instruction(18, (DEFAULT_LABEL, DEFAULT_REGISTER)),
    "jle": Base_instruction(19, (DEFAULT_LABEL, DEFAULT_REGISTER)),
    "jneq": Base_instruction(20, (DEFAULT_LABEL, DEFAULT_REGISTER)),
    "jgt": Base_instruction(21, (DEFAULT_LABEL, DEFAULT_REGISTER)),
    "jge": Base_instruction(22, (DEFAULT_LABEL, DEFAULT_REGISTER)),
    "jsr": Base_instruction(23, (DEFAULT_LABEL, DEFAULT_REGISTER)),
    "ret": Base_instruction(24, (DEFAULT_LABEL, DEFAULT_REGISTER)),
    "reti": Base_instruction(25, (DEFAULT_ADDRESS, DEFAULT_REGISTER)),
    "ldaddr": Base_instruction(26, (DEFAULT_ADDRESS, DEFAULT_REGISTER)),
    "ldaind": Base_instruction(27, (DEFAULT_ADDRESS, DEFAULT_REGISTER)),
    "staind": Base_instruction(28, (DEFAULT_ADDRESS, DEFAULT_REGISTER)),
}

# Pseudo instructions
OPCODES.update({
    "cge": OPCODES["cle"],
    "cgt": OPCODES["cle"],
    "cgti": OPCODES["clei"],
    "cgei": OPCODES["clei"],
})
