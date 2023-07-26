library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.TOP_LEVEL_TYPES.ALL;

entity CPU_ALU_CONTROL_UNIT is

  port (
    operation_code  : in  std_logic_vector(OPCODE_RANGE);
    function_code   : in  std_logic_vector(FUNCTION_RANGE);
    enable_function : in  std_logic;
    enable_jr       : out  std_logic;
    control         : out std_logic_vector(3 downto 0)
  );

end entity;

architecture BEHAVIOURAL of CPU_ALU_CONTROL_UNIT is

  signal from_funct  : std_logic_vector(3 downto 0);
  signal from_opcode : std_logic_vector(3 downto 0);

begin

  from_funct      <= "0000" when (function_code = FUNCTION_AND) else
                     "0001" when (function_code = FUNCTION_OR) else
                     "0010" when (function_code = FUNCTION_ADD) else
                     "0110" when (function_code = FUNCTION_SUB) else
                     "0111" when (function_code = FUNCTION_SLT) else
                     "1100" when (function_code = FUNCTION_NOR) else
                     "0000";

  from_opcode     <= "0110" when (operation_code = OPCODE_BEQ) else
                     "0110" when (operation_code = OPCODE_BNE) else
                     "0000" when (operation_code = OPCODE_J) else
                     "0000" when (operation_code = OPCODE_JAL) else
                     "0010" when (operation_code = OPCODE_LW) else
                     "0010" when (operation_code = OPCODE_LBU) else
                     "0010" when (operation_code = OPCODE_SW) else
                     "0010" when (operation_code = OPCODE_SB) else
                     "0000" when (operation_code = OPCODE_ANDI) else
                     "0001" when (operation_code = OPCODE_ORI) else
                     "0010" when (operation_code = OPCODE_ADDI) else
                     "0111" when (operation_code = OPCODE_SLTI) else
                     "0111" when (operation_code = OPCODE_SLTIU) else
                     "0000";

  enable_jr       <= '1' when (enable_function = '1' AND function_code = FUNCTION_JR) else
                     '0';

  control         <= from_funct when (enable_function = '1') else
                     from_opcode;

end architecture;
