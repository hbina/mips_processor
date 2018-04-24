LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY mux_8_32bit IS PORT ( 
	 input_selection	: IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
    input_data0		: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
    input_data1		: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
	 input_data2		: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
    input_data3		: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
	 input_data4		: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
    input_data5		: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
	 input_data6		: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
    input_data7		: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
	 output_data0 		: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
); END mux_8_32bit;

ARCHITECTURE gate_level OF mux_8_32bit IS
	
	COMPONENT mux_2_32bit
	PORT( 
		input_selection	: IN	STD_LOGIC;
		input_data0			: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		input_data1			: IN	STD_LOGIC_VECTOR(31 DOWNTO 0);
		output_data0 		: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
	); END COMPONENT;

	SIGNAL 
		signal_select0, signal_select1,
		signal_select2, signal_select3,
		signal_select4, signal_select5,
		signal_select6, signal_select7
	: STD_LOGIC;
	
	SIGNAL
		signal_value_data0, signal_value_data1,
		signal_value_data2, signal_value_data3,
		signal_value_data4, signal_value_data5,
		signal_value_data6, signal_value_data7
	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	
BEGIN
	signal_select0 <= (NOT input_selection(2)) AND (NOT input_selection(1)) AND (NOT input_selection(0));
	signal_select1 <= (NOT input_selection(2)) AND (NOT input_selection(1)) AND (input_selection(0));
	signal_select2 <= (NOT input_selection(2)) AND (input_selection(1)) AND (NOT input_selection(0));
	signal_select3 <= (NOT input_selection(2)) AND (input_selection(1)) AND (input_selection(0));
	signal_select4 <= (input_selection(2)) AND (NOT input_selection(1)) AND (NOT input_selection(0));
	signal_select5 <= (input_selection(2)) AND (NOT input_selection(1)) AND (input_selection(0));
	signal_select6 <= (input_selection(2)) AND (input_selection(1)) AND (NOT input_selection(0));
	signal_select7 <= (input_selection(2)) AND (input_selection(1)) AND (input_selection(0));
	
	b2v_select_0 : mux_2_32bit
	PORT MAP( 
		input_selection	=> signal_select0,
		input_data0			=> input_data0,
		input_data1			=> input_data0,
		output_data0 		=> signal_value_data0);
		
	b2v_select_1 : mux_2_32bit
	PORT MAP( 
		input_selection	=> signal_select1,
		input_data0			=> signal_value_data0,
		input_data1			=> input_data1,
		output_data0 		=> signal_value_data1);
	
	b2v_select_2 : mux_2_32bit
	PORT MAP( 
		input_selection	=> signal_select2,
		input_data0			=> signal_value_data1,
		input_data1			=> input_data2,
		output_data0 		=> signal_value_data2);
		
	b2v_select_3 : mux_2_32bit
	PORT MAP( 
		input_selection	=> signal_select3,
		input_data0			=> signal_value_data2,
		input_data1			=> input_data3,
		output_data0 		=> signal_value_data3);
	
	b2v_select_4 : mux_2_32bit
	PORT MAP( 
		input_selection	=> signal_select4,
		input_data0			=> signal_value_data3,
		input_data1			=> input_data4,
		output_data0 		=> signal_value_data4);
	
	b2v_select_5 : mux_2_32bit
	PORT MAP( 
		input_selection	=> signal_select5,
		input_data0			=> signal_value_data4,
		input_data1			=> input_data5,
		output_data0 		=> signal_value_data5);
	
	b2v_select_6 : mux_2_32bit
	PORT MAP( 
		input_selection	=> signal_select6,
		input_data0			=> signal_value_data5,
		input_data1			=> input_data6,
		output_data0 		=> signal_value_data6);
		
	b2v_select_7 : mux_2_32bit
	PORT MAP( 
		input_selection	=> signal_select7,
		input_data0			=> signal_value_data6,
		input_data1			=> input_data7,
		output_data0 		=> output_data0);
END gate_level;