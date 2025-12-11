library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity D_EX_integration is
    port(
        clk                   : in  std_logic;
        rst                   : in  std_logic;
        -- External inputs
        INPort                : in  std_logic_vector(31 downto 0);
        HWInt                 : in  std_logic;
        -- IF stage inputs (from memory/fetch)
        IFID_Immediate_IN     : in  std_logic_vector(31 downto 0);
        IFID_PC_IN            : in  std_logic_vector(31 downto 0);
        IFID_Instruction_IN   : in  std_logic_vector(31 downto 0);
        IFID_SWP_IN           : in  std_logic;
        IFID_flush            : in  std_logic;
        -- WB stage inputs (from MEMWB register)
        WB_WriteAddr          : in  std_logic_vector(2 downto 0);
        WB_Memory_Data        : in  std_logic_vector(31 downto 0);
        WB_ALU_Data           : in  std_logic_vector(31 downto 0);
        WB_MemToReg           : in  std_logic;
        WB_RegWrite           : in  std_logic;
        -- Flush signals
        IDEX_flush            : in  std_logic;
        EXMEM_flush           : in  std_logic;
        -- External EXMEM_MemOp input for control unit
        EXMEM_MemOp_IN        : in  std_logic;
        -- Outputs from EXMEM register (to MEM stage)
        EXMEM_MemToReg_OUT    : out std_logic;
        EXMEM_RegWrite_OUT    : out std_logic;
        EXMEM_PCStore_OUT     : out std_logic;
        EXMEM_MemOp_Inst_OUT  : out std_logic;
        EXMEM_MemRead_OUT     : out std_logic;
        EXMEM_MemWrite_OUT    : out std_logic;
        EXMEM_RET_OUT         : out std_logic;
        EXMEM_RTI_OUT         : out std_logic;
        EXMEM_StackOpType_OUT : out std_logic_vector(1 downto 0);
        EXMEM_PC_OUT          : out std_logic_vector(31 downto 0);
        EXMEM_StoreData_OUT   : out std_logic_vector(31 downto 0);
        EXMEM_ALUResult_OUT   : out std_logic_vector(31 downto 0);
        EXMEM_CCR_OUT         : out std_logic_vector(2 downto 0);
        EXMEM_Rdst_OUT        : out std_logic_vector(2 downto 0);
        -- Control outputs
        OUTPORT               : out std_logic_vector(31 downto 0);
        ConditionalJMP        : out std_logic;
        RegWrite_Fwd          : out std_logic;
        HLT_OUT               : out std_logic;
        PCWrite_OUT           : out std_logic;
        MemOp_Priority_OUT    : out std_logic;
        Imm32_OUT             : out std_logic;
        -- Enable outputs for pipeline registers
        IFID_EN_OUT           : out std_logic;
        IDEX_EN_OUT           : out std_logic;
        EXMEM_EN_OUT          : out std_logic;
        MEMWB_EN_OUT          : out std_logic
    );
end entity D_EX_integration;

architecture rtl of D_EX_integration is

    -- Component declarations
    component IFIDRegister is
        port(
            clk                                    : in  std_logic;
            rst                                    : in  std_logic;
            en                                     : in  std_logic;
            flush                                  : in  std_logic;
            SWP_IN                                 : in  std_logic;
            Immediate_IN, PC_IN, Instruction_IN    : in  std_logic_vector(31 downto 0);
            SWP_OUT                                : out std_logic;
            Immediate_OUT, PC_OUT, Instruction_OUT : out std_logic_vector(31 downto 0)
        );
    end component IFIDRegister;

    component IDEXRegister is
        port(
            clk                                                                                   : in  std_logic;
            rst                                                                                   : in  std_logic;
            en                                                                                    : in  std_logic;
            flush                                                                                 : in  std_logic;
            MemToReg_IN, RegWrite_IN                                                              : in  std_logic; -- WB Signals
            PCStore_IN, MemOp_Inst_IN, MemRead_IN, MemWrite_IN, RET_IN, RTI_IN, InputOp_IN        : in  std_logic; -- M Signals
            ALUSrc_IN, OutOp_IN, SWINT_IN, JMPCALL_IN, SWP_IN                                     : in  std_logic; -- EX Signals
            ALUOPType_IN, JMPType_IN                                                              : in  std_logic_vector(1 downto 0); -- EX Signals
            StackOpType_IN                                                                        : in  std_logic_vector(1 downto 0); -- M Signals
            PC_IN, ReadData1_IN, ReadData2_IN, Immediate_IN                                       : in  std_logic_vector(31 downto 0); -- Data
            Rsrc1_IN, Rsrc2_IN, Rdst_IN, Funct_IN                                                 : in  std_logic_vector(2 downto 0); -- Data
            MemToReg_OUT, RegWrite_OUT                                                            : out std_logic; -- WB Signals
            PCStore_OUT, MemOp_Inst_OUT, MemRead_OUT, MemWrite_OUT, RET_OUT, RTI_OUT, InputOp_OUT : out std_logic; -- M Signals
            ALUSrc_OUT, OutOp_OUT, SWINT_OUT, JMPCALL_OUT, SWP_OUT                                : out std_logic; -- EX Signals
            ALUOPType_OUT, JMPType_OUT                                                            : out std_logic_vector(1 downto 0); -- EX Signals
            StackOpType_OUT                                                                       : out std_logic_vector(1 downto 0); -- M Signals
            PC_OUT, ReadData1_OUT, ReadData2_OUT, Immediate_OUT                                   : out std_logic_vector(31 downto 0); -- Data
            Rsrc1_OUT, Rsrc2_OUT, Rdst_OUT, Funct_OUT                                             : out std_logic_vector(2 downto 0) -- Data
        );
    end component IDEXRegister;

    component EXMEMRegister is
        port(
            clk                                                                      : in  std_logic;
            rst                                                                      : in  std_logic;
            en                                                                       : in  std_logic;
            flush                                                                    : in  std_logic;
            MemToReg_IN, RegWrite_IN                                                 : in  std_logic; -- WB Signals
            PCStore_IN, MemOp_Inst_IN, MemRead_IN, MemWrite_IN, RET_IN, RTI_IN       : in  std_logic; -- M Signals
            StackOpType_IN                                                           : in  std_logic_vector(1 downto 0); -- M Signals
            PC_IN, StoreData_IN, ALUResult_IN                                        : in  std_logic_vector(31 downto 0); -- Data
            CCR_IN, Rdst_IN                                                          : in  std_logic_vector(2 downto 0); -- Data
            MemToReg_OUT, RegWrite_OUT                                               : out std_logic; -- WB Signals
            PCStore_OUT, MemOp_Inst_OUT, MemRead_OUT, MemWrite_OUT, RET_OUT, RTI_OUT : out std_logic; -- M Signals
            StackOpType_OUT                                                          : out std_logic_vector(1 downto 0); -- M Signals
            PC_OUT, StoreData_OUT, ALUResult_OUT                                     : out std_logic_vector(31 downto 0); -- Data
            CCR_OUT, Rdst_OUT                                                        : out std_logic_vector(2 downto 0) -- Data
        );
    end component EXMEMRegister;

    component WB_D_Stage is
        port(
            --F_Reg_input
            Imm_16                                                                   : in  std_logic_vector(15 downto 0);
            inst, PC                                                                 : in  std_logic_vector(31 downto 0);
            SECOND_SWP                                                               : in  std_logic;
            --WB_Req_input
            WriteAddr                                                                : in  std_logic_vector(2 downto 0);
            Memory_Data, ALU_Data                                                    : in  std_logic_vector(31 downto 0);
            clk                                                                      : in  std_logic;
            rst                                                                      : in  std_logic;
            -- control signals for the WB
            MemToReg, RegWrite                                                       : in  std_logic;
            RegWrite_Forwarding                                                      : out std_logic;
            PC_Out, ReadData1, ReadData2, Imm_32                                     : out std_logic_vector(31 downto 0);
            func, Rdst, Rsrc1, Rsrc2                                                 : out std_logic_vector(2 downto 0);
            --control unit in/out signals
            EXMEM_MemOp, HWInt                                                       : in  std_logic;
            MemToReg_OUT, RegWrite_OUT, PCStore, MemOp_Inst, MemOp_Priority, MemRead : out std_logic;
            MemWrite, RET, RTI, InputOp, ALUSrc, OutOp                               : out std_logic;
            SWINT, JMPCALL, HLT, PCWrite, SWP, Imm32                                 : out std_logic;
            IFID_EN, IDEX_EN, EXMEM_EN, MEMWB_EN, SECOND_SWP_OUT                     : out std_logic;
            StackOpType, ALUOPType, JMPType                                          : out std_logic_vector(1 downto 0)
        );
    end component WB_D_Stage;

    component EX_Stage
        port(
            PC, ReadData1, ReadData2, Imm, INPort : in  std_logic_vector(31 downto 0);
            func, Rdst, Rsrc1, Rsrc2              : in  std_logic_vector(2 downto 0);
            JumpType, AluOP                       : in  std_logic_vector(1 downto 0);
            Swap, AluSrc, OutOP, InputOp          : in  std_logic;
            M_control                             : in  std_logic_vector(7 downto 0);
            WB_control                            : in  std_logic_vector(1 downto 0);
            clk                                   : in  std_logic;
            rst                                   : in  std_logic;
            PC_Out, ALUResult, StoreData, OUTPORT : out std_logic_vector(31 downto 0);
            CCR                                   : out std_logic_vector(2 downto 0);
            M_out_Control                         : out std_logic_vector(7 downto 0);
            WB_out_Control                        : out std_logic_vector(1 downto 0);
            ConditionalJMP                        : out std_logic
        );
    end component EX_Stage;

    -- ============================================================
    -- Signals between IFID Register and WB_D_Stage (Decode Stage)
    -- ============================================================
    signal ifid_to_decode_immediate   : std_logic_vector(31 downto 0);
    signal ifid_to_decode_pc          : std_logic_vector(31 downto 0);
    signal ifid_to_decode_instruction : std_logic_vector(31 downto 0);
    signal ifid_to_decode_swp         : std_logic;

    -- ============================================================
    -- Signals from WB_D_Stage (Decode Stage) to IDEXRegister
    -- ============================================================
    -- Control signals
    signal decode_MemToReg       : std_logic;
    signal decode_RegWrite       : std_logic;
    signal decode_PCStore        : std_logic;
    signal decode_MemOp_Inst     : std_logic;
    signal decode_MemRead        : std_logic;
    signal decode_MemWrite       : std_logic;
    signal decode_RET            : std_logic;
    signal decode_RTI            : std_logic;
    signal decode_InputOp        : std_logic;
    signal decode_ALUSrc         : std_logic;
    signal decode_OutOp          : std_logic;
    signal decode_SWINT          : std_logic;
    signal decode_JMPCALL        : std_logic;
    signal decode_SWP            : std_logic;
    signal decode_StackOpType    : std_logic_vector(1 downto 0);
    signal decode_ALUOPType      : std_logic_vector(1 downto 0);
    signal decode_JMPType        : std_logic_vector(1 downto 0);
    -- Data signals
    signal decode_PC             : std_logic_vector(31 downto 0);
    signal decode_ReadData1      : std_logic_vector(31 downto 0);
    signal decode_ReadData2      : std_logic_vector(31 downto 0);
    signal decode_Imm_32         : std_logic_vector(31 downto 0);
    signal decode_func           : std_logic_vector(2 downto 0);
    signal decode_Rdst           : std_logic_vector(2 downto 0);
    signal decode_Rsrc1          : std_logic_vector(2 downto 0);
    signal decode_Rsrc2          : std_logic_vector(2 downto 0);
    -- Enable signals
    signal decode_IFID_EN        : std_logic;
    signal decode_IDEX_EN        : std_logic;
    signal decode_EXMEM_EN       : std_logic;
    signal decode_MEMWB_EN       : std_logic;
    signal decode_SECOND_SWP_OUT : std_logic;
    -- Other control
    signal decode_HLT            : std_logic;
    signal decode_PCWrite        : std_logic;
    signal decode_MemOp_Priority : std_logic;
    signal decode_Imm32          : std_logic;
    signal decode_RegWrite_Fwd   : std_logic;

    -- ============================================================
    -- Signals from IDEXRegister to EX_Stage
    -- ============================================================
    -- Control signals
    signal idex_MemToReg    : std_logic;
    signal idex_RegWrite    : std_logic;
    signal idex_PCStore     : std_logic;
    signal idex_MemOp_Inst  : std_logic;
    signal idex_MemRead     : std_logic;
    signal idex_MemWrite    : std_logic;
    signal idex_RET         : std_logic;
    signal idex_RTI         : std_logic;
    signal idex_InputOp     : std_logic;
    signal idex_ALUSrc      : std_logic;
    signal idex_OutOp       : std_logic;
    signal idex_SWINT       : std_logic;
    signal idex_JMPCALL     : std_logic;
    signal idex_SWP         : std_logic;
    signal idex_StackOpType : std_logic_vector(1 downto 0);
    signal idex_ALUOPType   : std_logic_vector(1 downto 0);
    signal idex_JMPType     : std_logic_vector(1 downto 0);
    -- Data signals
    signal idex_PC          : std_logic_vector(31 downto 0);
    signal idex_ReadData1   : std_logic_vector(31 downto 0);
    signal idex_ReadData2   : std_logic_vector(31 downto 0);
    signal idex_Immediate   : std_logic_vector(31 downto 0);
    signal idex_func        : std_logic_vector(2 downto 0);
    signal idex_Rdst        : std_logic_vector(2 downto 0);
    signal idex_Rsrc1       : std_logic_vector(2 downto 0);
    signal idex_Rsrc2       : std_logic_vector(2 downto 0);

    -- ============================================================
    -- Signals from EX_Stage to EXMEMRegister
    -- ============================================================
    signal ex_PC_Out         : std_logic_vector(31 downto 0);
    signal ex_ALUResult      : std_logic_vector(31 downto 0);
    signal ex_StoreData      : std_logic_vector(31 downto 0);
    signal ex_OUTPORT        : std_logic_vector(31 downto 0);
    signal ex_CCR            : std_logic_vector(2 downto 0);
    signal ex_M_out_Control  : std_logic_vector(7 downto 0);
    signal ex_WB_out_Control : std_logic_vector(1 downto 0);
    signal ex_ConditionalJMP : std_logic;

    -- M_control and WB_control signals for EX_Stage input
    signal idex_M_control  : std_logic_vector(7 downto 0);
    signal idex_WB_control : std_logic_vector(1 downto 0);

begin

    -- ============================================================
    -- IFID Register Instance
    -- Flow: External inputs -> IFID Register -> WB_D_Stage
    -- ============================================================
    IFID_Reg_inst : IFIDRegister
        port map(
            clk             => clk,
            rst             => rst,
            en              => decode_IFID_EN,
            flush           => IFID_flush,
            SWP_IN          => IFID_SWP_IN,
            Immediate_IN    => IFID_Immediate_IN,
            PC_IN           => IFID_PC_IN,
            Instruction_IN  => IFID_Instruction_IN,
            SWP_OUT         => ifid_to_decode_swp,
            Immediate_OUT   => ifid_to_decode_immediate,
            PC_OUT          => ifid_to_decode_pc,
            Instruction_OUT => ifid_to_decode_instruction
        );

    -- ============================================================
    -- WB_D_Stage Instance (Decode Stage)
    -- Flow: IFID Register outputs -> WB_D_Stage -> IDEX Register
    -- ============================================================
    WB_D_Stage_inst : WB_D_Stage
        port map(
            -- Inputs from IFID Register
            Imm_16              => ifid_to_decode_immediate(15 downto 0),
            inst                => ifid_to_decode_instruction,
            PC                  => ifid_to_decode_pc,
            SECOND_SWP          => ifid_to_decode_swp,
            -- Inputs from WB stage (external)
            WriteAddr           => WB_WriteAddr,
            Memory_Data         => WB_Memory_Data,
            ALU_Data            => WB_ALU_Data,
            clk                 => clk,
            rst                 => rst,
            MemToReg            => WB_MemToReg,
            RegWrite            => WB_RegWrite,
            -- Control input
            EXMEM_MemOp         => EXMEM_MemOp_IN,
            HWInt               => HWInt,
            -- Data outputs to IDEX Register
            RegWrite_Forwarding => decode_RegWrite_Fwd,
            PC_Out              => decode_PC,
            ReadData1           => decode_ReadData1,
            ReadData2           => decode_ReadData2,
            Imm_32              => decode_Imm_32,
            func                => decode_func,
            Rdst                => decode_Rdst,
            Rsrc1               => decode_Rsrc1,
            Rsrc2               => decode_Rsrc2,
            -- Control outputs to IDEX Register
            MemToReg_OUT        => decode_MemToReg,
            RegWrite_OUT        => decode_RegWrite,
            PCStore             => decode_PCStore,
            MemOp_Inst          => decode_MemOp_Inst,
            MemOp_Priority      => decode_MemOp_Priority,
            MemRead             => decode_MemRead,
            MemWrite            => decode_MemWrite,
            RET                 => decode_RET,
            RTI                 => decode_RTI,
            InputOp             => decode_InputOp,
            ALUSrc              => decode_ALUSrc,
            OutOp               => decode_OutOp,
            SWINT               => decode_SWINT,
            JMPCALL             => decode_JMPCALL,
            HLT                 => decode_HLT,
            PCWrite             => decode_PCWrite,
            SWP                 => decode_SWP,
            Imm32               => decode_Imm32,
            IFID_EN             => decode_IFID_EN,
            IDEX_EN             => decode_IDEX_EN,
            EXMEM_EN            => decode_EXMEM_EN,
            MEMWB_EN            => decode_MEMWB_EN,
            SECOND_SWP_OUT      => decode_SECOND_SWP_OUT,
            StackOpType         => decode_StackOpType,
            ALUOPType           => decode_ALUOPType,
            JMPType             => decode_JMPType
        );

    -- ============================================================
    -- IDEX Register Instance
    -- Flow: WB_D_Stage outputs -> IDEX Register -> EX_Stage
    -- ============================================================
    IDEX_Reg_inst : IDEXRegister
        port map(
            clk             => clk,
            rst             => rst,
            en              => decode_IDEX_EN,
            flush           => IDEX_flush,
            -- WB signals input
            MemToReg_IN     => decode_MemToReg,
            RegWrite_IN     => decode_RegWrite,
            -- M signals input
            PCStore_IN      => decode_PCStore,
            MemOp_Inst_IN   => decode_MemOp_Inst,
            MemRead_IN      => decode_MemRead,
            MemWrite_IN     => decode_MemWrite,
            RET_IN          => decode_RET,
            RTI_IN          => decode_RTI,
            InputOp_IN      => decode_InputOp,
            StackOpType_IN  => decode_StackOpType,
            -- EX signals input
            ALUSrc_IN       => decode_ALUSrc,
            OutOp_IN        => decode_OutOp,
            SWINT_IN        => decode_SWINT,
            JMPCALL_IN      => decode_JMPCALL,
            SWP_IN          => decode_SWP,
            ALUOPType_IN    => decode_ALUOPType,
            JMPType_IN      => decode_JMPType,
            -- Data input
            PC_IN           => decode_PC,
            ReadData1_IN    => decode_ReadData1,
            ReadData2_IN    => decode_ReadData2,
            Immediate_IN    => decode_Imm_32,
            Rsrc1_IN        => decode_Rsrc1,
            Rsrc2_IN        => decode_Rsrc2,
            Rdst_IN         => decode_Rdst,
            Funct_IN        => decode_func,
            -- WB signals output
            MemToReg_OUT    => idex_MemToReg,
            RegWrite_OUT    => idex_RegWrite,
            -- M signals output
            PCStore_OUT     => idex_PCStore,
            MemOp_Inst_OUT  => idex_MemOp_Inst,
            MemRead_OUT     => idex_MemRead,
            MemWrite_OUT    => idex_MemWrite,
            RET_OUT         => idex_RET,
            RTI_OUT         => idex_RTI,
            InputOp_OUT     => idex_InputOp,
            StackOpType_OUT => idex_StackOpType,
            -- EX signals output
            ALUSrc_OUT      => idex_ALUSrc,
            OutOp_OUT       => idex_OutOp,
            SWINT_OUT       => idex_SWINT,
            JMPCALL_OUT     => idex_JMPCALL,
            SWP_OUT         => idex_SWP,
            ALUOPType_OUT   => idex_ALUOPType,
            JMPType_OUT     => idex_JMPType,
            -- Data output
            PC_OUT          => idex_PC,
            ReadData1_OUT   => idex_ReadData1,
            ReadData2_OUT   => idex_ReadData2,
            Immediate_OUT   => idex_Immediate,
            Rsrc1_OUT       => idex_Rsrc1,
            Rsrc2_OUT       => idex_Rsrc2,
            Rdst_OUT        => idex_Rdst,
            Funct_OUT       => idex_func
        );

    -- Build M_control and WB_control vectors for EX_Stage
    -- M_control(7 downto 0) = PCStore & MemOp_Inst & MemRead & MemWrite & RET & RTI & StackOpType(1 downto 0)
    idex_M_control  <= idex_PCStore & idex_MemOp_Inst & idex_MemRead & idex_MemWrite & idex_RET & idex_RTI & idex_StackOpType;
    -- WB_control(1 downto 0) = MemToReg & RegWrite
    idex_WB_control <= idex_MemToReg & idex_RegWrite;

    -- ============================================================
    -- EX_Stage Instance (Execution Stage)
    -- Flow: IDEX Register outputs -> EX_Stage -> EXMEM Register
    -- ============================================================
    EX_Stage_inst : EX_Stage
        port map(
            PC             => idex_PC,
            ReadData1      => idex_ReadData1,
            ReadData2      => idex_ReadData2,
            Imm            => idex_Immediate,
            INPort         => INPort,
            func           => idex_func,
            Rdst           => idex_Rdst,
            Rsrc1          => idex_Rsrc1,
            Rsrc2          => idex_Rsrc2,
            JumpType       => idex_JMPType,
            AluOP          => idex_ALUOPType,
            Swap           => idex_SWP,
            AluSrc         => idex_ALUSrc,
            OutOP          => idex_OutOp,
            InputOp        => idex_InputOp,
            M_control      => idex_M_control,
            WB_control     => idex_WB_control,
            clk            => clk,
            rst            => rst,
            PC_Out         => ex_PC_Out,
            ALUResult      => ex_ALUResult,
            StoreData      => ex_StoreData,
            OUTPORT        => ex_OUTPORT,
            CCR            => ex_CCR,
            M_out_Control  => ex_M_out_Control,
            WB_out_Control => ex_WB_out_Control,
            ConditionalJMP => ex_ConditionalJMP
        );

    -- ============================================================
    -- EXMEM Register Instance
    -- Flow: EX_Stage outputs -> EXMEM Register -> MEM Stage (external)
    -- ============================================================
    EXMEM_Reg_inst : EXMEMRegister
        port map(
            clk             => clk,
            rst             => rst,
            en              => decode_EXMEM_EN,
            flush           => EXMEM_flush,
            -- WB signals input (from EX_Stage WB_out_Control)
            MemToReg_IN     => ex_WB_out_Control(1),
            RegWrite_IN     => ex_WB_out_Control(0),
            -- M signals input (from EX_Stage M_out_Control)
            PCStore_IN      => ex_M_out_Control(7),
            MemOp_Inst_IN   => ex_M_out_Control(6),
            MemRead_IN      => ex_M_out_Control(5),
            MemWrite_IN     => ex_M_out_Control(4),
            RET_IN          => ex_M_out_Control(3),
            RTI_IN          => ex_M_out_Control(2),
            StackOpType_IN  => ex_M_out_Control(1 downto 0),
            -- Data input
            PC_IN           => ex_PC_Out,
            StoreData_IN    => ex_StoreData,
            ALUResult_IN    => ex_ALUResult,
            CCR_IN          => ex_CCR,
            Rdst_IN         => idex_Rdst,
            -- WB signals output
            MemToReg_OUT    => EXMEM_MemToReg_OUT,
            RegWrite_OUT    => EXMEM_RegWrite_OUT,
            -- M signals output
            PCStore_OUT     => EXMEM_PCStore_OUT,
            MemOp_Inst_OUT  => EXMEM_MemOp_Inst_OUT,
            MemRead_OUT     => EXMEM_MemRead_OUT,
            MemWrite_OUT    => EXMEM_MemWrite_OUT,
            RET_OUT         => EXMEM_RET_OUT,
            RTI_OUT         => EXMEM_RTI_OUT,
            StackOpType_OUT => EXMEM_StackOpType_OUT,
            -- Data output
            PC_OUT          => EXMEM_PC_OUT,
            StoreData_OUT   => EXMEM_StoreData_OUT,
            ALUResult_OUT   => EXMEM_ALUResult_OUT,
            CCR_OUT         => EXMEM_CCR_OUT,
            Rdst_OUT        => EXMEM_Rdst_OUT
        );

    -- ============================================================
    -- Output assignments
    -- ============================================================
    OUTPORT            <= ex_OUTPORT;
    ConditionalJMP     <= ex_ConditionalJMP;
    RegWrite_Fwd       <= decode_RegWrite_Fwd;
    HLT_OUT            <= decode_HLT;
    PCWrite_OUT        <= decode_PCWrite;
    MemOp_Priority_OUT <= decode_MemOp_Priority;
    Imm32_OUT          <= decode_Imm32;
    IFID_EN_OUT        <= decode_IFID_EN;
    IDEX_EN_OUT        <= decode_IDEX_EN;
    EXMEM_EN_OUT       <= decode_EXMEM_EN;
    MEMWB_EN_OUT       <= decode_MEMWB_EN;

end architecture rtl;
