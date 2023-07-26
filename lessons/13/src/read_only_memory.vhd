library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity READ_ONLY_MEMORY is

  generic (
    address_width     : natural;
    addressable_width : natural;
    data_width        : natural
  );

  port (
    address  : in  std_logic_vector(address_width-1 downto 0);
    data_out : out std_logic_vector(data_width-1 downto 0)
  );

end entity;

architecture BEHAVIOUR OF READ_ONLY_MEMORY IS

  subtype word_t is std_logic_vector(data_width-1 downto 0);
  type memory_t is array(0 to 2**addressable_width - 1) of word_t;

  signal rom : memory_t;
  attribute ram_init_file : string;
  attribute ram_init_file of rom:
  signal is "../src/rom_content.mif";

  -- Utiliza uma quantidade menor de endereços locais:
  signal addressed : std_logic_vector(addressable_width-1 downto 0);

begin

  addressed <= address(addressable_width+1 downto 2);
  data_out  <= rom(to_integer(unsigned(addressed)));

end architecture;
