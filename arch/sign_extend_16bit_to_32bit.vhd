LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY sign_extend_16bit_to_32bit IS PORT(
	input_data0		: IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
	output_data0	: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END sign_extend_16bit_to_32bit;

ARCHITECTURE behv OF sign_extend_16bit_to_32bit IS
BEGIN
	output_data0(31) <= input_data0(15);
	output_data0(30) <= input_data0(15);
	output_data0(29) <= input_data0(15);
	output_data0(28) <= input_data0(15);
	output_data0(27) <= input_data0(15);
	output_data0(26) <= input_data0(15);
	output_data0(25) <= input_data0(15);
	output_data0(24) <= input_data0(15);
	output_data0(23) <= input_data0(15);
	output_data0(22) <= input_data0(15);
	output_data0(21) <= input_data0(15);
	output_data0(20) <= input_data0(15);
	output_data0(19) <= input_data0(15);
	output_data0(18) <= input_data0(15);
	output_data0(17) <= input_data0(15);
	output_data0(16) <= input_data0(15);
	output_data0(15 DOWNTO 0) <= input_data0;
END behv;