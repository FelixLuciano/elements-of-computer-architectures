library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.TOP_LEVEL_TYPES.ALL;

entity DECODER_INSTRUCTION is

  port (
    operation_code   : in  std_logic_vector(OPCODE_RANGE);
    function_code    : in  std_logic_vector(FUNCTION_RANGE);
    flag_z           : in  std_logic;
    enable_register  : out std_logic;
    enable_jump      : out std_logic;
    select_immediate : out std_logic;
    select_memory    : out std_logic;
    select_function  : out std_logic_vector(1 downto 0);
    read_enable      : out std_logic := '0';
    write_enable     : out std_logic := '0'
  );

end entity;

architecture BEHAVIOURAL of DECODER_INSTRUCTION is

  -- No signals

begin

    enable_register  <= '1' when (operation_code = OPCODE_ZERO) else
                        '0';

    enable_jump      <= '0';

    select_immediate <= '0';

    select_memory    <= '0';

    select_function  <= "00" when (operation_code = OPCODE_ZERO) else
                        (others => '0');

    read_enable      <= '0';

    write_enable     <= '0';

end architecture;
