library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.TOP_LEVEL_TYPES.ALL;

entity CENTRAL_PROCESSING_UNIT is

  port (
    clock         : in  std_logic;
    reset         : in  std_logic;
    instruction   : in  std_logic_vector(INSTRUCTION_RANGE);
    data_in       : in  std_logic_vector(DATA_RANGE);
    data_out      : out std_logic_vector(DATA_RANGE);
    rom_address   : out std_logic_vector(PROGRAM_RANGE);
    data_address  : out std_logic_vector(ADDRESS_RANGE);
    read_enable   : out std_logic;
    write_enable  : out std_logic
  );

end entity;

architecture BEHAVIOURAL of CENTRAL_PROCESSING_UNIT is

  alias opcode                      : std_logic_vector(OPCODE_RANGE)    is instruction(OPCODE_RANGE);
  alias registers_address_source    : std_logic_vector(REGISTER_RANGE)  is instruction(REGISTER_SOURCE_RANGE);
  alias registers_address_target    : std_logic_vector(REGISTER_RANGE)  is instruction(REGISTER_TARGET_RANGE);
  alias registers_address_destiny   : std_logic_vector(REGISTER_RANGE)  is instruction(REGISTER_DESTINY_RANGE);
  alias function_code               : std_logic_vector(FUNCTION_RANGE)  is instruction(FUNCTION_RANGE);
  alias registers_address_destiny_i : std_logic_vector(REGISTER_RANGE)  is instruction(REGISTER_DESTINY_I_RANGE);
  alias immediate                   : std_logic_vector(IMMEDIATE_RANGE) is instruction(IMMEDIATE_RANGE);
  alias j_address                   : std_logic_vector(J_ADDRESS_RANGE) is instruction(J_ADDRESS_RANGE);

  signal cu_enable_registers : std_logic;
  signal cu_enable_jump      : std_logic;
  signal cu_select_function  : std_logic_vector(1 downto 0);
  signal cu_select_immediate : std_logic;
  signal cu_select_memory    : std_logic;
  -- CU...
  signal cu_enable_read      : std_logic;
  signal cu_enable_write     : std_logic;
  signal mux_address_destiny : std_logic_vector(REGISTER_DESTINY_RANGE);
  signal immediate_extended  : std_logic_vector(DATA_RANGE);
  signal data_target         : std_logic_vector(DATA_RANGE);
  signal data_destiny        : std_logic_vector(DATA_RANGE);
  signal alu_source          : std_logic_vector(DATA_RANGE);
  signal alu_target          : std_logic_vector(DATA_RANGE);
  signal alu_destiny         : std_logic_vector(DATA_RANGE);
  signal alu_flag_z          : std_logic;

begin

  data_out     <= data_target;
  read_enable  <= cu_enable_read;
  write_enable <= cu_enable_write;

  CU : entity WORK.DECODER_INSTRUCTION
    port map (
      operation_code   => opcode,
      function_code    => function_code,
      flag_z           => alu_flag_z,
      enable_register  => cu_enable_registers,
      enable_jump      => cu_enable_jump,
      select_immediate => cu_select_immediate,
      select_memory    => cu_select_memory,
      select_function  => cu_select_function,
      read_enable      => cu_enable_read,
      write_enable     => cu_enable_write
    );

  PC : entity WORK.PROGRAM_COUNTER
    port map (
      clock     => clock,
      j_enable  => cu_enable_jump,
      j_address => j_address,
      data_out  => rom_address
    );

  MUX_DESTINY_REGISTER : entity WORK.MULTIPLEXER_2X1
    generic map (
      data_width => REGISTERS_WIDTH
    )
    port map (
      source_0 => registers_address_destiny,
      source_1 => registers_address_destiny_i,
      selector => cu_select_immediate,
      destiny  => mux_address_destiny
    );

  REGISTERS : entity WORK.REGISTERS_BANK
    generic map (
        data_width    => DATA_WIDTH,
        address_width => REGISTERS_WIDTH
    )
    port map (
        clock           => clock,
        enable          => cu_enable_registers,
        address_destiny => mux_address_destiny,
        address_source  => registers_address_source,
        address_target  => registers_address_target,
        data_destiny    => data_destiny,
        data_source     => alu_source,
        data_target     => data_target
    );
  
  IMMEDIATE_EXT : entity WORK.GENERIC_SIGNAL_EXTENDER
    generic map (
        source_width  => IMMEDIATE_WIDTH,
        destiny_width => DATA_WIDTH
    )
    port map (
        source  => immediate,
        destiny => immediate_extended
    );

  MUX_TARGET : entity WORK.MULTIPLEXER_2X1
    generic map (
      data_width => DATA_WIDTH
    )
    port map (
      source_0 => data_target,
      source_1 => immediate_extended,
      selector => cu_select_immediate,
      destiny  => alu_target
    );

  MUX_DESTINY : entity WORK.MULTIPLEXER_2X1
    generic map (
      data_width => DATA_WIDTH
    )
    port map (
      source_0 => alu_destiny,
      source_1 => data_in,
      selector => cu_select_memory,
      destiny  => data_destiny
    );

  ALU : entity WORK.ARITHMETIC_LOGIC_UNIT
    generic map (
      data_width => DATA_WIDTH
    )
    port map (
      source          => alu_source,
      target          => alu_target,
      select_function => cu_select_function,
      destiny         => alu_destiny,
      flag_z          => alu_flag_z
    );

end architecture;
