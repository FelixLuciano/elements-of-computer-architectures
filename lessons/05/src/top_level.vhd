library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top_level is
  generic ( 
    larguraDados     : natural := 8;
    larguraEnderecos : natural := 9;
    simulacao        : boolean := TRUE  -- para gravar na placa, altere de TRUE para FALSE
  );
  port (
    CLOCK_50         : in  std_logic;
    KEY              : in  std_logic_vector(3 downto 0);
    LEDR             : out std_logic_vector(9 downto 0);
    PC_OUT           : out std_logic_vector(larguraEnderecos-1 downto 0);
    Palavra_Controle : out std_logic_vector(8 downto 0);
    EntradaB_ULA     : out std_logic_vector(larguraDados-1 downto 0);
    ZeroFlag         : out std_logic
  );
end entity;


architecture arquitetura of top_level is
  signal CLK             : std_logic;
  signal proxPC          : std_logic_vector(larguraEnderecos-1 downto 0);
  signal Endereco        : std_logic_vector(larguraEnderecos-1 downto 0);
  signal Instrucao       : std_logic_vector(12 downto 0);
  signal opcode          : std_logic_vector(3 downto 0);
  signal Valor           : std_logic_vector(larguraDados-1 downto 0);
  signal Destino         : std_logic_vector(larguraEnderecos-1 downto 0);
  signal SelJMP          : std_logic_vector(1 downto 0);
  signal RET             : std_logic_vector(larguraEnderecos-1 downto 0);
  signal HAB_RET         : std_logic;
  signal MuxDestRET      : std_logic_vector(larguraEnderecos-1 downto 0);
  signal MuxDestPC       : std_logic_vector(larguraEnderecos-1 downto 0);
  signal EnderecoMem     : std_logic_vector(8 downto 0);
  signal SaidaDeDados    : std_logic_vector(larguraDados-1 downto 0);
  signal SelMUX          : std_logic;
  signal MUX_ULA_B       : std_logic_vector(larguraDados-1 downto 0);
  signal ULA_REG1        : std_logic_vector(larguraDados-1 downto 0);
  signal ULA_FlagZero    : std_logic;
  signal ULA_FlagZeroVec : std_logic_vector(0 downto 0);
  signal REG_FlagZero    : std_logic_vector(0 downto 0);
  signal Hab_FlagIgual   : std_logic;
  signal REG1_OUT        : std_logic_vector(larguraDados-1 downto 0);
  signal Habilita_A      : std_logic;
  signal Reset_A         : std_logic;
  signal Operacao_ULA    : std_logic_vector(1 downto 0);
  signal HabEscritaMEM   : std_logic;
  signal HabLeituraMEM   : std_logic;
begin

-- Para simular, fica mais simples tirar o edgeDetector
gravar:
if simulacao generate
	CLK <= KEY(0);
else generate
  detectorSub0: work.edgeDetector(bordaSubida) port map (
	 clk     => CLOCK_50,
	 entrada => (not KEY(0)),
	 saida   => CLK
  );
end generate;


opcode      <= Instrucao(12 downto 9);
Valor       <= Instrucao(7 downto 0);
EnderecoMem <= Instrucao(8 downto 0);
Destino     <= Instrucao(8 downto 0);

MUX11:
entity work.muxGenerico2x1 generic map (
  larguraDados => larguraEnderecos
) port map(
  entradaA_MUX => proxPC,
  entradaB_MUX => Destino,
  seletor_MUX  => SelJMP(0),
  saida_MUX    => MuxDestRET
);
MUX12:
entity work.muxGenerico2x1 generic map (
  larguraDados => larguraEnderecos
) port map(
  entradaA_MUX => MuxDestRET,
  entradaB_MUX => RET,
  seletor_MUX  => SelJMP(1),
  saida_MUX    => MuxDestPC
);

REG_RET:
entity work.registradorGenerico generic map (
  larguraDados => larguraEnderecos
) port map (
  DIN    => proxPC,
  DOUT   => RET,
  ENABLE => HAB_RET,
  CLK    => CLK,
  RST    => '0'
);

PC:
entity work.registradorGenerico generic map (
  larguraDados => larguraEnderecos
) port map (
  DIN    => MuxDestPC,
  DOUT   => Endereco,
  ENABLE => '1',
  CLK    => CLK,
  RST    => '0'
);

incrementaPC:
entity work.somaConstante generic map (
  larguraDados => larguraEnderecos,
  constante    => 1
) port map(
  entrada => Endereco,
  saida   => proxPC
);

ROM1:
entity work.memoriaROM generic map (
  dataWidth => 13,
  addrWidth => larguraEnderecos
) port map (
  Endereco => Endereco,
  Dado     => Instrucao
);


DECODERINSTRU1:
entity work.decoderInstru port map (
  opcode   => opcode,
  FlagZero => REG_FlagZero(0),
  Hab_RET  => HAB_RET,
  Sel_JMP  => SelJMP,
  Sel_MUX  => SelMUX,
  Hab_A    => Habilita_A,
  Operacao => Operacao_ULA,
  habFlag  => Hab_FlagIgual,
  RD       => HabLeituraMEM,
  WR       => HabEscritaMEM
);

MUX2:
entity work.muxGenerico2x1 generic map (
  larguraDados => larguraDados
) port map(
  entradaA_MUX => SaidaDeDados,
  entradaB_MUX => Valor,
  seletor_MUX  => SelMUX,
  saida_MUX    => MUX_ULA_B
);

REGA:
entity work.registradorGenerico generic map (
  larguraDados => larguraDados
) port map (
  DIN    => ULA_REG1,
  DOUT   => REG1_OUT,
  ENABLE => Habilita_A,
  CLK    => CLK,
  RST    => '0'
);

ULA1:
entity work.ULASomaSub generic map(
  larguraDados => larguraDados
) port map (
  entradaA => REG1_OUT,
  entradaB => MUX_ULA_B,
  saida    => ULA_REG1,
  Zero     => ULA_FlagZero,
  seletor  => Operacao_ULA
);
ULA_FlagZeroVec(0) <= ULA_FlagZero;

FlagZero:
entity work.registradorGenerico generic map (
  larguraDados => 1
) port map (
  DIN    => ULA_FlagZeroVec,
  DOUT   => REG_FlagZero,
  ENABLE => Hab_FlagIgual,
  CLK    => CLK,
  RST    => '0'
);

RAM1:
entity work.memoriaRAM generic map (
  dataWidth => larguraDados,
  addrWidth => 8
) port map (
  addr     => EnderecoMem(7 downto 0),
  we       => HabEscritaMEM,
  re       => HabLeituraMEM,
  habilita => EnderecoMem(8),
  dado_in  => REG1_OUT,
  dado_out => SaidaDeDados,
  clk      => CLK
);

PC_OUT <= Endereco;
Palavra_Controle <= SelJMP & SelMUX & Habilita_A & Operacao_ULA & Hab_FlagIgual & HabLeituraMEM & HabEscritaMEM;
EntradaB_ULA <= MUX_ULA_B;
LEDR(9 downto 8) <= Operacao_ULA;
LEDR(7 downto 0) <= ULA_REG1;
ZeroFlag <= ULA_FlagZero;

end architecture;
