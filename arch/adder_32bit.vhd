LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY adder_32bit IS PORT(
	input_carry		:	IN		STD_LOGIC;
	input_a			:	IN		STD_LOGIC_VECTOR(31 DOWNTO 0);
	input_b			:	IN		STD_LOGIC_VECTOR(31 DOWNTO 0);
	output_sum		:	OUT	STD_LOGIC_VECTOR(31 DOWNTO 0);
	output_carry	:	OUT	STD_LOGIC
);
END adder_32bit;

ARCHITECTURE gate_level OF adder_32bit IS

	SIGNAL
		signal_carry0, signal_carry1, signal_carry2
	:	STD_LOGIC;
	
	COMPONENT adder_8bit
	PORT(
		input_carry		:	IN		STD_LOGIC;
		input_a			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_b			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
		output_sum		:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		output_carry	:	OUT	STD_LOGIC
	); END COMPONENT;

BEGIN

	add_byte3 : adder_8bit
	PORT MAP(
		input_carry		=> signal_carry2,
		input_a 			=> input_a(31 DOWNTO 24),
		input_b 			=> input_b(31 DOWNTO 24),
		output_carry	=> output_carry,
		output_sum 		=> output_sum(31 DOWNTO 24));
	
	add_byte2 : adder_8bit
	PORT MAP(
		input_carry 	=> signal_carry1,
		input_a 			=> input_a(23 DOWNTO 16),
		input_b 			=> input_b(23 DOWNTO 16),
		output_carry	=> signal_carry2,
		output_sum 		=> output_sum(23 DOWNTO 16));
	
	add_byte1 : adder_8bit
	PORT MAP(
		input_carry 	=> signal_carry0,
		input_a 			=> input_a(15 DOWNTO 8),
		input_b 			=> input_b(15 DOWNTO 8),
		output_carry	=> signal_carry1,
		output_sum 		=> output_sum(15 DOWNTO 8));
		
	add_byte0 : adder_8bit
	PORT MAP(
		input_carry 	=> '0',
		input_a 			=> input_a(7 DOWNTO 0),
		input_b 			=> input_b(7 DOWNTO 0),
		output_carry	=> signal_carry0,
		output_sum 		=> output_sum(7 DOWNTO 0));
		
END gate_level;