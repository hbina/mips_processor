LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
 
ENTITY full_adder_1bit IS PORT (
	input_a			:	IN		STD_LOGIC;
	input_b 			:	IN		STD_LOGIC;
	input_carry		:	IN		STD_LOGIC;
	output_sum		:	OUT	STD_LOGIC;
	output_carry	:	OUT	STD_LOGIC
);
END full_adder_1bit;
 
ARCHITECTURE gate_level OF full_adder_1bit IS
BEGIN
	output_sum 		<= input_a XOR input_b XOR input_carry ;
	output_carry	<=(input_a AND input_b) OR (input_carry AND input_a) OR (input_carry AND input_b);
END gate_level;