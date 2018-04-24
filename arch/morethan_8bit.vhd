LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY morethan_8bit IS PORT(
	input_data0			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
	input_data1			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
	output_data0		:	OUT 	STD_LOGIC
); END morethan_8bit;

ARCHITECTURE behv OF morethan_8bit IS

	COMPONENT adder_8bit 
	PORT(
		input_carry		:	IN		STD_LOGIC;
		input_a			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_b			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
		output_sum		:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		output_carry	:	OUT	STD_LOGIC
	); END COMPONENT;
	
	COMPONENT not_8bit
	PORT(
		input_data0		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		output_data0	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
	); END COMPONENT;
	
	SIGNAL signal_result 			: STD_LOGIC;
	SIGNAL SIGNAL_STATIC_ONE		: STD_LOGIC := '1';
	SIGNAL signal_not_input_data1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN

	complement_input_data1 : not_8bit
	PORT MAP(
		input_data0 	=> input_data1,
		output_data0 	=> signal_not_input_data1
	);
	
	perform_substraction : adder_8bit
	PORT MAP(
		input_carry		=> SIGNAL_STATIC_ONE,
		input_a			=> input_data0,
		input_b			=> signal_not_input_data1,
		output_sum		=> open,
		output_carry	=> signal_result
	);
	
	output_data0 <= signal_result;
END behv;