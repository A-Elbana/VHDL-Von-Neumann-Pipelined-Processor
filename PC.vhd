LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY PC IS
    PORT(
        clk, reset : IN  STD_LOGIC;
        PCWrite    : IN  STD_LOGIC;
        PC_IN      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        PC_Out     : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY PC;

ARCHITECTURE pcArch OF PC IS

BEGIN
    PROCESS(clk, reset)
    BEGIN
        IF reset = '1' THEN
            PC_Out <= PC_IN;
        ELSIF clk = '1' and clk'event THEN
            IF PCWrite = '0' THEN
                PC_Out <= PC_IN;
            END IF;
        END IF;
    END PROCESS;

END pcArch;
