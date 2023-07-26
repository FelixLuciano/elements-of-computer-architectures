library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.TOP_LEVEL_TYPES.ALL;

entity INTERFACE_KEYS is

  port (
    clock        : in  std_logic;
    write_enable : in  std_logic;
    address      : in  std_logic_vector(ADDRESS_RANGE);
    key          : in  std_logic_vector(4 downto 0);
    state        : out std_logic_vector(4 downto 0)
  );

end entity;

architecture behaviour of INTERFACE_KEYS is

  signal selector           : std_logic_vector(7 downto 0);
  signal key0_state_clear   : std_logic;
  signal key1_state_clear   : std_logic;
  signal key2_state_clear   : std_logic;
  signal key3_state_clear   : std_logic;
  signal key4_state_clear   : std_logic;
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

  KEY0_DEBOUNCE : entity WORK.DEBOUNCE
    port map (
      clock  => clock,
      clear  => key0_state_clear,
      source => key(0),
      state  => state(0)
    );
  key0_state_clear <= '1' when address = ACK_KEY0 and write_enable = '1' else
                      '0';

  KEY1_DEBOUNCE : entity WORK.DEBOUNCE
    port map (
      clock  => clock,
      clear  => key1_state_clear,
      source => key(1),
      state  => state(1)
    );
  key1_state_clear <= '1' when address = ACK_KEY1 and write_enable = '1' else
                      '0';

  KEY2_DEBOUNCE : entity WORK.DEBOUNCE
    port map (
      clock  => clock,
      clear  => key2_state_clear,
      source => key(2),
      state  => state(2)
    );
  key2_state_clear <= '1' when address = ACK_KEY2 and write_enable = '1' else
                      '0';

  KEY3_DEBOUNCE : entity WORK.DEBOUNCE
    port map (
      clock  => clock,
      clear  => key3_state_clear,
      source => key(3),
      state  => state(3)
    );
  key3_state_clear <= '1' when address = ACK_KEY3 and write_enable = '1' else
                      '0';

  KEY4_DEBOUNCE : entity WORK.DEBOUNCE
    port map (
      clock  => clock,
      clear  => key4_state_clear,
      source => key(4),
      state  => state(4)
    );
  key4_state_clear <= '1' when address = ACK_KEY4 and write_enable = '1' else
                      '0';

end architecture;
