LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Memory IS
    PORT (
        clk, reset, MemWrite, MemRead : IN STD_LOGIC; 
        Address, writeData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        readData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) 
    );
END ENTITY Memory;

ARCHITECTURE memArch OF Memory IS
    TYPE memType IS ARRAY (0 TO 262143) OF STD_LOGIC_VECTOR(31 DOWNTO 0); 
    SIGNAL memData : memType;
    SIGNAL tempAddress : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN
    PROCESS (clk,reset) IS
    BEGIN

    IF(reset = '1') THEN
        tempAddress <= (OTHERS => '0');
    ELSE tempAddress <= Address;
    END IF;
    
        IF rising_edge(clk) THEN
            IF MemWrite = '1' THEN
                memData(to_integer(unsigned(tempAddress))) <= writeData;
            END IF;
        END IF;
    END PROCESS;


	readData <= (OTHERS => 'U') WHEN (to_integer(unsigned(tempAddress)) > 262143) OR (to_integer(signed(tempAddress)) < 0)
	ELSE memData(to_integer(unsigned(tempAddress))) WHEN MemRead = '1'
	ELSE (OTHERS => 'U');

END memArch;