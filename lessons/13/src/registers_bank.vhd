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

architecture BEHAVIOUR of REGISTERS_BANK is

    subtype word_t is std_logic_vector((data_width-1) downto 0);
    type memory_t is array(2**address_width-1 downto 0) of word_t;

    function init_memory return memory_t is
        variable tmp : memory_t := (others => (others => '0'));
    begin
        tmp(R_ZERO) := (others => '1');  -- Nao deve ter efeito.
        tmp(  R_AT) := "00000000000000000000000000000000";  -- 0x01
        tmp(  R_V0) := "00000000000000000000000000000000";  -- 0x02
        tmp(  R_V1) := "00000000000000000000000000000000";  -- 0x03
        tmp(  R_A0) := "00000000000000000000000000000000";  -- 0x04
        tmp(  R_A1) := "00000000000000000000000000000000";  -- 0x05
        tmp(  R_A2) := "00000000000000000000000000000000";  -- 0x06
        tmp(  R_A3) := "00000000000000000000000000000000";  -- 0x07
        tmp(  R_T0) := "00000000000000000000000000000001";  -- 0x08
        tmp(  R_T1) := "00000000000000000000000000000001";  -- 0x09
        tmp(  R_T2) := "00000000000000000000000000000000";  -- 0x0A
        tmp(  R_T3) := "00000000000000000000000000000000";  -- 0x0B
        tmp(  R_T4) := "00000000000000000000000000000000";  -- 0x0C
        tmp(  R_T5) := "00000000000000000000000000000000";  -- 0x0D
        tmp(  R_T6) := "00000000000000000000000000000000";  -- 0x0E
        tmp(  R_T7) := "00000000000000000000000000000000";  -- 0x0F
        tmp(  R_S0) := "00000000000000000000000000000000";  -- 0x00
        tmp(  R_S1) := "00000000000000000000000000000000";  -- 0x00
        tmp(  R_S2) := "00000000000000000000000000000000";  -- 0x00
        tmp(  R_S3) := "00000000000000000000000000000000";  -- 0x00
        tmp(  R_S4) := "00000000000000000000000000000000";  -- 0x00
        tmp(  R_S5) := "00000000000000000000000000000000";  -- 0x00
        tmp(  R_S6) := "00000000000000000000000000000000";  -- 0x00
        tmp(  R_S7) := "00000000000000000000000000000000";  -- 0x00
        tmp(  R_T8) := "00000000000000000000000000000000";  -- 0x00
        tmp(  R_T9) := "00000000000000000000000000000000";  -- 0x00
        tmp(  R_K0) := "00000000000000000000000000000000";  -- 0x00
        tmp(  R_K1) := "00000000000000000000000000000000";  -- 0x00
        tmp(  R_GP) := "00000000000000000000000000000000";  -- 0x00
        tmp(  R_SP) := "00000000000000000000000000000000";  -- 0x00
        tmp(  R_FP) := "00000000000000000000000000000000";  -- 0x00
        tmp(  R_RA) := "00000000000000000000000000000000";  -- 0x00
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
