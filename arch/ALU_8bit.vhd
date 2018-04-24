LIBRARY IEEE;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY alu_8bit IS PORT(
	input_data0			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
	input_data1			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
	input_selection	:	IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
	output_data0		:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
	output_alu_signal	:	OUT	STD_LOGIC
); END alu_8bit;

ARCHITECTURE behv OF alu_8bit IS

	COMPONENT and_8bit 
	PORT(
		input_data0			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_data1			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
		output_data0		:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
	); END COMPONENT;
	
	COMPONENT or_8bit 
	PORT(
		input_data0			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_data1			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
		output_data0		:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
	); END COMPONENT;
	
	COMPONENT adder_8bit 
	PORT(
		input_carry		:	IN		STD_LOGIC;
		input_a			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_b			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
		output_sum		:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		output_carry	:	OUT	STD_LOGIC
	); END COMPONENT;
	
	COMPONENT not_8bit IS PORT(
		input_data0		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		output_data0	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
	); END COMPONENT;
	
	COMPONENT mux_8_8bit IS PORT(
		input_selection		: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
		input_data0		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_data1		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_data2		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_data3		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_data4		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_data5		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_data6		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_data7		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		output_data0 	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
	); END COMPONENT;
	
	SIGNAL
		signal_and, 
		signal_or, 
		signal_add, 
		signal_sub,
		signal_set_on_less_than,
		signal_not_input_data1
	:	STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	SIGNAL
		signal_less_than, signal_carry_out_of_sub_operation
	: STD_LOGIC;
BEGIN
	
	-- And
	perform_and : and_8bit 
	PORT MAP(
		input_data0		=> input_data0,
		input_data1		=> input_data1,
		output_data0	=> signal_and
	);
	
	-- Or
	perform_or : or_8bit 
	PORT MAP(
		input_data0		=> input_data0,
		input_data1		=> input_data1,
		output_data0	=> signal_or
	);
	
	-- Perform addition
	perform_addition : adder_8bit
	PORT MAP(
		input_carry		=> '0',
		input_a			=> input_data0,
		input_b			=> input_data1,
		output_sum		=> signal_add,
		output_carry	=> open
	);
	
	-- Substraction
	complement_input_data1 : not_8bit
	PORT MAP(
		input_data0 	=> input_data1,
		output_data0 	=> signal_not_input_data1
	);
	
	perform_substraction : adder_8bit
	PORT MAP(
		input_carry		=> '1',
		input_a			=> input_data0,
		input_b			=> signal_not_input_data1,
		output_sum		=> signal_sub,
		output_carry	=> signal_carry_out_of_sub_operation
	);
	
--	-- Set-On-Less-Than
--	perform_lessthan : lessthan_8bit 
--	PORT MAP(
--		input_data0		=> input_data0,
--		input_data1		=> input_data1,
--		output_data0	=> signal_less_than
--	);
	
	signal_less_than <= NOT signal_carry_out_of_sub_operation;
	signal_set_on_less_than <= 
		signal_less_than & signal_less_than &
		signal_less_than & signal_less_than &
		signal_less_than & signal_less_than &
		signal_less_than & signal_less_than;
		
	-- MASTER OUTPUT
	master_output : mux_8_8bit 
	PORT MAP(
		input_selection		=> input_selection,
		input_data0		=> signal_and, -- 000
		input_data1		=> signal_or, -- 001
		input_data2		=> signal_add, -- 010
		input_data3		=> (OTHERS => 'Z'), -- 011
		input_data4		=> (OTHERS => 'Z'), -- 100
		input_data5		=> (OTHERS => 'Z'), -- 101
		input_data6		=> signal_sub, -- 110
		input_data7		=> signal_set_on_less_than, -- 111
		output_data0 	=> output_data0
	);
		
	-- Zero signal
	output_alu_signal <= NOT(signal_sub(7) OR signal_sub(6) OR signal_sub(5) OR signal_sub(4) OR signal_sub(3) OR signal_sub(2) OR signal_sub(1) OR signal_sub(0));
END behv;