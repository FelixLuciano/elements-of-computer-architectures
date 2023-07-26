library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RANDOM_ACCESS_MEMORY is

  generic (
    data_width    : natural := 8;
    address_width : natural := 8
  );

  port (
    clock        : in  std_logic;
    enable       : in  std_logic;
    read_enable  : in  std_logic;
    write_enable : in  std_logic;
    address      : in  std_logic_vector(address_width-1 downto 0);
    data_in      : in  std_logic_vector(data_width-1 downto 0);
    data_out     : out std_logic_vector(data_width-1 downto 0)
  );

end entity;

architecture behaviour of RANDOM_ACCESS_MEMORY is

  subtype word_t is std_logic_vector(data_width-1 downto 0);
  type memory_t is array((2**address_width-1) downto 0) of word_t;

  signal ram : memory_t;

begin

  process(clock)
  begin
    if(rising_edge(clock)) then
      if(enable='1' AND write_enable = '1') then
        ram(to_integer(unsigned(address))) <= data_in;
      end if;
    end if;
  end process;

  data_out <= ram(to_integer(unsigned(address))) when (enable='1' AND read_enable = '1') else
              (others => 'Z');

end architecture;
