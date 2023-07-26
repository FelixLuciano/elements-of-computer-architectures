library ieee;
use ieee.std_logic_1164.all;

entity top_level is
  generic ( 
    larguraDados     : natural := 8;
    larguraEnderecos : natural := 9;
    simulacao        : boolean := TRUE  -- para gravar na placa, altere de TRUE para FALSE
  );
  port (
    CLOCK_50 : in  std_logic;
    KEY      : in  std_logic_vector(3 downto 0);
    SW       : in  std_logic_vector(9 downto 0);
    Palavra_Controle : out std_logic_vector(5 downto 0);
    EntradaB_ULA: out std_logic_vector(larguraDados-1 downto 0);
    PC_OUT   : out std_logic_vector(larguraEnderecos-1 downto 0);
    LEDR     : out std_logic_vector(9 downto 0)
  );
end entity;


architecture arquitetura of top_level is
  signal CLK             : std_logic;
  signal proxPC          : std_logic_vector (larguraEnderecos-1 downto 0);
  signal Endereco        : std_logic_vector (larguraEnderecos-1 downto 0);
  signal Instrucao       : std_logic_vector (12 downto 0);
  signal opcode          : std_logic_vector (3 downto 0);
  signal Sinais_Controle : std_logic_vector (5 downto 0);
  signal Valor           : std_logic_vector (larguraDados-1 downto 0);
  signal EnderecoMem     : std_logic_vector (8 downto 0);
  signal SaidaDeDados    : std_logic_vector (larguraDados-1 downto 0);
  signal SelMUX          : std_logic;
  signal MUX_ULA_B       : std_logic_vector (larguraDados-1 downto 0);
  signal ULA_REG1        : std_logic_vector (larguraDados-1 downto 0);
  signal REG1_OUT        : std_logic_vector (larguraDados-1 downto 0);
  signal Habilita_A      : std_logic;
  signal Reset_A         : std_logic;
  signal Operacao_ULA    : std_logic_vector (1 downto 0);
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

PC:
entity work.registradorGenerico generic map (
  larguraDados => larguraEnderecos
) port map (
  DIN    => proxPC,
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
  opcode => opcode,
  saida  => Sinais_Controle
);

MUX1:
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
  seletor  => Operacao_ULA
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


SelMUX        <= Sinais_Controle(5);
Habilita_A    <= Sinais_Controle(4);
Operacao_ULA  <= Sinais_Controle(3 downto 2);
HabLeituraMEM <= Sinais_Controle(1);
HabEscritaMEM <= Sinais_Controle(0);

PC_OUT <= Endereco;
Palavra_Controle <= Sinais_Controle;
EntradaB_ULA <= MUX_ULA_B;
LEDR(9 downto 8) <= Operacao_ULA;
LEDR(7 downto 0) <= REG1_OUT;

end architecture;
