LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY complement_if_negative_8bit IS PORT(
	input_sign		: IN	STD_LOGIC;
	input_data0		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
	output_data0	: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)
); END complement_if_negative_8bit;

ARCHITECTURE gate_level OF complement_if_negative_8bit IS
	SIGNAL
		signal_output_positive, signal_output_negative
	: STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
	signal_output_positive <=
		((NOT input_sign) AND input_data0(7)) &
		((NOT input_sign) AND input_data0(6)) &
		((NOT input_sign) AND input_data0(5)) &
		((NOT input_sign) AND input_data0(4)) &
		((NOT input_sign) AND input_data0(3)) &
		((NOT input_sign) AND input_data0(2)) &
		((NOT input_sign) AND input_data0(1)) &
		((NOT input_sign) AND input_data0(0));
		
	signal_output_negative <=
		(input_sign AND (NOT input_data0(7))) &
		(input_sign AND (NOT input_data0(6))) &
		(input_sign AND (NOT input_data0(5))) &
		(input_sign AND (NOT input_data0(4))) &
		(input_sign AND (NOT input_data0(3))) &
		(input_sign AND (NOT input_data0(2))) &
		(input_sign AND (NOT input_data0(1))) &
		(input_sign AND (NOT input_data0(0)));
		
	output_data0 <=
		(signal_output_positive(7) OR signal_output_negative(7)) &
		(signal_output_positive(6) OR signal_output_negative(6)) &
		(signal_output_positive(5) OR signal_output_negative(5)) &
		(signal_output_positive(4) OR signal_output_negative(4)) &
		(signal_output_positive(3) OR signal_output_negative(3)) &
		(signal_output_positive(2) OR signal_output_negative(2)) &
		(signal_output_positive(1) OR signal_output_negative(1)) &
		(signal_output_positive(0) OR signal_output_negative(0));
END gate_level;