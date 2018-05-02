-- FDIV.vhd
-- ---------------------------------------
--   Frequency Divider for DE0
-- ---------------------------------------
--
-- Note : Only Tick1ms is used in this exercise.
--        you can leave the other outputs unconnected.

LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

-- ---------------------------------------
    Entity FDIV is
-- ---------------------------------------
   Generic (  Fclock : positive := 50E6); -- System Clock Freq in Hertz
      Port (     CLK : In  std_logic;
                 RST : In  std_logic;
                 clear : In std_logic := '0';
             Tick1us : Out std_logic;
             Tick9us : OUT std_logic;
             Tick18us : OUT std_logic;
             Tick52us : OUT std_logic;
            Tick104us : Out std_logic);
end FDIV;

-- ---------------------------------------
    Architecture RTL of FDIV is
-- ---------------------------------------

constant Divisor_us : positive := Fclock  / 1E6;
signal Count1     : integer range 0 to Divisor_us;
signal Count2     : integer range 0 to 8;
signal Count3     : integer range 0 to 1;
signal Count4     : integer range 0 to 51;
signal Count5     : integer range 0 to 1;
signal Tick1us_i  : std_logic;
signal Tick9us_i  : std_logic;
signal Tick18us_i  : std_logic;
signal Tick52us_i  : std_logic;
signal Tick104us_i : std_logic;

-- -------------------------------------

begin

Tick1us  <= Tick1us_i;
Tick9us  <= Tick9us_i;
Tick18us <= Tick18us_i;
Tick52us <= Tick52us_i;
Tick104us <= Tick104us_i;

process (RST,CLK)
begin
  if RST='1' or clear='1' then
    Count1     <= 0;
    Count2     <= 0;
    Count3     <= 0;
    Count4     <= 0;
    Count5     <= 0;
    Tick1us_i  <= '0';
    Tick9us_i  <= '0';
    Tick18us_i  <= '0';
    Tick52us_i  <= '0';
    Tick104us_i <= '0';

  elsif rising_edge (CLK) then

    Tick1us_i  <= '0';
    Tick9us_i  <= '0';
    Tick18us_i <= '0';
    Tick52us_i <= '0';
    Tick104us_i <= '0';

    if Count1 < Divisor_us-1 then
      Count1 <= Count1 + 1;
    else
      Count1 <= 0;
      Tick1us_i <= '1';
    end if;

    if Tick1us_i='1' then
      if Count2 < 8 then
        Count2 <= Count2 + 1;
      else
        Count2 <= 0;
        Tick9us_i <= '1';
      end if;
    end if;

    if Tick9us_i='1' then
      if Count3 < 1  then
        Count3 <= Count3 + 1;
      else
        Count3 <= 0;
        Tick18us_i <= '1';
      end if;
    end if;

    if Tick1us_i='1' then
      if Count4 < 51 then
        Count4 <= Count4 + 1;
      else
        Count4 <= 0;
        Tick52us_i <= '1';
      end if;
    end if;

    if Tick52us_i='1' then
      if Count5 < 1 then
        Count5 <= Count5 + 1;
      else
        Count5 <= 0;
        Tick104us_i <= '1';
      end if;
    end if;


  end if;
end process;

end RTL;

