library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FLIP_FLOP is

  port (
    clock   : in  std_logic;
    clear   : in  std_logic;
    enable  : in  std_logic;
    source  : in  std_logic;
    destiny : out std_logic := '0'
  );

end entity;

architecture behaviour of FLIP_FLOP is

  -- No signals

begin

  process(clear, clock)
  begin
    if (clear = '1') then
      destiny <= '0';
    else
      if (rising_edge(clock)) then
        if (enable = '1') then
          destiny <= source;
        end if;
      end if;
    end if;
  end process;

end architecture;
