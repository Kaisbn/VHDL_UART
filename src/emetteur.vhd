library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity emetteur is port(
    rst      	: IN  std_logic;
    clk		   : IN  std_logic;
    baud_sel : IN std_logic_vector(1 downto 0);
    din      : IN std_logic_vector(7 downto 0);
    tx      : OUT std_logic;
    tx_busy : OUT std_logic;
    go      : IN std_logic);
END entity ;


ARCHITECTURE struct OF emetteur IS
   signal tick1, tick2, tick3, tick4 : std_logic;
   signal I : std_logic_vector(3 downto 0);
   signal tick_bit : std_logic;
BEGIN
   
  FDIV: entity work.fdiv port map(rst => rst, clk => clk, Tick9us => tick1, Tick18us => tick2, Tick52us => tick3, Tick104us => tick4);
  I <= tick1 & tick2 & tick3 & tick4;
  MUX: entity work.mux41 port map(SEL => baud_sel, I => I, Y => tick_bit);
  State: entity work.emetteur_machine port map(rst => rst, clk => clk, tick_bit => tick_bit, din => din, tx => tx, tx_busy => tx_busy, go => go);
  
END architecture;
