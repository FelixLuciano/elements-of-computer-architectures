library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package TOP_LEVEL_TYPES is

  -- WIDTHS
  constant DATA_WIDTH        : natural := 32;
  constant PROGRAM_WIDTH     : natural := 32;
  constant INSTRUCTION_WIDTH : natural := 32;
  constant OPCODE_WIDTH      : natural := 6;
  constant REGISTERS_WIDTH   : natural := 5;
  constant CHANT_WIDTH       : natural := 5;
  constant FUNCTION_WIDTH    : natural := 6;

  -- RANGES
  subtype DATA_RANGE             is natural range DATA_WIDTH - 1                   downto 0;
  subtype PROGRAM_RANGE          is natural range PROGRAM_WIDTH - 1                downto 0;
  subtype INSTRUCTION_RANGE      is natural range INSTRUCTION_WIDTH - 1            downto 0;
  subtype OPCODE_RANGE           is natural range INSTRUCTION_WIDTH - 1            downto INSTRUCTION_WIDTH - OPCODE_WIDTH;
  subtype REGISTER_SOURCE_RANGE  is natural range OPCODE_RANGE'right - 1           downto OPCODE_RANGE'right - REGISTERS_WIDTH;
  subtype REGISTER_TARGET_RANGE  is natural range REGISTER_SOURCE_RANGE'right - 1  downto REGISTER_SOURCE_RANGE'right - REGISTERS_WIDTH;
  subtype REGISTER_DESTINY_RANGE is natural range REGISTER_TARGET_RANGE'right - 1  downto REGISTER_TARGET_RANGE'right - REGISTERS_WIDTH;
  subtype CHAMT_RANGE            is natural range REGISTER_DESTINY_RANGE'right - 1 downto REGISTER_DESTINY_RANGE'right - CHANT_WIDTH;
  subtype FUNCTION_RANGE         is natural range CHAMT_RANGE'right - 1            downto CHAMT_RANGE'right - FUNCTION_WIDTH;

  -- OPCODES
  constant OPCODE_ZERO  : std_logic_vector(OPCODE_RANGE) := 6X"00";  -- Operate on register function
  constant OPCODE_ADDI  : std_logic_vector(OPCODE_RANGE) := 6X"08";  -- Addition Immediate
  constant OPCODE_ADDIU : std_logic_vector(OPCODE_RANGE) := 6X"09";  -- Addition Immediate Unsigned
  constant OPCODE_ANDI  : std_logic_vector(OPCODE_RANGE) := 6X"0C";  -- Logic AND Immediate
  constant OPCODE_BEQ   : std_logic_vector(OPCODE_RANGE) := 6X"04";  -- Branch On Equal
  constant OPCODE_BNE   : std_logic_vector(OPCODE_RANGE) := 6X"05";  -- Branch on Not Equal
  constant OPCODE_J     : std_logic_vector(OPCODE_RANGE) := 6X"02";  -- Jump
  constant OPCODE_JAL   : std_logic_vector(OPCODE_RANGE) := 6X"03";  -- Jump And Link
  constant OPCODE_LBU   : std_logic_vector(OPCODE_RANGE) := 6X"24";  -- Load Byte Unsigned
  constant OPCODE_LHU   : std_logic_vector(OPCODE_RANGE) := 6X"25";  -- Load Halfword Unsigned
  constant OPCODE_LL    : std_logic_vector(OPCODE_RANGE) := 6X"30";  -- Load Linked
  constant OPCODE_LUI   : std_logic_vector(OPCODE_RANGE) := 6X"0F";  -- load Upper Immediate
  constant OPCODE_LW    : std_logic_vector(OPCODE_RANGE) := 6X"23";  -- Load Word
  constant OPCODE_ORI   : std_logic_vector(OPCODE_RANGE) := 6X"0D";  -- Logic OR Immediate
  constant OPCODE_SLTI  : std_logic_vector(OPCODE_RANGE) := 6X"0A";  -- Set Less Than Immediate
  constant OPCODE_SLTIU : std_logic_vector(OPCODE_RANGE) := 6X"0B";  -- Set Less Than Immediate Unsigned
  constant OPCODE_SB    : std_logic_vector(OPCODE_RANGE) := 6X"28";  -- Store Byte
  constant OPCODE_SC    : std_logic_vector(OPCODE_RANGE) := 6X"38";  -- Store Conditional
  constant OPCODE_SH    : std_logic_vector(OPCODE_RANGE) := 6X"29";  -- Store Halfword
  constant OPCODE_SW    : std_logic_vector(OPCODE_RANGE) := 6X"2B";  -- Store Word

  -- FUNCTIONS
  constant FUNCTION_ADD  : std_logic_vector(FUNCTION_RANGE) := 6X"20";  -- Addition
  constant FUNCTION_ADDU : std_logic_vector(FUNCTION_RANGE) := 6X"21";  -- Addition Unsigned
  constant FUNCTION_AND  : std_logic_vector(FUNCTION_RANGE) := 6X"24";  -- Logical AND
  constant FUNCTION_JMP  : std_logic_vector(FUNCTION_RANGE) := 6X"08";  -- Jump Register
  constant FUNCTION_NOR  : std_logic_vector(FUNCTION_RANGE) := 6X"27";  -- Logical NOR
  constant FUNCTION_OR   : std_logic_vector(FUNCTION_RANGE) := 6X"25";  -- Logical OR
  constant FUNCTION_SLT  : std_logic_vector(FUNCTION_RANGE) := 6X"2A";  -- Set Less Than
  constant FUNCTION_SLTU : std_logic_vector(FUNCTION_RANGE) := 6X"2B";  -- Set Less Than Unsigned
  constant FUNCTION_SLL  : std_logic_vector(FUNCTION_RANGE) := 6X"00";  -- Shift Left Logical
  constant FUNCTION_SRL  : std_logic_vector(FUNCTION_RANGE) := 6X"02";  -- Shift Right Logical
  constant FUNCTION_SUB  : std_logic_vector(FUNCTION_RANGE) := 6X"22";  -- Subtraction
  constant FUNCTION_SUBU : std_logic_vector(FUNCTION_RANGE) := 6X"23";  -- Subtraction Unsigned

  -- REGISTERS
  constant R_ZERO : natural := 16#00#;  -- The Constant Value Zero
  constant R_AT   : natural := 16#01#;  -- Assembler Temporary
  constant R_V0   : natural := 16#02#;  -- Function Results and Expressions Evaluation
  constant R_V1   : natural := 16#03#;  -- Function Results and Expressions Evaluation
  constant R_A0   : natural := 16#04#;  -- Arguments
  constant R_A1   : natural := 16#05#;  -- Arguments
  constant R_A2   : natural := 16#06#;  -- Arguments
  constant R_A3   : natural := 16#07#;  -- Arguments
  constant R_T0   : natural := 16#08#;  -- Temporaries
  constant R_T1   : natural := 16#09#;  -- Temporaries
  constant R_T2   : natural := 16#0A#;  -- Temporaries
  constant R_T3   : natural := 16#0B#;  -- Temporaries
  constant R_T4   : natural := 16#0C#;  -- Temporaries
  constant R_T5   : natural := 16#0D#;  -- Temporaries
  constant R_T6   : natural := 16#0E#;  -- Temporaries
  constant R_T7   : natural := 16#0F#;  -- Temporaries
  constant R_S0   : natural := 16#10#;  -- Saved Temporaries
  constant R_S1   : natural := 16#11#;  -- Saved Temporaries
  constant R_S2   : natural := 16#12#;  -- Saved Temporaries
  constant R_S3   : natural := 16#13#;  -- Saved Temporaries
  constant R_S4   : natural := 16#14#;  -- Saved Temporaries
  constant R_S5   : natural := 16#15#;  -- Saved Temporaries
  constant R_S6   : natural := 16#16#;  -- Saved Temporaries
  constant R_S7   : natural := 16#17#;  -- Saved Temporaries
  constant R_T8   : natural := 16#18#;  -- Temporaries
  constant R_T9   : natural := 16#19#;  -- Temporaries
  constant R_K0   : natural := 16#1A#;  -- Reserved for OS Kernel
  constant R_K1   : natural := 16#1B#;  -- Reserved for OS Kernel
  constant R_GP   : natural := 16#1C#;  -- Global Pointer
  constant R_SP   : natural := 16#1D#;  -- Stack pointer
  constant R_FP   : natural := 16#1E#;  -- Frame Pointer
  constant R_RA   : natural := 16#1F#;  -- Return Address

  -- constant R_ZERO : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($ZERO, REGISTERS_WIDTH));
  -- constant R_AT   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($AT, REGISTERS_WIDTH));
  -- constant R_V0   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($V0, REGISTERS_WIDTH));
  -- constant R_V1   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($V1, REGISTERS_WIDTH));
  -- constant R_A0   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($A0, REGISTERS_WIDTH));
  -- constant R_A1   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($A1, REGISTERS_WIDTH));
  -- constant R_A2   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($A2, REGISTERS_WIDTH));
  -- constant R_A3   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($A3, REGISTERS_WIDTH));
  -- constant R_T0   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($T0, REGISTERS_WIDTH));
  -- constant R_T1   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($T1, REGISTERS_WIDTH));
  -- constant R_T2   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($T2, REGISTERS_WIDTH));
  -- constant R_T3   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($T3, REGISTERS_WIDTH));
  -- constant R_T4   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($T4, REGISTERS_WIDTH));
  -- constant R_T5   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($T5, REGISTERS_WIDTH));
  -- constant R_T6   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($T6, REGISTERS_WIDTH));
  -- constant R_T7   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($T7, REGISTERS_WIDTH));
  -- constant R_S0   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($S0, REGISTERS_WIDTH));
  -- constant R_S1   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($S1, REGISTERS_WIDTH));
  -- constant R_S2   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($S2, REGISTERS_WIDTH));
  -- constant R_S3   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($S3, REGISTERS_WIDTH));
  -- constant R_S4   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($S4, REGISTERS_WIDTH));
  -- constant R_S5   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($S5, REGISTERS_WIDTH));
  -- constant R_S6   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($S6, REGISTERS_WIDTH));
  -- constant R_S7   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($S7, REGISTERS_WIDTH));
  -- constant R_T8   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($T8, REGISTERS_WIDTH));
  -- constant R_T9   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($T9, REGISTERS_WIDTH));
  -- constant R_K0   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($K0, REGISTERS_WIDTH));
  -- constant R_K1   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($K1, REGISTERS_WIDTH));
  -- constant R_GP   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($GP, REGISTERS_WIDTH));
  -- constant R_SP   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($SP, REGISTERS_WIDTH));
  -- constant R_FP   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($FP, REGISTERS_WIDTH));
  -- constant R_RA   : std_logic_vector(REGISTER_DESTINY_RANGE) := std_logic_vector(to_unsigned($RA, REGISTERS_WIDTH));

end package;
