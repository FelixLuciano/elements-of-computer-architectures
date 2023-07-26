library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.TOP_LEVEL_TYPES.ALL;

entity TOP_LEVEL is
	generic (
		enable_simulation : boolean := TRUE  -- para gravar na placa, altere de TRUE para FALSE
	);

  port (
    CLOCK_50     : in  std_logic;
    SW           : in  std_logic_vector(9 downto 0);
	  KEY          : in  std_logic_vector(3 downto 0);
    LEDR         : out std_logic_vector(9 downto 0);
    HEX0         : out std_logic_vector(6 downto 0);
    HEX1         : out std_logic_vector(6 downto 0);
    HEX2         : out std_logic_vector(6 downto 0);
    HEX3         : out std_logic_vector(6 downto 0);
    HEX4         : out std_logic_vector(6 downto 0);
    HEX5         : out std_logic_vector(6 downto 0);
    ula_out      : out std_logic_vector(DATA_RANGE);
    pc_out       : out std_logic_vector(PROGRAM_RANGE)
  );

end entity;

architecture BEHAVIOURAL of TOP_LEVEL is

  signal clock            : std_logic;
  signal cpu_rom_address  : std_logic_vector(PROGRAM_RANGE);
  signal cpu_data_address : std_logic_vector(ADDRESS_RANGE);
  signal cpu_data_in      : std_logic_vector(DATA_RANGE);
  signal cpu_data_out     : std_logic_vector(DATA_RANGE);
  signal cpu_enable_read  : std_logic;
  signal cpu_enable_write : std_logic;
  signal cpu_enable_byte  : std_logic;
  signal rom_data_out     : std_logic_vector(INSTRUCTION_RANGE);
  signal data_out         : std_logic_vector(31 downto 0);

begin

  ula_out <= cpu_data_address;
  pc_out  <= cpu_rom_address;

  CLICK : if enable_simulation = TRUE generate
    clock <= KEY(0);
  else generate
    KEY_EDGE : entity WORK.EDGE_DETECTOR
      Port map (
        clock  => CLOCK_50,
        source => NOT(KEY(0)),
        pulse  => clock
      );
  end generate;

  CPU : entity WORK.CENTRAL_PROCESSING_UNIT
    port map (
      clock        => clock,
      reset        => '0',
      instruction  => rom_data_out,
      data_in      => cpu_data_in,
      data_out     => cpu_data_out,
      rom_address  => cpu_rom_address,
      data_address => cpu_data_address,
      read_enable  => cpu_enable_read,
      write_enable => cpu_enable_write,
      enable_byte  => cpu_enable_byte
    );

  ROM : entity WORK.READ_ONLY_MEMORY(PROGRAM )
    generic map (
      address_width     => PROGRAM_WIDTH,
      addressable_width => 6,
      data_width        => INSTRUCTION_WIDTH
    )
    port map (
      address  => cpu_rom_address,
      data_out => rom_data_out
    );

  RAM : entity WORK.RANDOM_ACCESS_MEMORY
    generic map (
      data_width        => DATA_WIDTH,
      address_width     => ADDRESS_WIDTH,
      addressable_width => 6
    )
    port map (
      clock        => clock,
      enable       => '1',
      enable_read  => cpu_enable_read,
      enable_write => cpu_enable_write,
      enable_byte  => cpu_enable_byte,
      address      => cpu_data_address,
      data_in      => cpu_data_out,
      data_out     => cpu_data_in
    );

  data_out <= cpu_data_address when (SW(0) = '1') else
              cpu_rom_address;

  DECODE_HEX0 : entity WORK.DECODER_7SEG
    port map (
      value    => data_out(3 downto 0),
      selector => HEX0
    );

  DECODE_HEX1 : entity WORK.DECODER_7SEG
    port map (
      value    => data_out(7 downto 4),
      selector => HEX1
    );

  DECODE_HEX2 : entity WORK.DECODER_7SEG
    port map (
      value    => data_out(11 downto 8),
      selector => HEX2
    );

  DECODE_HEX3 : entity WORK.DECODER_7SEG
    port map (
      value    => data_out(15 downto 12),
      selector => HEX3
    );

  DECODE_HEX4 : entity WORK.DECODER_7SEG
    port map (
      value    => data_out(19 downto 16),
      selector => HEX4
    );

  DECODE_HEX5 : entity WORK.DECODER_7SEG
    port map (
      value    => data_out(23 downto 20),
      selector => HEX5
    );

  LEDR(3 downto 0) <= data_out(27 downto 24);

  LEDR(7 downto 4) <= data_out(31 downto 28);

end architecture;
