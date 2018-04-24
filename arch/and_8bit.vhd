LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY and_8bit IS PORT(
	input_data0			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
	input_data1			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
	output_data0		:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
); END and_8bit;

ARCHITECTURE behv OF and_8bit IS
BEGIN
	output_data0 <=
		(input_data0(7) AND input_data1(7)) &
		(input_data0(6) AND input_data1(6)) &
		(input_data0(5) AND input_data1(5)) &
		(input_data0(4) AND input_data1(4)) &
		(input_data0(3) AND input_data1(3)) &
		(input_data0(2) AND input_data1(2)) &
		(input_data0(1) AND input_data1(1)) &
		(input_data0(0) AND input_data1(0));
END behv;