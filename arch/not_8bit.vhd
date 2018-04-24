LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY not_8bit IS PORT(
	input_data0		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
	output_data0	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END not_8bit;

ARCHITECTURE gate_level OF not_8bit IS
BEGIN
	output_data0 <=
		(NOT input_data0(7)) &
		(NOT input_data0(6)) &
		(NOT input_data0(5)) &
		(NOT input_data0(4)) &
		(NOT input_data0(3)) &
		(NOT input_data0(2)) &
		(NOT input_data0(1)) &
		(NOT input_data0(0));
END gate_level;