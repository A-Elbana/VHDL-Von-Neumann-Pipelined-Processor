library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IF_MEM_Stage is
    port(
        clk                                                                : in  std_logic;
        rst                                                                : in  std_logic;
        HWInt                                                              : in  std_logic;
        MemOp_Priority_IN                                                  : in  std_logic;
        PCWrite, IFID_SWInt                                                : in  std_logic; -- IF/ID
        interrupt_index                                                    : in  std_logic; -- IF/ID
        EXMEM_EN                                                           : in  std_logic;
        PCStore_IN, MemOp_Inst_IN, MemRead_IN, MemWrite_IN, RET_IN, RTI_IN : in  std_logic; -- M Signals
        EXMEM_SWINT                                                        : in  std_logic;
        StackOpType_IN                                                     : in  std_logic_vector(1 downto 0); -- M Signals
        MemToReg_IN, RegWrite_IN                                           : in  std_logic;
        PC_IN, StoreData_IN, ALUResult_IN                                  : in  std_logic_vector(31 downto 0); -- Data
        CCR_IN, Rdst_IN                                                    : in  std_logic_vector(2 downto 0); -- Data
        IDEX_Imm                                                           : in  std_logic_vector(31 downto 0);
        IDEX_ConditionalJMP                                                : in  std_logic;
        IFID_JMPCALL                                                       : in  std_logic;
        IFID_SWP                                                           : in  std_logic;
        IFID_Imm32_SIGNAL                                                  : in  std_logic;
        IFID_Rsrc1                                                         : in  std_logic_vector(2 downto 0);
        IFID_Rdst                                                          : in  std_logic_vector(2 downto 0);
        IF_Imm                                                             : out std_logic_vector(31 downto 0);
        EXMEM_MemOp_Inst, EXMEM_RTI                                        : out std_logic;
        EXMEM_CCR_OUT                                                      : out  std_logic_vector(2 downto 0);
        MemToReg_OUT, RegWrite_OUT                                         : out std_logic;
        PC_OUT, readData_OUT, ALUResult_OUT                                : out std_logic_vector(31 downto 0); -- Data
        writeAddr_OUT                                                      : out std_logic_vector(2 downto 0); -- Data
        IFID_FLUSH                                                         : out std_logic;
        Fetched_Inst                                                       : out std_logic_vector(31 downto 0);
        RET_OUT                                                            : out std_logic
    );
end entity IF_MEM_Stage;

architecture RTL of IF_MEM_Stage is

    signal MemWrite, MemRead           : std_logic;
    signal Address                     : std_logic_vector(31 downto 0);
    signal Address_MUX1                : std_logic_vector(31 downto 0);
    signal Address_MUX2                : std_logic_vector(31 downto 0);
    signal Address_MUX3                : std_logic_vector(31 downto 0);
    signal Address_MUX2_Intermediate   : std_logic_vector(31 downto 0);
    signal writeData                   : std_logic_vector(31 downto 0);
    signal writeData_MUX               : std_logic_vector(31 downto 0);
    signal PC_REG_IN                   : std_logic_vector(31 downto 0);
    signal PC_REG_OUT                  : std_logic_vector(31 downto 0);
    signal JMPADDRESS                  : std_logic_vector(31 downto 0);
    signal PC_TO_BE_STORED_AND_FLAGS   : std_logic_vector(31 downto 0);
    signal STACKPOINTER                : std_logic_vector(31 downto 0);
    signal INTINDEX                    : std_logic_vector(1 downto 0);
    signal LoadPC                      : std_logic;
    signal INT                         : std_logic;
    signal readData                    : std_logic_vector(31 downto 0);
    signal demuxInst                   : std_logic_vector(31 downto 0);
    signal demuxInst2                  : std_logic_vector(31 downto 0);
    signal SECOND_SWP_INST             : std_logic_vector(31 downto 0);
    signal PC_IN_ADD                   : std_logic_vector(31 downto 0);
    signal intermediate, intermediate2 : std_logic_vector(31 downto 0);
    signal StackOpType_HWINT_IN        : std_logic_vector(1 downto 0);
    signal interrupt_index_MUX         : std_logic_vector(1 downto 0);

begin
    PC_IN_ADD       <= std_logic_vector(unsigned(PC_IN) + to_unsigned(1, 32)) when EXMEM_SWINT = '1' else std_logic_vector(unsigned(PC_IN) + to_unsigned(2, 32));
    -- TODO IFID Register INs (Demuxes and Muxes involving IFID_SWP and IFID_Imm32)
    RET_OUT         <= RET_IN or RTI_IN;
    SECOND_SWP_INST <= "00010" & IFID_Rsrc1 & IFID_Rdst & "000000000000000000" & "011";
    IF_Imm          <= readData when IFID_Imm32_SIGNAL = '1' else (others => '0');
    demuxInst2      <= readData when MemOp_Priority_IN = '0' else (others => '0');
    demuxInst       <= demuxInst2 when IFID_Imm32_SIGNAL = '0' else (others => '0');
    Fetched_Inst    <= SECOND_SWP_INST when IFID_SWP = '1' else demuxInst;

    RegWrite_OUT     <= RegWrite_IN;
    MemToReg_OUT     <= MemToReg_IN;
    writeAddr_OUT    <= Rdst_IN;
    EXMEM_MemOp_Inst <= MemOp_Inst_IN;
    EXMEM_RTI        <= RTI_IN;
    ALUResult_OUT    <= ALUResult_IN;

    INT                 <= IFID_SWInt or HWInt;
    interrupt_index_MUX <= "01" when HWInt = '1' else
                           '1' & interrupt_index;
    LoadToPCFSM_inst : entity work.LoadToPCFSM
        port map(
            clk             => clk,
            rst             => rst,
            interrupt_index => interrupt_index_MUX,
            memOp           => MemOp_Priority_IN,
            INT             => INT,
            LoadPC          => LoadPC,
            int_index       => INTINDEX,
            IFID_FLUSH      => IFID_FLUSH
        );
    PC_OUT              <= "000" & PC_REG_OUT(28 downto 0);
    JMPADDRESS          <= IDEX_Imm when IDEX_ConditionalJMP = '1' else readData;
    intermediate2       <= JMPADDRESS when (IFID_JMPCALL or IDEX_ConditionalJMP) = '1' else std_logic_vector(unsigned(PC_REG_OUT) + to_unsigned(1, 32));
    intermediate        <= readData when (RET_IN or LoadPC) = '1' else intermediate2;
    PC_REG_IN           <= readData when rst = '1' else intermediate;
    PC_inst : entity work.PC
        port map(
            clk     => clk,
            reset   => rst,
            PCWrite => PCWrite,
            PC_IN   => PC_REG_IN,
            PC_Out  => PC_REG_OUT
        );

    StackOpType_HWINT_IN <= "10" when HWInt = '1' else StackOpType_IN;
    SP_Block_inst : entity work.SP_Block
        port map(
            clk            => clk,
            rst            => rst,
            en             => EXMEM_EN,
            StackOpType_IN => StackOpType_HWINT_IN,
            Stack_OUT      => STACKPOINTER
        );

    MemWrite                  <= (HWInt OR MemWrite_IN) WHEN MemOp_Priority_IN = '1' ELSE '0';
    MemRead                   <= ((not HWInt) AND MemRead_IN) WHEN MemOp_Priority_IN = '1' ELSE '1';
    Address_MUX1              <= STACKPOINTER when (HWInt or StackOpType_IN(1)) = '1' else ALUResult_IN;
    EXMEM_CCR_OUT <= readData(31 downto 29);
    Address_MUX2_Intermediate <= Address_MUX1 when MemOp_Priority_IN = '1' else "000" & PC_REG_OUT(28 downto 0);

    Address_MUX2              <= (31 downto 2 => '0') & INTINDEX when LoadPC = '1' else Address_MUX2_Intermediate;
    Address_MUX3              <= Address_MUX2 when (StackOpType_IN(1) or HWInt) = '1' else
                                 (31 downto 16 => '0') & Address_MUX2(15 downto 0) when MemOp_Priority_IN = '1' else
                                 Address_MUX2;
    Address                   <= (31 downto 0 => '0') WHEN rst = '1' ELSE Address_MUX3;
    PC_TO_BE_STORED_AND_FLAGS <= CCR_IN & PC_IN_ADD(28 downto 0);
    writeData_MUX             <= PC_TO_BE_STORED_AND_FLAGS when PCStore_IN = '1' else StoreData_IN;
    writeData                 <= CCR_IN & PC_REG_OUT(28 downto 0) when HWInt = '1' else writeData_MUX;
    Memory_inst : entity work.Memory
        port map(
            clk       => clk,
            HWInt     => HWInt,
            MemWrite  => MemWrite,
            MemRead   => MemRead,
            Address   => Address,
            writeData => writeData,
            readData  => readData
        );
    readData_OUT              <= readData;

end architecture RTL;
