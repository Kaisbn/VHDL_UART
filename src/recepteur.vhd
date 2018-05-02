library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity recepteur is port(
    rst      	: IN  std_logic;
    clk		   : IN  std_logic;
    rx      : IN std_logic;
    clear : IN std_logic;
    rx_error   : OUT std_logic;
    DAV : OUT std_logic;
    dout : OUT std_logic_vector(9 downto 0));
END entity ;

ARCHITECTURE struct OF recepteur IS
   signal tick_bit : std_logic;
BEGIN

  FDIV: entity work.fdiv port map(rst => rst, clk => clk, clear => clear, Tick52us => tick_bit);
  State: entity work.recepteur_machine port map(rst => rst, clk => clk, dout => dout, rx_error => rx_error, DAV => DAV, tick_bit => tick_bit, rx => rx);

END architecture;
