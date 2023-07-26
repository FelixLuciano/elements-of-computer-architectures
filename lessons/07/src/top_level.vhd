library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is

  generic (
    simulation      : boolean := TRUE;  -- para gravar na placa, altere de TRUE para FALSE
    Len_ROM         : natural := 9;
    Len_Instruction : natural := 13;
    Len_Data        : natural := 8;
    Len_Address     : natural := 9;
    Len_Opcode      : natural := 4
  );
  port (
    CLOCK_50   : in  std_logic;
    KEY        : in  std_logic_vector(3 downto 0);
    LEDR       : out std_logic_vector(9 downto 0)
  );

end entity;

architecture arquitetura of top_level is

signal CLK         : std_logic;
signal Instruction : std_logic_vector(Len_Instruction-1 downto 0);
signal CpuData     : std_logic_vector(Len_Data-1 downto 0);
signal MemoryData  : std_logic_vector(Len_Data-1 downto 0);
signal ReadState   : std_logic;
signal WriteState  : std_logic;
signal RomAddress  : std_logic_vector(Len_ROM-1 downto 0);
signal DataAddress : std_logic_vector(Len_Address-1 downto 0);
signal Selector    : std_logic_vector(7 downto 0);

begin

-- Para simular, fica mais simples tirar o edgeDetector
is_record:
  if simulation generate
    CLK <= KEY(0);
  else generate
    detectorSub0:
      work.edgeDetector(bordaSubida) port map (
        clk     => CLOCK_50,
        entrada => not KEY(0),
        saida   => CLK
      );
  end generate;


CPU1:
  entity work.cpuGenerico generic map (
    Len_ROM         => Len_ROM,
    Len_Instruction => Len_Instruction,
    Len_Data        => Len_Data,
    Len_Address     => Len_Address,
    Len_Opcode      => Len_Opcode
  ) port map (
    CLK            => CLK,
    RST            => '0',
    Instruction_IN => Instruction,
    Data_IN        => MemoryData,
    Rd             => ReadState,
    Wr             => WriteState,
    ROM_Address    => RomAddress,
    Data_OUT       => CpuData,
    Data_Address   => DataAddress
  );

DECODER1:
  entity work.decodificador3x8 port map (
    d => DataAddress(8 downto 6),
    q => Selector
  );

ROM1:
  entity work.memoriaROM generic map (
    dataWidth => Len_Instruction,
    addrWidth => Len_ROM
  ) port map (
    Endereco => RomAddress,
    Dado     => Instruction
  );

RAM1:
  entity work.memoriaRAM generic map (
    dataWidth => Len_Data,
    addrWidth => 6
  ) port map (
    addr     => DataAddress(5 downto 0),
    we       => WriteState,
    re       => ReadState,
    habilita => Selector(0),
    dado_in  => CpuData,
    dado_out => MemoryData,
    clk      => CLK
  );

INTERFACELED1:
  entity work.interfaceLed generic map (
    Len_Data    => Len_Data,
    Len_Address => Len_Address
  ) port map (
    CLK         => CLK,
    RST         => '0',
    Enable      => Selector(4),
    Wr          => WriteState,
    Data_IN     => CpuData,
    DataAddress => DataAddress,
    LEDR        => LEDR
  );

end architecture;
