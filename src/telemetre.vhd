LIBRARY ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

ENTITY telemetre IS
	PORT
	(
		clk   :  IN  STD_LOGIC;
		rst   :  IN  STD_LOGIC;
		go    :  IN  STD_LOGIC;
        tick1us : IN std_logic;
		echo : IN std_logic;
        state_debug : OUT unsigned(3 downto 0);
		trigger : OUT std_logic;
        distance : OUT std_logic_vector(15 downto 0)
	);
END entity;

ARCHITECTURE struct OF telemetre IS
type Statetype is (E0, E1, E2, E3, E4);
signal state : Statetype;
BEGIN
  PROCESS(clk, rst)
    variable count : integer range 0 to 499;
    variable time_spent : integer;
    variable temp : integer;
  BEGIN
    if rst = '1' then
      trigger <= '0';
      distance <= (OTHERS => '0');
      count := 0;
      time_spent := 0;
      state <= E0;
    elsif rising_edge(clk)then
      case state is
        when E0 =>
            state_debug <= to_unsigned(0, 4);
            trigger <= '0';
            count := 0;
            time_spent := 0;
            if go = '1' then
                distance <= (OTHERS => '0');
                trigger <= '1';
                state <= E1;
            end if;
        when E1 =>
            state_debug <= to_unsigned(1, 4);
            if count < 499 then
              count := count + 1;
            else
              count := 0;
              trigger <= '0';
              state <= E2;
            end if;
        when E2 =>
            state_debug <= to_unsigned(2, 4);
            if echo = '1' then
                time_spent := time_spent + 1;
                state <= E3;
            end if;
        when E3 =>
            state_debug <= to_unsigned(3, 4);
            if echo = '1' then
                time_spent := time_spent + 1;
            else
                state <= E4;
            end if;
        when E4 =>
            state_debug <= to_unsigned(4, 4);
            temp := (17 * time_spent) / 50000;
            distance(3 downto 0) <= std_logic_vector(To_unsigned(temp MOD 10, 4));
            distance(7 downto 4) <= std_logic_vector(To_unsigned(temp / 10 MOD 10, 4));
            distance(11 downto 8) <= std_logic_vector(To_unsigned(temp / 100 MOD 10, 4));
            distance(15 downto 12) <= std_logic_vector(To_unsigned(temp / 1000 MOD 10, 4));
            if go = '0' then
                state <= E0;
            end if;
      end case;
    end if;
  END PROCESS;
END ARCHITECTURE;
