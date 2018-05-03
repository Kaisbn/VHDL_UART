LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY DE2_top is
	PORT
	(
		CLOCK_50 	:  IN  STD_LOGIC;
		KEY			 	:  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		SW 				:  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX2 			:  OUT  STD_LOGIC_VECTOR(0 TO 6);
		HEX3 			:  OUT  STD_LOGIC_VECTOR(0 TO 6);
		HEX4 			:  OUT  STD_LOGIC_VECTOR(0 TO 6);
		HEX5 			:  OUT  STD_LOGIC_VECTOR(0 TO 6);
		HEX6 			:  OUT  STD_LOGIC_VECTOR(0 TO 6);
        UART_RXD : IN STD_LOGIC;
        UART_TXD : OUT STD_LOGIC;
        GPIO_0 : INOUT std_logic_vector(9 downto 0);
        LEDR : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END entity;

ARCHITECTURE RTL OF DE2_top IS

    signal 	rst,clk, go  : std_logic;
    signal dout : std_logic_vector(15 downto 0);
    signal tick : std_logic;
    signal trig : std_logic;
    signal statos : unsigned(3 downto 0);
BEGIN

rst <= not KEY(1);
go <= not KEY(0);
clk <= CLOCK_50;

-- recepteur: entity WORK.recepteur port map (
--                  rst => rst,
--                   clk => clk,
--                   rx =>uart_rxd,
--                   rx_error => LEDR(0),
--                   DAV => LEDR(1),
--                   dout => dout
--           );

-- emetteur: entity WORK.emetteur port map (
--                  rst => rst,
--                  clk => clk,
--                  baud_sel => SW(9 downto 8),
--                  din => SW(7 downto 0),
--                  go => go,
--                  tx => UART_TXD,
--                  tx_busy => LEDR(3)
--            );


G2: entity WORK.SEVEN_SEG(COMB) port map (data => dout(3 downto 0), pol => '0', segout => hex2);
G3: entity WORK.SEVEN_SEG(COMB) port map (data => dout(7 downto 4), pol => '0', segout => hex3);
G4: entity WORK.SEVEN_SEG(COMB) port map (data => dout(11 downto 8), pol => '0', segout => hex4);
G5: entity WORK.SEVEN_SEG(COMB) port map (data => dout(15 downto 12), pol => '0', segout => hex5);

G6: entity WORK.SEVEN_SEG(COMB) port map (data => std_logic_vector(statos), pol => '0', segout => hex6);

fdiv: entity WORK.fdiv port map (clk => clk, rst => rst, Tick1us => tick);

telemetre: entity WORK.telemetre port map (
                rst => rst,
                clk => clk,
                go => go,
                tick1us => tick,
                trigger => trig,
                echo => GPIO_0(9),
                state_debug => statos,
                distance => dout
            );
GPIO_0(8) <= trig;
LEDR(0) <= trig;
LEDR(2) <= GPIO_0(9);

END architecture;
