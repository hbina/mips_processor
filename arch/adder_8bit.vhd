LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY adder_8bit IS PORT(
	input_carry		:	IN		STD_LOGIC;
	input_a			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
	input_b			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
	output_sum		:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
	output_carry	:	OUT	STD_LOGIC
);
END adder_8bit;

ARCHITECTURE gate_level OF adder_8bit IS

	SIGNAL
		signal_carry_0, signal_carry_1, signal_carry_2, signal_carry_3,
		signal_carry_4, signal_carry_5, signal_carry_6, signal_carry_7
	:	STD_LOGIC;
	
	COMPONENT full_adder_1bit
	PORT(
		input_a			:	IN		STD_LOGIC;
		input_b 			:	IN		STD_LOGIC;
		input_carry		:	IN		STD_LOGIC;
		output_sum		:	OUT	STD_LOGIC;
		output_carry	:	OUT	STD_LOGIC
	);
	END COMPONENT;

BEGIN
	sum0 : full_adder_1bit PORT MAP(
		input_a(0),
		input_b(0),
		input_carry,
		output_sum(0),
		signal_carry_0
	);
	
	sum1 : full_adder_1bit PORT MAP(
		input_a(1),
		input_b(1),
		signal_carry_0,
		output_sum(1),
		signal_carry_1
	);
	
	sum2 : full_adder_1bit PORT MAP(
		input_a(2),
		input_b(2),
		signal_carry_1,
		output_sum(2),
		signal_carry_2
	);
	
	sum3 : full_adder_1bit PORT MAP(
		input_a(3),
		input_b(3),
		signal_carry_2,
		output_sum(3),
		signal_carry_3
	);
	
	sum4 : full_adder_1bit PORT MAP(
		input_a(4),
		input_b(4),
		signal_carry_3,
		output_sum(4),
		signal_carry_4
	);
	
	sum5 : full_adder_1bit PORT MAP(
		input_a(5),
		input_b(5),
		signal_carry_4,
		output_sum(5),
		signal_carry_5
	);
	
	sum6 : full_adder_1bit PORT MAP(
		input_a(6),
		input_b(6),
		signal_carry_5,
		output_sum(6),
		signal_carry_6
	);
	
	sum7 : full_adder_1bit PORT MAP(
		input_a(7),
		input_b(7),
		signal_carry_6,
		output_sum(7),
		output_carry
	);
END gate_level;