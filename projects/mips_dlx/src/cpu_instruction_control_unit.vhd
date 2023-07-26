library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.TOP_LEVEL_TYPES.ALL;

entity CPU_INSTRUCTION_CONTROL_UNIT is

  port (
    operation_code   : in  std_logic_vector(OPCODE_RANGE);
    enable_jump      : out std_logic;
    select_destiny   : out std_logic_vector(1 downto 0);
    enable_unsigned  : out std_logic;
    enable_registers : out std_logic;
    select_immediate : out std_logic;
    enable_function  : out std_logic;
    select_memory    : out std_logic_vector(1 downto 0);
    enable_beq       : out std_logic;
    enable_bne       : out std_logic;
    enable_read      : out std_logic;
    enable_write     : out std_logic;
    enable_byte      : out std_logic
  );

end entity;

architecture BEHAVIOURAL of CPU_INSTRUCTION_CONTROL_UNIT is

  -- No signals

begin

  enable_jump      <= '1' when (
                        operation_code = OPCODE_J OR
                        operation_code = OPCODE_JAL
                      ) else
                      '0';

  select_destiny   <= "01" when (operation_code = OPCODE_ZERO) else
                      "10" when (operation_code = OPCODE_JAL) else
                      "00"; 

  enable_unsigned  <= '1' when (
                        operation_code = OPCODE_ORI OR
                        operation_code = OPCODE_SLTIU OR
                        operation_code = OPCODE_LBU
                      ) else
                      '0';

  enable_registers <= '1' when (
                        operation_code = OPCODE_ZERO OR
                        operation_code = OPCODE_LW OR
                        operation_code = OPCODE_LBU OR
                        operation_code = OPCODE_ANDI OR
                        operation_code = OPCODE_ORI OR
                        operation_code = OPCODE_ADDI OR
                        operation_code = OPCODE_SLTI OR
                        operation_code = OPCODE_SLTIU OR
                        operation_code = OPCODE_LUI OR
                        operation_code = OPCODE_JAL
                      ) else
                      '0';

  select_immediate <= '1' when (
                        operation_code = OPCODE_SW OR
                        operation_code = OPCODE_SB OR
                        operation_code = OPCODE_LW OR
                        operation_code = OPCODE_LBU OR
                        operation_code = OPCODE_ANDI OR
                        operation_code = OPCODE_ORI OR
                        operation_code = OPCODE_ADDI OR
                        operation_code = OPCODE_SLTI OR
                        operation_code = OPCODE_SLTIU OR
                        operation_code = OPCODE_LUI
                      ) else
                      '0';

  enable_function  <= '1' when (operation_code = OPCODE_ZERO) else
                      '0';

  select_memory    <= "01" when (
                        operation_code = OPCODE_LW OR
                        operation_code = OPCODE_LBU
                      ) else
                      "10" when (operation_code = OPCODE_JAL) else
                      "11" when (operation_code = OPCODE_LUI) else
                      "00";

  enable_beq       <= '1' when (operation_code = OPCODE_BEQ) else
                      '0';

  enable_bne       <= '1' when (operation_code = OPCODE_BNE) else
                      '0';

  enable_read      <= '1' when (
                        operation_code = OPCODE_LW OR
                        operation_code = OPCODE_LBU
                      ) else
                      '0';

  enable_write     <= '1' when (
                        operation_code = OPCODE_SW OR
                        operation_code = OPCODE_SB
                      ) else
                      '0';

  enable_byte      <= '1' when (
                        operation_code = OPCODE_SB OR
                        operation_code = OPCODE_LBU
                      ) else
                      '0';

end architecture;
