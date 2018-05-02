-- SevenSeg.vhd
-- ------------------------------
--   squelette de l'encodeur sept segment
-- ------------------------------

--
-- Notes :
--  * We don't ask for an hexadecimal decoder, only 0..9
--  * outputs are active high if Pol='1'
--    else active low (Pol='0')
--  * Order is : Segout(1)=Seg_A, ... Segout(7)=Seg_G
--
--  * Display Layout :
--
--       A=Seg(1)
--      -----
--    F|     |B=Seg(2)
--     |  G  |
--      -----
--     |     |C=Seg(3)
--    E|     |
--      -----
--        D=Seg(4)


library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

-- ------------------------------
    Entity SEVEN_SEG is
-- ------------------------------
  port ( Data   : in  std_logic_vector(3 downto 0); -- Expected within 0 .. 9
         Pol    : in  std_logic;                    -- '0' if active LOW
         Segout : out std_logic_vector(1 to 7) );   -- Segments A, B, C, D, E, F, G
end entity SEVEN_SEG;

-- -----------------------------------------------
    Architecture COMB of SEVEN_SEG is
-- ------------------------------------------------

signal output : std_logic_vector(1 to 7);

begin
process(Data, Pol)
begin
  case(Data) is
    when "0000" => output <= "0000001";
    when "0001" => output <= "1001111";
    when "0010" => output <= "0010010";
    when "0011" => output <= "0000110";
    when "0100" => output <= "1101100";
    when "0101" => output <= "0100100";
    when "0110" => output <= "0100000";
    when "0111" => output <= "0001111";
    when "1000" => output <= "0000000";
    when "1001" => output <= "0000100";
    when "1010" => output <= "1110111";
    when "1011" => output <= "0011111";
    when "1100" => output <= "1001110";
    when "1101" => output <= "0111101";
    when "1110" => output <= "1001111";
    when "1111" => output <= "1000111";
    when others => output <= "1111111";
  end case;

    if Pol = '0' then
        Segout <= output;
    elsif Pol = '1' then
        Segout <= NOT output;
    end if;
end process;
end architecture COMB;

