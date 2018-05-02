LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


entity MUX41 IS
	port (
		I		: in std_logic_vector(3 downto 0);
      SEL	: in std_logic_vector(1 downto 0);
      Y  	: out std_logic);
END MUX41 ;


architecture BEHAVIOUR of MUX41 is
begin
	WITH SEL select
		Y <= I(0) WHEN "00",
		I(1) WHEN "01",
		I(2) WHEN "10",
		I(3) WHEN "11",
		'0' WHEN others;

end BEHAVIOUR;
