library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.TOP_LEVEL_TYPES.ALL;

entity INTERFACE_LEDS is

  port (
    clock        : in  std_logic;
    clear        : in  std_logic;
    enable       : in  std_logic;
    write_enable : in  std_logic;
    address      : in  std_logic_vector(ADDRESS_RANGE);
    data_in      : in  std_logic_vector(DATA_RANGE);
    ledr         : out std_logic_vector(9 downto 0);
    hex0         : out std_logic_vector(6 downto 0);
    hex1         : out std_logic_vector(6 downto 0);
    hex2         : out std_logic_vector(6 downto 0);
    hex3         : out std_logic_vector(6 downto 0);
    hex4         : out std_logic_vector(6 downto 0);
    hex5         : out std_logic_vector(6 downto 0)
  );

end entity;

architecture behaviour of INTERFACE_LEDS is

  signal selector                              : std_logic_vector(7 downto 0);
  signal hex0_register_dout_hex0_decoder_value : std_logic_vector(3 downto 0);
  signal hex1_register_dout_hex1_decoder_value : std_logic_vector(3 downto 0);
  signal hex2_register_dout_hex2_decoder_value : std_logic_vector(3 downto 0);
  signal hex3_register_dout_hex3_decoder_value : std_logic_vector(3 downto 0);
  signal hex4_register_dout_hex4_decoder_value : std_logic_vector(3 downto 0);
  signal hex5_register_dout_hex5_decoder_value : std_logic_vector(3 downto 0);

begin

  ADDRESS_DECODER : entity WORK.DECODER_3X8
    port map (
      index    => address(2 downto 0),
      selector => selector
    );

  LED1_REGISTER : entity WORK.GENERIC_REGISTER
    generic map (
      data_width => 1
    )
    port map (
      clock   => clock,
      clear   => clear,
      enable  => enable and write_enable and selector(2) and not(address(5)),
      source  => data_in(0 downto 0),
      destiny => ledr(9 downto 9)
    );

  LED2_REGISTER : entity WORK.GENERIC_REGISTER
    generic map (
      data_width => 1
    )
    port map (
      clock   => clock,
      clear   => clear,
      enable  => enable and write_enable and selector(1) and not(address(5)),
      source  => data_in(0 downto 0),
      destiny => ledr(8 downto 8)
    );

  LEDR_REGISTER : entity WORK.GENERIC_REGISTER
    generic map (
      data_width => 8
    )
    port map (
      clock   => clock,
      clear   => clear,
      enable  => enable and write_enable and selector(0) and not(address(5)),
      source  => data_in(7 downto 0),
      destiny => ledr(7 downto 0)
    );

  HEX0_REGISTER: entity WORK.GENERIC_REGISTER
    generic map (
      data_width => 4
    )
    port map (
      clock   => clock,
      clear   => clear,
      enable  => enable and write_enable and selector(0) and address(5),
      source  => data_in(3 downto 0),
      destiny => hex0_register_dout_hex0_decoder_value
    );

  HEX0_DECODER: entity WORK.DECODER_7SEG
    port map (
      enable   => '1',
      negative => '0',
      overFlow => '0',
      value    => hex0_register_dout_hex0_decoder_value,
      selector => hex0
    );

  HEX1_REGISTER: entity WORK.GENERIC_REGISTER
    generic map (
      data_width => 4
    )
    port map (
      clock   => clock,
      clear   => clear,
      enable  => enable and write_enable and selector(1) and address(5),
      source  => data_in(3 downto 0),
      destiny => hex1_register_dout_hex1_decoder_value
    );

  HEX1_DECODER: entity WORK.DECODER_7SEG
    port map (
      enable   => '1',
      negative => '0',
      overFlow => '0',
      value    =>  hex1_register_dout_hex1_decoder_value,
      selector => hex1
    );

  HEX2_REGISTER: entity WORK.GENERIC_REGISTER
    generic map (
      data_width => 4
    )
    port map (
      clock   => clock,
      clear   => clear,
      enable  => enable and write_enable and selector(2) and address(5),
      source  => data_in(3 downto 0),
      destiny => hex2_register_dout_hex2_decoder_value
    );

  HEX2_DECODER: entity WORK.DECODER_7SEG
    port map (
      enable   => '1',
      negative => '0',
      overFlow => '0',
      value    => hex2_register_dout_hex2_decoder_value,
      selector => hex2
    );

  HEX3_REGISTER: entity WORK.GENERIC_REGISTER
    generic map (
      data_width => 4
    )
    port map (
      clock   => clock,
      clear   => clear,
      enable  => enable and write_enable and selector(3) and address(5),
      source  => data_in(3 downto 0),
      destiny => hex3_register_dout_hex3_decoder_value
    );

  HEX3_DECODER: entity WORK.DECODER_7SEG
    port map (
      enable   => '1',
      negative => '0',
      overFlow => '0',
      value    => hex3_register_dout_hex3_decoder_value,
      selector => hex3
    );

  HEX4_REGISTER: entity WORK.GENERIC_REGISTER
    generic map (
      data_width => 4
    )
    port map (
      clock   => clock,
      clear   => clear,
      enable  => enable and write_enable and selector(4) and address(5),
      source  => data_in(3 downto 0),
      destiny => hex4_register_dout_hex4_decoder_value
    );

  HEX4_DECODER: entity WORK.DECODER_7SEG
    port map (
      enable   => '1',
      negative => '0',
      overFlow => '0',
      value    => hex4_register_dout_hex4_decoder_value,
      selector => hex4
    );

  HEX5_REGISTER: entity WORK.GENERIC_REGISTER
    generic map (
      data_width => 4
    )
    port map (
      clock   => clock,
      clear   => clear,
      enable  => enable and write_enable and selector(5) and address(5),
      source  => data_in(3 downto 0),
      destiny => hex5_register_dout_hex5_decoder_value
    );

  HEX5_DECODER: entity WORK.DECODER_7SEG
    port map (
      enable   => '1',
      negative => '0',
      overFlow => '0',
      value    => hex5_register_dout_hex5_decoder_value,
      selector => hex5
    );

end architecture;
