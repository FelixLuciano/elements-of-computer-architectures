library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CONSTANT_SUM is

  generic (
    data_width : natural;
    value      : natural
  );

  port (
    source  : in  std_logic_vector(data_width-1 downto 0);
    destiny : out std_logic_vector(data_width-1 downto 0)
  );

end entity;

architecture behaviour of CONSTANT_SUM is

  -- No signals

begin

  destiny <= std_logic_vector(unsigned(source) + value);

end architecture;
