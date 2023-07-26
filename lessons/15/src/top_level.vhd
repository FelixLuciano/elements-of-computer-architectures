library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.TOP_LEVEL_TYPES.ALL;

entity TOP_LEVEL is

  port (
    CLOCK_50     : in  std_logic;
    -- FPGA_RESET_N : in  std_logic;
    -- KEY          : in  std_logic_vector(3 downto 0);
    -- SW           : in  std_logic_vector(9 downto 0);
    -- LEDR         : out std_logic_vector(9 downto 0);
    -- HEX0         : out std_logic_vector(6 downto 0);
    -- HEX1         : out std_logic_vector(6 downto 0);
    -- HEX2         : out std_logic_vector(6 downto 0);
    -- HEX3         : out std_logic_vector(6 downto 0);
    -- HEX4         : out std_logic_vector(6 downto 0);
    -- HEX5         : out std_logic_vector(6 downto 0)
    pc             : out std_logic_vector(PROGRAM_RANGE);
    instruction    : out std_logic_vector(INSTRUCTION_RANGE)
  );

end entity;

architecture BEHAVIOURAL of TOP_LEVEL is

  signal clock                              : std_logic;

  signal cpu_rom_address : std_logic_vector(PROGRAM_RANGE);
  signal rom_data_out    : std_logic_vector(INSTRUCTION_RANGE);

begin

  clock       <= CLOCK_50;
  pc          <= cpu_rom_address;
  instruction <= rom_data_out;

  CPU : entity WORK.CENTRAL_PROCESSING_UNIT
    port map (
      clock         => clock,
      reset         => '0',
      instruction   => rom_data_out,
      data_in       => (others => '0'),
      -- data_out      => ,
      rom_address   => cpu_rom_address --,
      -- data_address  => ,
      -- read_enable   => ,
      -- write_enable  => 
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

end architecture;
