from typing import Dict, List

from .data_models import Operation, Symbol, TYPES
from .parse import Line, Parse


class Interpret:
    labels: Dict[str, Symbol]
    operations: List[Line]
    lines: List[Symbol | Operation]
    symbols: Dict[str, Symbol]
    liness: List[Line]

    def __init__(self, lines: Parse, symbols: List[Symbol] = {}):
        self.labels = {}
        self.operations = []
        self.lines = []

        self.liness = lines
        self.symbols = {symbol.name: symbol for symbol in symbols}

    def execute(self):
        for line in self.liness:            
            if line.expression and line.expression.mnemonic in (".data", ".text"):
                continue

            if line.label is not None:
                if line.expression is None:
                    self._push_label(line)
                elif line.expression.mnemonic is None:
                    self._push_symbol(line)
                else:
                    if line.expression.mnemonic == ".byte":
                        self._push_symbol(line)
                    else:
                        self._push_operation(line)
                        self._push_label(line)
            elif line.expression is not None and line.expression.mnemonic is not None:
                self._push_operation(line)

    def _push_label(self, line: Line):
        symbol = Symbol(
            name=line.label,
            value=None, 
            type=TYPES.label
        )

        self.labels["." + symbol.name] = symbol

        self.lines.append(symbol)

    def _push_symbol(self, line: Line):
        symbol = Symbol.from_line(line)

        self.symbols[symbol.name] = symbol

    def _push_operation(self, line: Line):
        operation = Operation.from_line(line)

        self.lines.append(operation)
        self.operations.append(operation)
