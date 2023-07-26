library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity READ_ONLY_MEMORY is

  generic (
    data_width    : natural := 8;
    address_width : natural := 3
  );

  port (
    address  : in  std_logic_vector((address_width-1) downto 0);
    data_out : out std_logic_vector((data_width-1) downto 0)
  );

end entity;

architecture PROGRAM of READ_ONLY_MEMORY is

  subtype word_t is std_logic_vector((data_width-1) downto 0);
  type memory_t is array(0 to (2**address_width-1)) of word_t;

  signal rom : memory_t;
  attribute ram_init_file : string;
  attribute ram_init_file of rom:
  signal is "../src/rom_content.mif";

begin

  data_out <= rom(to_integer(unsigned(address)));

end architecture;

architecture INTERRUPT_TABLE of READ_ONLY_MEMORY is

  subtype word_t is std_logic_vector((data_width-1) downto 0);
  type memory_t is array(0 to (2**address_width-1)) of word_t;

  signal table : memory_t;
  attribute ram_init_file : string;
  attribute ram_init_file of table:
  signal is "../src/interrupt_vector_table.mif";

begin

  data_out <= table(to_integer(unsigned(address)));

end architecture;
