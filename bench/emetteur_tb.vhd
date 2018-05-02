entity emetteur_tb is
port( OK: out Boolean := True);
end entity emetteur_tb;

library IEEE;
use IEEE.Std_logic_1164.all;

architecture Bench of emetteur_tb is

  signal clk : std_logic;
  signal rst : std_logic;
  signal go: Std_logic;
  signal baud_sel : std_logic_vector(1 downto 0);
  signal din: Std_logic_vector(7 downto 0);
  signal tx : std_logic;
  signal tx_busy : std_logic;

begin

  Clock: process
  begin
    while now <= 3000 us loop
      clk <= '0';
      wait for 10 ns;
      clk <= '1';
      wait for 10 ns;
    end loop;
    wait;
  end process;

  Stim: process
  begin
      rst <= '1';
      wait for 10 ns;
      rst <= '0';
      wait for 10 ns;
      baud_sel <= "00";
      wait for 10 ns;
      go <= '1';
      wait for 10 ns;
      din <= "01010101";
      wait for 10 ns;
      go <= '0';
      wait for 1500 us;
  end process;

  test : entity work.emetteur port map(rst => rst, clk => clk, go => go, baud_sel => baud_sel, din => din, tx => tx, tx_busy => tx_busy);

  Check: process
  begin
      wait for 230 us;
      if tx /= '0' then
          OK <= FALSE;
      end if;
      wait for 110 us;
      if tx /= '1' then
          OK <= FALSE;
      end if;
      wait for 110 us;
      if tx /= '0' then
          OK <= FALSE;
      end if;
      wait for 110 us;
      if tx /= '1' then
          OK <= FALSE;
      end if;
      wait for 110 us;
      if tx /= '0' then
          OK <= FALSE;
      end if;
      wait for 110 us;
      if tx /= '1' then
          OK <= FALSE;
      end if;
      wait for 110 us;
      if tx /= '0' then
          OK <= FALSE;
      end if;
      wait for 110 us;
      if tx /= '1' then
          OK <= FALSE;
      end if;
      wait for 110 us;
      if tx /= '0' then
          OK <= FALSE;
      end if;
      wait for 110 us;
      if tx /= '1' then
          OK <= FALSE;
      end if;
  end process;

end architecture Bench;
