LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY sign_extend_4bit_to_8bit IS PORT(
	input_data0		: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
	output_data0	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END sign_extend_4bit_to_8bit;

ARCHITECTURE behv OF sign_extend_4bit_to_8bit IS
BEGIN
	output_data0(7) <= input_data0(3);
	output_data0(6) <= input_data0(3);
	output_data0(5) <= input_data0(3);
	output_data0(4) <= input_data0(3);
	output_data0(3 DOWNTO 0) <= input_data0(3 DOWNTO 0);
END behv;