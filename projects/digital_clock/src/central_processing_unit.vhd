library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.TOP_LEVEL_TYPES.ALL;

entity CENTRAL_PROCESSING_UNIT is

  port (
    clock        : in  std_logic;
    reset        : in  std_logic;
    intr_0       : in  std_logic;
    intr_1       : in  std_logic;
    intr_2       : in  std_logic;
    intr_3       : in  std_logic;
    intr_4       : in  std_logic;
    intr_5       : in  std_logic;
    intr_6       : in  std_logic;
    instruction  : in  std_logic_vector(INSTRUCTION_RANGE);
    data_in      : in  std_logic_vector(DATA_RANGE);
    data_out     : out std_logic_vector(DATA_RANGE);
    rom_address  : out std_logic_vector(PROGRAM_RANGE);
    data_address : out std_logic_vector(ADDRESS_RANGE);
    read_enable  : out std_logic;
    write_enable : out std_logic
  );

end entity;

architecture BEHAVIOUR of CENTRAL_PROCESSING_UNIT is

  signal instruction_opcode    : std_logic_vector(OPCODE_RANGE);
  signal instruction_register  : std_logic_vector(REGISTERS_RANGE);
  signal instruction_immediate : std_logic_vector(IMMEDIATE_RANGE);
  signal instruction_addrress  : std_logic_vector(ADDRESS_RANGE);
  signal instruction_data      : std_logic_vector(DATA_RANGE);

  signal pc_register_source    : std_logic_vector(PROGRAM_RANGE);
  signal pc_register_destiny   : std_logic_vector(PROGRAM_RANGE);
  signal pc_next_destiny       : std_logic_vector(PROGRAM_RANGE);
  signal ret_push              : std_logic;
  signal ret_pop               : std_logic;
  signal ret_destiny           : std_logic_vector(PROGRAM_RANGE);
  signal intr_address_selector : std_logic_vector(2 downto 0);
  signal intr_address          : std_logic_vector(PROGRAM_RANGE);
  signal pc_mux_selector       : std_logic_vector(1 downto 0);
  signal load_register_enable  : std_logic;
  signal load_register_destiny : std_logic_vector(ADDRESS_RANGE);
  signal select_load_address   : std_logic;
  signal source_mux_selector   : std_logic;
  signal registers_enable      : std_logic;
  signal alu_source            : std_logic_vector(DATA_RANGE);
  signal alu_target            : std_logic_vector(DATA_RANGE);
  signal alu_destiny           : std_logic_vector(DATA_RANGE);
  signal alu_function          : std_logic_vector(1 downto 0);
  signal flag_eq_enable        : std_logic;
  signal flag_eq_source        : std_logic;
  signal flag_eq_destiny       : std_logic;
  signal flag_lt_enable        : std_logic;
  signal flag_lt_source        : std_logic;
  signal flag_lt_destiny       : std_logic;

begin

  instruction_opcode    <= instruction(OPCODE_RANGE);
  instruction_register  <= instruction(REGISTERS_RANGE);
  instruction_immediate <= instruction(IMMEDIATE_RANGE);
  instruction_addrress  <= instruction_immediate(ADDRESS_RANGE);
  instruction_data      <= instruction_immediate(DATA_RANGE);
  rom_address           <= pc_register_destiny;
  data_out              <= alu_target;

  CU : entity WORK.DECODER_INSTRUCTION
    port map (
	    clock               => clock,
      opcode              => instruction_opcode,
      flag_eq             => flag_eq_destiny,
      flag_lt             => flag_lt_destiny,
      intr_0              => intr_0,
      intr_1              => intr_1,
      intr_2              => intr_2,
      intr_3              => intr_3,
      intr_4              => intr_4,
      intr_5              => intr_5,
      intr_6              => intr_6,
      enable_read         => read_enable,
      enable_write        => write_enable,
      enable_ret_push     => ret_push,
      enable_ret_pop      => ret_pop,
      enable_register     => registers_enable,
      enable_eq           => flag_eq_enable,
      enable_lt           => flag_lt_enable,
      enable_load         => load_register_enable,
      select_pc           => pc_mux_selector,
      select_source       => source_mux_selector,
      select_function     => alu_function,
      select_addressing   => select_load_address,
      select_interruption => intr_address_selector
    );

  PC_REGISTER : entity WORK.GENERIC_REGISTER
    generic map (
      data_width => PROGRAM_WIDTH
    )
    port map (
      clock   => clock,
      clear   => reset,
      enable  => '1',
      source  => pc_register_source,
      destiny => pc_register_destiny
    );

  PC_NEXT : entity WORK.CONSTANT_ADDER
    generic map (
      data_width => PROGRAM_WIDTH,
      value      => 1
    )
    port map (
      source  => pc_register_destiny,
      destiny => pc_next_destiny
    );

  RET_STACK : entity WORK.REGISTERS_STACK
    generic map (
        data_width => PROGRAM_WIDTH,
        size       => 8
    )
    port map (
        clock        => clock,
        enable_read  => ret_pop,
        enable_write => ret_push,
        data_in      => pc_next_destiny,
        data_out     => ret_destiny
    );

  INTR_TABLE : entity WORK.READ_ONLY_MEMORY(INTERRUPT_TABLE)
    generic map (
      data_width    => PROGRAM_WIDTH,
      address_width => 3
    )
    port map (
      address  => intr_address_selector,
      data_out => intr_address
    );

  PC_MUX : entity WORK.MULTIPLEXER_4X1
    generic map (
      data_width => PROGRAM_WIDTH
    )
    port map (
      source_0 => pc_next_destiny,
      source_1 => instruction_addrress,
      source_2 => ret_destiny,
      source_3 => intr_address,
      selector => pc_mux_selector,
      destiny  => pc_register_source
    );

  LOAD_REGISTER : entity WORK.GENERIC_REGISTER
    generic map (
      data_width => ADDRESS_WIDTH
    )
    port map (
      clock   => clock,
      clear   => reset,
      enable  => load_register_enable,
      source  => instruction_addrress,
      destiny => load_register_destiny
    );

  ADDRESS_MUX : entity WORK.MULTIPLEXER_2X1
    generic map (
      data_width => ADDRESS_WIDTH
    )
    port map (
      source_0 => instruction_addrress,
      source_1 => load_register_destiny,
      selector => select_load_address,
      destiny  => data_address
    );

  SOURCE_MUX : entity WORK.MULTIPLEXER_2X1
    generic map (
      data_width => DATA_WIDTH
    )
    port map (
      source_0 => data_in,
      source_1 => instruction_data,
      selector => source_mux_selector,
      destiny  => alu_source
    );

  REGISTERS : entity WORK.REGISTERS_BANK
    generic map (
        data_width    => DATA_WIDTH,
        address_width => 2
    )
    port map (
        clock    => clock,
        enable   => registers_enable,
        address  => instruction_register,
        data_in  => alu_destiny,
        data_out => alu_target
    );

  ALU : entity WORK.ARITHMETIC_LOGIC_UNIT
    generic map (
      data_width => DATA_WIDTH
    )
    port map (
      source   => alu_source,
      target   => alu_target,
      funct    => alu_function,
      destiny  => alu_destiny,
      zero     => flag_eq_source,
      negative => flag_lt_source
    );

  FLAG_EQ : entity WORK.FLIP_FLOP
    port map (
      clock   => clock,
      clear   => reset,
      enable  => flag_eq_enable,
      source  => flag_eq_source,
      destiny => flag_eq_destiny
    );

  FLAG_LT : entity WORK.FLIP_FLOP
    port map (
      clock   => clock,
      clear   => reset,
      enable  => flag_lt_enable,
      source  => flag_lt_source,
      destiny => flag_lt_destiny
    );

end architecture;
