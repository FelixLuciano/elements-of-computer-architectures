library ieee;
use ieee.std_logic_1164.all;

entity decoderInstru is
	port (
		opcode   : in std_logic_vector(3 downto 0);
		FlagZero : in std_logic;
		Hab_RET  : out std_logic;
		Sel_JMP  : out std_logic_vector(1 downto 0);
		Sel_MUX  : out std_logic;
		Hab_A    : out std_logic;
		Operacao : out std_logic_vector(1 downto 0);
		habFlag  : out std_logic;
		RD       : out std_logic;
		WR       : out std_logic
	);
end entity;

architecture comportamento of decoderInstru is

	constant NOP  : std_logic_vector(3 downto 0) := "0000"; -- Sem Operação	
	constant LDA  : std_logic_vector(3 downto 0) := "0001"; -- Carrega valor da memória para A	
	constant SOMA : std_logic_vector(3 downto 0) := "0010"; -- Soma A e B e armazena em A	
	constant SUB  : std_logic_vector(3 downto 0) := "0011"; -- Subtrai B de A e armazena em A	
	constant LDI  : std_logic_vector(3 downto 0) := "0100"; -- Carrega valor imediato para A	
	constant STA  : std_logic_vector(3 downto 0) := "0101"; -- Salva valor de A para a memória	
	constant JMP  : std_logic_vector(3 downto 0) := "0110"; -- Desvio de execução
	constant JEQ  : std_logic_vector(3 downto 0) := "0111"; -- Verifica o flag IGUAL e, caso verdadeiro, faz o desvio
	constant CEQ  : std_logic_vector(3 downto 0) := "1000"; -- Compara se o valor do acumulador é igual ao valor contido no endereço de memória. Caso sim ativa o flag IGUAL
	constant JSR  : std_logic_vector(3 downto 0) := "1001"; -- Chamada de Sub Rotina	
	constant RET  : std_logic_vector(3 downto 0) := "1010"; -- Retorno de Sub Rotina	


begin

	Hab_RET  <= '1' when opcode = JSR else
					'0';

	Sel_JMP  <= "01" when opcode = JMP else
					"01" when opcode = JEQ AND FlagZero = '1' else
					"01" when opcode = JSR else
					"10" when opcode = RET else
					"00";

	Sel_MUX  <= '1' when opcode = LDI else
					'0';

	Hab_A    <= '1' when opcode = LDA else
					'1' when opcode = SOMA else
					'1' when opcode = SUB else
					'1' when opcode = LDI else
					'0';

	Operacao <= "10" when opcode = LDA else
					"01" when opcode = SOMA else
					"00" when opcode = SUB else
					"10" when opcode = LDI else
					"00" when opcode = CEQ else
					"00";

	habFlag  <= '1' when opcode = CEQ else
					'0';

	RD       <= '1' when opcode = LDA else
					'1' when opcode = SOMA else
					'1' when opcode = SUB else
					'1' when opcode = CEQ else
					'0';

	WR       <= '1' when opcode = STA else
					'0';

end architecture;
