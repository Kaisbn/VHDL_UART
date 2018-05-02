LIBRARY ieee;
USE ieee.std_logic_1164.all; 

ENTITY STATE_MACHINE IS 
	PORT
	(
		clk   :  IN  STD_LOGIC;
		rst   :  IN  STD_LOGIC;
		go    :  IN  STD_LOGIC;
		tick_bit : IN STD_LOGIC;
		tx       : OUT STD_LOGIC;
		tx_busy  : OUT STD_LOGIC;
		din : IN std_logic_vector(7 downto 0)
	);
END entity;

ARCHITECTURE struct OF STATE_MACHINE IS 
type Statetype is (E0, E1, E2, E3);
signal state : Statetype;
signal reg : std_logic_vector(9 downto 0);
BEGIN
  PROCESS(clk, rst)
    variable i : integer;
  BEGIN
    if rst = '1' then
      tx <= '1';
      tx_busy <= '0';
      reg <= (OTHERS => '0');
      i := 0;
      state <= E0;
    elsif rising_edge(clk)then
      case state is
        when E0 =>
          tx <= '1';
          tx_busy <= '0';
          if go = '1' then
            state <= E1;
          end if;
        when E1 =>
          reg <= '1' & din & '0';
          i := 0;
          tx_busy <= '1';
          state <= E2;
        when E2 =>
          if tick_bit = '1' then
              if i <= 9 then
                  tx <= reg(i);
                  i := i + 1;
              else
                  state <= E3;
              end if;
          end if;
        when E3 =>
          i := 0;
          tx_busy <= '0';
          if go = '0' then
            state <= E0;
          end if;
      end case; 
    end if;
  END PROCESS;
END architecture;
