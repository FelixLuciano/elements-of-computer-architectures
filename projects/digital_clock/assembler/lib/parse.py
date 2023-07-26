import re
from typing import List, TextIO

from .data_models import Line, Expression


class Parse:
    LINE_SYNTAX = re.compile(
        r"^\s*(?:(?P<label>[@$%.]?\w+)\s*:\s*)?(?P<expr>(?:,?\s*?[\w@$%.-]+)+)?\s*?(?:#\s*(?P<comm>.+))?$"
    )
    EXPR_SYNTAX = re.compile(
        r"^(?:(?P<mnemonic>.?\w+)\s*)?(?:(?P<arg0>[@$%.](?:-|\+)?\w+)\s*)?(?:,\s*(?P<arg1>[@$%]\w+)\s*)?$"
    )

    lines: List[Line]

    def __init__(self, source: TextIO):
        self.lines = []
        self.source = source

    def execute(self):
        for index, text in enumerate(self.source, 1):
            if text.endswith("\n"):
                text = text[:-1]

            line = Parse._parse_line(index, text.strip())

            self.lines.append(line)

    @staticmethod
    def _parse_line(index: int, text: str):
        matches = Parse.LINE_SYNTAX.match(text)

        if matches is None:
            raise Exception(f"Invalid syntax, at line {index}.")

        line = matches.groupdict()

        try:
            expression = Parse._parse_expression(line["expr"])
        except ValueError as err:
            raise ValueError(f"{err.args[0]}, at line {index}.") from None

        return Line(index, text, line["label"], expression, line["comm"])

    @staticmethod
    def _parse_expression(text: str | None):
        if text is None:
            return None

        matches = Parse.EXPR_SYNTAX.match(text)

        if matches is None:
            raise ValueError(f'Invalid expression "{text}"')

        expression_dict = matches.groupdict()
        arguments = []

        if expression_dict["arg0"] is not None:
            arguments.append(expression_dict["arg0"])

        if expression_dict["arg1"] is not None:
            arguments.append(expression_dict["arg1"])

        return Expression(expression_dict["mnemonic"], arguments)

