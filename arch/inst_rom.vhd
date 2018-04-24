LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
-- USE IEEE.STD_LOGIC_ARITH.ALL;
USE STD.TEXTIO.ALL;

-- Add a generic parameter
ENTITY inst_rom IS PORT (
	 addr		 	: IN  std_logic_vector(7 DOWNTO 0);
    read_data	 	: OUT std_logic_vector(31 DOWNTO 0)
  );
END ENTITY inst_rom;

ARCHITECTURE rtl OF inst_rom IS

   TYPE ram_type IS ARRAY(0 TO (2**addr'LENGTH)-1) OF std_logic_vector(read_data'RANGE);
	
	-- Populate RAM with the desired value
	-- Need to manually input the values the tho xd
	FUNCTION init_rom RETURN ram_type IS
		VARIABLE r : ram_type;
		BEGIN
			FOR i IN r'RANGE LOOP
				r(i) := (OTHERS => '0');
			END LOOP;
		RETURN r;
	END FUNCTION;
	
	-- FILL MEMORY FROM TEXT FILE
	
--	FUNCTION fill_memory RETURN ram_type IS
--		VARIABLE mem : ram_type;
--		TYPE HexTable IS ARRAY (CHARACTER RANGE <>) OF INTEGER;
--		CONSTANT lookup : HexTable('0' TO 'F'):=
--		(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, -1, -1, -1,
--		-1, -1, -1, -1, 10, 11, 12, 13, 14, 15);
--		FILE infile: TEXT OPEN read_mode IS "mem_ram.mif";
--		VARIABLE buff		: LINE;
--		VARIABLE addr_s 	: STRING(2 DOWNTO 1);
--		VARIABLE data_s 	: STRING(8 DOWNTO 1);
--		VARIABLE addr1 	: INTEGER; 
--		VARIABLE data		: INTEGER RANGE 4294967295 DOWNTO 0;
--		BEGIN
--			WHILE (not endfile(infile)) LOOP
--				readline(infile, buff);
--				read(buff, addr_s);
--				addr1 := lookup(addr_s(2))*16 + lookup(addr_s(1));
--				
--				readline(infile, buff);
--				read(buff, data_s);
--				data :=	lookup(data_s(8))*268435456 + lookup(data_s(7))*16777216 + lookup(data_s(6))*1048576 +
--							lookup(data_s(5))*65536 + lookup(data_s(4))*4096 + lookup(data_s(3))*256 + 
--							lookup(data_s(2))*16 + lookup(data_s(1));
--				mem(addr1) := CONV_STD_LOGIC_VECTOR(data, 32);
--			END LOOP;
--			
--		RETURN mem;
--	END FUNCTION;
--	
	SIGNAL muh_ram : ram_type := (
		0 	=> "10001100000000100000000000000000", -- lw $2, 0 memory(00)=55
		4 	=> "10001100000000110000000000000001", -- lw $3, 1 memory(01)=AA
		8 	=> "00000000010000110000100000100000", -- add $1, $2, $3
		12	=> "10101100000000010000000000000011", -- sw $1, 3 memory(03)=FF
		16	=> "00010000001000101111111111111111", -- beq $1, $2, -4
		20	=> "00010000001000011111111111111010", -- beq $1, $1, -24
		24 => "00001000000000000000111111110111", -- jmp to random fucking place
		OTHERS => (OTHERS => '0'));
	
--	-- Method obtained from this link:http://quartushelp.altera.com/15.0/mergedProjects/hdl/vhdl/vhdl_file_dir_ram_init.htm
--	SIGNAL muh_ram : ram_type;
--	ATTRIBUTE ram_init_file : string;
--	ATTRIBUTE ram_init_file OF muh_ram : SIGNAL IS "rom_memory.mif";
	
BEGIN
	
	read_data <= muh_ram(TO_INTEGER(UNSIGNED(addr)));
  
END ARCHITECTURE rtl;
