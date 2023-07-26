library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DECODER_3X8 is

  port (
    index    : in  std_logic_vector(2 downto 0);
    selector : out std_logic_vector(7 downto 0)
  );

end entity;

architecture BEHAVIOUR of DECODER_3X8 is

  -- No signals

begin

  selector(7) <= '1' when (index = "111") else '0';
  selector(6) <= '1' when (index = "110") else '0';
  selector(5) <= '1' when (index = "101") else '0';
  selector(4) <= '1' when (index = "100") else '0';
  selector(3) <= '1' when (index = "011") else '0';
  selector(2) <= '1' when (index = "010") else '0';
  selector(1) <= '1' when (index = "001") else '0';
  selector(0) <= '1' when (index = "000") else '0';

end architecture;
