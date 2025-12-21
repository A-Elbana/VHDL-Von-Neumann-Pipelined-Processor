library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity HazardUnit is
    port(
        IFID_Rsrc1, IFID_Rsrc2, IDEX_Rdst : in std_logic_vector(2 downto 0);
        IFID_JMPCALL, IFID_RET, IFID_HLT, Rsrc1_Used, Rsrc2_Used : in  std_logic; -- IFID
        IDEX_MemRead, IDEX_ConditionalJMP                                     : in  std_logic; -- IDEX
        EX_MEM_RET                                                                       : in  std_logic; -- EXMEM
        HU_IFID_FLUSH, HU_IFID_EN, HU_IDEX_FLUSH, HU_EXMEM_FLUSH, HU_PCWrite_OUT         : out std_logic
    );
end entity HazardUnit;

architecture RTL of HazardUnit is
    signal LoadUse      : std_logic;
    signal JumpConflict : std_logic;

begin
    LoadUse        <= '1' when 
                (
                (((IFID_Rsrc1 = IDEX_Rdst) and (Rsrc1_Used = '1'))
                 or 
                ((IFID_Rsrc2 = IDEX_Rdst) and (Rsrc2_Used = '1')))
                 and 
                 (IDEX_MemRead = '1')
                 )
                  else '0';
    JumpConflict   <= '1' when (IDEX_ConditionalJMP and IFID_JMPCALL) = '1' else '0';
    HU_IFID_EN     <= LoadUse or (IFID_RET and not IDEX_ConditionalJMP and not EX_MEM_RET);
    HU_IFID_FLUSH  <= JumpConflict or (IFID_JMPCALL) or (IDEX_ConditionalJMP) or (IFID_RET and EX_MEM_RET);
    HU_IDEX_FLUSH  <= LoadUse or JumpConflict or (IDEX_ConditionalJMP) or (IFID_RET and EX_MEM_RET);
    HU_EXMEM_FLUSH <= (IFID_RET and EX_MEM_RET);
    HU_PCWrite_OUT <= LoadUse or (IFID_HLT and not IDEX_ConditionalJMP) or (IFID_RET and not IDEX_ConditionalJMP and not EX_MEM_RET);

end architecture RTL;
