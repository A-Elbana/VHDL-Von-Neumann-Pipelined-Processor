library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_MEM_Stage is
    port(
        clk                                                                : in  std_logic;
        rst                                                                : in  std_logic;
        HWInt                                                              : in  std_logic;
        MemOp_Priority_IN                                                  : in  std_logic;
        LoadPC_IN                                                          : in  std_logic;
        PCStore_IN, MemOp_Inst_IN, MemRead_IN, MemWrite_IN, RET_IN, RTI_IN : in  std_logic; -- M Signals
        WB_control_IN                                                      : in  std_logic_vector(1 downto 0);
        PC_IN, StoreData_IN                                                : in  std_logic_vector(31 downto 0); -- Data
        CCR_IN, Rdst_IN                                                    : in  std_logic_vector(2 downto 0); -- Data
        IFID_Imm, IDEX_Imm                                                 : in  std_logic_vector(31 downto 0);
        IDEX_ConditionalJMP                                                : in  std_logic;
        IFID_JMPCALL                                                       : in  std_logic;
        WB_control_OUT                                                     : out std_logic_vector(1 downto 0);
        PC_OUT, readData_OUT                                               : out std_logic_vector(31 downto 0); -- Data
        Rdst_OUT                                                           : out std_logic_vector(2 downto 0) -- Data
    );
end entity IF_MEM_Stage;

architecture RTL of IF_MEM_Stage is

    signal MemWrite, MemRead   : std_logic;
    signal Address             : std_logic_vector(31 downto 0);
    signal Address_MUX1        : std_logic_vector(31 downto 0);
    signal Address_MUX2        : std_logic_vector(31 downto 0);
    signal writeData           : std_logic_vector(31 downto 0);
    signal writeData_MUX       : std_logic_vector(31 downto 0);
    signal PC_REG_IN           : std_logic_vector(31 downto 0);
    signal PC_REG_OUT          : std_logic_vector(31 downto 0);
    signal JMPADDRRESS         : std_logic_vector(31 downto 0);
    signal STORED_PC_AND_FLAGS : std_logic_vector(31 downto 0);

begin

    PC_OUT      <= PC_REG_OUT;
    JMPADDRRESS <= IDEX_Imm when IDEX_ConditionalJMP else IFID_Imm;
    PC_REG_IN   <= readData_OUT when rst else readData_OUT when (RET_IN or LoadPC_IN) else JMPADDRRESS when (IFID_JMPCALL or IDEX_ConditionalJMP) else std_logic_vector(unsigned(PC_REG_OUT) + unsigned(1));
    PC_inst : entity work.PC
        port map(
            clk     => clk,
            reset   => rst,
            PCWrite => PCWrite,
            PC_IN   => PC_REG_IN,
            PC_Out  => PC_REG_OUT
        );

    MemWrite            <= (HWInt OR MemWrite_IN) WHEN MemOp_Priority_IN ELSE '0';
    MemRead             <= ((not HWInt) AND MemRead_IN) WHEN MemOp_Priority_IN ELSE '1';
    Address            <= (31 downto 0 => '0') WHEN MemOp_Priority_IN ELSE ();
    STORED_PC_AND_FLAGS <= (31 downto 29 => CCR_IN, 28 downto 0 => std_logic_vector(unsigned(PC_IN) + unsigned(1))(28 downto 0));
    writeData_MUX       <= STORED_PC_AND_FLAGS when PCStore_IN else StoreData_IN;
    writeData           <= writeData_MUX when HWInt else PC_REG_OUT;
    Memory_inst : entity work.Memory
        port map(
            clk       => clk,
            MemWrite  => MemWrite,
            MemRead   => MemRead,
            Address   => Address,
            writeData => writeData,
            readData  => readData_OUT
        );

end architecture RTL;
