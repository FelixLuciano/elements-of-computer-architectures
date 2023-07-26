library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.TOP_LEVEL_TYPES.ALL;

entity REGISTERS_BANK is

    generic (
        data_width    : natural;
        address_width : natural
    );

    port (
        clock           : in  std_logic;
        enable          : in  std_logic := '0';
        address_destiny : in  std_logic_vector(address_width-1 downto 0);
        address_source  : in  std_logic_vector(address_width-1 downto 0);
        address_target  : in  std_logic_vector(address_width-1 downto 0);
        data_destiny    : in  std_logic_vector(data_width-1 downto 0);
        data_source     : out std_logic_vector(data_width-1 downto 0);
        data_target     : out std_logic_vector(data_width-1 downto 0)
    );

end entity;

architecture CPU of REGISTERS_BANK is

    subtype word_t is std_logic_vector((data_width-1) downto 0);
    type memory_t is array(2**address_width-1 downto 0) of word_t;

    function init_memory return memory_t is
        variable tmp : memory_t := (others => (others => '0'));
    begin
        tmp(R_ZERO) := 32X"00";
        tmp(  R_AT) := 32X"00";
        tmp(  R_V0) := 32X"00";
        tmp(  R_V1) := 32X"00";
        tmp(  R_A0) := 32X"00";
        tmp(  R_A1) := 32X"00";
        tmp(  R_A2) := 32X"00";
        tmp(  R_A3) := 32X"00";
        tmp(  R_T0) := 32X"00";
        tmp(  R_T1) := 32X"0A";
        tmp(  R_T2) := 32X"0B";
        tmp(  R_T3) := 32X"0C";
        tmp(  R_T4) := 32X"0D";
        tmp(  R_T5) := 32X"16";
        tmp(  R_T6) := 32X"FFFFF";
        tmp(  R_T7) := 32X"00";
        tmp(  R_S0) := 32X"00";
        tmp(  R_S1) := 32X"00";
        tmp(  R_S2) := 32X"00";
        tmp(  R_S3) := 32X"00";
        tmp(  R_S4) := 32X"00";
        tmp(  R_S5) := 32X"00";
        tmp(  R_S6) := 32X"00";
        tmp(  R_S7) := 32X"00";
        tmp(  R_T8) := 32X"00";
        tmp(  R_T9) := 32X"00";
        tmp(  R_K0) := 32X"00";
        tmp(  R_K1) := 32X"00";
        tmp(  R_GP) := 32X"00";
        tmp(  R_SP) := 32X"00";
        tmp(  R_FP) := 32X"00";
        tmp(  R_RA) := 32X"00";
        return tmp;
    end function;

    shared variable registers : memory_t := init_memory;

    constant ZERO : std_logic_vector(data_width-1 downto 0) := (others => '0');
    constant ADDRESS_ZERO : std_logic_vector(address_width-1 downto 0) := (others => '0');

begin

    process(clock)
    begin
        if (rising_edge(clock)) then
            if (enable = '1') then
                registers(to_integer(unsigned(address_destiny))) := data_destiny;
            end if;
        end if;
    end process;

    data_source <= ZERO when address_source = ADDRESS_ZERO else
                   registers(to_integer(unsigned(address_source)));

    data_target <= ZERO when address_target = ADDRESS_ZERO else
                   registers(to_integer(unsigned(address_target)));

end architecture;
