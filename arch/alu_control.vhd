LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY alu_control IS PORT(
	input_function_from_instruction	: IN	STD_LOGIC_VECTOR(5 DOWNTO 0);
	input_control_signal					: IN	STD_LOGIC_VECTOR(1 DOWNTO 0);
	output_effective_operation			: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0)
); END alu_control;

ARCHITECTURE logic_level OF alu_control IS
BEGIN

	output_effective_operation(2) <=
		(input_control_signal(0)) OR
		(input_control_signal(1) AND ((NOT input_function_from_instruction(3)) AND (NOT input_function_from_instruction(2)) AND (input_function_from_instruction(1)) AND (NOT input_function_from_instruction(0)))) OR
		(input_control_signal(1) AND ((input_function_from_instruction(3)) AND (NOT input_function_from_instruction(2)) AND (input_function_from_instruction(1)) AND (NOT input_function_from_instruction(0))));
	
	output_effective_operation(1) <=
		((NOT input_control_signal(1)) AND (NOT input_control_signal(0))) OR
		(input_control_signal(0)) OR
		(input_control_signal(1) AND ((NOT input_function_from_instruction(3)) AND (NOT input_function_from_instruction(2)) AND (NOT input_function_from_instruction(1)) AND (NOT input_function_from_instruction(0)))) OR
		(input_control_signal(1) AND (input_function_from_instruction(3)) AND (NOT input_function_from_instruction(2)) AND (input_function_from_instruction(1)) AND (NOT input_function_from_instruction(0))) OR
		(input_control_signal(1) AND ((input_function_from_instruction(3)) AND (NOT input_function_from_instruction(2)) AND (input_function_from_instruction(1)) AND (NOT input_function_from_instruction(0))));
	
	output_effective_operation(0) <=
		(input_control_signal(1) AND ((NOT input_function_from_instruction(3)) AND (input_function_from_instruction(2)) AND (NOT input_function_from_instruction(1)) AND (input_function_from_instruction(0)))) OR
		(input_control_signal(1) AND ((input_function_from_instruction(3)) AND (NOT input_function_from_instruction(2)) AND (input_function_from_instruction(1)) AND (NOT input_function_from_instruction(0))));

END logic_level;