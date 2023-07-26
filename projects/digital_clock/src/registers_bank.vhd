library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity REGISTERS_BANK is

    generic (
        data_width    : natural;
        address_width : natural
    );

    port (
        clock    : in  std_logic;
        enable   : in  std_logic;
        address  : in  std_logic_vector((address_width-1) downto 0);
        data_in  : in  std_logic_vector((data_width-1) downto 0);
        data_out : out std_logic_vector((data_width-1) downto 0)
    );

end entity;

architecture BEHAVIOUR of REGISTERS_BANK is

    subtype word_t is std_logic_vector((data_width-1) downto 0);
    type memory_t is array((2**address_width-1) downto 0) of word_t;

    shared variable registers : memory_t;

begin

    process(clock) is
    begin
        if (rising_edge(clock)) then
            if (enable = '1') then
                registers(to_integer(unsigned(address))) := data_in;
            end if;
        end if;
    end process;

    data_out <= registers(to_integer(unsigned(address)));

end architecture;
