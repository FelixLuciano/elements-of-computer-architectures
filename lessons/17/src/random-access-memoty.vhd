library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RANDOM_ACCESS_MEMORY is

  generic (
    data_width        : natural := 32;
    address_width     : natural := 32;
    addressable_width : natural := 6
  );

  port (
    clock        : in  std_logic;
    enable       : in  std_logic;
    enable_read  : in  std_logic;
    enable_write : in  std_logic;
    address      : in  std_logic_vector((address_width-1) downto 0);
    data_in      : in  std_logic_vector((data_width-1) downto 0);
    data_out     : out std_logic_vector((data_width-1) downto 0)
  );

end entity;

architecture BEHAVIORAL OF RANDOM_ACCESS_MEMORY IS

  subtype word_t is std_logic_vector((data_width-1) downto 0);
  type memory_t is array(0 to (2**addressable_width - 1)) of word_t;

  signal ram: memory_t;
  --  Caso queira inicializar a RAM (para testes):
  --  attribute ram_init_file : string;
  --  attribute ram_init_file of ram:
  --  signal is "ram_content.mif";

  -- Utiliza uma quantidade menor de endereços locais:
  signal local_address : std_logic_vector((addressable_width-1) downto 0);

begin

  -- Ajusta o enderecamento para o acesso de 32 bits.
  local_address <= address((addressable_width+1) downto 2);

  process(clock)
  begin
      if(rising_edge(clock)) then
          if(enable_write = '1' AND enable = '1') then
              ram(to_integer(unsigned(local_address))) <= data_in;
          end if;
      end if;
  end process;

  -- A leitura deve ser sempre assincrona:
  data_out <= ram(to_integer(unsigned(local_address))) when (enable_read = '1' and enable='1') else
             (others => 'Z');

end architecture;
