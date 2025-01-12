library IEEE;
use ieee.std_logic_1164.all;

ENTITY fulladd1 IS
	PORT (Cin,x,y : IN STD_LOGIC;
			s,Cout : OUT STD_LOGIC);
END fulladd1;

ARCHITECTURE LogicFunc OF fulladd1 IS
BEGIN
	s<= x XOR y XOR Cin;
	Cout <= (x AND y) or (Cin AND x) OR (Cin AND y);
END LogicFunc;

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY adder41 IS
 PORT ( Cin : IN STD_LOGIC;
		  x,y : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  s: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		  Cout : OUT STD_LOGIC);
END adder41;

ARCHITECTURE Structure OF adder41 IS
	SIGNAL c1,c2,c3:STD_LOGIC;
	COMPONENT fulladd1
		PORT(Cin,x,y: IN STD_LOGIC;
			s,Cout : OUT STD_LOGIC);
	END COMPONENT;
BEGIN
	stage0:fulladd1 PORT MAP (Cin,x(0),y(0),s(0),c1);
	stage1:fulladd1 PORT MAP (C1,x(1),y(1),s(1),c2);
	stage2:fulladd1 PORT MAP (C2,x(2),y(2),s(2),c3);
	stage3:fulladd1 PORT MAP (c3,x(3),y(3),s(3),Cout);					
END Structure;

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY BCD IS
	PORT ( X : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			 S : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
END BCD;

ARCHITECTURE Behaviour OF BCD IS
BEGIN
		S<= X+"11" WHEN X>4 ELSE X;
END Behaviour;

library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
ENTITY Assignment IS
	PORT( X,Y : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			Sout : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
			BCDO : OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
	);
END Assignment;

ARCHITECTURE Display OF Assignment IS

	COMPONENT adder41
		PORT ( Cin : IN STD_LOGIC;
		  x,y : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		  s: OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		  Cout : OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT BCD
		PORT ( X : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
			 S : OUT STD_LOGIC_VECTOR(3 DOWNTO 0));
	END COMPONENT;
	
	SIGNAL n : STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL c : STD_LOGIC;
	SIGNAL z : STD_LOGIC_VECTOR(4 DOWNTO 0);
	SIGNAL tmp: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL tmp2: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL tmp3: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL FINAL: STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL FIRST,SECOND: STD_LOGIC_VECTOR(3 DOWNTO 0);
	
BEGIN
	stage0: adder41 PORT MAP ('0',X,Y,n,c);
	z<=c&n;
	Sout<=z;
	stage1: BCD PORT MAP('0'&z(4 DOWNTO 2),tmp);
	
	tmp2<=tmp(2 DOWNTO 0) & z(1);
	
	stage2: BCD PORT MAP(tmp2,tmp3);
	
	FINAL<='0'&'0'&tmp(3)&tmp3&z(0); 
	
	FIRST<=FINAL(7 DOWNTO 4);
	SECOND<=FINAL(3 DOWNTO 0);
	process(FIRST,SECOND)
	BEGIN
	if SECOND="0000" then BCDO(6 DOWNTO 0) <= "0000001" ; END IF;
	if SECOND="0001" then BCDO(6 DOWNTO 0) <= "1001111" ; END IF;
	if SECOND="0010" then BCDO(6 DOWNTO 0) <= "0010010" ; END IF;
	if SECOND="0011" then BCDO(6 DOWNTO 0) <= "0000110" ; END IF;
	if SECOND="0100" then BCDO(6 DOWNTO 0) <= "1001100" ; END IF;
	if SECOND="0101" then BCDO(6 DOWNTO 0) <= "0100100" ; END IF;
	if SECOND="0110" then BCDO(6 DOWNTO 0) <= "0100000" ; END IF;
	if SECOND="0111" then BCDO(6 DOWNTO 0) <= "0001111" ; END IF;
	if SECOND="1000" then BCDO(6 DOWNTO 0) <= "0000000" ; END IF;
	if SECOND="1001" then BCDO(6 DOWNTO 0) <= "0000100" ; END IF;
	
	if FIRST="0000" then BCDO(13 DOWNTO 7) <= "0000001" ; END IF;
	if FIRST="0001" then BCDO(13 DOWNTO 7) <= "1001111" ; END IF;
	if FIRST="0010" then BCDO(13 DOWNTO 7) <= "0010010" ; END IF;
	if FIRST="0011" then BCDO(13 DOWNTO 7) <= "0000110" ; END IF;
	
	END PROCESS;

END Display;