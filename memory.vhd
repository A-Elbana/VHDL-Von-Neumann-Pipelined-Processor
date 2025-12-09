LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Memory IS
    PORT (
        clk, MemWrite, MemRead : IN STD_LOGIC; 
        Address, writeData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        readData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
    );
END ENTITY Memory;

ARCHITECTURE memArch OF Memory IS
    TYPE memType IS ARRAY (0 TO 262143) OF STD_LOGIC_VECTOR(31 DOWNTO 0); 
    SIGNAL memData : memType;

BEGIN
    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            IF MemWrite = '1' THEN
                memData(to_integer(unsigned(Address))) <= writeData;
            END IF;
        END IF;
    END PROCESS;


	readData <= (OTHERS => '0') WHEN (to_integer(unsigned(Address)) > 262143)
	ELSE memData(to_integer(unsigned(Address))) WHEN MemRead = '1'
	ELSE (OTHERS => '0');

END memArch;