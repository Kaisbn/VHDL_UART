entity recepteur_tb is
port( OK: out Boolean := True);
end entity recepteur_tb;

library IEEE;
use IEEE.Std_logic_1164.all;

architecture Bench of recepteur_tb is

  signal clk : std_logic;
  signal rst : std_logic;

  -- Recepteur
  signal rx : std_logic;
  signal rx_error : std_logic;
  signal DAV : std_logic;
  signal dout : std_logic_vector(9 downto 0);
  signal clear : std_logic;

begin

  Clock: process
  begin
    while now <= 3000 us loop
      clk <= '0';
      wait for 5 ns;
      clk <= '1';
      wait for 5 NS;
    end loop;
    wait;
  end process;

  Stim: process
  begin
      rst <= '1';
      wait for 10 ns;
      rst <= '0';
      wait for 10 ns;

      rx <= '0';
      wait for 110 us;
      rx <= '1';
      wait for 110 us;
      rx <= '0';
      wait for 110 us;
      rx <= '1';
      wait for 110 us;
      rx <= '0';
      wait for 110 us;
      rx <= '1';
      wait for 110 us;
      rx <= '0';
      wait for 110 us;
      rx <= '1';
      wait for 110 us;
      rx <= '0';
      wait for 110 us;
      rx <= '1';
      wait for 110 us;
  end process;

  recept : entity work.recepteur port map(rst => rst, clk => clk, rx => rx, rx_error => rx_error, DAV => DAV, dout => dout, clear => clear);

  Check: process
  begin
  wait for 1300 us;
  if dout /= "1010101010" then
      OK <= FALSE;
  end if;
 
  end process;

end architecture Bench;

