from copy import deepcopy
from typing import Dict, List

from .data_models import TYPES, Base_instruction, Instruction, Operation, Symbol
from .interpret import Interpret


class Link:
    instructions: List[Instruction]
    interpreter: Interpret

    def __init__(
        self,
        lines: List[Instruction | Symbol],
        symbols: Dict[str, Symbol],
        labels: Dict[str, Symbol],
        opcodes: List[Base_instruction] = {},
    ):
        self.instructions = []

        self.lines = lines
        self.symbols = symbols
        self.labels = labels
        self.opcodes = opcodes

    def execute(self):
        self._base_address = 0

        for symbol in self.symbols.values():
            if symbol.value is None and symbol.text is not None:
                symbol.value = self.symbols[symbol.text].value

        for line in self.lines:
            if isinstance(line, Operation):
                self._execute_operation(line)
            elif isinstance(line, Symbol):
                self._execute_label(line)

        self.instructions.sort(key=lambda x: x.address)

    def _execute_label(self, symbol: Symbol):
        symbol.value = self._base_address

    def _execute_operation(self, operation: Operation):
        for index, argument in enumerate(operation.arguments):
            if argument.type == TYPES.label:
                try:
                    if argument.value is None and argument.text is not None:
                        operation.arguments[index] = self.labels[argument.text]
                except KeyError:
                    raise ValueError(
                        f'Couldn\'t find label "{argument.text}", at line {operation.index}.'
                    ) from None
            else:
                try:
                    if argument.value is None and argument.text is not None:
                        argument.value = self.symbols[argument.text].value
                except KeyError:
                    if argument.type == TYPES.register:
                        raise ValueError(
                            f'Couldn\'t find register "{argument.text}", at line {operation.index}.'
                        ) from None
                    else:
                        raise ValueError(
                            f'Couldn\'t find symbol "{argument.text}", at line {operation.index}.'
                        ) from None

        if operation.mnemonic.startswith("."):
            self._execute_assembler_operation(operation)
        else:
            self._execute_static_operation(operation)

    def _execute_assembler_operation(self, operation: Operation):
        if operation.mnemonic == ".equ":
            self._base_address = operation.arguments[0].value

    def _execute_static_operation(self, operation: Operation):
        arguments = list(deepcopy(self.opcodes[operation.mnemonic].base_arguments))

        for index, argument in enumerate(operation.arguments):
            arguments[index] = argument

        operation.arguments = arguments

        instruction_label = None
        for label in self.labels.values():
            if label.value == self._base_address:
                instruction_label = label

        instruction = Instruction(
            address=self._base_address,
            opcode=self.opcodes[operation.mnemonic].opcode,
            operation=operation,
            label=instruction_label,
        )

        self.instructions.append(instruction)

        self._base_address += 1
