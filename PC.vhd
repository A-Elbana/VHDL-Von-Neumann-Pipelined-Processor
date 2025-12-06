LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY PC IS
    PORT (
        clk, reset : IN STD_LOGIC;
        PCWrite : IN STD_LOGIC;
        memOP : IN STD_LOGIC;
        PC_IN : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        PC_Out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY PC;

ARCHITECTURE pcArch OF PC IS
    SIGNAL PC_Reg : STD_LOGIC_VECTOR(31 DOWNTO 0);
    
BEGIN
    PROCESS(clk, reset)
    BEGIN
    --active high PCWRite signal
        IF reset = '1' THEN
            PC_Reg <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF PCWrite = '1' THEN
                    PC_Reg <= STD_LOGIC_VECTOR(unsigned(PC_Reg) + 1);
            else 
                IF memOP = '1' THEN
                    PC_Reg <= PC_IN;
                END IF;
            END IF;
        END IF;
    END PROCESS;
    
    PC_Out <= PC_Reg;
    
END pcArch;
