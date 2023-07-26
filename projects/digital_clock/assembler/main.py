import re

from lib import SYMBOLS, OPCODES, Parse, Interpret, Link, Serialize

class Main:
    exit_code: int
    ENTRY_FILE  = "src/entry.asm"
    OUTPUT_FILE = "src/rom_content.mif"

    def __init__(self):
        print(f'Loading entry point from \033[94m"{self.ENTRY_FILE}"\033[0m')
        self._execute_load()

        print(f'\033[94mAssembling program...\033[0m')
        self._execute_assemble()

        print(f'Dumping memory initialization into \033[94m"{self.OUTPUT_FILE}"\033[0m')
        self._execute_dump()

        print("\033[92mSuccessful program assembly!\033[0m")

        exit(0)

    def _execute_load(self):
        with open(self.ENTRY_FILE, "r", encoding="utf-8") as self.source_file:
            self.parser = Parse(self.source_file)

            self.parser.execute()

    def _execute_assemble(self):
        interpreter = Interpret(self.parser.lines, SYMBOLS)
        linker = Link(interpreter.lines, interpreter.symbols, interpreter.labels, OPCODES)
        self.serializer = Serialize(linker.instructions)

        interpreter.execute()
        linker.execute()
        self.serializer.execute()
    
    def _execute_dump(self):
        pattern = r"(?<=^CONTENT BEGIN\n)(?:.+\n)*.*(?=\nEND;)"
        content = "\n".join(self.serializer.result)

        with open(self.OUTPUT_FILE, "r", encoding="utf-8") as file:
            program_content = re.sub(pattern, content, file.read(), flags=re.MULTILINE)

        with open(self.OUTPUT_FILE, "w", encoding="utf-8") as file:
            file.write(program_content)


if __name__ == "__main__":
    Main()
