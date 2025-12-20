library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity WB_D_Stage is
    port(
        --F_Reg_input
        Imm_32_IN                                                                : in  std_logic_vector(31 downto 0);
        inst, PC                                                                 : in  std_logic_vector(31 downto 0);
        SECOND_SWP                                                               : in  std_logic;
        --WB_Req_input
        WriteAddr                                                                : in  std_logic_vector(2 downto 0);
        Memory_Data, ALU_Data                                                    : in  std_logic_vector(31 downto 0);
        clk                                                                      : in  std_logic;
        rst                                                                      : in  std_logic;
        -- control signals for the WB
        MemToReg, MEMWBRegWrite_IN                                               : in  std_logic;
        SECOND_Imm32_SIGNAL_IN                                                   : in  std_logic;
        MEMWBRegWrite_OUT                                                        : out std_logic;
        PC_Out, ReadData1, ReadData2, Imm_32_OUT, Write_Back_Data_OUT            : out std_logic_vector(31 downto 0);
        func, Rdst, Rsrc1, Rsrc2                                                 : out std_logic_vector(2 downto 0);
        --control unit in/out signals
        EXMEM_MemOp, HWInt                                                       : in  std_logic;
        MemToReg_OUT, RegWrite_OUT, PCStore, MemOp_Inst, MemOp_Priority, MemRead : out std_logic;
        MemWrite, RET, RTI, InputOp, ALUSrc, OutOp                               : out std_logic;
        SWINT, JMPCALL, HLT, PCWrite, SWP, Imm32_SIGNAL                          : out std_logic;
        IFID_EN, IDEX_EN, EXMEM_EN, MEMWB_EN, SECOND_SWP_OUT                     : out std_logic;
        StackOpType, ALUOPType, JMPType                                          : out std_logic_vector(1 downto 0)
    );
end entity WB_D_Stage;

architecture WB_D_Stage_Arch of WB_D_Stage is

    component regFile
        port(
            clk                          : in  std_logic;
            regWrite                     : in  std_logic;
            writeReg, readReg1, readReg2 : in  std_logic_vector(2 downto 0);
            writeData                    : in  std_logic_vector(31 downto 0);
            readData1, readData2         : out std_logic_vector(31 downto 0)
        );
    end component regFile;

    signal Write_Back_Data : std_logic_vector(31 downto 0);

begin
    ControlUnit_inst : entity work.ControlUnit
        port map(
            SECOND_Imm32_SIGNAL_IN => SECOND_Imm32_SIGNAL_IN,
            inst_bits              => inst(31 downto 27),
            EXMEM_MemOp            => EXMEM_MemOp,
            HWInt                  => HWInt,
            MemToReg               => MemToReg_OUT,
            RegWrite               => RegWrite_OUT,
            PCStore                => PCStore,
            MemOp_Inst             => MemOp_Inst,
            MemOp_Priority         => MemOp_Priority,
            MemRead                => MemRead,
            MemWrite               => MemWrite,
            RET                    => RET,
            RTI                    => RTI,
            InputOp                => InputOp,
            ALUSrc                 => ALUSrc,
            OutOp                  => OutOp,
            SWINT                  => SWINT,
            JMPCALL                => JMPCALL,
            HLT                    => HLT,
            PCWrite                => PCWrite,
            SWP                    => SWP,
            Imm32                  => Imm32_SIGNAL,
            IFID_EN                => IFID_EN,
            IDEX_EN                => IDEX_EN,
            EXMEM_EN               => EXMEM_EN,
            MEMWB_EN               => MEMWB_EN,
            StackOpType            => StackOpType,
            ALUOPType              => ALUOPType,
            JMPType                => JMPType
        );

    --Select the data source for the write back from Memory or ALU result   
    Write_Back_Data     <= ALU_Data WHEN MemToReg = '0' ELSE
                           Memory_Data WHEN MemToReg = '1';
    Write_Back_Data_OUT <= Write_Back_Data;
    regfile_inst : regFile
        port map(
            clk       => clk,
            regWrite  => MEMWBRegWrite_IN,
            writeReg  => WriteAddr,
            readReg1  => inst(23 downto 21),
            readReg2  => inst(20 downto 18),
            writeData => Write_Back_Data,
            readData1 => readData1,
            readData2 => readData2
        );

    func           <= inst(2 downto 0);
    Rsrc1          <= inst(23 downto 21);
    Rsrc2          <= inst(20 downto 18);
    Rdst           <= inst(26 downto 24);
    SECOND_SWP_OUT <= SECOND_SWP;
    PC_Out         <= PC;
    Imm_32_OUT     <= std_logic_vector(resize(signed(Imm_32_IN(15 downto 0)), 32));
    -- Imm32<=std_logic_vector(resize(unsigned(Imm_16),32));

    MEMWBRegWrite_OUT <= MEMWBRegWrite_IN;
end architecture WB_D_Stage_Arch;
