library ieee;
use ieee.std_logic_1164.all;

entity decoderInstru is
  port ( opcode : in std_logic_vector(3 downto 0);
         saida : out std_logic_vector(3 downto 0)
  );
end entity;

architecture comportamento of decoderInstru is

  constant NOP  : std_logic_vector(3 downto 0) := "0000";
  constant LDA  : std_logic_vector(3 downto 0) := "0001";
  constant SOMA : std_logic_vector(3 downto 0) := "0010";
  constant SUB  : std_logic_vector(3 downto 0) := "0011";
  constant CLRA : std_logic_vector(3 downto 0) := "1111";

  begin
saida <= "0000" when opcode = NOP else
         "0100" when opcode = LDA else
         "1101" when opcode = SOMA else
         "1100" when opcode = SUB else
         "1111" when opcode = CLRA else
         "0000";  -- NOP para os opcodes Indefinidos
end architecture;
