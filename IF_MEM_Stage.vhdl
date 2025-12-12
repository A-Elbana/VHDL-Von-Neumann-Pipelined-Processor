library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_MEM_Stage is
    port(
        clk                                                                : in  std_logic;
        rst                                                                : in  std_logic;
        HWInt                                                              : in  std_logic;
        MemOp_Priority_IN                                                  : in  std_logic;
        PCWrite, SWInt, SWP                                                : in  std_logic; -- IF/ID
        interrupt_index                                                    : in  std_logic_vector(1 downto 0); -- IF/ID
        PCStore_IN, MemOp_Inst_IN, MemRead_IN, MemWrite_IN, RET_IN, RTI_IN : in  std_logic; -- M Signals
        StackOpType_IN                                                     : in  std_logic_vector(1 downto 0); -- M Signals
        WB_control_IN                                                      : in  std_logic_vector(1 downto 0);
        PC_IN, StoreData_IN, ALUResult_IN                                  : in  std_logic_vector(31 downto 0); -- Data
        CCR_IN, Rdst_IN                                                    : in  std_logic_vector(2 downto 0); -- Data
        IFID_Imm, IDEX_Imm                                                 : in  std_logic_vector(31 downto 0);
        IDEX_ConditionalJMP                                                : in  std_logic;
        IFID_JMPCALL                                                       : in  std_logic;
        EXMEM_MemOp_Inst, EXMEM_RTI                                        : out std_logic;
        WB_control_OUT                                                     : out std_logic_vector(1 downto 0);
        PC_OUT, readData_OUT, ALUResult_OUT                                : out std_logic_vector(31 downto 0); -- Data
        writeAddr_OUT                                                      : out std_logic_vector(2 downto 0); -- Data
        IFID_FLUSH                                                         : out std_logic;
        Fetched_Inst                                                       : out std_logic_vector(31 downto 0)
    );
end entity IF_MEM_Stage;

architecture RTL of IF_MEM_Stage is

    signal MemWrite, MemRead         : std_logic;
    signal Address                   : std_logic_vector(31 downto 0);
    signal Address_MUX1              : std_logic_vector(31 downto 0);
    signal Address_MUX2              : std_logic_vector(31 downto 0);
    signal writeData                 : std_logic_vector(31 downto 0);
    signal writeData_MUX             : std_logic_vector(31 downto 0);
    signal PC_REG_IN                 : std_logic_vector(31 downto 0);
    signal PC_REG_OUT                : std_logic_vector(31 downto 0);
    signal JMPADDRRESS               : std_logic_vector(31 downto 0);
    signal PC_TO_BE_STORED_AND_FLAGS : std_logic_vector(31 downto 0);
    signal STACKPOINTER              : std_logic_vector(31 downto 0);
    signal INTINDEX                  : std_logic_vector(1 downto 0);
    signal LoadPC                    : std_logic;
    signal INT                       : std_logic;
    signal readData                  : std_logic_vector(31 downto 0);

begin
    -- TODO IFID Register INs (Demuxes and Muxes invloving IFID_SWP and IFID_Imm32)
    WB_control_OUT   <= WB_control_IN;
    writeAddr_OUT    <= Rdst_IN;
    EXMEM_MemOp_Inst <= MemOp_Inst_IN;
    EXMEM_RTI        <= RTI_IN;
    ALUResult_OUT    <= ALUResult_IN;
    Fetched_Inst     <= readData when SWP = '0' else "00010" & readData(26 downto 21) & (20 downto 3 => '0') & "011";

    INT         <= SWINT or HWInt;
    LoadToPCFSM_inst : entity work.LoadToPCFSM
        port map(
            clk             => clk,
            rst             => rst,
            interrupt_index => interrupt_index,
            memOp           => MemOp_Priority_IN,
            INT             => INT,
            LoadPC          => LoadPC,
            int_index       => INTINDEX,
            IFID_FLUSH      => IFID_FLUSH
        );
    PC_OUT      <= PC_REG_OUT;
    JMPADDRRESS <= IDEX_Imm when IDEX_ConditionalJMP = '1' else IFID_Imm;
    PC_REG_IN   <= readData when rst = '1' else readData when (RET_IN or LoadPC) = '1' else JMPADDRRESS when (IFID_JMPCALL or IDEX_ConditionalJMP) = '1' else std_logic_vector(unsigned(PC_REG_OUT) + unsigned(1));
    PC_inst : entity work.PC
        port map(
            clk     => clk,
            reset   => rst,
            PCWrite => PCWrite,
            PC_IN   => PC_REG_IN,
            PC_Out  => PC_REG_OUT
        );

    SP_Block_inst : entity work.SP_Block
        port map(
            clk            => clk,
            rst            => rst,
            StackOpType_IN => StackOpType_IN,
            Stack_OUT      => STACKPOINTER
        );

    MemWrite                  <= (HWInt OR MemWrite_IN) WHEN MemOp_Priority_IN = '1' ELSE '0';
    MemRead                   <= ((not HWInt) AND MemRead_IN) WHEN MemOp_Priority_IN = '1' ELSE '1';
    Address_MUX1              <= STACKPOINTER when (HWInt or StackOpType_IN(1)) = '1' else ALUResult_IN;
    Address_MUX2              <= ((others => '0'), (1 downto 0) => INTINDEX) when LoadPC = '1' else Address_MUX1 when MemOp_Priority_IN = '1' else PC_REG_OUT;
    Address                   <= (31 downto 0 => '0') WHEN MemOp_Priority_IN = '1' ELSE Address_MUX2;
    PC_TO_BE_STORED_AND_FLAGS <= (31 downto 29 => CCR_IN, 28 downto 0 => std_logic_vector(unsigned(PC_IN) + unsigned(1))(28 downto 0));
    writeData_MUX             <= PC_TO_BE_STORED_AND_FLAGS when PCStore_IN = '1' else StoreData_IN;
    writeData                 <= writeData_MUX when HWInt = '1' else (31 downto 29 => CCR_IN, 28 downto 0 => std_logic_vector(unsigned(PC_REG_OUT) + unsigned(1))(28 downto 0));
    Memory_inst : entity work.Memory
        port map(
            clk       => clk,
            MemWrite  => MemWrite,
            MemRead   => MemRead,
            Address   => Address,
            writeData => writeData,
            readData  => readData
        );
    readData_OUT              <= readData;

end architecture RTL;
