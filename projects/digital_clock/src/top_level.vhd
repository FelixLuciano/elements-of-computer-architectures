library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.TOP_LEVEL_TYPES.ALL;

entity TOP_LEVEL is

  port (
    CLOCK_50     : in  std_logic;
    FPGA_RESET_N : in  std_logic;
    KEY          : in  std_logic_vector(3 downto 0);
    SW           : in  std_logic_vector(9 downto 0);
    LEDR         : out std_logic_vector(9 downto 0);
    HEX0         : out std_logic_vector(6 downto 0);
    HEX1         : out std_logic_vector(6 downto 0);
    HEX2         : out std_logic_vector(6 downto 0);
    HEX3         : out std_logic_vector(6 downto 0);
    HEX4         : out std_logic_vector(6 downto 0);
    HEX5         : out std_logic_vector(6 downto 0)
  );

end entity;

architecture BEHAVIOUR of TOP_LEVEL is

  signal clock        : std_logic;
  signal rom_address  : std_logic_vector(PROGRAM_RANGE);
  signal rom_data_out : std_logic_vector(INSTRUCTION_RANGE);
  signal enable_read  : std_logic;
  signal enable_write : std_logic;
  signal cpu_address  : std_logic_vector(ADDRESS_RANGE);
  signal cpu_data_in  : std_logic_vector(DATA_RANGE);
  signal cpu_data_out : std_logic_vector(DATA_RANGE);
  signal block_select : std_logic_vector(7 downto 0);
  signal keys         : std_logic_vector(4 downto 0);
  signal keys_state   : std_logic_vector(4 downto 0);
  signal tc_state     : std_logic_vector(1 downto 0);

begin

  clock <= CLOCK_50;
  keys(3 downto 0) <= KEY;
  keys(4) <= FPGA_RESET_N;

  ROM : entity WORK.READ_ONLY_MEMORY(PROGRAM)
    generic map (
      data_width    => INSTRUCTION_WIDTH,
      address_width => PROGRAM_WIDTH
    )
    port map (
      address  => rom_address,
      data_out => rom_data_out
    );

  CPU : entity WORK.CENTRAL_PROCESSING_UNIT
    port map (
      clock         => clock,
      reset         => '0',
      intr_0        => keys_state(0),
      intr_1        => keys_state(1),
      intr_2        => keys_state(2),
      intr_3        => keys_state(3),
      intr_4        => keys_state(4),
      intr_5        => tc_state(0),
      intr_6        => tc_state(1),
      instruction   => rom_data_out,
      data_in       => cpu_data_in,
      data_out      => cpu_data_out,
      rom_address   => rom_address,
      data_address  => cpu_address,
      read_enable   => enable_read,
      write_enable  => enable_write
    );

  block_SELECTOR : entity WORK.DECODER_3X8
    port map (
      index    => cpu_address(8 downto 6),
      selector => block_select
    );

  RAM : entity WORK.RANDOM_ACCESS_MEMORY
    generic map (
      data_width    => DATA_WIDTH,
      address_width => ADDRESS_WIDTH
    )
    port map (
      clock        => clock,
      enable       => block_select(0),
      read_enable  => enable_read,
      write_enable => enable_write,
      address      => cpu_address,
      data_in      => cpu_data_out,
      data_out     => cpu_data_in
    );

  IO_LEDS : entity WORK.INTERFACE_LEDS
    port map (
      clock        => clock,
      clear        => '0',
      enable       => block_select(4),
      write_enable => enable_write,
      address      => cpu_address,
      data_in      => cpu_data_out,
      ledr         => LEDR,
      hex0         => HEX0,
      hex1         => HEX1,
      hex2         => HEX2,
      hex3         => HEX3,
      hex4         => HEX4,
      hex5         => HEX5
    );

  IO_SWITCHES : entity WORK.INTERFACE_SWITCHES
    port map (
      clock        => clock,
      enable       => block_select(5),
      read_enable  => enable_read,
      address      => cpu_address,
      switch       => SW,
      data_out     => cpu_data_in
    );

  IO_KEYS : entity WORK.INTERFACE_KEYS
    port map (
      clock        => clock,
      write_enable => enable_write,
      address      => cpu_address,
      key          => keys,
      state        => keys_state
    );

  IO_TC : entity WORK.INTERFACE_TC
    port map (
      clock        => clock,
      enable       => block_select(6),
      write_enable => enable_write,
      address      => cpu_address,
      data_in      => cpu_data_out,
      state        => tc_state
    );

end architecture;
