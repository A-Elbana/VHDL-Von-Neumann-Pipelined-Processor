LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
use STD.TEXTIO.ALL;
use IEEE.STD_LOGIC_TEXTIO.ALL;
use ieee.std_logic_1164.all;





ENTITY Memory IS
    PORT (
        clk, MemWrite, MemRead : IN STD_LOGIC; 
        HWInt : in std_logic;
        Address, writeData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        readData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
    );
END ENTITY Memory;

ARCHITECTURE memArch OF Memory IS
    TYPE memType IS ARRAY (0 TO 262143) OF STD_LOGIC_VECTOR(31 DOWNTO 0); 
    
    
    impure function init_ram_hex return memType is
        file text_file : text open read_mode is "out1.txt";
        variable text_line : line;
        variable ram_content : memType;
        variable c : character;
        variable offset : integer;
        variable addr : integer;
        variable hex_val : std_logic_vector(3 downto 0);
    begin
        ram_content := (others => (others => '0'));
        while not endfile(text_file) loop
            readline(text_file, text_line);
            
            -- 1. Read the address (stops at the colon)
            read(text_line, addr);
            
            -- 2. Skip the colon character ':'
            read(text_line, c);

            offset := 0;
            
            while offset < ram_content(addr)'high loop
                read(text_line, c);
                
                case c is
                    when '0' => hex_val := "0000";
                    when '1' => hex_val := "0001";
                    when '2' => hex_val := "0010";
                    when '3' => hex_val := "0011";
                    when '4' => hex_val := "0100";
                    when '5' => hex_val := "0101";
                    when '6' => hex_val := "0110";
                    when '7' => hex_val := "0111";
                    when '8' => hex_val := "1000";
                    when '9' => hex_val := "1001";
                    when 'A' | 'a' => hex_val := "1010";
                    when 'B' | 'b' => hex_val := "1011";
                    when 'C' | 'c' => hex_val := "1100";
                    when 'D' | 'd' => hex_val := "1101";
                    when 'E' | 'e' => hex_val := "1110";
                    when 'F' | 'f' => hex_val := "1111";
            
        when others =>
            hex_val := "XXXX";
            assert false report "Found non-hex character '" & c & "'";
        end case;
        
        ram_content(addr)(31 - offset
        downto 28 - offset) := hex_val;
        offset := offset + 4;
        
        end loop;
    end loop;

    return ram_content;
    end function;
SIGNAL memData : memType := init_ram_hex;
    
BEGIN
    PROCESS (clk, HWInt) IS
    BEGIN
        IF HWInt = '1' then
            memData(to_integer(unsigned(Address))) <= writeData;
        ELSIF rising_edge(clk) THEN
            IF MemWrite = '1' THEN
                memData(to_integer(unsigned(Address))) <= writeData;
            END IF;
        END IF;
    END PROCESS;


	readData <= (OTHERS => '0') WHEN (unsigned(Address) > to_unsigned(262143, 32))
	ELSE memData(to_integer(unsigned(Address))) WHEN MemRead = '1'
	ELSE (OTHERS => '0');

END memArch;