LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux_2_32bit IS PORT ( 
	 input_selection			:	IN		STD_LOGIC;
    input_data0		:	IN		STD_LOGIC_VECTOR(31 DOWNTO 0);
    input_data1		:	IN		STD_LOGIC_VECTOR(31 DOWNTO 0);
	 output_data0 		:	OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
); END mux_2_32bit;

ARCHITECTURE gate_level OF mux_2_32bit IS
	SIGNAL 
		signal_select0, signal_select1
	: STD_LOGIC;
	
	SIGNAL
		signal_effective_data0, signal_effective_data1
	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	
BEGIN
	signal_select0 <= NOT input_selection;
	signal_select1 <= input_selection;
	
	signal_effective_data0 <=
		(input_data0(31) AND signal_select0) &
		(input_data0(30) AND signal_select0) &
		(input_data0(29) AND signal_select0) &
		(input_data0(28) AND signal_select0) &
		(input_data0(27) AND signal_select0) &
		(input_data0(26) AND signal_select0) &
		(input_data0(25) AND signal_select0) &
		(input_data0(24) AND signal_select0) &
		(input_data0(23) AND signal_select0) &
		(input_data0(22) AND signal_select0) &
		(input_data0(21) AND signal_select0) &
		(input_data0(20) AND signal_select0) &
		(input_data0(19) AND signal_select0) &
		(input_data0(18) AND signal_select0) &
		(input_data0(17) AND signal_select0) &
		(input_data0(16) AND signal_select0) &
		(input_data0(15) AND signal_select0) &
		(input_data0(14) AND signal_select0) &
		(input_data0(13) AND signal_select0) &
		(input_data0(12) AND signal_select0) &
		(input_data0(11) AND signal_select0) &
		(input_data0(10) AND signal_select0) &
		(input_data0(9) AND signal_select0) &
		(input_data0(8) AND signal_select0) &
		(input_data0(7) AND signal_select0) &
		(input_data0(6) AND signal_select0) &
		(input_data0(5) AND signal_select0) &
		(input_data0(4) AND signal_select0) &
		(input_data0(3) AND signal_select0) &
		(input_data0(2) AND signal_select0) &
		(input_data0(1) AND signal_select0) &
		(input_data0(0) AND signal_select0);
		
	signal_effective_data1 <=
		(input_data1(31) AND signal_select1) &
		(input_data1(30) AND signal_select1) &
		(input_data1(29) AND signal_select1) &
		(input_data1(28) AND signal_select1) &
		(input_data1(27) AND signal_select1) &
		(input_data1(26) AND signal_select1) &
		(input_data1(25) AND signal_select1) &
		(input_data1(24) AND signal_select1) &
		(input_data1(23) AND signal_select1) &
		(input_data1(22) AND signal_select1) &
		(input_data1(21) AND signal_select1) &
		(input_data1(20) AND signal_select1) &
		(input_data1(19) AND signal_select1) &
		(input_data1(18) AND signal_select1) &
		(input_data1(17) AND signal_select1) &
		(input_data1(16) AND signal_select1) &
		(input_data1(15) AND signal_select1) &
		(input_data1(14) AND signal_select1) &
		(input_data1(13) AND signal_select1) &
		(input_data1(12) AND signal_select1) &
		(input_data1(11) AND signal_select1) &
		(input_data1(10) AND signal_select1) &
		(input_data1(9) AND signal_select1) &
		(input_data1(8) AND signal_select1) &
		(input_data1(7) AND signal_select1) &
		(input_data1(6) AND signal_select1) &
		(input_data1(5) AND signal_select1) &
		(input_data1(4) AND signal_select1) &
		(input_data1(3) AND signal_select1) &
		(input_data1(2) AND signal_select1) &
		(input_data1(1) AND signal_select1) &
		(input_data1(0) AND signal_select1);
	
	output_data0 <=
		(signal_effective_data1(31) OR signal_effective_data0(31)) &
		(signal_effective_data1(30) OR signal_effective_data0(30)) & 
		(signal_effective_data1(29) OR signal_effective_data0(29)) & 
		(signal_effective_data1(28) OR signal_effective_data0(28)) & 
		(signal_effective_data1(27) OR signal_effective_data0(27)) & 
		(signal_effective_data1(26) OR signal_effective_data0(26)) & 
		(signal_effective_data1(25) OR signal_effective_data0(25)) &
		(signal_effective_data1(24) OR signal_effective_data0(24)) &
		(signal_effective_data1(23) OR signal_effective_data0(23)) & 
		(signal_effective_data1(22) OR signal_effective_data0(22)) & 
		(signal_effective_data1(21) OR signal_effective_data0(21)) & 
		(signal_effective_data1(20) OR signal_effective_data0(20)) & 
		(signal_effective_data1(19) OR signal_effective_data0(19)) & 
		(signal_effective_data1(18) OR signal_effective_data0(18)) &
		(signal_effective_data1(17) OR signal_effective_data0(17)) &
		(signal_effective_data1(16) OR signal_effective_data0(16)) & 
		(signal_effective_data1(15) OR signal_effective_data0(15)) & 
		(signal_effective_data1(14) OR signal_effective_data0(14)) & 
		(signal_effective_data1(13) OR signal_effective_data0(13)) & 
		(signal_effective_data1(12) OR signal_effective_data0(12)) & 
		(signal_effective_data1(11) OR signal_effective_data0(11)) &
		(signal_effective_data1(10) OR signal_effective_data0(10)) &
		(signal_effective_data1(9) OR signal_effective_data0(9)) & 
		(signal_effective_data1(8) OR signal_effective_data0(8)) & 
		(signal_effective_data1(7) OR signal_effective_data0(7)) & 
		(signal_effective_data1(6) OR signal_effective_data0(6)) & 
		(signal_effective_data1(5) OR signal_effective_data0(5)) & 
		(signal_effective_data1(4) OR signal_effective_data0(4)) &
		(signal_effective_data1(3) OR signal_effective_data0(3)) &
		(signal_effective_data1(2) OR signal_effective_data0(2)) & 
		(signal_effective_data1(1) OR signal_effective_data0(1)) & 
		(signal_effective_data1(0) OR signal_effective_data0(0));
END gate_level;