library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity forwardUnit is
    port(
        ID_EX_Rsrc1     : in  std_logic_vector(2 downto 0);
        ID_EX_Rsrc2     : in  std_logic_vector(2 downto 0);
        EX_MEM_Rdst     : in  std_logic_vector(2 downto 0);
        MEM_WB_Rdst     : in  std_logic_vector(2 downto 0);
        EX_MEM_RegWrite : in  std_logic;
        MEM_WB_RegWrite : in  std_logic;
        ForwardA        : out std_logic_vector(1 downto 0);
        ForwardB        : out std_logic_vector(1 downto 0)
    );
end entity forwardUnit;

architecture forwardUnitArch of forwardUnit is
begin
    process(ID_EX_Rsrc1, ID_EX_Rsrc2, EX_MEM_Rdst, MEM_WB_Rdst, EX_MEM_RegWrite, MEM_WB_RegWrite)
    begin
        ForwardA <= "00";
        ForwardB <= "00";

        if (EX_MEM_RegWrite = '1' and EX_MEM_Rdst = ID_EX_Rsrc1) then
            ForwardA <= "10"; 
            
        elsif (MEM_WB_RegWrite = '1' and MEM_WB_Rdst = ID_EX_Rsrc1) then
            ForwardA <= "01";
        end if;

        if (EX_MEM_RegWrite = '1' and EX_MEM_Rdst = ID_EX_Rsrc2) then
            ForwardB <= "10";
            
        elsif (MEM_WB_RegWrite = '1' and MEM_WB_Rdst = ID_EX_Rsrc2) then
            ForwardB <= "01";
        end if;
        
    end process;
end architecture forwardUnitArch;
