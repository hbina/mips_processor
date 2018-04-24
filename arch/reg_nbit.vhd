LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
	
ENTITY reg_nbit IS 
	GENERIC(
		num_bits : INTEGER
	);
	PORT(
		clock, reset	: IN 	STD_LOGIC;
		enable			: IN	STD_LOGIC;
		input_data0		: IN 	STD_LOGIC_VECTOR(num_bits - 1 DOWNTO 0);
		output_data0	: OUT	STD_LOGIC_VECTOR(num_bits - 1 DOWNTO 0)
);
END reg_nbit;

ARCHITECTURE behv OF reg_nbit IS

BEGIN
    PROCESS(clock, reset)
    BEGIN
        IF (reset = '1') THEN
            output_data0 <= (OTHERS => '0');
        ELSIF (RISING_EDGE(clock)) THEN
            IF (enable = '1') THEN
                output_data0 <= input_data0;
            END IF;
        END IF;
    END PROCESS;
END behv;