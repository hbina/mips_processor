LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux_4_8bit IS PORT ( 
	 input_selection			:	IN		STD_LOGIC_VECTOR(1 DOWNTO 0);
    input_data0		:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
    input_data1		:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
	 input_data2		:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
    input_data3		:	IN		STD_LOGIC_VECTOR(7 DOWNTO 0);
	 output_data0 		:	OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
); END mux_4_8bit;

ARCHITECTURE gate_level OF mux_4_8bit IS
	SIGNAL 
		signal_select0, signal_select1, 
		signal_select2, signal_select3
	: STD_LOGIC;
	
	SIGNAL
		signal_effective_data0, signal_effective_data1, 
		signal_effective_data2, signal_effective_data3
	: STD_LOGIC_VECTOR(7 DOWNTO 0);
	
BEGIN
	signal_select0 <= (NOT input_selection(1)) AND (NOT input_selection(0));
	signal_select1 <= (NOT input_selection(1)) AND (input_selection(0));
	signal_select2 <= (input_selection(1)) AND (NOT input_selection(0));
	signal_select3 <= (input_selection(1)) AND (input_selection(0));
	
	signal_effective_data0 <=
		(input_data0(7) AND signal_select0) &
		(input_data0(6) AND signal_select0) &
		(input_data0(5) AND signal_select0) &
		(input_data0(4) AND signal_select0) &
		(input_data0(3) AND signal_select0) &
		(input_data0(2) AND signal_select0) &
		(input_data0(1) AND signal_select0) &
		(input_data0(0) AND signal_select0);
		
	signal_effective_data1 <=
		(input_data1(7) AND signal_select1) &
		(input_data1(6) AND signal_select1) &
		(input_data1(5) AND signal_select1) &
		(input_data1(4) AND signal_select1) &
		(input_data1(3) AND signal_select1) &
		(input_data1(2) AND signal_select1) &
		(input_data1(1) AND signal_select1) &
		(input_data1(0) AND signal_select1);
		
	signal_effective_data2 <=
		(input_data2(7) AND signal_select2) &
		(input_data2(6) AND signal_select2) &
		(input_data2(5) AND signal_select2) &
		(input_data2(4) AND signal_select2) &
		(input_data2(3) AND signal_select2) &
		(input_data2(2) AND signal_select2) &
		(input_data2(1) AND signal_select2) &
		(input_data2(0) AND signal_select2);
		
	signal_effective_data3 <=
		(input_data3(7) AND signal_select3) &
		(input_data3(6) AND signal_select3) &
		(input_data3(5) AND signal_select3) &
		(input_data3(4) AND signal_select3) &
		(input_data3(3) AND signal_select3) &
		(input_data3(2) AND signal_select3) &
		(input_data3(1) AND signal_select3) &
		(input_data3(0) AND signal_select3);
	
	output_data0 <=
		(signal_effective_data3(7) OR signal_effective_data2(7) OR signal_effective_data1(7) OR signal_effective_data0(7))&
		(signal_effective_data3(6) OR signal_effective_data2(6) OR signal_effective_data1(6) OR signal_effective_data0(6))& 
		(signal_effective_data3(5) OR signal_effective_data2(5) OR signal_effective_data1(5) OR signal_effective_data0(5))& 
		(signal_effective_data3(4) OR signal_effective_data2(4) OR signal_effective_data1(4) OR signal_effective_data0(4))& 
		(signal_effective_data3(3) OR signal_effective_data2(3) OR signal_effective_data1(3) OR signal_effective_data0(3))& 
		(signal_effective_data3(2) OR signal_effective_data2(2) OR signal_effective_data1(2) OR signal_effective_data0(2))& 
		(signal_effective_data3(1) OR signal_effective_data2(1) OR signal_effective_data1(1) OR signal_effective_data0(1))& 
		(signal_effective_data3(0) OR signal_effective_data2(0) OR signal_effective_data1(0) OR signal_effective_data0(0));
END gate_level;