LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux_2_1bit IS PORT ( 
	 input_selection			:	IN		STD_LOGIC;
    input_data0		:	IN		STD_LOGIC;
    input_data1		:	IN		STD_LOGIC;
	 output_data0 		:	OUT	STD_LOGIC
); END mux_2_1bit;

ARCHITECTURE gate_level OF mux_2_1bit IS
	SIGNAL 
		signal_select0, signal_select1
	: STD_LOGIC;
	
	SIGNAL
		signal_effective_data0, signal_effective_data1
	: STD_LOGIC;
	
BEGIN
	signal_select0 <= NOT input_selection;
	signal_select1 <= input_selection;
	
	signal_effective_data0 <= input_data0 AND signal_select0;
	signal_effective_data1 <= input_data1 AND signal_select1;
	
	output_data0 <= signal_effective_data0 OR signal_effective_data1;
END gate_level;