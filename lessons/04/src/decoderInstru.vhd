library ieee;
use ieee.std_logic_1164.all;

entity decoderInstru is
  port ( opcode : in std_logic_vector(3 downto 0);
         saida : out std_logic_vector(5 downto 0)
  );
end entity;

architecture comportamento of decoderInstru is

  constant NOP  : std_logic_vector(3 downto 0) := "0000"; -- Sem Operação	
  constant LDA  : std_logic_vector(3 downto 0) := "0001"; -- Carrega valor da memória para A	
  constant SOMA : std_logic_vector(3 downto 0) := "0010"; -- Soma A e B e armazena em A	
  constant SUB  : std_logic_vector(3 downto 0) := "0011"; -- Subtrai B de A e armazena em A	
  constant LDI  : std_logic_vector(3 downto 0) := "0100"; -- Carrega valor imediato para A	
  constant STA  : std_logic_vector(3 downto 0) := "0101"; -- Salva valor de A para a memória	

  begin
saida <= "000000" when opcode = NOP else
         "011010" when opcode = LDA else
         "010010" when opcode = SOMA else
         "010110" when opcode = SUB else
         "111000" when opcode = LDI else
         "000001" when opcode = STA else
         "000000";  -- NOP para os opcodes Indefinidos
end architecture;
