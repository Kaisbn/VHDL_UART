entity recepteur_tb is
port( OK: out Boolean := True);
end entity recepteur_tb;

library IEEE;
use IEEE.Std_logic_1164.all;

architecture Bench of recepteur_tb is

  -- Emetteur
  signal rst      	: std_logic;
  signal clk      : std_logic;
  signal baud_sel : std_logic_vector(1 downto 0);
  signal din      : std_logic_vector(7 downto 0);
  signal tx_busy : std_logic;
  signal go      : std_logic;

  signal x      : std_logic;

  -- Recepteur
  signal rx_error : std_logic;
  signal DAV : std_logic;
  signal dout : std_logic_vector(7 downto 0);

begin

  Clock: process
  begin
    while now <= 3000 us loop
      clk <= '0';
      wait for 10 ns;
      clk <= '1';
      wait for 10 NS;
    end loop;
    wait;
  end process;

  Stim: process
  begin
    rst <= '0';
    baud_sel <= "00";
    go <= '1';
    tx_busy <= '0';
    din <= "11100110";
    wait;
  end process;

  recept : entity work.recepteur port map(rst => rst, clk => clk, rx => x, rx_error => rx_error, DAV => DAV, dout => dout);
  emetteur : entity work.emetteur port map(rst => rst, clk => clk, tx => x, baud_sel => baud_sel, din => din, go => go, tx_busy => tx_busy);

  Check: process
  begin
  wait for 1200 us;
  if dout /= "11100110" then
      OK <= FALSE;
  end if;
 
  end process;

end architecture Bench;

