library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;    -- Biblioteca IEEE para funções aritméticas

entity ULASomaSub is

  generic (
    larguraDados : natural := 4
  );
  port (
    entradaA : in  STD_LOGIC_VECTOR((larguraDados-1) downto 0);
    entradaB : in  STD_LOGIC_VECTOR((larguraDados-1) downto 0);
    seletor  : in  STD_LOGIC_VECTOR(1 downto 0);
    saida    : out STD_LOGIC_VECTOR((larguraDados-1) downto 0);
    Zero     : out STD_LOGIC
  );

end entity;

architecture comportamento of ULASomaSub is

  signal soma      : STD_LOGIC_VECTOR((larguraDados-1) downto 0);
  signal subtracao : STD_LOGIC_VECTOR((larguraDados-1) downto 0);
  signal auxiliar  : STD_LOGIC_VECTOR((larguraDados-1) downto 0);

begin

  soma      <= STD_LOGIC_VECTOR(unsigned(entradaA) + unsigned(entradaB));
  subtracao <= STD_LOGIC_VECTOR(unsigned(entradaA) - unsigned(entradaB));
  auxiliar  <= subtracao when seletor = "00" else
               soma      when seletor = "01" else
               entradaB  when seletor = "10" else
               soma;
  saida     <= auxiliar;
  Zero      <= not (auxiliar(7) OR auxiliar(6) OR auxiliar(5) OR auxiliar(4) OR auxiliar(3) OR auxiliar(2) OR auxiliar(1) OR auxiliar(0));

end architecture;
