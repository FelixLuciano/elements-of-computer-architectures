import math
from typing import List
from abc import ABC, abstractmethod

from .data_models import Instruction


class Base_instruction_serializer(ABC):
    def __init__(self, instructions: List[Instruction]):
        self.instructions = instructions

    @abstractmethod
    def execute(self, instruction: Instruction):
        pass


class Instruction_serializer(Base_instruction_serializer):
    def __init__(self, instructions: List[Instruction]):
        super().__init__(instructions)

        max_address = max(inst.address for inst in self.instructions)
        self.pad_start = math.ceil(math.log10(max_address)) + 4

    def execute(self, instruction: Instruction):
        template = f"{{address: >{self.pad_start}}}: "
        template += "{opcode:05b}{args[1].value:02b}{args[0].value:09b};"
        template += "  -- {operation.mnemonic}{args[0].type}{args[0].value}"

        for argument in instruction.operation.arguments:
            if argument.value < 0:
                argument.value += 2**9

        if instruction.operation.arguments[1].text:
            template += " {args[1].text}"
        if instruction.label:
            template += " [{label.name}]"
        if instruction.operation.comment:
            template += ' "{operation.comment}"'

        return template.format(
            address=instruction.address,
            opcode=instruction.opcode,
            label=instruction.label,
            operation=instruction.operation,
            args=instruction.operation.arguments,
        )


class Serialize:
    serializers = {
        Instruction: Instruction_serializer
    }
    result: List[str]

    def __init__(self, instructions: List[Instruction]):
        self.instructions = instructions

    def execute(self):
        self._serializers = {
            key: serializer(self.instructions)
            for key, serializer in self.serializers.items()
        }

        self.result = [
            self._get_serializer(instruction).execute(instruction)
            for instruction in self.instructions
        ]

    def _get_serializer(self, instruction: Instruction) -> Base_instruction_serializer:
        return self._serializers[type(instruction)]
