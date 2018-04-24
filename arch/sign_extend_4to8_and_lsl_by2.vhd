LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY sign_extend_4to8_and_lsl_by2 IS PORT(
	input_data0		: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
	output_data0	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
); END sign_extend_4to8_and_lsl_by2;

ARCHITECTURE gate_level OF sign_extend_4to8_and_lsl_by2 IS
	
	COMPONENT shift_left_2_8bit
	PORT(
		input_data0		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		output_data0	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);  END COMPONENT;

	COMPONENT sign_extend_4bit_to_8bit
	PORT(
		input_data0		: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		output_data0	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	); END COMPONENT;
	
	SIGNAL
		signal_value_sign_extended_input_data0
	: STD_LOGIC_VECTOR(7 DOWNTO 0);
	
BEGIN
	
	b2v_perform_sign_extend_from_4bit_to_8bit : sign_extend_4bit_to_8bit
	PORT MAP(
		input_data0		=> input_data0,
		output_data0	=> signal_value_sign_extended_input_data0);
	
	b2v_perform_logical_shift_left_by_2_8bit : shift_left_2_8bit
	PORT MAP(
		input_data0		=> signal_value_sign_extended_input_data0,
		output_data0	=> output_data0);
	
END gate_level;