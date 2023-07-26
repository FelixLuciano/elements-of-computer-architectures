library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.TOP_LEVEL_TYPES.ALL;

entity INTERFACE_TC is

  port (
    clock        : in  std_logic;
    enable       : in  std_logic;
    write_enable : in  std_logic;
    address      : in  std_logic_vector(ADDRESS_RANGE);
    data_in      : in  std_logic_vector(DATA_RANGE);
    state        : out std_logic_vector(1 downto 0)
  );

end entity;

architecture behaviour of INTERFACE_TC is

  signal selector      : std_logic_vector(7 downto 0);
  signal set_tc0_state : std_logic;
  signal ack_tc0_state : std_logic;
  signal set_tc1_state : std_logic;
  signal ack_tc1_state : std_logic;

begin

  ADDRESS_DECODER: entity WORK.DECODER_3X8
    port map (
      index    => address(2 downto 0),
      selector => selector
    );

  TC0: entity WORK.TIMER_COUNTER
    port map (
      clock  => clock,
      clear  => ack_tc0_state,
      set    => '0',
      source => (others => '0'),
      state  => state(0)
    );
  ack_tc0_state <= '1' when (address = ACK_TC0 AND write_enable = '1') else
                   '0';

  TC1: entity WORK.TIMER_COUNTER
    port map (
      clock  => clock,
      clear  => ack_tc1_state,
      set    => set_tc1_state,
      source => data_in(4 downto 0),
      state  => state(1)
    );
  ack_tc1_state <= '1' when (address = ACK_TC1 AND write_enable = '1') else
                   '0';
  set_tc1_state <= '1' when (enable = '1' AND selector(0) = '1' AND write_enable = '1') else
                   '0';

end architecture;
