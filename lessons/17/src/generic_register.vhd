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

architecture BEHAVIOURAL of GENERIC_REGISTER is

  -- No signals

begin

  process(clear, clock, enable)
  begin
    if (clear = '1') then
      destiny <= (others => '0');
    elsif (rising_edge(clock) AND enable = '1') then
      destiny <= source;
    end if;
  end process;

end architecture;
