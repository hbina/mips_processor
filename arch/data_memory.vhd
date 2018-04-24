-- I forgot where I originally obtained the reference VHDL to implement this 
-- but it's quite similar to the one here, so it might actualy have been this:
-- http://www.rfwireless-world.com/source-code/VHDL/read-write-RAM-vhdl-code.html
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.NUMERIC_STD.ALL;

ENTITY data_memory IS
	GENERIC (
		DATA_WIDTH : INTEGER := 8;
		ADDR_WIDTH : INTEGER := 8
	);
	PORT (
		clock, reset			: IN std_logic; -- Reset		
		addr_in				: IN std_logic_vector (ADDR_WIDTH - 1 DOWNTO 0); -- addr_in Input
		input_write_signal 	: IN std_logic; -- Write Enable/Read Enable
		data_in 					: IN std_logic_vector (DATA_WIDTH - 1 DOWNTO 0); -- data_in bi-directional
		input_read_signal		: IN STD_LOGIC;
		data_out					: OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
	);
END ENTITY;
ARCHITECTURE rtl OF data_memory IS
	
	-- Internal variables
	CONSTANT RAM_DEPTH : INTEGER := 2 ** ADDR_WIDTH;
	SIGNAL signal_data_out : std_logic_vector (DATA_WIDTH - 1 DOWNTO 0);
	TYPE ram_type IS ARRAY (0 TO (RAM_DEPTH - 1)) OF std_logic_vector (DATA_WIDTH - 1 DOWNTO 0);
	
	-- Populate RAM with the desired value
	-- Need to manually input the values the tho xd
	FUNCTION init_rom RETURN ram_type IS
		VARIABLE r : ram_type;
		BEGIN
			FOR i IN r'RANGE LOOP
				IF (i = 0) THEN
					r(i) := "01010101";
				ELSIF (i = 1) THEN
					r(i) := "10101010";
				ELSE
					r(i) := (OTHERS => '0');
				END IF;
			END LOOP;
		RETURN r;
	END FUNCTION;
	
	--SIGNAL mem : ram_type := init_rom;
			
	-- Method obtained from this link:http://quartushelp.altera.com/15.0/mergedProjects/hdl/vhdl/vhdl_file_dir_ram_init.htm
	SIGNAL mem : ram_type := (
		0 	=> "01010101",
		1 	=> "10101010",
		OTHERS => (OTHERS => '0'));
	-- ATTRIBUTE ram_init_file : string;
	--ATTRIBUTE ram_init_file OF mem : SIGNAL IS "data_memory.mif";
	
BEGIN

	MEM_WRITE :
	PROCESS (reset, clock) BEGIN
		IF (reset = '1') THEN 
			mem <= (
				0 			=> "01010101",
				1 			=> "10101010",
				OTHERS	=> (OTHERS => '0'));
		ELSIF (RISING_EDGE(clock)) THEN -- Only update the RAM at the end of a clock cycle
			IF (input_write_signal = '1' AND input_read_signal = '0') THEN -- Only update the RAM when we are not reading
				mem(TO_INTEGER(UNSIGNED(addr_in))) <= data_in;
			END IF;
		END IF;
	END PROCESS;

	data_out <= signal_data_out WHEN (input_write_signal = '0' AND input_read_signal = '1') ELSE (OTHERS => 'Z');

	-- Memory Read Block
	MEM_READ_0 :
	PROCESS (addr_in, input_write_signal, input_read_signal, mem) BEGIN
		IF (input_write_signal = '0' AND input_read_signal = '1') THEN
			signal_data_out <= mem(TO_INTEGER(UNSIGNED(addr_in)));
		ELSE
			signal_data_out <= (OTHERS => '0');
		END IF;
	END PROCESS;
	
END ARCHITECTURE;