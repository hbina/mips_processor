LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY adder_add4_8bit IS PORT(
	input_data0		:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
	output_data0	:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
);
END adder_add4_8bit;

ARCHITECTURE gate_level OF adder_add4_8bit IS
BEGIN
	output_data0 <= STD_LOGIC_VECTOR(UNSIGNED(input_data0) + 4);
END gate_level;