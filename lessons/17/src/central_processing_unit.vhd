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

  alias operation_code              : std_logic_vector(OPCODE_RANGE)    is instruction(OPCODE_RANGE);
  alias registers_address_source    : std_logic_vector(REGISTER_RANGE)  is instruction(REGISTER_SOURCE_RANGE);
  alias registers_address_target    : std_logic_vector(REGISTER_RANGE)  is instruction(REGISTER_TARGET_RANGE);
  alias registers_address_destiny   : std_logic_vector(REGISTER_RANGE)  is instruction(REGISTER_DESTINY_RANGE);
  alias function_code               : std_logic_vector(FUNCTION_RANGE)  is instruction(FUNCTION_RANGE);
  alias registers_address_destiny_i : std_logic_vector(REGISTER_RANGE)  is instruction(REGISTER_DESTINY_I_RANGE);
  alias immediate                   : std_logic_vector(IMMEDIATE_RANGE) is instruction(IMMEDIATE_RANGE);
  alias j_address                   : std_logic_vector(J_ADDRESS_RANGE) is instruction(J_ADDRESS_RANGE);

  signal cu_enable_jump      : std_logic;
  signal cu_select_destiny   : std_logic;
  signal cu_enable_registers : std_logic;
  signal cu_select_immediate : std_logic;
  signal cu_enable_function  : std_logic;
  signal cu_select_memory    : std_logic;
  signal cu_enable_beq       : std_logic;
  signal cu_enable_read      : std_logic;
  signal cu_enable_write     : std_logic;
  signal alu_control         : std_logic_vector(3 downto 0);
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
  data_address <= alu_destiny;
  read_enable  <= cu_enable_read;
  write_enable <= cu_enable_write;

  DF_CU : entity WORK.CPU_INSTRUCTION_CONTROL_UNIT
    port map (
      operation_code   => operation_code,
      enable_jump      => cu_enable_jump,
      select_destiny   => cu_select_destiny,
      enable_registers => cu_enable_registers,
      select_immediate => cu_select_immediate,
      enable_function  => cu_enable_function,
      select_memory    => cu_select_memory,
      enable_beq       => cu_enable_beq,
      enable_read      => cu_enable_read,
      enable_write     => cu_enable_write
    );

  ALU_CU : entity WORK.CPU_ALU_CONTROL_UNIT
    port map (
      operation_code  => operation_code,
      function_code   => function_code,
      enable_function => cu_enable_function,
      control         => alu_control
    );

  PC : entity WORK.PROGRAM_COUNTER
    port map (
      clock    => clock,
      enable_j => cu_enable_jump,
      enable_i => cu_enable_beq AND alu_flag_z,
      address  => j_address,
      data_out => rom_address
    );

  MUX_DESTINY_REGISTER : entity WORK.MULTIPLEXER_2X1
    generic map (
      data_width => REGISTERS_WIDTH
    )
    port map (
      source_0 => registers_address_destiny_i,
      source_1 => registers_address_destiny,
      selector => cu_select_destiny,
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
  
  IMMEDIATE_EXT : entity WORK.GENERIC_SIGNAL_EXTENDER(ARITHMETICAL)
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
      invert_source   => alu_control(3),
      invert_target   => alu_control(2),
      select_function => alu_control(1 downto 0),
      source          => alu_source,
      target          => alu_target,
      destiny         => alu_destiny,
      flag_z          => alu_flag_z
    );

end architecture;
