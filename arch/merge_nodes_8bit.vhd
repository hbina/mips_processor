LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY merge_nodes_8bit IS PORT (
	input_data0 	: IN	STD_LOGIC;
	input_data1 	: IN	STD_LOGIC;
	input_data2 	: IN	STD_LOGIC;
	input_data3 	: IN	STD_LOGIC;
	input_data4 	: IN	STD_LOGIC;
	input_data5 	: IN	STD_LOGIC;
	input_data6 	: IN	STD_LOGIC;
	input_data7 	: IN	STD_LOGIC;
	output_data0	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
); END ENTITY;

ARCHITECTURE gate_level OF merge_nodes_8bit IS 
BEGIN
	output_data0 <= input_data0 & input_data1 & input_data2 & input_data3 & input_data4 & input_data5 & input_data6 & input_data7; 
END gate_level;