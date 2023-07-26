library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity GENERIC_MULTIPLEXER is

  generic (
    selector_width : natural := 1
  );

  port (
    sources  : in  std_logic_vector((2**selector_width - 1) downto 0) := (others => '0');
    selector : in  std_logic_vector(selector_width-1 downto 0);
    destiny  : out std_logic
  );

end entity;

architecture BEHAVIOURAL of GENERIC_MULTIPLEXER is

  -- No signals

begin

  destiny <= sources(to_integer(unsigned(selector)));

end architecture;
