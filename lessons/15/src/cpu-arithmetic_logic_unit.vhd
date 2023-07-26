library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ARITHMETIC_LOGIC_UNIT is

  generic (
    data_width : natural
  );

  port (
    source          : in  std_logic_vector(data_width-1 downto 0);
    target          : in  std_logic_vector(data_width-1 downto 0);
    select_function : in  std_logic_vector(1 downto 0);
    destiny         : out std_logic_vector(data_width-1 downto 0);
    flag_z          : out std_logic
  );

end entity;

architecture CPU of ARITHMETIC_LOGIC_UNIT is

  signal sum_result : std_logic_vector(data_width-1 downto 0);
  signal sub_result : std_logic_vector(data_width-1 downto 0);
  signal and_result : std_logic_vector(data_width-1 downto 0);

begin

  sum_result <= std_logic_vector(unsigned(target) + unsigned(source));
  sub_result <= std_logic_vector(unsigned(target) - unsigned(source));
  and_result <= target and source;

  destiny    <= sum_result when (select_function = "00") else
                sub_result when (select_function = "01") else
                and_result when (select_function = "10") else
                source;

end architecture;
