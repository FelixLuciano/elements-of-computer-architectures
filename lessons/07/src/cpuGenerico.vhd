library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity cpuGenerico is

  generic (
    Len_ROM         : natural;
    Len_Instruction : natural;
    Len_Data        : natural;
    Len_Address     : natural;
    Len_Opcode      : natural
  );
  port (
    CLK            : in  std_logic;
    RST            : in  std_logic;
    Instruction_IN : in  std_logic_vector(Len_Instruction-1 downto 0);
    Data_IN        : in  std_logic_vector(Len_Data-1 downto 0);
    Rd             : out std_logic;
    Wr             : out std_logic;
    ROM_Address    : out std_logic_vector(Len_ROM-1 downto 0);
    Data_OUT       : out std_logic_vector(Len_Data-1 downto 0);
    Data_Address   : out std_logic_vector(Len_Address-1 downto 0)
  );

end entity;

architecture comportamento of cpuGenerico is

  signal PC_next         : std_logic_vector(Len_ROM-1 downto 0);
  signal PC_address      : std_logic_vector(Len_ROM-1 downto 0);
  signal PC_increment    : std_logic_vector(Len_ROM-1 downto 0);
  signal PC_aux_MUX      : std_logic_vector(Len_ROM-1 downto 0);
  signal PC_Selector     : std_logic_vector(1 downto 0);
  signal JMP_Address     : std_logic_vector(Len_ROM-1 downto 0);
  signal RET_Address     : std_logic_vector(Len_ROM-1 downto 0);
  signal RET_enable      : std_logic;
  signal Opcode          : std_logic_vector(Len_Opcode-1 downto 0);
  signal Immediate       : std_logic_vector(Len_Instruction-Len_Opcode-1 downto 0);
  signal Data_Value      : std_logic_vector(Len_Instruction-Len_Opcode-2 downto 0);
  signal Data_selector   : std_logic;
  signal Data_ULA_IN     : std_logic_vector(Len_Data-1 downto 0);
  signal Data_ULA_REG    : std_logic_vector(Len_Data-1 downto 0);
  signal Data_ULA_OUT    : std_logic_vector(Len_Data-1 downto 0);
  signal ULA_FlagZero    : std_logic;
  signal ULA_OPERATION   : std_logic_vector(1 downto 0);
  signal Habilita_A      : std_logic;
  signal ULA_FlagZeroVec : std_logic_vector(0 downto 0);
  signal ULA_FlagZeroReg : std_logic_vector(0 downto 0);
  signal FLAG_enable     : std_logic;

begin
Opcode       <= Instruction_IN(Len_Instruction-1 downto Len_Instruction-Len_Opcode);
Immediate    <= Instruction_IN(Len_Instruction-Len_Opcode-1 downto 0);
JMP_Address  <= Immediate(Len_ROM-1 downto 0);
Data_Value   <= Immediate(Len_Data-1 downto 0);
Data_Address <= Immediate;

PC_REGISTER:
  entity work.registradorGenerico generic map (
    larguraDados => len_ROM
  ) port map (
    DIN    => PC_next,
    DOUT   => PC_address,
    ENABLE => '1',
    CLK    => CLK,
    RST    => RST
  );
ROM_Address <= PC_address;

PC_SUM:
  entity work.somaConstante generic map (
    larguraDados => len_ROM,
    constante    => 1
  ) port map(
    entrada => PC_address,
    saida   => PC_increment
  );

MUX_PC1:
  entity work.muxGenerico2x1 generic map (
    larguraDados => len_ROM
  ) port map(
    entradaA_MUX => PC_increment,
    entradaB_MUX => JMP_Address,
    seletor_MUX  => PC_Selector(0),
    saida_MUX    => PC_aux_MUX
  );
MUX_PC2:
  entity work.muxGenerico2x1 generic map (
    larguraDados => len_ROM
  ) port map(
    entradaA_MUX => PC_aux_MUX,
    entradaB_MUX => RET_Address,
    seletor_MUX  => PC_Selector(1),
    saida_MUX    => PC_next
  );

RET_REGISTER:
  entity work.registradorGenerico generic map (
    larguraDados => len_ROM
  ) port map (
    DIN    => PC_increment,
    DOUT   => RET_Address,
    ENABLE => RET_enable,
    CLK    => CLK,
    RST    => RST
  );

INSTRUCTION_DECODER:
  entity work.decoderInstru port map (
    Opcode             => Opcode,
    EqualFlag          => ULA_FlagZeroReg(0),
    RET_enable         => RET_enable,
    PC_Selector        => PC_Selector,
    Data_selector      => Data_selector,
    Accumulator_enable => Habilita_A,
    Operation          => ULA_OPERATION,
    EqualFlag_enable   => FLAG_enable,
    Rd                 => Rd,
    Wr                 => Wr
  );

DATA_MUX:
  entity work.muxGenerico2x1 generic map (
    larguraDados => Len_Data
  ) port map(
    entradaA_MUX => Data_IN,
    entradaB_MUX => Data_Value,
    seletor_MUX  => Data_selector,
    saida_MUX    => Data_ULA_IN
  );

ACUUMULATOR_REGISTER:
  entity work.registradorGenerico generic map (
    larguraDados => Len_Data
  ) port map (
    DIN    => Data_ULA_OUT,
    DOUT   => Data_ULA_REG,
    ENABLE => Habilita_A,
    CLK    => CLK,
    RST    => RST
  );
Data_OUT <= Data_ULA_REG;

ULA:
  entity work.ULASomaSub generic map(
    larguraDados => Len_Data
  ) port map (
    entradaA => Data_ULA_REG,
    entradaB => Data_ULA_IN,
    saida    => Data_ULA_OUT,
    Zero     => ULA_FlagZero,
    seletor  => ULA_OPERATION
  );
ULA_FlagZeroVec(0) <= ULA_FlagZero;

FlagZero:
  entity work.registradorGenerico generic map (
    larguraDados => 1
  ) port map (
    DIN    => ULA_FlagZeroVec,
    DOUT   => ULA_FlagZeroReg,
    ENABLE => FLAG_enable,
    CLK    => CLK,
    RST    => RST
  );

end architecture;
