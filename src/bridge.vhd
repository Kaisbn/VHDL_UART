LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY bridge IS
	PORT
	(
		clk   :  IN  STD_LOGIC;
		rst   :  IN  STD_LOGIC;
		go    :  IN  STD_LOGIC;
        dist : IN std_logic_vector(7 downto 0);
        busy : IN std_logic;
        state_debug : OUT unsigned(3 downto 0);
        data_send : OUT std_logic_vector(7 downto 0);
        send : OUT std_logic
	);
END entity;

ARCHITECTURE struct OF bridge IS
type Statetype is (E0, E1, E2, E3, E4);
signal state : Statetype;
BEGIN
  PROCESS(clk, rst)
  BEGIN
    if rst = '1' then
      data_send <= (OTHERS => '0');
      send <= '0';
      state <= E0;
    elsif rising_edge(clk)then
      case state is
        when E0 =>
            state_debug <= to_unsigned(0, 4);
            send <= '0';
            if go = '1' and busy = '0' then
                state <= E1;
            end if;
        when E1 =>
            state_debug <= to_unsigned(1, 4);
            data_send <= std_logic_vector("0000" & unsigned(dist(7 downto 4)) + 48);
            send <= '1';
            state <= E2;
        when E2 =>
            state_debug <= to_unsigned(2, 4);
            send <= '0';
            if busy = '0' then
                state <= E3;
            end if;
        when E3 =>
            state_debug <= to_unsigned(3, 4);
            data_send <= std_logic_vector("0000" & unsigned(dist(3 downto 0)) + 48);
            send <= '1';
            state <= E4;
        when E4 =>
            state_debug <= to_unsigned(4, 4);
            send <= '0';
            if busy = '0' then
                state <= E0;
            end if;
      end case;
    end if;
  END PROCESS;
END ARCHITECTURE;
