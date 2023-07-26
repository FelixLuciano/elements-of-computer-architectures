library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity REGISTERS_STACK is

    generic (
        data_width : natural := 8;
        size       : natural := 8
    );

    port (
        clock        : in  std_logic;
        enable_read  : in  std_logic;
        enable_write : in  std_logic;
        data_in      : in  std_logic_vector((data_width-1) downto 0);
        data_out     : out std_logic_vector((data_width-1) downto 0)
    );

end entity;

architecture LIFO of REGISTERS_STACK is

    subtype word_t is std_logic_vector((data_width-1) downto 0);
    type memory_t is array((size-1) downto 0) of word_t;

    shared variable registers : memory_t;

    signal top     : natural := 0;
    signal pointer : natural := 0;

begin

    STACK : process(clock, enable_read, enable_write, pointer) is
    begin
        if (rising_edge(clock)) then
            PUSH : if (enable_write = '1' and pointer < size) then
                registers(pointer) := data_in;
                pointer <= pointer + 1;
            end if PUSH;

            POP : if (enable_read = '1' and pointer > 0) then
                pointer <= pointer - 1;
            end if POP;
        end if;
    end process;

    top      <= 0 when (pointer = 0) else
                pointer - 1;
    data_out <= registers(top);

end architecture;
