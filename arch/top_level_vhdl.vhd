LIBRARY ieee;
USE ieee.std_logic_1164.all; 
LIBRARY lpm;
USE lpm.lpm_components.all; 

ENTITY top_level_vhdl IS PORT(

		-- Synchronous components
		GCLOCK : IN	STD_LOGIC;
		GRESET : IN	STD_LOGIC;
		
		-- Required inputs
		ValueSelect : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		InstrSelect : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		
		--Required ouputs
		MuxOut 			: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		InstructionOut	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		BranchOut 		: OUT STD_LOGIC;
		ZeroOut 			: OUT STD_LOGIC;
		MemWriteOut 	: OUT STD_LOGIC;
		RegWriteOut 	: OUT STD_LOGIC
		
--		-- Control signals
--		DEBUG_REG_WRITE_ADDRESS_SELECT :  OUT  STD_LOGIC;
--		DEBUG_JUMP :  OUT  STD_LOGIC;
--		DEBUG_BRANCH_EQUAL :  OUT  STD_LOGIC;
--		DEBUG_BRANCH_NOT_EQUAL :  OUT  STD_LOGIC;
--		DEBUG_MEM_READ :  OUT  STD_LOGIC;
--		DEBUG_MEM_TO_REG :  OUT  STD_LOGIC;
--		DEBUG_MEM_WRITE :  OUT  STD_LOGIC;
--		DEBUG_ALU_SRC :  OUT  STD_LOGIC;
--		DEBUG_REG_WRITE :  OUT  STD_LOGIC;
--		
--		-- Other values inside the processor
--		DEBUG_PC_PLUS_4 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
--		DEBUG_DATA_MEMORY_ADDRESS_VALUE :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
--		DEBUG_DATA_MEMORY_READ_VALUE :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
--		DEBUG_REG_FILE_ADDRESS_0 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
--		DEBUG_REG_FILE_ADDRESS_1 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
--		DEBUG_REG_FILE_READ_0 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
--		DEBUG_REG_FILE_READ_1 :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
--		DEBUG_REG_FILE_WRITE_ADDRESS : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
--		DEBUG_REG_FILE_WRITE_VALUE :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0);
--		
--		DEBUG_ALU_INPUT_A : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
--		DEBUG_ALU_INPUT_B : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
--		DEBUG_ALU_OPERATION : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
--		DEBUG_MAIN_ALU_OUTPUT :  OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END top_level_vhdl;

ARCHITECTURE bdf_type OF top_level_vhdl IS 

	COMPONENT adder_8bit
	PORT(
		input_carry 	: IN	STD_LOGIC;
		input_a 			: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_b 			: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		output_carry 	: OUT STD_LOGIC;
		output_sum 		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	); END COMPONENT;

	COMPONENT extend_shift_left_2_6bit
	PORT(
		input_data0		: IN	STD_LOGIC_VECTOR(5 DOWNTO 0);
		output_data0	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
	); END COMPONENT;

	COMPONENT adder_add4_8bit
	PORT(
		input_data0 	: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		output_data0 	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	); END COMPONENT;

	COMPONENT instruction_control 
	PORT(
		input_instruction						: IN	STD_LOGIC_VECTOR(5 DOWNTO 0);
		output_reg_dist 						: OUT STD_LOGIC;
		output_jump 							: OUT STD_LOGIC;
		output_beq 								: OUT STD_LOGIC;
		output_bne								: OUT STD_LOGIC;
		output_mem_read 						: OUT STD_LOGIC;
		output_mem_to_reg						: OUT STD_LOGIC;
		output_mem_write 						: OUT STD_LOGIC;
		output_alu_src 						: OUT STD_LOGIC;
		output_reg_write 						: OUT STD_LOGIC;
		output_alu_op 							: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		output_EXCEPTION_illegal_opcode	: OUT STD_LOGIC
	); END COMPONENT;

	COMPONENT alu_8bit
	PORT(
		input_data0			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_data1			:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_selection	:	IN 	STD_LOGIC_VECTOR(2 DOWNTO 0);
		output_data0		:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		output_alu_signal	:	OUT	STD_LOGIC
	); END COMPONENT;
	
	COMPONENT alu_control
	PORT(
		input_function_from_instruction	: IN	STD_LOGIC_VECTOR(5 DOWNTO 0);
		input_control_signal					: IN	STD_LOGIC_VECTOR(1 DOWNTO 0);
		output_effective_operation			: OUT	STD_LOGIC_VECTOR(2 DOWNTO 0)
	); END COMPONENT;

	COMPONENT data_memory
	GENERIC(
		ADDR_WIDTH : INTEGER;
		DATA_WIDTH : INTEGER
	);
	PORT(
		clock, reset 			: IN 	STD_LOGIC;
		input_write_signal	: IN 	STD_LOGIC;
		input_read_signal		: IN 	STD_LOGIC;
		addr_in					: IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
		data_in					: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		data_out 				: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
	); END COMPONENT;

	COMPONENT inst_rom
	PORT(
		addr 		: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		read_data	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	); END COMPONENT;

	COMPONENT register_file
	PORT(
		clock, reset 		: IN 	STD_LOGIC;
		reg_write 			: IN 	STD_LOGIC;
		read_register_0 	: IN 	STD_LOGIC_VECTOR(4 DOWNTO 0);
		read_register_1	: IN 	STD_LOGIC_VECTOR(4 DOWNTO 0);
		write_data 			: IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
		write_register 	: IN 	STD_LOGIC_VECTOR(4 DOWNTO 0);
		read_data_0 		: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
		read_data_1 		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	); END COMPONENT;

	COMPONENT mux_2_8bit
	PORT(
		input_selection	: IN 	STD_LOGIC;
		input_data0			: IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_data1 		: IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
		output_data0 		: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
	); END COMPONENT;

	COMPONENT mux_2_5bit
	PORT(
		input_selection	: IN 	STD_LOGIC;
		input_data0 		: IN	STD_LOGIC_VECTOR(4 DOWNTO 0);
		input_data1			: IN	STD_LOGIC_VECTOR(4 DOWNTO 0);
		output_data0		: OUT	STD_LOGIC_VECTOR(4 DOWNTO 0)
	);END COMPONENT;

	COMPONENT shift_left_2_8bit
	PORT(
		input_data0		: IN 	STD_LOGIC_VECTOR(7 DOWNTO 0);
		output_data0	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);  END COMPONENT;

	COMPONENT sign_extend_4bit_to_8bit
	PORT(
		input_data0		: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		output_data0	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
	); END COMPONENT;
	
	COMPONENT sign_extend_4to8_and_lsl_by2
	PORT(
		input_data0		: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
		output_data0	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
	); END COMPONENT;
	
	COMPONENT reg_1bit 
	PORT(
		clock, reset	: IN 	STD_LOGIC;
		enable			: IN	STD_LOGIC;
		input_data0		: IN 	STD_LOGIC;
		output_data0	: OUT	STD_LOGIC
	); END COMPONENT;

	COMPONENT reg_nbit
	GENERIC(
		num_bits : INTEGER
	); 
	PORT(
		clock, reset 	: IN	STD_LOGIC;
		enable 			: IN	STD_LOGIC;
		input_data0 	: IN  STD_LOGIC_VECTOR(num_bits - 1 DOWNTO 0);
		output_data0 	: OUT	STD_LOGIC_VECTOR(num_bits - 1 DOWNTO 0)
	); END COMPONENT;
	
	COMPONENT mux_8_8bit
	PORT( 
		input_selection	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
		input_data0			: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_data1			: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_data2			: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_data3			: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_data4			: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_data5			: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_data6			: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_data7			: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		output_data0		: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
	); END COMPONENT;
	
	COMPONENT forwarding_unit
	PORT(
		input_is_reg_write_stage4		:	IN		STD_LOGIC;
		input_is_reg_write_stage5		:	IN		STD_LOGIC;
		input_reg_write_addr_stage4	:	IN		STD_LOGIC_VECTOR(4 DOWNTO 0);
		input_reg_write_addr_stage5	:	IN		STD_LOGIC_VECTOR(4 DOWNTO 0);
		input_source0_addr				:	IN		STD_LOGIC_VECTOR(4 DOWNTO 0);
		input_source1_addr				:	IN		STD_LOGIC_VECTOR(4 DOWNTO 0);
		output_select_a					:	OUT	STD_LOGIC_VECTOR(1 DOWNTO 0);
		output_select_b					:	OUT	STD_LOGIC_VECTOR(1 DOWNTO 0)
	); END COMPONENT;
	
	COMPONENT mux_4_8bit
	PORT( 
	 input_selection	:	IN		STD_LOGIC_VECTOR(1 DOWNTO 0);
    input_data0		:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
    input_data1		:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
	 input_data2		:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
    input_data3		:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
	 output_data0 		:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
	); END COMPONENT;
	
	COMPONENT mux_2_1bit
	PORT( 
		input_selection	: IN	STD_LOGIC;
		input_data0			: IN	STD_LOGIC;
		input_data1			: IN	STD_LOGIC;
		output_data0 		: OUT	STD_LOGIC
	); END COMPONENT;
	
	COMPONENT mux_8_32bit
	PORT( 
		input_selection	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
		input_data0			: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		input_data1			: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		input_data2			: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		input_data3			: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		input_data4			: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		input_data5			: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		input_data6			: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		input_data7			: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		output_data0 		: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
	); END COMPONENT;
	
	COMPONENT mux_2_2bit
	PORT ( 
		input_selection	: IN	STD_LOGIC;
		input_data0			: IN	STD_LOGIC_VECTOR(1 DOWNTO 0);
		input_data1			: IN	STD_LOGIC_VECTOR(1 DOWNTO 0);
		output_data0 		: OUT	STD_LOGIC_VECTOR(1 DOWNTO 0)
	); END COMPONENT;
	
	COMPONENT hazard_detection_unit
	PORT(
		input_instruction_string_stage2	: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		input_regfile_addr_stage3 			: IN	STD_LOGIC_VECTOR(4 DOWNTO 0);
		input_mem_read_stage3				: IN	STD_LOGIC;
		input_branch_instruction_signals : IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
		output_select_input_buffer_idex 	: OUT STD_LOGIC;
		output_flush_buffer_ifid 			: OUT STD_LOGIC;
		output_disable_pc_load 				: OUT STD_LOGIC;
		output_disable_ifid_load			: OUT	STD_LOGIC
	); END COMPONENT;
	
	COMPONENT mux_2_32bit
	PORT ( 
		input_selection	: IN	STD_LOGIC;
		input_data0			: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		input_data1			: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		output_data0 		: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
	); END COMPONENT;
	
	COMPONENT equal_8bit
	PORT(
		input_data0		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		input_data1 	: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
		output_equal	: OUT	STD_LOGIC
	); END COMPONENT;
	
	-----------------
	-- 31 DOWNTO 0 --
	-----------------
	SIGNAL
		signal_value_stage1_instruction_string,
		signal_value_stage2_instruction_string,
		signal_value_stage3_instruction_string,
		signal_value_stage4_instruction_string,
		signal_value_stage5_instruction_string,
		signal_value_stage1_instruction_string_after_branchcheck
	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	----------------
	-- 7 DOWNTO 0 --
	----------------
	SIGNAL	
		signal_value_stage1_pc,
		signal_value_stage1_pc4,
		signal_value_stage2_regfile_data0,
		signal_value_stage2_regfile_data1,
		signal_value_stage2_branch_addr_lsl_by2,
		signal_value_stage3_alu_src_input_b,
		signal_value_stage3_effective_alu_result,
		signal_value_stage4_regfile_write_data,
		signal_value_stage5_regfile_write_data,
		signal_value_stage1_finalized_next_pc,
		signal_value_stage4_data_memory_output,
		signal_value_stage2_effective_addr_of_branch,
		signal_value_stage2_effective_addr_of_jump,
		signal_value_stage2_addr_previous_or_bne,
		signal_value_stage2_addr_pc4_or_beq,
		signal_value_stage3_regfile_data0,
		signal_value_stage4_effective_alu_result,
		signal_value_stage4_regfile_data1,
		signal_value_stage5_effective_alu_result,
		signal_value_stage5_data_memory_read0,
		signal_value_stage2_sign_extended_addr,
		signal_value_stage3_sign_extended_addr,
		signal_value_stage2_pc4,
		signal_value_stage3_regfile_data1,
		signal_value_stage3_effective_input_a_of_alu,
		signal_value_stage3_effective_input_b_of_alu,
		signal_value_stage1_pc4_after_branchcheck,
		signal_value_stage3_effective_regfile_read0,
		signal_value_stage3_effective_regfile_read1,
		signal_value_muxout_others
	: STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	----------------
	-- 5 DOWNTO 0 --
	----------------
	SIGNAL
		signal_value_stage3_instruction_5to0
	: STD_LOGIC_VECTOR(5 DOWNTO 0);
	
	----------------
	-- 4 DOWNTO 0 --
	----------------
	SIGNAL
		signal_value_stage3_regfile_write_addr,
		signal_value_stage4_regfile_write_addr,
		signal_value_stage5_regfile_write_addr,
		signal_value_stage3_instruction_20to16,
		signal_value_stage3_instruction_15to11,
		signal_value_stage3_read0_addr,
		signal_value_stage3_read1_addr,
		signal_value_stage2_regfile_addr0,
		signal_value_stage2_regfile_addr1
	: STD_LOGIC_VECTOR(4 DOWNTO 0);
	
	----------------
	-- 2 DOWNTO 0 --
	----------------
	SIGNAL
		signal_value_stage3_effective_alu_operation,
		signal_value_concat_of_branch_signals
	: STD_LOGIC_VECTOR(2 DOWNTO 0);
	
	----------------
	-- 1 DOWNTO 0 --
	----------------
	SIGNAL
		signal_value_stage2_instruct_alu_operation,
		signal_passive_stage3_select_alu_src_a_forwarding_unit,
		signal_passive_stage3_select_alu_src_b_forwarding_unit,
		signal_value_stage2_alu_operation_after_stallcheck,
		signal_value_stage3_alu_operation,
		signal_passive_stage2_select_read0_forwarding_unit,
		signal_passive_stage2_select_read1_forwarding_unit
	: STD_LOGIC_VECTOR(1 DOWNTO 0);
	
	---------------
	-- STD_LOGIC --
	---------------
	SIGNAL	
		signal_passive_stage2_instruct_branch_equal,
		signal_passive_stage2_instruct_mem_write,
		signal_passive_stage2_instruct_mem_read,
		signal_passive_stage2_instruct_enable_write_to_regfile,
		signal_passive_stage2_instruct_select_alu_or_mem_for_regfile,
		signal_passive_stage2_instruct_select_alu_src,
		signal_passive_stage2_select_pc4_or_beq,
		signal_passive_stage2_instruct_jump,
		signal_passive_stage2_instruct_select_addr,
		signal_passive_stage2_select_previous_or_bne,
		signal_passive_stage2_instruct_branch_not_equal,
		signal_passive_stage1_disable_pc_load, 
		signal_passive_stage1_enable_pc_load,
		signal_passive_stage1_disable_ifid_load, 
		signal_passive_stage1_enable_ifid_load,
		signal_passive_stage1_flush_buffer_ifid,
		signal_passive_stage2_enable_write_to_regfile_after_stallcheck,
		signal_passive_stage2_select_data_to_write_regfile_after_stallcheck,
		signal_passive_stage2_instruct_mem_read_after_stallcheck,
		signal_passive_stage2_instruct_mem_write_after_stallcheck,
		signal_passive_stage2_select_addr_to_be_written_to_regfile_after_stallcheck,
		signal_passive_stage2_instruct_select_alu_src_after_stallcheck,
		signal_passive_select_input_for_buffer_idex,
		signal_passive_stage4_instruct_mem_write,
		signal_passive_stage4_instruct_mem_read,
		signal_passive_stage4_enable_write_to_regfile,
		signal_passive_stage5_enable_write_to_regfile,
		signal_passive_stage3_enable_write_to_regfile,
		signal_passive_stage3_select_data_to_write_regfile,
		signal_passive_stage3_instruct_mem_read,
		signal_passive_stage3_instruct_mem_write,
		signal_passive_stage3_instruct_select_alu_src,
		signal_passive_stage4_select_data_to_write_regfile,
		signal_passive_stage5_select_data_to_write_regfile,
		signal_passive_stage3_select_addr_to_be_written_to_regfile,
		signal_passive_stage2_beq_compare,
		EXCEPTION_ILLEGAL_INSTRUCTION,
		signal_passive_alu_output_is_zero,
		signal_EXCEPTION_RESET
	:  STD_LOGIC;

BEGIN

	signal_EXCEPTION_RESET <= EXCEPTION_ILLEGAL_INSTRUCTION OR GRESET;
--	-- internal signals
--	DEBUG_REG_WRITE_ADDRESS_SELECT <= signal_passive_stage2_instruct_select_addr;
--	
--	-- instruction decoder
--	DEBUG_JUMP 					<= signal_passive_stage2_instruct_jump;
--	DEBUG_BRANCH_EQUAL 		<= signal_passive_stage2_instruct_branch_equal;
--	DEBUG_BRANCH_NOT_EQUAL	<= signal_passive_stage2_instruct_branch_not_equal;
--	DEBUG_MEM_READ 			<= signal_passive_stage2_instruct_mem_read;
--	DEBUG_MEM_TO_REG 			<= signal_passive_stage2_instruct_select_alu_or_mem_for_regfile;
--	DEBUG_MEM_WRITE 			<= signal_passive_stage2_instruct_mem_write;
--	DEBUG_ALU_SRC 				<= signal_passive_stage2_instruct_select_alu_src;
--	DEBUG_REG_WRITE 			<= signal_passive_stage2_instruct_enable_write_to_regfile;
--	
--	-- internal values
--	DEBUG_PC_PLUS_4 						<= signal_value_stage1_pc4;
--	DEBUG_DATA_MEMORY_ADDRESS_VALUE	<= signal_value_stage3_effective_alu_result;
--	DEBUG_DATA_MEMORY_READ_VALUE 		<= signal_value_stage4_data_memory_output;
--	
--	-- register file
--	DEBUG_REG_FILE_READ_0 			<= signal_value_stage2_regfile_data0;
--	DEBUG_REG_FILE_READ_1 			<= signal_value_stage2_regfile_data1;
--	DEBUG_REG_FILE_WRITE_ADDRESS	<= signal_value_stage3_regfile_write_addr;
--	DEBUG_REG_FILE_WRITE_VALUE		<= signal_value_stage5_regfile_write_data;
--	DEBUG_REG_FILE_ADDRESS_0 		<= signal_value_stage1_instruction_string(25 DOWNTO 21);
--	DEBUG_REG_FILE_ADDRESS_1 		<= signal_value_stage1_instruction_string(20 DOWNTO 16);
--	
--	-- alu
--	DEBUG_ALU_INPUT_A 		<= signal_value_stage2_regfile_data0;
--	DEBUG_ALU_INPUT_B			<= signal_value_stage3_alu_src_input_b;
--	DEBUG_ALU_OPERATION		<= signal_value_stage3_effective_alu_operation;
--	DEBUG_MAIN_ALU_OUTPUT	<= signal_value_stage3_effective_alu_result;
	
	-- Required outputs
	-- InstructionOut <= signal_value_stage1_instruction_string;
	BranchOut 		<= signal_passive_stage2_instruct_branch_equal;
	ZeroOut 			<= signal_passive_alu_output_is_zero;
	MemWriteOut 	<= signal_passive_stage2_instruct_mem_write;
	RegWriteOut 	<= signal_passive_stage2_instruct_enable_write_to_regfile;
	
	signal_value_muxout_others <= 
		'0' & 
		signal_passive_stage2_instruct_select_addr &
		signal_passive_stage2_instruct_jump &
		signal_passive_stage2_instruct_mem_read &
		signal_passive_stage2_instruct_select_alu_or_mem_for_regfile &
		signal_value_stage2_instruct_alu_operation & 
		signal_passive_stage2_instruct_select_alu_src;
		
	b2v_MuxOut : mux_8_8bit
	PORT MAP(
		input_selection	=> ValueSelect,
		input_data0			=> signal_value_stage1_pc, --000
		input_data1			=> signal_value_stage3_effective_alu_result, --001
		input_data2			=> signal_value_stage2_regfile_data0, --010
		input_data3			=> signal_value_stage2_regfile_data1, --011
		input_data4			=> signal_value_stage5_regfile_write_data, --100
		input_data5			=> signal_value_muxout_others, --101
		input_data6			=> signal_value_muxout_others,--110
		input_data7			=> signal_value_muxout_others, --111
		output_data0 		=> MuxOut);
	
	b2v_MuxOut_INSTRUCTION : mux_8_32bit
	PORT MAP(
		input_selection	=> InstrSelect,
		input_data0			=> signal_value_stage1_instruction_string, --000
		input_data1			=> signal_value_stage2_instruction_string, --001
		input_data2			=> signal_value_stage3_instruction_string, --010
		input_data3			=> signal_value_stage4_instruction_string, --011
		input_data4			=> signal_value_stage5_instruction_string, --100
		input_data5			=> (OTHERS => '0'), --101
		input_data6			=> (OTHERS => '0'),--110
		input_data7			=> (OTHERS => '0'), --111
		output_data0 		=> InstructionOut);
	
	signal_passive_stage1_enable_pc_load <= NOT signal_passive_stage1_disable_pc_load;
	b2v_PROGRAM_COUNTER : reg_nbit
	GENERIC MAP(
		num_bits => 8)
	PORT MAP(
		clock 			=> GCLOCK,
		reset 			=> signal_EXCEPTION_RESET,
		enable 			=> signal_passive_stage1_enable_pc_load,
		input_data0 	=> signal_value_stage1_finalized_next_pc,
		output_data0	=> signal_value_stage1_pc);

	b2v_INCREMENT_PC_BY_4 : adder_8bit
	PORT MAP(
		input_carry 	=> '0',
		input_a 			=> signal_value_stage1_pc,
		input_b 			=> "00000100",
		output_sum 		=> signal_value_stage1_pc4,
		output_carry	=> open);

	b2v_INSTRUCTION_CONTROL : instruction_control
	PORT MAP(
		input_instruction 					=> signal_value_stage2_instruction_string(31 DOWNTO 26),
		output_reg_dist 						=> signal_passive_stage2_instruct_select_addr,
		output_jump 							=> signal_passive_stage2_instruct_jump,
		output_beq 								=> signal_passive_stage2_instruct_branch_equal,
		output_bne 								=> signal_passive_stage2_instruct_branch_not_equal,
		output_mem_read 						=> signal_passive_stage2_instruct_mem_read,
		output_mem_to_reg 					=> signal_passive_stage2_instruct_select_alu_or_mem_for_regfile,
		output_mem_write 						=> signal_passive_stage2_instruct_mem_write,
		output_alu_src 						=> signal_passive_stage2_instruct_select_alu_src,
		output_reg_write 						=> signal_passive_stage2_instruct_enable_write_to_regfile,
		output_alu_op 							=> signal_value_stage2_instruct_alu_operation,
		output_EXCEPTION_illegal_opcode	=> EXCEPTION_ILLEGAL_INSTRUCTION);
			 
	b2v_MAIN_ALU : alu_8bit
	PORT MAP(
		input_data0 		=> signal_value_stage3_effective_input_a_of_alu,
		input_data1 		=> signal_value_stage3_effective_input_b_of_alu,
		input_selection 	=> signal_value_stage3_effective_alu_operation,
		output_data0 		=> signal_value_stage3_effective_alu_result,
		output_alu_signal	=> signal_passive_alu_output_is_zero);

	b2v_MAIN_ALU_CONTROL : alu_control
	PORT MAP(
		input_function_from_instruction	=> signal_value_stage3_instruction_5to0,
		input_control_signal 				=> signal_value_stage3_alu_operation,
		output_effective_operation			=> signal_value_stage3_effective_alu_operation);

	b2v_MAIN_DATA_MEMORY : data_memory
	GENERIC MAP(
		ADDR_WIDTH => 8,
		DATA_WIDTH => 8)
	PORT MAP(
		clock 					=> GCLOCK,
		reset 					=> signal_EXCEPTION_RESET,
		input_write_signal	=> signal_passive_stage4_instruct_mem_write,
		input_read_signal 	=> signal_passive_stage4_instruct_mem_read,
		addr_in 					=> signal_value_stage4_effective_alu_result,
		data_in 					=> signal_value_stage4_regfile_data1,
		data_out 				=> signal_value_stage4_data_memory_output);

	b2v_MAIN_INSTRUCTION_ROM : inst_rom
	PORT MAP(
		addr 			=> signal_value_stage1_pc,
		read_data	=> signal_value_stage1_instruction_string);
		
	signal_value_stage2_regfile_addr0 <= signal_value_stage2_instruction_string(25 DOWNTO 21);
	signal_value_stage2_regfile_addr1 <= signal_value_stage2_instruction_string(20 DOWNTO 16);
	b2v_MAIN_REGISTER_FILE : register_file
	PORT MAP(
		clock 				=> GCLOCK,
		reset 				=> signal_EXCEPTION_RESET,
		reg_write		 	=> signal_passive_stage5_enable_write_to_regfile,
		read_register_0	=> signal_value_stage2_regfile_addr0,
		read_register_1 	=> signal_value_stage2_regfile_addr1,
		write_data 			=> signal_value_stage5_regfile_write_data,
		write_register 	=> signal_value_stage5_regfile_write_addr,
		read_data_0 		=> signal_value_stage2_regfile_data0,
		read_data_1 		=> signal_value_stage2_regfile_data1);
	
	b2v_SELECT_REG_WRITE_ADDRESS : mux_2_5bit
	PORT MAP(
		input_selection 	=> signal_passive_stage3_select_addr_to_be_written_to_regfile,
		input_data0			=> signal_value_stage3_instruction_20to16,
		input_data1			=> signal_value_stage3_instruction_15to11,
		output_data0		=> signal_value_stage3_regfile_write_addr);
	
	b2v_stage4_mux_select_alu_or_mem_data : mux_2_8bit
	PORT MAP(
		input_selection 	=> signal_passive_stage4_select_data_to_write_regfile,
		input_data0 		=> signal_value_stage4_effective_alu_result,
		input_data1 		=> signal_value_stage4_data_memory_output,
		output_data0		=> signal_value_stage4_regfile_write_data);
	
	b2v_SELECT_REG_WRITE_DATA : mux_2_8bit
	PORT MAP(
		input_selection	=> signal_passive_stage5_select_data_to_write_regfile,
		input_data0 		=> signal_value_stage5_effective_alu_result,
		input_data1 		=> signal_value_stage5_data_memory_read0,
		output_data0		=> signal_value_stage5_regfile_write_data);

	b2v_SELECT_INPUT_FOR_ALU : mux_2_8bit
	PORT MAP(
		input_selection	=> signal_passive_stage3_instruct_select_alu_src,
		input_data0			=> signal_value_stage3_regfile_data1,
		input_data1			=> signal_value_stage3_sign_extended_addr,
		output_data0		=> signal_value_stage3_alu_src_input_b);
		
	b2v_SELECT_SIGN_EXTEND : sign_extend_4bit_to_8bit
	PORT MAP(
		input_data0		=> signal_value_stage2_instruction_string(3 DOWNTO 0),
		output_data0	=> signal_value_stage2_sign_extended_addr);
		
	------------------------
	-- BRANCH CALCULATION --
	------------------------
	
	b2v_CALCULATE_BOOLEAN_OF_BEQ : equal_8bit
	PORT MAP(
		input_data0		=> signal_value_stage3_effective_regfile_read0,
		input_data1 	=> signal_value_stage3_effective_regfile_read1,
		output_equal	=> signal_passive_stage2_beq_compare);
		
	b2v_CALCULATE_VALUE_FOR_BRANCH : adder_8bit
	PORT MAP(
		input_carry 	=> '0',
		input_a 			=> signal_value_stage2_pc4,
		input_b			=> signal_value_stage2_branch_addr_lsl_by2,
		output_sum 		=> signal_value_stage2_effective_addr_of_branch,
		output_carry	=> open);

	signal_passive_stage2_select_pc4_or_beq		<= signal_passive_stage2_beq_compare AND signal_passive_stage2_instruct_branch_equal;
	signal_passive_stage2_select_previous_or_bne	<= (NOT signal_passive_stage2_beq_compare) AND signal_passive_stage2_instruct_branch_not_equal;
	
	b2v_SELECT_PC4_OR_BEQ : mux_2_8bit
	PORT MAP(
		input_selection	=> signal_passive_stage2_select_pc4_or_beq,
		input_data0			=> signal_value_stage1_pc4,
		input_data1			=> signal_value_stage2_effective_addr_of_branch,
		output_data0		=> signal_value_stage2_addr_pc4_or_beq);
	
	b2v_SELECT_PREVIOUS_OR_BNE : mux_2_8bit
	PORT MAP(
		input_selection	=> signal_passive_stage2_select_previous_or_bne,
		input_data0			=> signal_value_stage2_addr_pc4_or_beq,
		input_data1			=> signal_value_stage2_effective_addr_of_branch,
		output_data0		=> signal_value_stage2_addr_previous_or_bne);

	b2v_SELECT_PREVIOUS_OR_JUMP : mux_2_8bit
	PORT MAP(
		input_selection	=> signal_passive_stage2_instruct_jump,
		input_data0			=> signal_value_stage2_addr_previous_or_bne,
		input_data1			=> signal_value_stage2_effective_addr_of_jump,
		output_data0		=> signal_value_stage1_finalized_next_pc);
	
	b2v_perform_logical_shift_left_by_2_8bit : shift_left_2_8bit
	PORT MAP(
		input_data0		=> signal_value_stage2_instruction_string(7 DOWNTO 0),
		output_data0	=> signal_value_stage2_branch_addr_lsl_by2);
	
	
	b2v_EXTEND_ADDRESS_FOR_JUMP : extend_shift_left_2_6bit
	PORT MAP(
		input_data0		=> signal_value_stage2_instruction_string(5 DOWNTO 0),
		output_data0	=> signal_value_stage2_effective_addr_of_jump);
	
	--------------
	-- PIPELINE --
	--------------
	-- Using concatenation is WAAAAY too confusing. Also not that easily scalable if we want to support additional instruction.
	-----------------
	-- STAGE IF_ID --
	-----------------
		
	signal_passive_stage1_enable_ifid_load <= NOT signal_passive_stage1_disable_ifid_load;
	b2v_select_zero_if_branch_for_buffer_pc4 : mux_2_8bit
	PORT MAP(
		input_selection	=> signal_passive_stage1_flush_buffer_ifid,
		input_data0 		=> signal_value_stage1_pc4,
		input_data1 		=> (OTHERS => '0'),
		output_data0 		=> signal_value_stage1_pc4_after_branchcheck);
		
	b2v_buffer_pc4_stage_ifid : reg_nbit
	GENERIC MAP (num_bits => 8)
	PORT MAP(
		clock				=> GCLOCK,
		reset				=> signal_EXCEPTION_RESET,
		enable			=> signal_passive_stage1_enable_ifid_load,
		input_data0		=> signal_value_stage1_pc4_after_branchcheck,
		output_data0	=> signal_value_stage2_pc4);
	
	b2v_select_zero_if_branch_for_main_instruction_string : mux_2_32bit
	PORT MAP(
		input_selection	=> signal_passive_stage1_flush_buffer_ifid,
		input_data0 		=> signal_value_stage1_instruction_string,
		input_data1 		=> (OTHERS => '0'),
		output_data0 		=> signal_value_stage1_instruction_string_after_branchcheck);
	
	b2v_buffer_main_instruction_string_stage_ifid : reg_nbit
	GENERIC MAP (num_bits => 32)
	PORT MAP(
		clock				=> GCLOCK,
		reset				=> signal_EXCEPTION_RESET,
		enable			=> signal_passive_stage1_enable_ifid_load,
		input_data0		=> signal_value_stage1_instruction_string_after_branchcheck,
		output_data0	=> signal_value_stage2_instruction_string);

	-----------------
	-- STAGE ID_EX --
	-----------------
	
	b2v_buffer_main_instruction_string_stage_idex : reg_nbit
	GENERIC MAP (num_bits => 32)
	PORT MAP(
		clock				=> GCLOCK,
		reset				=> signal_EXCEPTION_RESET,
		enable			=> signal_passive_stage1_enable_ifid_load,
		input_data0		=> signal_value_stage2_instruction_string,
		output_data0	=> signal_value_stage3_instruction_string);
	
	b2v_mux_select_zero_if_stalling_for_signal_passive_enable_write_to_reg_file : mux_2_1bit
	PORT MAP( 
		input_selection	=>	signal_passive_select_input_for_buffer_idex,
		input_data0			=> signal_passive_stage2_instruct_enable_write_to_regfile,
		input_data1			=> '0',
		output_data0 		=> signal_passive_stage2_enable_write_to_regfile_after_stallcheck);
	 
	b2v_buffer_enable_write_to_regfile_stage_idex : reg_1bit
	PORT MAP(
		clock				=> GCLOCK,
		reset				=> signal_EXCEPTION_RESET,
		enable			=> '1',
		input_data0		=> signal_passive_stage2_enable_write_to_regfile_after_stallcheck,
		output_data0	=> signal_passive_stage3_enable_write_to_regfile);
	
	-- Stores the signal of select data to be written to reg file that will be used in stage 5.
	
	b2v_mux_select_zero_if_stalling_for_signal_passive_select_data_to_write_reg_file : mux_2_1bit
	PORT MAP( 
		input_selection	=>	signal_passive_select_input_for_buffer_idex,
		input_data0			=> signal_passive_stage2_instruct_select_alu_or_mem_for_regfile,
		input_data1			=> '0',
		output_data0 		=> signal_passive_stage2_select_data_to_write_regfile_after_stallcheck);
	 
	b2v_buffer_select_data_to_write_regfile_stage_idex : reg_1bit
	PORT MAP(
		clock				=> GCLOCK,
		reset				=> signal_EXCEPTION_RESET,
		enable			=> '1',
		input_data0		=> signal_passive_stage2_select_data_to_write_regfile_after_stallcheck,
		output_data0	=> signal_passive_stage3_select_data_to_write_regfile);
	
	b2v_mux_select_zero_if_stalling_for_signal_passive_instruct_mem_read : mux_2_1bit
	PORT MAP( 
		input_selection	=> signal_passive_select_input_for_buffer_idex,
		input_data0			=> signal_passive_stage2_instruct_mem_read,
		input_data1			=> '0',
		output_data0 		=> signal_passive_stage2_instruct_mem_read_after_stallcheck);
	 
	b2v_buffer_signal_passive_instruct_mem_read_stage_idex : reg_1bit
	PORT MAP(
		clock				=> GCLOCK,
		reset				=> signal_EXCEPTION_RESET,
		enable			=> '1',
		input_data0		=> signal_passive_stage2_instruct_mem_read_after_stallcheck,
		output_data0	=> signal_passive_stage3_instruct_mem_read);
	
	-- Stores the signal of writing into data_memory that will be used in stage 4.
	
	b2v_mux_select_zero_if_stalling_for_signal_passive_instruct_mem_write : mux_2_1bit
	PORT MAP( 
		input_selection	=> signal_passive_select_input_for_buffer_idex,
		input_data0			=> signal_passive_stage2_instruct_mem_write,
		input_data1			=> '0',
		output_data0 		=> signal_passive_stage2_instruct_mem_write_after_stallcheck);
	 
	b2v_buffer_signal_passive_instruct_mem_write_stage_idex : reg_1bit
	PORT MAP(
		clock				=> GCLOCK,
		reset				=> signal_EXCEPTION_RESET,
		enable			=> '1',
		input_data0		=> signal_passive_stage2_instruct_mem_write_after_stallcheck,
		output_data0	=> signal_passive_stage3_instruct_mem_write);
	
	b2v_mux_select_zero_if_stalling_for_signal_passive_select_addr_to_be_written_to_reg_file : mux_2_1bit
	PORT MAP( 
		input_selection	=> signal_passive_select_input_for_buffer_idex,
		input_data0			=> signal_passive_stage2_instruct_select_addr,
		input_data1			=> '0',
		output_data0 		=> signal_passive_stage2_select_addr_to_be_written_to_regfile_after_stallcheck);
	 
	b2v_buffer_signal_passive_select_addr_to_be_written_to_regfile_stage_idex : reg_1bit
	PORT MAP(
		clock				=> GCLOCK,
		reset				=> signal_EXCEPTION_RESET,
		enable			=> '1',
		input_data0		=> signal_passive_stage2_select_addr_to_be_written_to_regfile_after_stallcheck,
		output_data0	=> signal_passive_stage3_select_addr_to_be_written_to_regfile);
	
	b2v_mux_select_zero_if_stalling_for_signal_passive_alu_operation : mux_2_2bit
	PORT MAP( 
		input_selection	=> signal_passive_select_input_for_buffer_idex,
		input_data0			=> signal_value_stage2_instruct_alu_operation,
		input_data1			=> (OTHERS => '0'),
		output_data0 		=> signal_value_stage2_alu_operation_after_stallcheck);
	 
	b2v_buffer_signal_passive_alu_operation_stage_idex : reg_nbit
	GENERIC MAP (num_bits => 2)
	PORT MAP(
		clock				=> GCLOCK,
		reset				=> signal_EXCEPTION_RESET,
		enable			=> '1',
		input_data0		=> signal_value_stage2_alu_operation_after_stallcheck,
		output_data0	=> signal_value_stage3_alu_operation);
		
	b2v_mux_select_zero_if_stalling_for_signal_passive_instruct_select_alu_src : mux_2_1bit
	PORT MAP( 
		input_selection	=> signal_passive_select_input_for_buffer_idex,
		input_data0			=> signal_passive_stage2_instruct_select_alu_src,
		input_data1			=> '0',
		output_data0 		=> signal_passive_stage2_instruct_select_alu_src_after_stallcheck);
	 
		
	-- Stores the signal to select the source for input_b of the alu at stage 3.
	b2v_buffer_signal_passive_instruct_select_alu_src_stage_idex : reg_1bit
	PORT MAP(
		clock				=> GCLOCK,
		reset				=> signal_EXCEPTION_RESET,
		enable			=> '1',
		input_data0		=> signal_passive_stage2_instruct_select_alu_src_after_stallcheck,
		output_data0	=> signal_passive_stage3_instruct_select_alu_src);
		
	-----------------------------------------------------------------------------------------------------
	-- Cut-off between instruction signals and the temporary signals required for values memorization. --
	-----------------------------------------------------------------------------------------------------
	
	b2v_buffer_signal_value_sign_extended_offset_addr_stage_idex : reg_nbit
	GENERIC MAP (num_bits => 8)
	PORT MAP(
		clock 			=> GCLOCK,
		reset 			=> signal_EXCEPTION_RESET,
		enable 			=> '1',
		input_data0		=> signal_value_stage2_sign_extended_addr,
		output_data0	=> signal_value_stage3_sign_extended_addr);

	b2v_buffer_instruction_5to0_stage_idex : reg_nbit
	GENERIC MAP (num_bits => 6)
	PORT MAP(
		clock 			=> GCLOCK,
		reset 			=> signal_EXCEPTION_RESET,
		enable 			=> '1',
		input_data0		=> signal_value_stage2_instruction_string(5 DOWNTO 0),
		output_data0	=> signal_value_stage3_instruction_5to0);
	
	b2v_buffer_instruction_20to16_stage_idex : reg_nbit
	GENERIC MAP (num_bits => 5)
	PORT MAP(
		clock 			=> GCLOCK,
		reset 			=> signal_EXCEPTION_RESET,
		enable 			=> '1',
		input_data0		=> signal_value_stage2_instruction_string(20 DOWNTO 16),
		output_data0	=> signal_value_stage3_instruction_20to16);
		
	b2v_buffer_instruction_15to11_stage_idex : reg_nbit
	GENERIC MAP (num_bits => 5)
	PORT MAP(
		clock 			=> GCLOCK,
		reset 			=> signal_EXCEPTION_RESET,
		enable 			=> '1',
		input_data0		=> signal_value_stage2_instruction_string(15 DOWNTO 11),
		output_data0	=> signal_value_stage3_instruction_15to11);
		
	b2v_buffer_signal_value_regfile_data1_stage_idex : reg_nbit
	GENERIC MAP (num_bits => 8)
	PORT MAP(
		clock 			=> GCLOCK,
		reset 			=> signal_EXCEPTION_RESET,
		enable 			=> '1',
		input_data0		=> signal_value_stage2_regfile_data1,
		output_data0	=> signal_value_stage3_regfile_data1);
	
	b2v_buffer_signal_value_regfile_data0_stage_idex : reg_nbit
	GENERIC MAP (num_bits => 8)
	PORT MAP(
		clock 			=> GCLOCK,
		reset 			=> signal_EXCEPTION_RESET,
		enable			=> '1',
		input_data0		=> signal_value_stage2_regfile_data0,
		output_data0	=> signal_value_stage3_regfile_data0);
		
	-------------
	-- STAGE EX_MEM --
	-------------
	
	b2v_buffer_main_instruction_string_stage_exmem : reg_nbit
	GENERIC MAP (num_bits => 32)
	PORT MAP(
		clock				=> GCLOCK,
		reset				=> signal_EXCEPTION_RESET,
		enable			=> signal_passive_stage1_enable_ifid_load,
		input_data0		=> signal_value_stage3_instruction_string,
		output_data0	=> signal_value_stage4_instruction_string);
		
	b2v_buffer_signal_passive_instruct_mem_read_stage_exmem : reg_1bit
	PORT MAP(
		clock				=> GCLOCK,
		reset				=> signal_EXCEPTION_RESET,
		enable			=> '1',
		input_data0		=> signal_passive_stage3_instruct_mem_read,
		output_data0	=> signal_passive_stage4_instruct_mem_read);
		
	b2v_buffer_signal_passive_instruct_mem_write_stage_exmem : reg_1bit
	PORT MAP(
		clock				=> GCLOCK,
		reset				=> signal_EXCEPTION_RESET,
		enable			=> '1',
		input_data0		=> signal_passive_stage3_instruct_mem_write,
		output_data0	=> signal_passive_stage4_instruct_mem_write);
	
	b2v_buffer_signal_enable_write_to_regfile_stage_exmem : reg_1bit
	PORT MAP(
		clock				=> GCLOCK,
		reset				=> signal_EXCEPTION_RESET,
		enable			=> '1',
		input_data0		=> signal_passive_stage3_enable_write_to_regfile,
		output_data0	=> signal_passive_stage4_enable_write_to_regfile);
	
	b2v_buffer_signal_select_data_to_write_regfile_stage_exmem : reg_1bit
	PORT MAP(
		clock				=> GCLOCK,
		reset				=> signal_EXCEPTION_RESET,
		enable			=> '1',
		input_data0		=> signal_passive_stage3_select_data_to_write_regfile,
		output_data0	=> signal_passive_stage4_select_data_to_write_regfile);
	
	
	b2v_buffer_signal_effective_reg_write_addr_stage_exmem : reg_nbit
	GENERIC MAP (num_bits => 5)
	PORT MAP(
		clock				=> GCLOCK,
		reset 			=> signal_EXCEPTION_RESET,
		enable 			=> '1',
		input_data0 	=> signal_value_stage3_regfile_write_addr,
		output_data0	=> signal_value_stage4_regfile_write_addr);
		
	b2v_buffer_signal_value_regfile_data1_stage_exmem : reg_nbit
	GENERIC MAP (num_bits => 8)
	PORT MAP(
		clock 			=> GCLOCK,
		reset 			=> signal_EXCEPTION_RESET,
		enable 			=> '1',
		input_data0		=> signal_value_stage3_regfile_data1,
		output_data0	=> signal_value_stage4_regfile_data1);
		
	b2v_buffer_signal_value_effective_alu_result_stage_exmem : reg_nbit
	GENERIC MAP (num_bits => 8)
	PORT MAP(
		clock 			=> GCLOCK,
		reset 			=> signal_EXCEPTION_RESET,
		enable 			=> '1',
		input_data0		=> signal_value_stage3_effective_alu_result,
		output_data0	=> signal_value_stage4_effective_alu_result);
		
	------------------
	-- STAGE MEM_WB --
	------------------
	
	b2v_buffer_main_instruction_string_stage_memwb : reg_nbit
	GENERIC MAP (num_bits => 32)
	PORT MAP(
		clock				=> GCLOCK,
		reset				=> signal_EXCEPTION_RESET,
		enable			=> signal_passive_stage1_enable_ifid_load,
		input_data0		=> signal_value_stage4_instruction_string,
		output_data0	=> signal_value_stage5_instruction_string);
	
	b2v_buffer_signal_passive_enable_write_to_regfile_stage_memwb : reg_1bit
	PORT MAP (
		clock 			=> GCLOCK,
		reset 			=> signal_EXCEPTION_RESET,
		enable 			=> '1',
		input_data0		=> signal_passive_stage4_enable_write_to_regfile,
		output_data0	=> signal_passive_stage5_enable_write_to_regfile);
		
	b2v_buffer_signal_passive_select_data_to_write_regfile_stage_memwb : reg_1bit
	PORT MAP (
		clock 			=> GCLOCK,
		reset 			=> signal_EXCEPTION_RESET,
		enable 			=> '1',
		input_data0		=> signal_passive_stage4_select_data_to_write_regfile,
		output_data0	=> signal_passive_stage5_select_data_to_write_regfile);
	
	b2v_value_effective_alu_result_stage_memwb: reg_nbit
	GENERIC MAP (num_bits => 8)
	PORT MAP(
		clock 			=> GCLOCK,
		reset 			=> signal_EXCEPTION_RESET,
		enable 			=> '1',
		input_data0		=> signal_value_stage4_effective_alu_result,
		output_data0	=> signal_value_stage5_effective_alu_result);
	
	b2v_value_data_from_mem_read_stage_memwb: reg_nbit
	GENERIC MAP (num_bits => 8)
	PORT MAP(
		clock 			=> GCLOCK,
		reset 			=> signal_EXCEPTION_RESET,
		enable 			=> '1',
		input_data0		=> signal_value_stage4_data_memory_output,
		output_data0	=> signal_value_stage5_data_memory_read0);	
		
	b2v_sign_reg_write_addr_stage_memwb : reg_nbit
	GENERIC MAP (num_bits => 5)
	PORT MAP(
		clock 			=> GCLOCK,
		reset 			=> signal_EXCEPTION_RESET,
		enable 			=> '1',
		input_data0 	=> signal_value_stage4_regfile_write_addr,
		output_data0	=> signal_value_stage5_regfile_write_addr);
	
	---------------------
	-- FORWARDING UNIT --
	---------------------
	b2v_forwarding_unit_for_alu : forwarding_unit
	PORT MAP(
		input_is_reg_write_stage4		=> signal_passive_stage4_enable_write_to_regfile,
		input_is_reg_write_stage5		=> signal_passive_stage5_enable_write_to_regfile,
		input_reg_write_addr_stage4	=> signal_value_stage4_regfile_write_addr,
		input_reg_write_addr_stage5	=> signal_value_stage5_regfile_write_addr,
		input_source0_addr				=> signal_value_stage3_read0_addr,
		input_source1_addr				=> signal_value_stage3_read1_addr,
		output_select_a					=> signal_passive_stage3_select_alu_src_a_forwarding_unit,
		output_select_b					=> signal_passive_stage3_select_alu_src_b_forwarding_unit);
		
	b2v_forwarding_unit_for_branch : forwarding_unit
	PORT MAP(
		input_is_reg_write_stage4		=> signal_passive_stage4_enable_write_to_regfile,
		input_is_reg_write_stage5		=> signal_passive_stage5_enable_write_to_regfile,
		input_reg_write_addr_stage4	=> signal_value_stage4_regfile_write_addr,
		input_reg_write_addr_stage5	=> signal_value_stage5_regfile_write_addr,
		input_source0_addr				=> signal_value_stage2_instruction_string(25 DOWNTO 21),
		input_source1_addr				=> signal_value_stage2_instruction_string(20 DOWNTO 16),
		output_select_a					=> signal_passive_stage2_select_read0_forwarding_unit,
		output_select_b					=> signal_passive_stage2_select_read1_forwarding_unit);
		
	b2v_select_input_a_with_alu_forwarding : mux_4_8bit
	PORT MAP(
		input_selection	=> signal_passive_stage3_select_alu_src_a_forwarding_unit,
		input_data0			=> signal_value_stage3_regfile_data0, --00
		input_data1			=> signal_value_stage5_regfile_write_data, --01
		input_data2			=> signal_value_stage4_regfile_write_data, --10
		input_data3			=> signal_value_stage4_regfile_write_data,--11
		output_data0 		=> signal_value_stage3_effective_input_a_of_alu);
	
	b2v_select_input_b_with_alu_forwarding : mux_4_8bit
	PORT MAP(
		input_selection	=> signal_passive_stage3_select_alu_src_b_forwarding_unit,
		input_data0			=> signal_value_stage3_alu_src_input_b, --00
		input_data1			=> signal_value_stage5_regfile_write_data, --01
		input_data2			=> signal_value_stage4_regfile_write_data, --10
		input_data3			=> signal_value_stage4_regfile_write_data, --11
		output_data0 		=> signal_value_stage3_effective_input_b_of_alu);
	
	b2v_select_read0_with_alu_forwarding : mux_4_8bit
	PORT MAP(
		input_selection	=> signal_passive_stage2_select_read0_forwarding_unit,
		input_data0			=> signal_value_stage2_regfile_data0, --00
		input_data1			=> signal_value_stage5_regfile_write_data, --01
		input_data2			=> signal_value_stage4_regfile_write_data, --10
		input_data3			=> signal_value_stage4_regfile_write_data,--11
		output_data0 		=> signal_value_stage3_effective_regfile_read0);
	
	b2v_select_read1_with_alu_forwarding : mux_4_8bit
	PORT MAP(
		input_selection	=> signal_passive_stage2_select_read1_forwarding_unit,
		input_data0			=> signal_value_stage2_regfile_data1, --00
		input_data1			=> signal_value_stage5_regfile_write_data, --01
		input_data2			=> signal_value_stage4_regfile_write_data, --10
		input_data3			=> signal_value_stage4_regfile_write_data, --11
		output_data0 		=> signal_value_stage3_effective_regfile_read1);
	
	------------------
	-- Buffer ID_EX --
	------------------
	b2v_read0_addr_stage_idex : reg_nbit
	GENERIC MAP (num_bits => 5)
	PORT MAP(
		clock 			=> GCLOCK,
		reset 			=> signal_EXCEPTION_RESET,
		enable 			=> '1',
		input_data0 	=> signal_value_stage2_instruction_string(25 DOWNTO 21),
		output_data0	=> signal_value_stage3_read0_addr);
	
	b2v_read1_addr_stage_idex : reg_nbit
	GENERIC MAP (num_bits => 5)
	PORT MAP(
		clock 			=> GCLOCK,
		reset 			=> signal_EXCEPTION_RESET,
		enable 			=> '1',
		input_data0 	=> signal_value_stage2_instruction_string(20 DOWNTO 16),
		output_data0	=> signal_value_stage3_read1_addr);
		
	---------------------------
	-- HAZARD DETECTION UNIT --
	---------------------------
	-- Remember that stalling involves forwarding unit, we are basically 
	-- denying the advance of instructions at stage 2. The forwarding unit will see 
	-- that the write addr is the same as the input addr on one or both 
	-- of them hence replacing the input for a and (or) b
	signal_value_concat_of_branch_signals <=	signal_passive_stage2_instruct_jump & 
															signal_passive_stage2_select_previous_or_bne &
															signal_passive_stage2_select_pc4_or_beq;
	b2v_hazard_resolution_unit : hazard_detection_unit
	PORT MAP(
		input_instruction_string_stage2	=> signal_value_stage2_instruction_string,
		input_regfile_addr_stage3			=> signal_value_stage3_instruction_20to16,
		input_mem_read_stage3				=> signal_passive_stage3_instruct_mem_read,
		input_branch_instruction_signals => signal_value_concat_of_branch_signals,
		output_select_input_buffer_idex 	=> signal_passive_select_input_for_buffer_idex,
		output_flush_buffer_ifid 			=> signal_passive_stage1_flush_buffer_ifid,
		output_disable_pc_load 			 	=> signal_passive_stage1_disable_pc_load,
		output_disable_ifid_load			=> signal_passive_stage1_disable_ifid_load);
END bdf_type;

