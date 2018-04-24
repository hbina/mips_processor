LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY equal_8bit IS PORT(
	input_data0		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
	input_data1 	: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
	output_equal	: OUT	STD_LOGIC
); END equal_8bit;

ARCHITECTURE gate_level OF equal_8bit IS
BEGIN
	output_equal <= NOT(
		(input_data0(7) XOR input_data1(7)) OR
		(input_data0(6) XOR input_data1(6)) OR
		(input_data0(5) XOR input_data1(5)) OR
		(input_data0(4) XOR input_data1(4)) OR
		(input_data0(3) XOR input_data1(3)) OR
		(input_data0(2) XOR input_data1(2)) OR
		(input_data0(1) XOR input_data1(1)) OR
		(input_data0(0) XOR input_data1(0)));
END gate_level;