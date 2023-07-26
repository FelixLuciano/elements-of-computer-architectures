library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CONSTANT_ADDER is

  generic (
    data_width : natural := 8;
    value      : natural := 1
  );

  port (
    source  : in  std_logic_vector(data_width-1 downto 0);
    destiny : out std_logic_vector(data_width-1 downto 0)
  );

end entity;

architecture BEHAVIOUR of CONSTANT_ADDER is

  -- No signals

begin

  destiny <= std_logic_vector(unsigned(source) + value);

end architecture;
