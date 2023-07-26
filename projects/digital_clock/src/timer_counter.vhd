library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.TOP_LEVEL_TYPES.ALL;

entity TIMER_COUNTER is

  generic (
    default_timeout : natural := CLOCK_FREQUENCY  -- 1 second
  );

  port (
    clock  : in  std_logic;
    clear  : in  std_logic;
    set    : in  std_logic;
    source : in  std_logic_vector(4 downto 0);
    state  : out std_logic
  );

end entity;

architecture BEHAVIOUR of TIMER_COUNTER is

  -- No signals

begin

  process(clock, set)
    variable pow     : integer;
    variable timeout : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(default_timeout, 32));
    variable count   : std_logic_vector(31 downto 0) := (others => '0');
  begin
    if rising_edge(clock) then
      count := std_logic_vector(unsigned(count) + 1);

      SET_TIMEOUT : if (set = '1') then
        pow := to_integer(unsigned(source(4 downto 0)));
        timeout := std_logic_vector(to_unsigned(2 ** pow, 32));
      end if;

      SET_STATE : if (count = timeout) then
        state <= '1';
        count := (others => '0');
      end if;

      CLEAR_STATE : if (clear = '1') then
        state <= '0';
      end if;
    end if;
  end process;

end architecture;
