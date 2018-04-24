LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY shift_left_2_8bit IS PORT(
	input_data0	:	IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
	output_data0	:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END shift_left_2_8bit;

ARCHITECTURE gate_level OF shift_left_2_8bit IS
	
BEGIN
	output_data0 <= input_data0((input_data0'length - 3) DOWNTO 0) & "00";
END gate_level;