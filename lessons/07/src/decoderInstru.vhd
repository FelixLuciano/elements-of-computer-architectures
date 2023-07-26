library ieee;
use ieee.std_logic_1164.all;

entity decoderInstru is

  port (
    Opcode             : in  std_logic_vector(3 downto 0);
    EqualFlag          : in  std_logic;
    RET_enable         : out std_logic;
    PC_Selector        : out std_logic_vector(1 downto 0);
    Data_selector      : out std_logic;
    Accumulator_enable : out std_logic;
    Operation          : out std_logic_vector(1 downto 0);
    EqualFlag_enable   : out std_logic;
    Rd                 : out std_logic;
    Wr                 : out std_logic
  );

end entity;

architecture comportamento of decoderInstru is

  constant NOP : std_logic_vector(3 downto 0) := "0000";  -- Sem Operação
  constant LDA : std_logic_vector(3 downto 0) := "0001";  -- Carrega valor da memória para A
  constant SUM : std_logic_vector(3 downto 0) := "0010";  -- Soma A e B e armazena em A
  constant SUB : std_logic_vector(3 downto 0) := "0011";  -- Subtrai B de A e armazena em A
  constant LDI : std_logic_vector(3 downto 0) := "0100";  -- Carrega valor imediato para A
  constant STA : std_logic_vector(3 downto 0) := "0101";  -- Salva valor de A para a memória
  constant JMP : std_logic_vector(3 downto 0) := "0110";  -- Desvio de execução
  constant JEQ : std_logic_vector(3 downto 0) := "0111";  -- Verifica o flag IGUAL e, caso verdadeiro, faz o desvio
  constant CEQ : std_logic_vector(3 downto 0) := "1000";  -- Compara se o valor do acumulador é igual ao valor contido no endereço de memória. Caso sim ativa o flag IGUAL
  constant JSR : std_logic_vector(3 downto 0) := "1001";  -- Chamada de Sub Rotina
  constant RET : std_logic_vector(3 downto 0) := "1010";  -- Retorno de Sub Rotina
  constant SMI : std_logic_vector(3 downto 0) := "1011";  -- Soma A e B e armazena em A selecionando o imediato
  constant SBI : std_logic_vector(3 downto 0) := "1100";  -- Subtrai B de A e armazena em A selecionando o imediato

begin

  RET_enable <=         '1' when Opcode = JSR else
                        '0';

  PC_Selector <=        "01" when Opcode = JMP else
                        "01" when Opcode = JEQ AND EqualFlag = '1' else
                        "01" when Opcode = JSR else
                        "10" when Opcode = RET else
                        "00";

  Data_selector <=      '1' when Opcode = LDI else
                        '1' when Opcode = SMI else
                        '1' when Opcode = SBI else
                        '0';

  Accumulator_enable <= '1' when Opcode = LDA else
                        '1' when Opcode = SUM else
                        '1' when Opcode = SMI else
                        '1' when Opcode = SUB else
                        '1' when Opcode = SBI else
                        '1' when Opcode = LDI else
                        '0';

  Operation <=          "10" when Opcode = LDA else
                        "01" when Opcode = SUM else
                        "01" when Opcode = SMI else
                        "00" when Opcode = SUB else
                        "10" when Opcode = LDI else
                        "00" when Opcode = CEQ else
                        "00";

  EqualFlag_enable <=   '1' when Opcode = CEQ else
                        '0';

  Rd <=                 '1' when Opcode = LDA else
                        '1' when Opcode = SUM else
                        '1' when Opcode = SUB else
                        '1' when Opcode = CEQ else
                        '0';

  Wr <=                 '1' when Opcode = STA else
                        '0';

end architecture;
