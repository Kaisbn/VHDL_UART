LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY recepteur_machine IS
	PORT
	(
		clk   :  IN  STD_LOGIC;
		rst   :  IN  STD_LOGIC;
		tick_bit : IN STD_LOGIC;
		rx       : IN STD_LOGIC;
		rx_error  : OUT STD_LOGIC;
		dout : OUT std_logic_vector(7 downto 0);
		DAV: OUT std_logic;
		clear: OUT std_logic
	);
END entity;

ARCHITECTURE struct OF recepteur_machine IS
type Statetype is (E0, E1, E2, E3, E4, E5, E6, E7, E8, ER);
signal state : Statetype;
signal reg : std_logic_vector(7 downto 0);
BEGIN
  PROCESS(clk, rst)
      variable i : integer;
      variable tick104 : boolean := true;
  BEGIN
    if rst = '1' then
      rx_error <= '1';
      DAV <= '0';
      reg <= (OTHERS => '0');
      dout <= (OTHERS => '0');
      clear <= '0';
      i := 0;
      state <= E0;
      tick104 := true;
    elsif rising_edge(clk)then
      case state is
        when E0 =>
          DAV <= '0';
          if rx = '0' then
            state <= E1;
          end if;
        when E1 =>
          clear <= '1';
          rx_error <= '0';
          state <= E2;
        when E2 =>
          clear <= '0';
          if tick_bit = '1' then
            tick104 := not tick104;
            state <= E3;
          end if;
        when E3 =>
          if rx ='0' then
            state <= E4;
          else
            state <= ER;
          end if;
        when E4 =>
          i := 0;
          if tick_bit = '1' then
              state <= E5;
              tick104 := not tick104;
          end if;
        when E5 =>
          if tick_bit = '1' then
              tick104 := not tick104;
              if tick104 = false then
                  if i <= 7 then
                      reg(i) <= rx;
                      i := i + 1;
                  else
                    state <= E6;
                  end if;
              end if;
          end if;
        when E6 =>
          if tick_bit = '1' then
            tick104 := not tick104;
            state <= E7;
          end if;
        when E7 =>
          if rx = '1' then
            state <= E8;
          else
            state <= ER;
          end if;
        when E8 =>
          dout <= reg;
          DAV <= '1';
          if rx = '0' then
            state <= E0;
          end if;
        when ER =>
          rx_error <= '1';
          if rx = '1' then
            state <= E3;
          end if;
      end case;
    end if;
  END PROCESS;
END architecture;
