library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.TOP_LEVEL_TYPES.ALL;

entity PROGRAM_COUNTER is

  port (
    clock     : in  std_logic;
    j_enable  : in  std_logic;
    j_address : in  std_logic_vector(J_ADDRESS_RANGE);
    data_out  : out std_logic_vector(PROGRAM_RANGE)
  );

end entity;

architecture CPU of PROGRAM_COUNTER is

  signal count_source       : std_logic_vector(PROGRAM_RANGE);
  signal count_destiny      : std_logic_vector(PROGRAM_RANGE);
  signal count_added        : std_logic_vector(PROGRAM_RANGE);
  signal j_address_extended : std_logic_vector(PROGRAM_RANGE);
  signal j_address_added    : std_logic_vector(PROGRAM_RANGE);

begin

  data_out <= count_destiny;

  COUNT : entity WORK.GENERIC_REGISTER
    generic map (
      data_width => PROGRAM_WIDTH
    )
    port map (
      clock   => clock,
      clear   => '0',
      enable  => '1',
      source  => count_source,
      destiny => count_destiny
    );

  COUNT_ADDER : entity WORK.GENERIC_ADDER
    generic map (
      data_width     => PROGRAM_WIDTH,
      default_target => 4
    )
    port map (
      source  => count_destiny,
      destiny => count_added
    );

  J_ADDRESS_EXTENDER : entity WORK.GENERIC_SIGNAL_EXTENDER
    generic map (
        source_width  => J_ADDRESS_WIDTH,
        destiny_width => PROGRAM_WIDTH
    )
    port map (
        source  => j_address((J_ADDRESS_WIDTH - 3) downto 0) & "00",
        destiny => j_address_extended
    );

  J_ADDRESS_ADDER : entity WORK.GENERIC_ADDER
    generic map (
      data_width => PROGRAM_WIDTH
    )
    port map (
      source  => count_added,
      target  => j_address_extended,
      destiny => j_address_added
    );

  COUNT_SOURCE_MUX : entity WORK.MULTIPLEXER_2X1
    generic map (
      data_width => PROGRAM_WIDTH
    )
    port map (
      source_0 => count_added,
      source_1 => j_address_added,
      selector => j_enable,
      destiny  => count_source
    );

end architecture;
