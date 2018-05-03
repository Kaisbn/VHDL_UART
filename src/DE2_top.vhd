LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY DE2_top is
	PORT
	(
		CLOCK_50 	:  IN  STD_LOGIC;
		KEY			 	:  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		SW 				:  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX0 			:  OUT  STD_LOGIC_VECTOR(0 TO 6);
		HEX1 			:  OUT  STD_LOGIC_VECTOR(0 TO 6);
        UART_RXD : IN STD_LOGIC;
        UART_TXD : OUT STD_LOGIC;
        LEDR : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END entity;

ARCHITECTURE RTL OF DE2_top IS

    signal 	rst,clk, go  : std_logic;
    signal dout : std_logic_vector(7 downto 0);
BEGIN

rst <= not KEY(1);
go <= not KEY(0);
clk <= CLOCK_50;

 recepteur: entity WORK.recepteur port map (
                  rst => rst,
                   clk => clk,
                   rx =>uart_rxd,
                   rx_error => LEDR(0),
                   DAV => LEDR(1),
                   dout => dout
           );

emetteur: entity WORK.emetteur port map (
                  rst => rst,
                  clk => clk,
                  baud_sel => SW(9 downto 8),
                  din => SW(7 downto 0),
                  go => go,
                  tx => UART_TXD,
                  tx_busy => LEDR(3)
            );

G2: entity WORK.SEVEN_SEG(COMB) port map (data => dout(3 downto 0), pol => '0', segout => hex0);
G3: entity WORK.SEVEN_SEG(COMB) port map (data => dout(7 downto 4), pol => '0', segout => hex1);

END architecture;
