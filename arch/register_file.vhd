LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY register_file IS PORT (
	clock, reset		: IN	STD_LOGIC;
	reg_write      	: IN  STD_LOGIC;
	read_register_0 	: IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
	read_register_1 	: IN  STD_LOGIC_VECTOR(4 DOWNTO 0);
	read_data_0 		: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
	read_data_1 		: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0);
	write_register 	: IN	STD_LOGIC_VECTOR(4 DOWNTO 0);
	write_data  		: IN	STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END ENTITY register_file;

ARCHITECTURE rtl OF register_file IS

   TYPE ram_type IS ARRAY(0 TO (2**read_register_0'LENGTH)-1) OF STD_LOGIC_VECTOR(write_data'RANGE);
   SIGNAL ram : ram_type := (OTHERS=>(OTHERS=> '0'));
	
   SIGNAL 
		signal_read_register_1, signal_read_register_2 
	: STD_LOGIC_VECTOR(read_register_0'RANGE);

BEGIN

	PROCESS(reset, clock, reg_write) IS
	BEGIN
	
		IF (reset = '1') THEN
			ram <= (OTHERS=>(OTHERS=> '0'));
		ELSIF (RISING_EDGE(clock) AND reg_write = '1') THEN
				ram(TO_INTEGER(UNSIGNED(write_register))) <= write_data;
		END IF;
	END PROCESS;
	
	signal_read_register_1 <= read_register_0;
	signal_read_register_2 <= read_register_1;
	
	read_data_0 <= ram(TO_INTEGER(UNSIGNED(signal_read_register_1)));
	read_data_1 <= ram(TO_INTEGER(UNSIGNED(signal_read_register_2)));
  
END ARCHITECTURE rtl;
