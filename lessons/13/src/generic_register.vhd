library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity GENERIC_REGISTER is

  generic (
    data_width : natural
  );

  port (
    clock   : in  std_logic;
    clear   : in  std_logic;
    enable  : in  std_logic;
    source  : in  std_logic_vector(data_width-1 downto 0);
    destiny : out std_logic_vector(data_width-1 downto 0) := (others => '0')
  );

end entity;

architecture behaviour of GENERIC_REGISTER is

  -- No signals

begin

  -- In Altera devices, register signals have a set priority.
  -- The HDL design should reflect this priority.
  process(clear, clock)
  begin
    -- The asynchronous reset signal has the highest priority
    if (clear = '1') then
      destiny <= (others => '0');    -- Código reconfigurável.
    else
      -- At a clock edge, if asynchronous signals have not taken priority,
      -- respond to the appropriate synchronous signal.
      -- Check for synchronous reset, then synchronous load.
      -- If none of these takes precedence, update the register output
      -- to be the register input.
      if (rising_edge(clock)) then
        if (enable = '1') then
          destiny <= source;
        end if;
      end if;
    end if;
  end process;

end architecture;
