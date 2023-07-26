library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DECODER_7SEG is

  port (
    enable   : in  std_logic := '1';
    negative : in  std_logic := '0';
    overFlow : in  std_logic := '0';
    value   : in  std_logic_vector(3 downto 0);
    selector : out std_logic_vector(6 downto 0)
  );

end entity;

architecture BEHAVIOUR of DECODER_7SEG is

  signal segments: std_logic_vector(6 downto 0);

begin

  selector <= "1111111" when (enable   = '0') else
              "0111111" when (negative = '1') else
              "1100010" when (overFlow = '1') else
              segments;

  segments <= "1000000" when (value = "0000") else -- 0    --0--
              "1111001" when (value = "0001") else -- 1   |     |
              "0100100" when (value = "0010") else -- 2   5     1
              "0110000" when (value = "0011") else -- 3   |     |
              "0011001" when (value = "0100") else -- 4    --6--
              "0010010" when (value = "0101") else -- 5   |     |
              "0000010" when (value = "0110") else -- 6   4     2
              "1111000" when (value = "0111") else -- 7   |     |
              "0000000" when (value = "1000") else -- 8    --3--
              "0010000" when (value = "1001") else -- 9
              "0001000" when (value = "1010") else -- A
              "0000011" when (value = "1011") else -- B
              "1000110" when (value = "1100") else -- C
              "0100001" when (value = "1101") else -- D
              "0000110" when (value = "1110") else -- E
              "0001110" when (value = "1111") else -- F
              (others => '1');                     -- NOT USED

end architecture;
