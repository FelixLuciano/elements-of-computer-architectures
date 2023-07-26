library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.TOP_LEVEL_TYPES.ALL;

entity CPU_INSTRUCTION_CONTROL_UNIT is

  port (
    operation_code   : in  std_logic_vector(OPCODE_RANGE);
    enable_jump      : out std_logic;
    select_destiny   : out std_logic;
    enable_registers : out std_logic;
    select_immediate : out std_logic;
    enable_function  : out std_logic;
    select_memory    : out std_logic;
    enable_beq       : out std_logic;
    enable_read      : out std_logic;
    enable_write     : out std_logic
  );

end entity;

architecture BEHAVIOURAL of CPU_INSTRUCTION_CONTROL_UNIT is

  -- No signals

begin

  enable_jump      <= '1' when (operation_code = OPCODE_J) else
                      '0';

  select_destiny   <= '1' when (operation_code = OPCODE_ZERO) else
                      '0';

  enable_registers <= '1' when (operation_code = OPCODE_ZERO OR operation_code = OPCODE_LW) else
                      '0';

  select_immediate <= '1' when (operation_code = OPCODE_SW OR operation_code = OPCODE_LW) else
                      '0';

  enable_function  <= '1' when (operation_code = OPCODE_ZERO) else
                      '0';

  select_memory    <= '1' when (operation_code = OPCODE_LW) else
                      '0';

  enable_beq       <= '1' when (operation_code = OPCODE_BEQ) else
                      '0';

  enable_read      <= '1' when (operation_code = OPCODE_LW) else
                      '0';

  enable_write     <= '1' when (operation_code = OPCODE_SW) else
                      '0';

end architecture;
