library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.TOP_LEVEL_TYPES.ALL;

entity INTERFACE_SWITCHES is

  port (
    clock        : in  std_logic;
    enable       : in  std_logic;
    read_enable  : in  std_logic;
    address      : in  std_logic_vector(ADDRESS_RANGE);
    switch       : in  std_logic_vector(9 downto 0);
    data_out     : out std_logic_vector(DATA_RANGE)
  );

end entity;

architecture behaviour of INTERFACE_SWITCHES is

  signal selector           : std_logic_vector(7 downto 0);
  signal key0_state_clear   : std_logic;
  signal key1_state_clear   : std_logic;
  signal key2_state_clear   : std_logic;
  signal key3_state_clear   : std_logic;
  signal key4_state_clear   : std_logic;
  signal data_out_switch_9  : std_logic_vector(DATA_RANGE);
  signal data_out_switch_8  : std_logic_vector(DATA_RANGE);
  signal data_out_switch_r  : std_logic_vector(DATA_RANGE);
  signal data_out_key_0     : std_logic_vector(DATA_RANGE);
  signal data_out_key_1     : std_logic_vector(DATA_RANGE);
  signal data_out_key_2     : std_logic_vector(DATA_RANGE);
  signal data_out_key_3     : std_logic_vector(DATA_RANGE);
  signal data_out_key_4     : std_logic_vector(DATA_RANGE);

begin

  ADDRESS_DECODER: entity WORK.DECODER_3X8
    port map (
      index    => address(2 downto 0),
      selector => selector
    );

  data_out_switch_9(0)          <= switch(9);
  data_out_switch_9(7 downto 1) <= (others => '0');

  data_out_switch_8(0)          <= switch(8);
  data_out_switch_8(7 downto 1) <= (others => '0');

  data_out_switch_r             <= switch(7 downto 0);


  data_out <= (others => 'Z')   when (read_enable = '0' OR enable = '0') else
              data_out_switch_r when (selector(0) = '1') else
              data_out_switch_8 when (selector(1) = '1') else
              data_out_switch_9 when (selector(2) = '1') else
              (others => '0');

end architecture;
