library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.TOP_LEVEL_TYPES.ALL;

entity BRACH_CONTROL_UNIT is

  port (
    enable_beq    : in  std_logic;
    enable_bne    : in  std_logic;
    enable_jr     : in  std_logic;
    flag_z        : in  std_logic;
    select_branch : out std_logic_vector(1 downto 0)
  );

end entity;

architecture BEHAVIORAL of BRACH_CONTROL_UNIT is


begin

  select_branch <= "01" when (
                      (enable_beq = '1' AND flag_z = '1') OR
                      (enable_bne = '1' AND flag_Z = '0')
                    ) else
                    "10" when (
                      enable_jr = '1'
                    ) else
                    "00";

end architecture;
