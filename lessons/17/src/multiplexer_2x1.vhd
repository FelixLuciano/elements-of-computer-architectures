library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MULTIPLEXER_2X1 is

  generic (
    data_width : natural := 8
  );

  port (
    source_0 : in  std_logic_vector(data_width-1 downto 0);
    source_1 : in  std_logic_vector(data_width-1 downto 0);
    selector : in  std_logic;
    destiny  : out std_logic_vector(data_width-1 downto 0)
  );

end entity;

architecture behaviour of MULTIPLEXER_2X1 is

  -- No signals

begin

  destiny <= source_1 when (selector = '1') else
             source_0;

end architecture;
