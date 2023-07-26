library ieee;
use ieee.std_logic_1164.all;

entity GENERIC_SIGNAL_EXTENDER is

  generic (
      source_width  : natural;
      destiny_width : natural
  );

  port (
      source          : in  std_logic_vector(source_width-1 downto 0);
      enable_unsigned : in  std_logic := '0';
      destiny         : out std_logic_vector(destiny_width-1 downto 0)
  );

end entity;

architecture LOWER_EXTEND of GENERIC_SIGNAL_EXTENDER is

  signal upper : std_logic_vector((destiny_width-1) downto source_width);

begin

    upper <= (others => '0') when (enable_unsigned = '1') else
             (others => source(source_width-1));

    destiny((destiny_width-1) downto source_width) <= upper;
    destiny((source_width-1) downto 0) <= source;

end architecture;

architecture LOGICAL_UPPER of GENERIC_SIGNAL_EXTENDER is

  -- No signals

begin

    destiny((destiny_width-1) downto (destiny_width-source_width)) <= source;
    destiny((destiny_width-source_width-1) downto 0) <= (others => '0');

end architecture;
