LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY static_four_32bit IS PORT(
	output_1	:	OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END static_four_32bit;

ARCHITECTURE main_behv  OF  static_four_32bit IS
BEGIN
	output_1 <= "00000000000000000000000000000100";
END main_behv;