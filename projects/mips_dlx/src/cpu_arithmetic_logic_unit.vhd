library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ARITHMETIC_LOGIC_UNIT is

  generic (
    data_width : natural
  );

  port (
    invert_source   : in  std_logic;
    invert_target   : in  std_logic;
    select_function : in  std_logic_vector(1 downto 0);
    source          : in  std_logic_vector((data_width - 1) downto 0);
    target          : in  std_logic_vector((data_width - 1) downto 0);
    destiny         : out std_logic_vector((data_width - 1) downto 0);
    flag_z          : out std_logic
  );

end entity;

architecture CPU of ARITHMETIC_LOGIC_UNIT is

  constant ZERO : std_logic_vector((data_width - 1) downto 0) := (others => '0');

  signal result   : std_logic_vector((data_width-1) downto 0);
  signal carry    : std_logic_vector(data_width downto 0);
  signal slt      : std_logic_vector((data_width - 1) downto 0) := (others => '0');
  signal overflow : std_logic_vector((data_width - 1) downto 0);

begin

  carry(0) <= invert_source XOR invert_target;
  slt(0)   <= overflow(data_width-1);

  BIT_TO_BIT : for i in 0 to (data_width - 1) generate
    FOR_BIT : entity WORK.CPU_ALU_BIT
      port map (
        invert_source   => invert_source,
        invert_target   => invert_target,
        select_function => select_function,
        carry_in        => carry(i),
        slt             => slt(i),
        source          => source(i),
        target          => target(i),
        destiny         => result(i),
        carry_out       => carry(i+1),
        overflow        => overflow(i)
      );
  end generate;

  destiny <= result;
  
  flag_z  <= '1' when (result = ZERO) else
             '0';

end architecture;
