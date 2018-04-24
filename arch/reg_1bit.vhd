LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
	
ENTITY reg_1bit IS PORT(
	clock, reset	: IN 	STD_LOGIC;
	enable			: IN	STD_LOGIC;
	input_data0		: IN 	STD_LOGIC;
	output_data0	: OUT	STD_LOGIC
);
END reg_1bit;

ARCHITECTURE behv OF reg_1bit IS

BEGIN
    PROCESS(clock, reset)
    BEGIN
        IF (reset = '1') THEN
            output_data0 <= '0';
        ELSIF (RISING_EDGE(clock)) THEN
            IF (enable = '1') THEN
                output_data0 <= input_data0;
            END IF;
        END IF;
    END PROCESS;
END behv;