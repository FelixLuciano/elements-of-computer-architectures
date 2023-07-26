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
        tmp(0) := instrucao(LDI, 4);
        tmp(1) := instrucao(STA, 256+1);
        tmp(2) := instrucao(LDI, 3);
        tmp(3) := instrucao(STA, 256+2);
        tmp(4) := instrucao(SOMA, 256+2);
        tmp(5) := instrucao(SOMA, 256+2);
        tmp(6) := instrucao(SUB, 256+1);
        tmp(7) := instrucao(NOP);
        return tmp;
    end initMemory;

    signal memROM : blocoMemoria := initMemory;

begin
    Dado <= memROM (to_integer(unsigned(Endereco)));
end architecture;
