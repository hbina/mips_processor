LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY extend_shift_left_2_6bit IS PORT(
	input_data0		: IN 	STD_LOGIC_VECTOR(5 DOWNTO 0);
	output_data0	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END extend_shift_left_2_6bit;

ARCHITECTURE gate_level OF extend_shift_left_2_6bit IS
BEGIN
	output_data0 <= input_data0(5 DOWNTO 0) & "00";
END gate_level;