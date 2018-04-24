LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY hazard_detection_unit IS PORT(
	-- the instruction at stage 2, decode if rs and rt of this instruction
	-- is equal to the rt of a write instruction in subsequent instructions
	input_instruction_string_stage2	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	-- the rt (destination of an lw instruction) value, which will be compared to the rs and rs of stage 2
	input_regfile_addr_stage3 	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
	-- check if stage 3 is performing lw because the cpu only have vision of the register file, the content 
	-- of the data memory is 'invisible' as far as the cpu is concerned. Hence, 'reading' implies loading 
	-- word into the cpu.
	input_mem_read_stage3				: IN STD_LOGIC;
	-- the input_selection, if 10 or 11, select '0' for buffer idex to create NOP
	input_branch_instruction_signals : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
	output_select_input_buffer_idex 	: OUT STD_LOGIC;
	-- flush signal that will be required by branch hazard
	output_flush_buffer_ifid 			: OUT STD_LOGIC;
	-- stalling signals that will be required by stalling procedure
	output_disable_pc_load 				: OUT STD_LOGIC;
	output_disable_ifid_load			: OUT STD_LOGIC
); END hazard_detection_unit;

ARCHITECTURE gate_level OF hazard_detection_unit IS

	SIGNAL 
		signal_passive_cpu_is_stalling,
		signal_passive_cpu_is_branching,
		signal_idex_rt_equal_ifid_rs,
		signal_idex_rt_equal_ifid_rt
	: STD_LOGIC := '0';
	
	COMPONENT equal_5bit
	PORT(
		input_data0		: IN	STD_LOGIC_VECTOR(4 DOWNTO 0);
		input_data1 	: IN	STD_LOGIC_VECTOR(4 DOWNTO 0);
		output_equal	: OUT	STD_LOGIC
	); END COMPONENT;
BEGIN
	signal_passive_cpu_is_stalling <= input_mem_read_stage3 AND (signal_idex_rt_equal_ifid_rs OR signal_idex_rt_equal_ifid_rt);
	
	b2v_idex_rt_equal_ifid_rs : equal_5bit
	PORT MAP(
		input_regfile_addr_stage3,
		input_instruction_string_stage2(25 DOWNTO 21),
		signal_idex_rt_equal_ifid_rs);
	
	b2v_idex_rt_equal_ifid_rt : equal_5bit
	PORT MAP(
		input_regfile_addr_stage3,
		input_instruction_string_stage2(20 DOWNTO 16),
		signal_idex_rt_equal_ifid_rt);
	
	signal_passive_cpu_is_branching <=	input_branch_instruction_signals(0) OR 
													input_branch_instruction_signals(1) OR
													input_branch_instruction_signals(2);
	output_disable_ifid_load			<= signal_passive_cpu_is_stalling;
	output_disable_pc_load				<= signal_passive_cpu_is_stalling;
	output_select_input_buffer_idex	<= signal_passive_cpu_is_stalling;
	output_flush_buffer_ifid 			<= signal_passive_cpu_is_stalling OR signal_passive_cpu_is_branching;
	
END gate_level;