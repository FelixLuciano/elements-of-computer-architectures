library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.TOP_LEVEL_TYPES.ALL;

entity DECODER_INSTRUCTION is

  port (
    opcode            : in  std_logic_vector(OPCODE_RANGE);
    enable_register   : out std_logic;
    select_function   : out std_logic_vector(1 downto 0)
  );

end entity;

architecture BEHAVIOUR of DECODER_INSTRUCTION is

  -- No signals

begin

    enable_register <= '1' when (opcode = OPCODE_ZERO) else
                       '0';

    select_function <= "00" when (opcode = OPCODE_ZERO) else
                       (others => '0');

end architecture;
