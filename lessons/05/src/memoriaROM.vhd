library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaROM is
   generic (
          dataWidth: natural := 8;
          addrWidth: natural := 3
    );
   port (
          Endereco : in std_logic_vector (addrWidth-1 DOWNTO 0);
          Dado : out std_logic_vector (dataWidth-1 DOWNTO 0)
    );
end entity;

architecture assincrona of memoriaROM is

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);

  constant NOP  : std_logic_vector(3 downto 0) := "0000"; -- Sem Operação	
  constant LDA  : std_logic_vector(3 downto 0) := "0001"; -- Carrega valor da memória para A	
  constant SOMA : std_logic_vector(3 downto 0) := "0010"; -- Soma A e B e armazena em A	
  constant SUB  : std_logic_vector(3 downto 0) := "0011"; -- Subtrai B de A e armazena em A	
  constant LDI  : std_logic_vector(3 downto 0) := "0100"; -- Carrega valor imediato para A	
  constant STA  : std_logic_vector(3 downto 0) := "0101"; -- Salva valor de A para a memória	
  constant JMP  : std_logic_vector(3 downto 0) := "0110"; -- Desvio de execução
  constant JEQ  : std_logic_vector(3 downto 0) := "0111"; -- Verifica o flag IGUAL e, caso verdadeiro, faz o desvio
  constant CEQ  : std_logic_vector(3 downto 0) := "1000"; -- Compara se o valor do acumulador é igual ao valor contido no endereço de memória. Caso sim ativa o flag IGUAL
  constant JSR  : std_logic_vector(3 downto 0) := "1001"; -- Chamada de Sub Rotina
  constant RET  : std_logic_vector(3 downto 0) := "1010"; -- Retorno de Sub Rotina

  function instrucao (
    opcode   : std_logic_vector;
	 imediato : natural := 0
  ) return std_logic_vector is
  begin
    return opcode & std_logic_vector(to_unsigned(imediato, dataWidth - opcode'length));
  end instrucao;
  
  function initMemory
        return blocoMemoria is variable tmp : blocoMemoria := (others => (others => '0'));
  begin
        -- Inicializa os endereços:
        tmp( 0) := instrucao(JSR, 14);
        tmp( 1) := instrucao(JMP, 5);
        tmp( 2) := instrucao(JEQ, 9);
        tmp( 3) := instrucao(NOP);
        tmp( 4) := instrucao(NOP);
        tmp( 5) := instrucao(LDI, 5);
        tmp( 6) := instrucao(STA, 255+1);
        tmp( 7) := instrucao(CEQ, 255+1);
        tmp( 8) := instrucao(JMP, 2);
        tmp( 9) := instrucao(NOP);
        tmp(10) := instrucao(LDI, 4);
        tmp(11) := instrucao(CEQ, 255+1);
        tmp(12) := instrucao(JEQ, 3);
        tmp(13) := instrucao(JMP, 13);
        tmp(14) := instrucao(NOP);
        tmp(15) := instrucao(RET);
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;
