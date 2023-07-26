library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

package TOP_LEVEL_TYPES is

  constant CLOCK_FREQUENCY : integer := 50_000_000; -- 50 MHz clock frequency

  -- WIDTHS
  constant PROGRAM_WIDTH     : natural := 9;
  constant INSTRUCTION_WIDTH : natural := 16;
  constant OPCODE_WIDTH      : natural := 5;
  constant REGISTERS_WIDTH   : natural := 2;
  constant ADDRESS_WIDTH     : natural := 9;
  constant DATA_WIDTH        : natural := 8;

  -- RANGES
  subtype PROGRAM_RANGE     is natural range (PROGRAM_WIDTH-1) downto 0;
  subtype INSTRUCTION_RANGE is natural range (INSTRUCTION_WIDTH-1) downto 0;
  subtype OPCODE_RANGE      is natural range (INSTRUCTION_WIDTH-1) downto (INSTRUCTION_WIDTH-OPCODE_WIDTH);
  subtype REGISTERS_RANGE   is natural range (INSTRUCTION_WIDTH-OPCODE_WIDTH-1) downto (INSTRUCTION_WIDTH-OPCODE_WIDTH-REGISTERS_WIDTH);
  subtype IMMEDIATE_RANGE   is natural range (INSTRUCTION_WIDTH-OPCODE_WIDTH-REGISTERS_WIDTH-1) downto 0;
  subtype ADDRESS_RANGE     is natural range (PROGRAM_WIDTH-1) downto 0;
  subtype DATA_RANGE        is natural range (DATA_WIDTH-1) downto 0;

  -- OPCODES
  constant NOP    : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(00, OPCODE_WIDTH));  -- Sem Operação
  constant LDA    : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(01, OPCODE_WIDTH));  -- Carrega o valor armazenado em um endereço de memória em um registrador
  constant STA    : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(02, OPCODE_WIDTH));  -- Salva o valor do registrador na memória RAM em um endereço específico
  constant ADD    : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(03, OPCODE_WIDTH));  -- Realiza a soma de dois valores armazenados em um registrador e em um endereço de memória e armazena o resultado em um registrador
  constant SUBR   : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(04, OPCODE_WIDTH));  -- Realiza a subtração de dois valores armazenados em um registrador e em um endereço de memória e armazena o resultado em um registrador
  constant ANDR   : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(05, OPCODE_WIDTH));  -- Realiza a operação lógica AND entre dois valores armazenados em um registrador e em um endereço de memória e armazena o resultado em um registrador
  constant CEQ    : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(06, OPCODE_WIDTH));  -- Compara se o valor armazenado em um registrador é igual ao valor armazenado em um endereço de memória e, caso verdadeiro, ativa o flag EQ
  constant CLT    : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(07, OPCODE_WIDTH));  -- Compara se o valor armazenado em um registrador é menor que o valor armazenado em um endereço de memória e, caso verdadeiro, ativa o flag LT
  constant CLE    : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(08, OPCODE_WIDTH));  -- Compara se o valor armazenado em um registrador é menor ou igual ao valor armazenado em um endereço de memória e, caso verdadeiro, ativa o flag LT
  constant LDI    : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(09, OPCODE_WIDTH));  -- Carrega o valor do imediato em um registrador
  constant ADDI   : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(10, OPCODE_WIDTH));  -- Soma um valor armazenado em um registrador ao valor do imediato e armazena o resultado no mesmo registrador
  constant SUBI   : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(11, OPCODE_WIDTH));  -- Subtrai o valor do imediato do valor armazenado em um registrador e armazena o resultado no mesmo registrador
  constant ANDI   : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(12, OPCODE_WIDTH));  -- Realiza a operação lógica AND entre o valor armazenado em um registrador e o valor imediato e armazena o resultado no mesmo registrador
  constant CEQI   : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(13, OPCODE_WIDTH));  -- Compara se o valor armazenado em um registrador é igual ao valor imediato e, caso verdadeiro, ativa o flag EQ
  constant CLTI   : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(14, OPCODE_WIDTH));  -- Compara se o valor armazenado em um registrador é menor que o valor imediato e, caso verdadeiro, ativa o flag LT
  constant CLEI   : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(15, OPCODE_WIDTH));  -- Compara se o valor armazenado em um registrador é menor ou igual ao valor imediato e, caso verdadeiro, ativa o flag LT
  constant JMP    : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(16, OPCODE_WIDTH));  -- Faz um desvio de execução para o endereço no valor imediato
  constant JEQ    : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(17, OPCODE_WIDTH));  -- Verifica o flag EQ e, caso verdadeiro, faz um desvio de execução para o endereço armazenado no valor imediato
  constant JLT    : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(18, OPCODE_WIDTH));  -- Verifica o flag LT e, caso verdadeiro, faz um desvio de execução para o endereço armazenado no valor imediato
  constant JLE    : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(19, OPCODE_WIDTH));  -- Verifica o flag EQ ou LT e, caso verdadeiro, faz um desvio de execução para o endereço armazenado no valor imediato
  constant JNEQ   : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(20, OPCODE_WIDTH));  -- Verifica o flag IGUAL e, caso falso, faz um desvio de execução para o endereço armazenado no valor imediato
  constant JGT    : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(21, OPCODE_WIDTH));  -- Verifica o flag EQ E LT e, caso falso, faz um desvio de execução para o endereço armazenado no valor imediato
  constant JGE    : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(22, OPCODE_WIDTH));  -- Verifica o flag EQ OU LT e, caso falso, faz um desvio de execução para o endereço armazenado no valor imediato
  constant JSR    : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(23, OPCODE_WIDTH));  -- Faz a chamada de uma sub-rotina, armazenando o endereço de retorno na pilha de retorno
  constant RET    : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(24, OPCODE_WIDTH));  -- Retorna da sub-rotina, recuperando o endereço de retorno da pilha de retorno
  constant RETI   : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(25, OPCODE_WIDTH));  -- Retorna da interrupção, recuperando o endereço de retorno da pilha de retorno e reconhecendo estado
  constant LDADDR : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(26, OPCODE_WIDTH));  -- Carrega endereço de memória do imediato para acesso posterior
  constant LDAIND : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(27, OPCODE_WIDTH));  -- Carrega o valor armazenado no endereço de memória carregado em um registrador
  constant STAIND : std_logic_vector(OPCODE_RANGE) := std_logic_vector(to_unsigned(28, OPCODE_WIDTH));  -- Salva o valor do registrador na memória RAM no endereço carregado

  -- CLEAR ADDRESSES
  constant ACK_KEY0 : std_logic_vector(ADDRESS_RANGE) := std_logic_vector(to_unsigned(511, ADDRESS_WIDTH));  -- Acknouledge KEY0 interruption
  constant ACK_KEY1 : std_logic_vector(ADDRESS_RANGE) := std_logic_vector(to_unsigned(510, ADDRESS_WIDTH));  -- Acknouledge KEY0 interruption
  constant ACK_KEY2 : std_logic_vector(ADDRESS_RANGE) := std_logic_vector(to_unsigned(509, ADDRESS_WIDTH));  -- Acknouledge KEY0 interruption
  constant ACK_KEY3 : std_logic_vector(ADDRESS_RANGE) := std_logic_vector(to_unsigned(508, ADDRESS_WIDTH));  -- Acknouledge KEY0 interruption
  constant ACK_KEY4 : std_logic_vector(ADDRESS_RANGE) := std_logic_vector(to_unsigned(507, ADDRESS_WIDTH));  -- Acknouledge KEY0 interruption
  constant ACK_TC0  : std_logic_vector(ADDRESS_RANGE) := std_logic_vector(to_unsigned(506, ADDRESS_WIDTH));  -- Acknouledge TC0 interruption
  constant ACK_TC1  : std_logic_vector(ADDRESS_RANGE) := std_logic_vector(to_unsigned(505, ADDRESS_WIDTH));  -- Acknouledge TC1 interruption

end package;
