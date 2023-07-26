library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MULTIPLEXER_4X1 is

  generic (
    data_width : natural := 8
  );

  port (
    source_0 : in  std_logic_vector(data_width-1 downto 0);
    source_1 : in  std_logic_vector(data_width-1 downto 0);
    source_2 : in  std_logic_vector(data_width-1 downto 0);
    source_3 : in  std_logic_vector(data_width-1 downto 0);
    selector : in  std_logic_vector(1 downto 0);
    destiny  : out std_logic_vector(data_width-1 downto 0)
  );

end entity;

architecture behaviour of MULTIPLEXER_4X1 is

  signal mux1_destiny : std_logic_vector(data_width-1 downto 0);
  signal mux2_destiny : std_logic_vector(data_width-1 downto 0);

begin

  destiny <= mux1_destiny when (selector(1) = '0') else
             mux2_destiny;

  MUX_1 : entity WORK.MULTIPLEXER_2X1
    generic map (
      data_width => data_width
    )
    port map (
      source_0 => source_0,
      source_1 => source_1,
      selector => selector(0),
      destiny  => mux1_destiny
    );

  MUX_2 : entity WORK.MULTIPLEXER_2X1
    generic map (
      data_width => data_width
    )
    port map (
      source_0 => source_2,
      source_1 => source_3,
      selector => selector(0),
      destiny  => mux2_destiny
    );

end architecture;
