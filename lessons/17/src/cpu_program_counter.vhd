library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.TOP_LEVEL_TYPES.ALL;

entity PROGRAM_COUNTER is

  port (
    clock    : in  std_logic;
    enable_j : in  std_logic;
    enable_i : in  std_logic;
    address  : in  std_logic_vector(J_ADDRESS_RANGE);
    data_out : out std_logic_vector(PROGRAM_RANGE)
  );

end entity;

architecture CPU of PROGRAM_COUNTER is

  signal count_source     : std_logic_vector(PROGRAM_RANGE);
  signal count_destiny    : std_logic_vector(PROGRAM_RANGE);
  signal count_added      : std_logic_vector(PROGRAM_RANGE);
  signal address_extended : std_logic_vector(PROGRAM_RANGE);
  signal i_address        : std_logic_vector(PROGRAM_RANGE);
  signal j_address        : std_logic_vector(PROGRAM_RANGE);

begin

  data_out  <= count_destiny;
  j_address <= count_added(31 downto 28) & address & "00";

  count_source <= i_address when (enable_i = '1') else
                  j_address when (enable_j = '1') else
                  count_added;

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

  I_ADDRESS_EXTENDER : entity WORK.GENERIC_SIGNAL_EXTENDER(ARITHMETICAL)
    generic map (
        source_width  => IMMEDIATE_WIDTH,
        destiny_width => PROGRAM_WIDTH
    )
    port map (
        source  => address((IMMEDIATE_WIDTH - 3) downto 0) & "00",
        destiny => address_extended
    );

  I_ADDRESS_ADDER : entity WORK.GENERIC_ADDER
    generic map (
      data_width => PROGRAM_WIDTH
    )
    port map (
      source  => count_added,
      target  => address_extended,
      destiny => i_address
    );

end architecture;
