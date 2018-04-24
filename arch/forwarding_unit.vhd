LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY forwarding_unit IS PORT(
		input_is_reg_write_stage4			:	IN		STD_LOGIC;
		input_is_reg_write_stage5		:	IN		STD_LOGIC;
		
		input_reg_write_addr_stage4	:	IN		STD_LOGIC_VECTOR(4 DOWNTO 0);
		input_reg_write_addr_stage5	:	IN		STD_LOGIC_VECTOR(4 DOWNTO 0);
		
		input_source0_addr				:	IN		STD_LOGIC_VECTOR(4 DOWNTO 0);
		input_source1_addr				:	IN		STD_LOGIC_VECTOR(4 DOWNTO 0);
		
		output_select_a					:	OUT	STD_LOGIC_VECTOR(1 DOWNTO 0);
		output_select_b					:	OUT	STD_LOGIC_VECTOR(1 DOWNTO 0)
); END forwarding_unit;

ARCHITECTURE gate_level OF forwarding_unit IS

	SIGNAL 
		logic1, logic2, logic3, logic4
	:	STD_LOGIC;
	
	COMPONENT equal_5bit PORT(
		input_data0 	: IN	STD_LOGIC_VECTOR(4 DOWNTO 0);
		input_data1 	: IN	STD_LOGIC_VECTOR(4 DOWNTO 0);
		output_equal	: OUT	STD_LOGIC
	); END COMPONENT;
	
BEGIN

	-- Evaluate the components A, B, C and D which compares the addres
	A : equal_5bit PORT MAP(
		input_data0 	=> input_reg_write_addr_stage4,
		input_data1 	=> input_source0_addr,
		output_equal 	=> logic1);
	
	B : equal_5bit PORT MAP(
		input_data0 	=> input_reg_write_addr_stage4,
		input_data1 	=> input_source1_addr,
		output_equal 	=> logic2);
	
	C : equal_5bit PORT MAP(
		input_data0 	=> input_reg_write_addr_stage5,
		input_data1 	=> input_source0_addr,
		output_equal 	=> logic3);
	
	D : equal_5bit PORT MAP(
		input_data0 	=> input_reg_write_addr_stage5,
		input_data1 	=> input_source1_addr,
		output_equal 	=> logic4);
	
	-- The truth table is described as follows:
	-- 00 => select the default input_data0
	-- 01 => select the input from stage5
	-- 10 => select the input from stage4
	-- 11 => select the input from stage4
	-- Notice that '11' is actually a conflict, since 
	-- both stage4 and stage5 wrote to the same addr.
	-- This can easily be resolved by noting that the 
	-- latest value written to the addr should be considered.
	output_select_a <= (logic1 AND input_is_reg_write_stage4) & (logic3 AND input_is_reg_write_stage5);
	output_select_b <= (logic2 AND input_is_reg_write_stage4) & (logic4 AND input_is_reg_write_stage5);
	
END gate_level;