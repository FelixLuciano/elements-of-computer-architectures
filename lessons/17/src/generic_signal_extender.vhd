library ieee;
use ieee.std_logic_1164.all;

entity GENERIC_SIGNAL_EXTENDER is

  generic (
      source_width  : natural;
      destiny_width : natural
  );

  port (
      source  : in  std_logic_vector(source_width-1 downto 0);
      destiny : out std_logic_vector(destiny_width-1 downto 0)
  );

end entity;

architecture ARITHMETICAL of GENERIC_SIGNAL_EXTENDER is

  -- No signals

begin

    destiny((destiny_width-1) downto source_width) <= (others => source(source_width-1));
    destiny((source_width-1) downto 0) <= source;

end architecture;

architecture LOGICAL of GENERIC_SIGNAL_EXTENDER is

  -- No signals

begin

    destiny((destiny_width-1) downto source_width) <= (others => '0');
    destiny((source_width-1) downto 0) <= source;

end architecture;
