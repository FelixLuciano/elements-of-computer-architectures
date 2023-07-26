library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ARITHMETIC_LOGIC_UNIT is

  generic (
    data_width : natural
  );

  port (
    source   : in  std_logic_vector((data_width-1) downto 0);
    target   : in  std_logic_vector((data_width-1) downto 0);
    funct    : in  std_logic_vector(1 downto 0);
    destiny  : out std_logic_vector((data_width-1) downto 0);
    zero     : out std_logic;
    negative : out std_logic
  );

end entity;

architecture BEHAVIOUR of ARITHMETIC_LOGIC_UNIT is

  constant ZERO_TEMPLATE : std_logic_vector((data_width-1) downto 0) := (others => '0');

  signal funct_sum : std_logic_vector((data_width-1) downto 0);
  signal funct_sub : std_logic_vector((data_width-1) downto 0);
  signal funct_and : std_logic_vector((data_width-1) downto 0);
  signal result    : std_logic_vector((data_width-1) downto 0);

begin

  funct_sum <= std_logic_vector(unsigned(target) + unsigned(source));
  funct_sub <= std_logic_vector(unsigned(target) - unsigned(source));
  funct_and <= target and source;
  result    <= funct_sub    when (funct = "00") else
               funct_sum    when (funct = "01") else
               source       when (funct = "10") else
               funct_and;

  destiny  <= result;
  zero     <= '1' when (result = ZERO_TEMPLATE) else '0';
  negative <= result(data_width-1);

end architecture;
