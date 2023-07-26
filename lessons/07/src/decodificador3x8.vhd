library ieee;
use ieee.std_logic_1164.all;

entity decodificador3x8 is
  port
  (
    d : in  std_logic_vector(2 downto 0);
    q : out std_logic_vector(7 downto 0)
  );

end entity;

architecture comportamento of decodificador3x8 is
-- No signals
begin

  q <= "00000001" when d = "000" else
       "00000010" when d = "001" else
       "00000100" when d = "010" else
       "00001000" when d = "011" else
       "00010000" when d = "100" else
       "00100000" when d = "101" else
       "01000000" when d = "110" else
       "10000000" when d = "111" else
       "00000000";

end architecture;
