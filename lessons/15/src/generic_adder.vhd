library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity GENERIC_ADDER is

  generic (
    data_width     : natural := 8;
    default_target : integer := 1
  );

  port (
    source  : in  std_logic_vector(data_width-1 downto 0);
    target  : in  std_logic_vector(data_width-1 downto 0) := std_logic_vector(to_signed(default_target, data_width));
    destiny : out std_logic_vector(data_width-1 downto 0)
  );

end entity;

architecture BEHAVIOURAL of GENERIC_ADDER is

  -- No signals

begin

  destiny <= std_logic_vector(unsigned(source) + unsigned(target));

end architecture;
