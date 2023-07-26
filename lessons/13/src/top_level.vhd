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
    instruction    : out std_logic_vector(INSTRUCTION_RANGE);
    destiny        : out std_logic_vector(DATA_RANGE);
    source         : out std_logic_vector(DATA_RANGE);
    target         : out std_logic_vector(DATA_RANGE)
  );

end entity;

architecture BEHAVIOUR of TOP_LEVEL is

  signal clock                              : std_logic;
  signal pc_step_destiny_pc_register_source : std_logic_vector(PROGRAM_RANGE);
  signal pc_register_destiny                : std_logic_vector(PROGRAM_RANGE) := (others => '0'); -- Begin at zero position
  signal rom_data_out_instruction           : std_logic_vector(INSTRUCTION_RANGE);
  signal opcode                             : std_logic_vector(OPCODE_RANGE);
  signal select_function                    : std_logic_vector(FUNCTION_RANGE);
  signal registers_address_destiny          : std_logic_vector(REGISTER_DESTINY_RANGE);
  signal registers_address_source           : std_logic_vector(REGISTER_SOURCE_RANGE);
  signal registers_address_target           : std_logic_vector(REGISTER_TARGET_RANGE);
  signal registers_enable                   : std_logic;
  signal alu_select_function                : std_logic_vector(1 downto 0);
  signal alu_destiny                        : std_logic_vector(DATA_RANGE);
  signal alu_source                         : std_logic_vector(DATA_RANGE);
  signal alu_target                         : std_logic_vector(DATA_RANGE);

begin

  pc          <= pc_register_destiny;
  instruction <= rom_data_out_instruction;
  destiny     <= alu_destiny;
  source      <= alu_source;
  target      <= alu_target;

  clock                              <= CLOCK_50;
  opcode                             <= rom_data_out_instruction(OPCODE_RANGE);
  registers_address_destiny          <= rom_data_out_instruction(REGISTER_DESTINY_RANGE);
  registers_address_source           <= rom_data_out_instruction(REGISTER_SOURCE_RANGE);
  registers_address_target           <= rom_data_out_instruction(REGISTER_TARGET_RANGE);

  PC_REGISTER : entity WORK.GENERIC_REGISTER
    generic map (
      data_width => PROGRAM_WIDTH
    )
    port map (
      clock   => clock,
      clear   => '0',
      enable  => '1',
      source  => pc_step_destiny_pc_register_source,
      destiny => pc_register_destiny
    );

  PC_STEP : entity WORK.CONSTANT_SUM
    generic map (
      data_width => PROGRAM_WIDTH,
      value      => 4
    )
    port map (
      source  => pc_register_destiny,
      destiny => pc_step_destiny_pc_register_source
    );

  ROM : entity WORK.READ_ONLY_MEMORY
    generic map (
      address_width => PROGRAM_WIDTH,
      addressable_width => 6,
      data_width    => INSTRUCTION_WIDTH
    )
    port map (
      address  => pc_register_destiny,
      data_out => rom_data_out_instruction
    );

  CU : entity WORK.DECODER_INSTRUCTION
    port map (
      opcode            => opcode,
      enable_register   => registers_enable,
      select_function   => alu_select_function
    );

  REGISTERS : entity WORK.REGISTERS_BANK
    generic map (
        data_width    => DATA_WIDTH,
        address_width => REGISTERS_WIDTH
    )
    port map (
        clock           => clock,
        enable          => registers_enable,
        address_destiny => registers_address_destiny,
        address_source  => registers_address_source,
        address_target  => registers_address_target,
        data_destiny    => alu_destiny,
        data_source     => alu_source,
        data_target     => alu_target
    );

  ALU : entity WORK.ARITHMETIC_LOGIC_UNIT
    generic map (
      data_width => DATA_WIDTH
    )
    port map (
      source          => alu_source,
      target          => alu_target,
      select_function => "00",
      destiny         => alu_destiny
    );

end architecture;
