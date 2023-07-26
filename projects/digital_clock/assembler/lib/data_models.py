import re
from dataclasses import dataclass
from enum import Enum
from typing import List, Tuple


@dataclass
class Expression:
    mnemonic: str | None
    arguments: List[str]


@dataclass
class Line:
    index: int
    text: str
    label: str | None = None
    expression: Expression | None = None
    comment: str | None = None


class TYPES(str, Enum):
    literal = "$"
    address = "@"
    register = "%"
    label = "."

    @property
    def is_numeric(self):
        return self in (TYPES.literal, TYPES.address)

    @property
    def is_reference(self):
        return self in (TYPES.register, TYPES.label)


@dataclass
class Value:
    PATTERN = re.compile(r"^[@$](?:-|\+)?(?:0x[\da-fA-F]+|0b[01]+|(?:[0-9]+))$")

    value: int | None
    type: TYPES
    text: str | None = None

    @property
    def is_numeric(self):
        return self.type.is_numeric and self.value is not None

    @staticmethod
    def parse(text: str):
        type_ = TYPES(text[0])

        if type_.is_numeric and Value.PATTERN.match(text):
            num = text[1:]
            if num.startswith("+"):
                signal = 1
                num = num[1:]
            elif num.startswith("-"):
                signal = -1
                num = num[1:]
            else:
                signal = 1

            base = 10
            if num.startswith("0x") or num.startswith("#"):
                base = 16
            elif num.startswith("0b"):
                base = 2

            value = int(num, base) * signal
        else:
            value = None

        return Value(value, type_, text)


@dataclass
class Symbol:
    name: str
    value: int | None
    type: str
    text: str | None = None

    @staticmethod
    def from_line(line: Line):
        try:
            name = Value.parse(line.label)
        except ValueError:
            raise ValueError(f'"{line.label}" is not an valid symbol name, at line {line.index}') from None
        
        if not name.type.is_numeric:
            raise ValueError(f'"{line.label}" is not an valid symbol type, at line {line.index}')

        value = Value.parse(line.expression.arguments[0])

        if name.type != value.type:
            raise ValueError(f'"{line.label}" should be the same type as "{value.text}", at line {line.index}')

        return Symbol(
            name=line.label,
            value=value.value,
            type=value.type,
            text=value.text,
        )


@dataclass
class Operation:
    index: int
    text: str
    mnemonic: str | None
    arguments: List[Value]
    comment: str | None = None

    @staticmethod
    def from_line(line: Line):

        return Operation(
            index=line.index,
            text=line.text,
            mnemonic=line.expression.mnemonic,
            arguments=list(map(Value.parse, line.expression.arguments)),
            comment=line.comment,
        )

@dataclass
class Instruction:
    address: int
    opcode: int
    operation: Operation
    label: Symbol | None = None


@dataclass
class Base_instruction:
    opcode: int
    base_arguments: Tuple[int]
