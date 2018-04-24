LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY shift_left_2_32bit IS PORT(
	input_data1		:	IN 	STD_LOGIC_VECTOR(31 DOWNTO 0);
	output_1	:	OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
);
END shift_left_2_32bit;

ARCHITECTURE gate_level OF shift_left_2_32bit IS
	
BEGIN
	output_1 <= input_data1((input_data1'length - 3) DOWNTO 0) & "00";
END gate_level;