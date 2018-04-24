LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY instruction_control IS PORT(
	input_instruction						: IN	STD_LOGIC_VECTOR(5 DOWNTO 0);
	output_reg_dist						: OUT	STD_LOGIC;
	output_jump								: OUT	STD_LOGIC;
	output_beq								: OUT	STD_LOGIC;
	output_bne								: OUT STD_LOGIC;
	output_mem_read						: OUT	STD_LOGIC;
	output_mem_to_reg						: OUT	STD_LOGIC;
	output_alu_op							: OUT	STD_LOGIC_VECTOR(1 DOWNTO 0);
	output_mem_write						: OUT	STD_LOGIC;
	output_alu_src							: OUT	STD_LOGIC;
	output_reg_write						: OUT	STD_LOGIC;
	output_EXCEPTION_illegal_opcode	: OUT STD_LOGIC
); END instruction_control;

ARCHITECTURE main_behv  OF  instruction_control IS
	SIGNAL 
		opcode_0, opcode_35, opcode_43, opcode_4,
		opcode_5, opcode_2
	: STD_LOGIC := '0';

BEGIN

	opcode_0 <= (NOT input_instruction(5) AND  NOT input_instruction(4) AND  NOT input_instruction(3) AND NOT input_instruction(2) AND NOT input_instruction(1) AND NOT input_instruction(0));
	opcode_35 <= (input_instruction(5) AND  NOT input_instruction(4) AND  NOT input_instruction(3) AND NOT input_instruction(2) AND input_instruction(1) AND input_instruction(0));
	opcode_43 <= (input_instruction(5) AND  NOT input_instruction(4) AND  input_instruction(3) AND NOT input_instruction(2) AND input_instruction(1) AND input_instruction(0));
	opcode_4 <= (NOT input_instruction(5) AND  NOT input_instruction(4) AND  NOT input_instruction(3) AND input_instruction(2) AND NOT input_instruction(1) AND NOT input_instruction(0));
	opcode_5 <= (NOT input_instruction(5) AND  NOT input_instruction(4) AND  NOT input_instruction(3) AND input_instruction(2) AND NOT input_instruction(1) AND input_instruction(0));
	opcode_2 <= (NOT input_instruction(5) AND  NOT input_instruction(4) AND  NOT input_instruction(3) AND NOT input_instruction(2) AND input_instruction(1) AND NOT input_instruction(0));
	
	output_reg_dist <= opcode_0;
	output_alu_src <= opcode_35 OR opcode_43;
	output_mem_to_reg <= opcode_35;
	output_reg_write <= opcode_0 OR opcode_35;
	output_mem_read <= opcode_35;
	output_mem_write <= opcode_43;
	output_beq <= opcode_4;
	output_alu_op(1) <= opcode_0;
	output_alu_op(0) <= opcode_4;
	output_jump <= opcode_2;
	output_bne <= opcode_5;
	
	output_EXCEPTION_illegal_opcode <=	NOT(
													opcode_0 OR
													opcode_35 OR
													opcode_43 OR
													opcode_4 OR
													opcode_5 OR
													opcode_2);
END main_behv;