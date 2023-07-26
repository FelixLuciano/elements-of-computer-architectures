library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoriaROM is

  generic (
    dataWidth: natural := 8;
    addrWidth: natural := 3
  );

  port (
    Endereco : in  std_logic_vector(addrWidth-1 DOWNTO 0);
    Dado     : out std_logic_vector(dataWidth-1 DOWNTO 0)
  );

end entity;

architecture assincrona of memoriaROM is

  type blocoMemoria is array(0 TO 2**addrWidth - 1) of std_logic_vector(dataWidth-1 DOWNTO 0);
  
  function initMemory return blocoMemoria is
    variable tmp : blocoMemoria := (others => (others => '0'));
  begin
    -- !INICIO!
    tmp(0) := "0100000000001";   -- LDI  Carrega HIGH no acumulador
    tmp(1) := "0101100000010";   -- STA  Liga o LED 1
    tmp(2) := "0101100000001";   -- STA  Liga o LED 2
    tmp(3) := "0100010101010";   -- LDI  Carrega padrão alternado
    tmp(4) := "0101100000000";   -- STA  Atualiza os LEDs
    tmp(5) := "0100000000000";   -- LDI  Carrega 1 no acumulador
    tmp(6) := "1011000000001";   -- SMI  Soma 1 no acumulador
    tmp(7) := "0101100000000";   -- STA  Atualiza os LED para a contagem
    tmp(8) := "0110000000110";   -- JMP  Volta para o Loop
    -- !FIM!
    return tmp;
  end function;

  signal memROM : blocoMemoria := initMemory;

begin

  Dado <= memROM(to_integer(unsigned(Endereco)));

end architecture;
