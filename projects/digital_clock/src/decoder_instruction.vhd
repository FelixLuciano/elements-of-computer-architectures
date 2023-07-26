library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.TOP_LEVEL_TYPES.ALL;

entity DECODER_INSTRUCTION is

  port (
    clock               : in  std_logic;
    opcode              : in  std_logic_vector(OPCODE_RANGE);
    flag_eq             : in  std_logic;
    flag_lt             : in  std_logic;
    intr_0              : in  std_logic;
    intr_1              : in  std_logic;
    intr_2              : in  std_logic;
    intr_3              : in  std_logic;
    intr_4              : in  std_logic;
    intr_5              : in  std_logic;
    intr_6              : in  std_logic;
    enable_read         : out std_logic;
    enable_write        : out std_logic;
    enable_ret_push     : out std_logic;
    enable_ret_pop      : out std_logic;
    enable_register     : out std_logic;
    enable_eq           : out std_logic;
    enable_lt           : out std_logic;
    enable_load         : out std_logic;
    select_pc           : out std_logic_vector(1 downto 0);
    select_source       : out std_logic;
    select_function     : out std_logic_vector(1 downto 0);
    select_addressing   : out std_logic;
    select_interruption : out std_logic_vector(2 downto 0)
  );

end entity;

architecture BEHAVIOUR of DECODER_INSTRUCTION is

  signal is_jump    : std_logic;
  signal is_intr    : std_logic;
  signal do_intr    : std_logic;
  signal intr_iddle : std_logic := '1';

begin

  is_jump <= '1' when (
                (opcode = JMP) OR
                (opcode = JEQ AND Flag_EQ = '1') OR
                (opcode = JLT AND Flag_LT = '1') OR
                (opcode = JLE AND (Flag_LT = '1' OR Flag_EQ = '1')) OR
                (opcode = JNEQ AND Flag_EQ = '0') OR
                (opcode = JGT AND Flag_LT = '0' AND Flag_EQ = '0') OR
                (opcode = JGE AND (Flag_LT = '0' OR Flag_EQ = '1')) OR
                (opcode = JSR) OR
					 (opcode = RET) OR
                (opcode = RETI)
             ) else '0';

  is_intr <= intr_0 OR intr_1 OR intr_2 OR intr_3 OR intr_4 OR intr_5 OR intr_6;

  do_intr <= NOT(is_jump) AND is_intr AND intr_iddle;

  process(clock, do_intr)
  begin
    if rising_edge(clock) then
      if (do_intr) then
        intr_iddle <= '0';
      elsif (intr_iddle = '0' AND opcode = RETI) then
        intr_iddle <= '1';
      end if;
    end if;
  end process;

  enable_read         <= '1' when (
                           (opcode = LDA) OR
                           (opcode = ADD) OR
                           (opcode = SUBR) OR
                           (opcode = CEQ) OR
                           (opcode = CLT) OR
                           (opcode = CLE) OR
                           (opcode = ANDR) OR
                           (opcode = LDAIND)
                         ) else
                         '0';

  enable_write        <= '1' when (
                           (opcode = STA) OR
                           (opcode = STAIND) OR
                           (opcode = RETI)
                         ) else
                         '0';

  enable_ret_push     <= '1' when (
                           (opcode = JSR) OR
                           (do_intr = '1')
                         ) else
                         '0';

  enable_ret_pop      <= '1' when (
                           (opcode = RET) OR
                           (intr_iddle = '0' AND opcode = RETI)
                         ) else
                         '0';

  enable_register     <= '1' when (
                           (opcode = LDA) OR
                           (opcode = ADD) OR
                           (opcode = ADDI) OR
                           (opcode = SUBR) OR
                           (opcode = SUBI) OR
                           (opcode = LDI) OR
                           (opcode = ANDR) OR
                           (opcode = ANDI) OR
                           (opcode = LDAIND)
                         ) else
                         '0';

  enable_eq           <= '1' when (
                           (opcode = CEQ) OR
                           (opcode = CEQI) OR
                           (opcode = CLE) OR
                           (opcode = CLEI)
                         ) else
                         '0';

  enable_lt           <= '1' when (
                           (opcode = CLT) OR
                           (opcode = CLTI) OR
                           (opcode = CLE) OR
                           (opcode = CLEI)
                         ) else
                         '0';

  enable_load         <= '1' when (
                           (opcode = LDADDR)
                         ) else '0';

  select_pc           <= "10" when (is_jump = '1' AND opcode = RET) else
                         "10" when (is_jump = '1' AND opcode = RETI) else
                         "01" when (is_jump = '1') else
                         "11" when (do_intr = '1') else
                         "00";

  select_source       <= '1' when (
                           (opcode = LDI) OR
                           (opcode = ADDI) OR
                           (opcode = SUBI) OR
                           (opcode = ANDI) OR
                           (opcode = CEQI) OR
                           (opcode = CLTI) OR
                           (opcode = CLEI)
                         ) else '0';

  select_function     <= "11" when (
                            (opcode = ANDR) OR
                            (opcode = ANDI)
                         ) else
                         "10" when (
                            (opcode = LDA) OR
                            (opcode = LDI) OR
                            (opcode = LDAIND)
                         ) else
                         "01" when (
                            (opcode = ADD) OR
                            (opcode = ADDI)
                         ) else
                         "00" when (
                            (opcode = SUBR) OR
                            (opcode = SUBI) OR
                            (opcode = CEQ) OR
                            (opcode = CEQI) OR
                            (opcode = CLT) OR
                            (opcode = CLTI) OR
                            (opcode = CLE) OR
                            (opcode = CLEI)
                          ) else
                         "00";

  select_addressing   <= '1' when (
                           (opcode = STAIND) OR
                           (opcode = LDAIND)
                         ) else
                         '0';

  select_interruption <= "000" when (intr_0 = '1') else
                         "001" when (intr_1 = '1') else
                         "010" when (intr_2 = '1') else
                         "011" when (intr_3 = '1') else
                         "100" when (intr_4 = '1') else
                         "101" when (intr_5 = '1') else
                         "110" when (intr_6 = '1') else
                         "111";

end architecture;
