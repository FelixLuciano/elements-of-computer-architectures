library ieee;
use ieee.std_logic_1164.all;

entity interfaceLed is
  generic (
    Len_Data        : natural;
    Len_Address     : natural
  );
  port
  (
    CLK         : in  std_logic;
    RST         : in  std_logic;
    Enable      : in  std_logic;
    Wr          : in  std_logic;
    Data_IN     : in  std_logic_vector(Len_Data-1 downto 0);
    DataAddress : in  std_logic_vector(Len_Address-1 downto 0);
    LEDR        : out std_logic_vector(9 downto 0)
  );

end entity;

architecture comportamento of interfaceLed is

signal Selector : std_logic_vector(7 downto 0);

begin

DECODER1:
  entity work.decodificador3x8 port map (
    d => DataAddress(2 downto 0),
    q => Selector
  );

REGISTER_LED_1:
  entity work.registradorGenerico generic map (
    larguraDados => 1
  ) port map (
    DIN    => Data_IN(0 downto 0),
    DOUT   => LEDR(9 downto 9),
    ENABLE => Enable and Wr and Selector(2),
    CLK    => CLK,
    RST    => RST
  );

REGISTER_LED_2:
  entity work.registradorGenerico generic map (
    larguraDados => 1
  ) port map (
    DIN    => Data_IN(0 downto 0),
    DOUT   => LEDR(8 downto 8),
    ENABLE => Enable and Wr and Selector(1),
    CLK    => CLK,
    RST    => RST
  );

REGISTER_LED_DATA:
  entity work.registradorGenerico generic map (
    larguraDados => 8
  ) port map (
    DIN    => Data_IN(7 downto 0),
    DOUT   => LEDR(7 downto 0),
    ENABLE => Enable and Wr and Selector(0),
    CLK    => CLK,
    RST    => RST
  );

end architecture;
