LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY shift_left_2_9bit IS PORT(
	input_data0	:	IN 	STD_LOGIC_VECTOR(8 DOWNTO 0);
	output_data0	:	OUT	STD_LOGIC_VECTOR(8 DOWNTO 0)
); END shift_left_2_9bit;

ARCHITECTURE behavioral OF shift_left_2_9bit IS
	
BEGIN
	output_data0 <= input_data0((input_data0'length - 3) DOWNTO 0) & "00";
END behavioral;