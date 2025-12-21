library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity forwardUnit is
    port(
        ID_EX_Rsrc1     : in  std_logic_vector(2 downto 0);
        ID_EX_Rsrc2     : in  std_logic_vector(2 downto 0);
        EX_MEM_Rdst     : in  std_logic_vector(2 downto 0);
        MEM_WB_Rdst     : in  std_logic_vector(2 downto 0); --xxx
        EX_MEM_RegWrite : in  std_logic;
        MEM_WB_RegWrite : in  std_logic;
        ID_EX_Swap      : in  std_logic; 
        ForwardA        : out std_logic_vector(1 downto 0);
        ForwardB        : out std_logic_vector(1 downto 0)
    );
end entity forwardUnit;

architecture forwardUnitArch of forwardUnit is
begin
    -- Combinational Assignment for ForwardA
    ForwardA <= "10" when (EX_MEM_RegWrite = '1' and EX_MEM_Rdst = ID_EX_Rsrc1 and ID_EX_Swap = '0') else
                "01" when (MEM_WB_RegWrite = '1' and MEM_WB_Rdst = ID_EX_Rsrc1) else
                "00";

    -- Combinational Assignment for ForwardB
    ForwardB <= "10" when (EX_MEM_RegWrite = '1' and EX_MEM_Rdst = ID_EX_Rsrc2 and ID_EX_Swap = '0') else
                "01" when (MEM_WB_RegWrite = '1' and MEM_WB_Rdst = ID_EX_Rsrc2) else
                "00";
end architecture forwardUnitArch;
