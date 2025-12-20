library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Full_Integration is
    port(
        clk, rst : in std_logic
    );
end entity Full_Integration;

architecture RTL of Full_Integration is
    signal IFID_REG_OUT   : std_logic_vector(97 downto 0);
    signal HWInt          : std_logic                     := '0';
    signal INPort         : std_logic_vector(31 downto 0) := x"ABABABAB";
    signal OUTPort        : std_logic_vector(31 downto 0);
    signal WB_D_OUT       : std_logic_vector(199 downto 0);
    signal IDEX_REG_OUT   : std_logic_vector(159 downto 0);
    signal EX_OUT         : std_logic_vector(141 downto 0);
    signal EX_MEM_REG_OUT : std_logic_vector(111 downto 0);
    signal IF_MEM_OUT     : std_logic_vector(167 downto 0);
    signal MEM_WB_REG_OUT : std_logic_vector(68 downto 0);

    signal First_Operand_Data_Signal  : std_logic_vector(31 downto 0);
    signal Second_Operand_Data_Signal : std_logic_vector(31 downto 0);
    signal First_Operand_Signal       : std_logic_vector(1 downto 0);
    signal Second_Operand_Signal      : std_logic_vector(1 downto 0);

begin
    IFIDRegister_inst : entity work.IFIDRegister
        port map(
            clk                     => clk,
            rst                     => rst,
            en                      => WB_D_OUT(0),
            flush                   => IF_MEM_OUT(135),
            SWP_IN                  => WB_D_OUT(162),
            SECOND_Imm32_SIGNAL_IN  => WB_D_OUT(163),
            Imm32_SIGNAL            => WB_D_OUT(163),
            Immediate_IN            => IF_MEM_OUT(31 downto 0),
            PC_IN                   => IF_MEM_OUT(67 downto 36),
            Instruction_IN          => IF_MEM_OUT(167 downto 136),
            SWP_OUT                 => IFID_REG_OUT(0),
            Immediate_OUT           => IFID_REG_OUT(32 downto 1),
            PC_OUT                  => IFID_REG_OUT(64 downto 33),
            Instruction_OUT         => IFID_REG_OUT(96 downto 65),
            SECOND_Imm32_SIGNAL_OUT => IFID_REG_OUT(97)
        );

    WB_D_Stage_inst : entity work.WB_D_Stage
        port map(
            SECOND_Imm32_SIGNAL_IN => IFID_REG_OUT(97),
            Imm_32_IN              => IFID_REG_OUT(32 downto 1),
            inst                   => IFID_REG_OUT(96 downto 65),
            PC                     => IFID_REG_OUT(64 downto 33),
            SECOND_SWP             => IFID_REG_OUT(0),
            WriteAddr              => MEM_WB_REG_OUT(68 downto 66),
            Memory_Data            => MEM_WB_REG_OUT(33 downto 2),
            ALU_Data               => MEM_WB_REG_OUT(65 downto 34),
            clk                    => clk,
            rst                    => rst,
            MemToReg               => MEM_WB_REG_OUT(0),
            MEMWBRegWrite_IN       => MEM_WB_REG_OUT(1),
            HWInt                  => HWInt,
            EXMEM_MemOp            => IF_MEM_OUT(32),
            MEMWBRegWrite_OUT      => open,
            PC_Out                 => WB_D_OUT(53 downto 22),
            ReadData1              => WB_D_OUT(85 downto 54),
            ReadData2              => WB_D_OUT(117 downto 86),
            Imm_32_OUT             => WB_D_OUT(149 downto 118),
            func                   => WB_D_OUT(152 downto 150),
            Rdst                   => WB_D_OUT(155 downto 153),
            Rsrc1                  => WB_D_OUT(158 downto 156),
            Rsrc2                  => WB_D_OUT(161 downto 159),
            MemToReg_OUT           => WB_D_OUT(2),
            RegWrite_OUT           => WB_D_OUT(3),
            PCStore                => WB_D_OUT(4),
            MemOp_Inst             => WB_D_OUT(5),
            MemOp_Priority         => WB_D_OUT(164),
            MemRead                => WB_D_OUT(6),
            MemWrite               => WB_D_OUT(7),
            RET                    => WB_D_OUT(8),
            RTI                    => WB_D_OUT(9),
            InputOp                => WB_D_OUT(10),
            ALUSrc                 => WB_D_OUT(11),
            OutOp                  => WB_D_OUT(12),
            SWINT                  => WB_D_OUT(13),
            JMPCALL                => WB_D_OUT(14),
            SECOND_SWP_OUT         => WB_D_OUT(15),
            ALUOPType              => WB_D_OUT(17 downto 16),
            JMPType                => WB_D_OUT(19 downto 18),
            StackOpType            => WB_D_OUT(21 downto 20),
            Imm32_SIGNAL           => WB_D_OUT(163),
            HLT                    => open,
            PCWrite                => WB_D_OUT(165),
            IFID_EN                => WB_D_OUT(0),
            IDEX_EN                => WB_D_OUT(1),
            EXMEM_EN               => WB_D_OUT(166),
            MEMWB_EN               => WB_D_OUT(167),
            Write_Back_Data_OUT    => WB_D_OUT(199 downto 168),
            SWP                    => WB_D_OUT(162)
        );

    IDEXRegister_inst : entity work.IDEXRegister
        port map(
            clk             => clk,
            rst             => rst,
            en              => WB_D_OUT(1),
            flush           => '0',
            MemToReg_IN     => WB_D_OUT(2),
            RegWrite_IN     => WB_D_OUT(3),
            PCStore_IN      => WB_D_OUT(4),
            MemOp_Inst_IN   => WB_D_OUT(5),
            MemRead_IN      => WB_D_OUT(6),
            MemWrite_IN     => WB_D_OUT(7),
            RET_IN          => WB_D_OUT(8),
            RTI_IN          => WB_D_OUT(9),
            InputOp_IN      => WB_D_OUT(10),
            ALUSrc_IN       => WB_D_OUT(11),
            OutOp_IN        => WB_D_OUT(12),
            SWINT_IN        => WB_D_OUT(13),
            JMPCALL_IN      => WB_D_OUT(14),
            SECOND_SWP_IN   => WB_D_OUT(15),
            ALUOPType_IN    => WB_D_OUT(17 downto 16),
            JMPType_IN      => WB_D_OUT(19 downto 18),
            StackOpType_IN  => WB_D_OUT(21 downto 20),
            PC_IN           => WB_D_OUT(53 downto 22),
            ReadData1_IN    => WB_D_OUT(85 downto 54),
            ReadData2_IN    => WB_D_OUT(117 downto 86),
            Immediate_IN    => WB_D_OUT(149 downto 118),
            Funct_IN        => WB_D_OUT(152 downto 150),
            Rdst_IN         => WB_D_OUT(155 downto 153),
            Rsrc1_IN        => WB_D_OUT(158 downto 156),
            Rsrc2_IN        => WB_D_OUT(161 downto 159),
            MemToReg_OUT    => IDEX_REG_OUT(140), -- WB
            RegWrite_OUT    => IDEX_REG_OUT(141), -- WB
            PCStore_OUT     => IDEX_REG_OUT(142), -- M
            MemOp_Inst_OUT  => IDEX_REG_OUT(143), -- M
            MemRead_OUT     => IDEX_REG_OUT(144), -- M
            MemWrite_OUT    => IDEX_REG_OUT(145), -- M
            RET_OUT         => IDEX_REG_OUT(146), -- M
            RTI_OUT         => IDEX_REG_OUT(147), -- M
            StackOpType_OUT => IDEX_REG_OUT(149 downto 148), -- M
            InputOp_OUT     => IDEX_REG_OUT(150), -- EX
            ALUSrc_OUT      => IDEX_REG_OUT(151), -- EX
            OutOp_OUT       => IDEX_REG_OUT(152), -- EX
            SECOND_SWP_OUT  => IDEX_REG_OUT(155), -- EX
            ALUOPType_OUT   => IDEX_REG_OUT(157 downto 156), -- EX
            JMPType_OUT     => IDEX_REG_OUT(159 downto 158), -- EX
            JMPCALL_OUT     => IDEX_REG_OUT(154), -- EX
            SWINT_OUT       => IDEX_REG_OUT(153), -- EX
            PC_OUT          => IDEX_REG_OUT(31 downto 0),
            ReadData1_OUT   => IDEX_REG_OUT(63 downto 32),
            ReadData2_OUT   => IDEX_REG_OUT(95 downto 64),
            Immediate_OUT   => IDEX_REG_OUT(127 downto 96),
            Funct_OUT       => IDEX_REG_OUT(130 downto 128),
            Rdst_OUT        => IDEX_REG_OUT(133 downto 131),
            Rsrc1_OUT       => IDEX_REG_OUT(136 downto 134),
            Rsrc2_OUT       => IDEX_REG_OUT(139 downto 137)
        );

    EX_Stage_inst : entity work.EX_Stage
        port map(
            clk            => clk,
            rst            => rst,
            PC             => IDEX_REG_OUT(31 downto 0),
            ReadData1      => First_Operand_Data_Signal,
            ReadData2      => Second_Operand_Data_Signal,
            Imm            => IDEX_REG_OUT(127 downto 96),
            INPort         => INPort,
            func           => IDEX_REG_OUT(130 downto 128),
            Rdst           => IDEX_REG_OUT(133 downto 131),
            Rsrc1          => IDEX_REG_OUT(136 downto 134),
            Rsrc2          => IDEX_REG_OUT(139 downto 137),
            M_control      => IDEX_REG_OUT(149 downto 142),
            WB_control     => IDEX_REG_OUT(141 downto 140),
            InputOp        => IDEX_REG_OUT(150),
            AluSrc         => IDEX_REG_OUT(151),
            OutOP          => IDEX_REG_OUT(152),
            Swap           => IDEX_REG_OUT(155),
            AluOP          => IDEX_REG_OUT(157 downto 156),
            JumpType       => IDEX_REG_OUT(159 downto 158),
            M_out_Control  => EX_OUT(7 downto 0),
            WB_out_Control => EX_OUT(9 downto 8),
            PC_Out         => EX_OUT(41 downto 10),
            ALUResult      => EX_OUT(73 downto 42),
            StoreData      => EX_OUT(105 downto 74),
            OUTPORT        => OUTPort,
            CCR            => EX_OUT(108 downto 106),
            ConditionalJMP => EX_OUT(109),
            EX_Imm         => EX_OUT(141 downto 110)
        );

    EXMEMRegister_inst : entity work.EXMEMRegister
        port map(
            clk             => clk,
            rst             => rst,
            en              => WB_D_OUT(166),
            flush           => '0',
            PCStore_IN      => EX_OUT(0),
            MemOp_Inst_IN   => EX_OUT(1),
            MemRead_IN      => EX_OUT(2),
            MemWrite_IN     => EX_OUT(3),
            RET_IN          => EX_OUT(4),
            RTI_IN          => EX_OUT(5),
            StackOpType_IN  => EX_OUT(7 downto 6),
            MemToReg_IN     => EX_OUT(8),
            RegWrite_IN     => EX_OUT(9),
            PC_IN           => EX_OUT(41 downto 10),
            StoreData_IN    => EX_OUT(105 downto 74),
            ALUResult_IN    => EX_OUT(73 downto 42),
            CCR_IN          => EX_OUT(108 downto 106),
            Rdst_IN         => IDEX_REG_OUT(133 downto 131),
            MemToReg_OUT    => EX_MEM_REG_OUT(0),
            RegWrite_OUT    => EX_MEM_REG_OUT(1),
            PCStore_OUT     => EX_MEM_REG_OUT(2),
            MemOp_Inst_OUT  => EX_MEM_REG_OUT(3),
            MemRead_OUT     => EX_MEM_REG_OUT(4),
            MemWrite_OUT    => EX_MEM_REG_OUT(5),
            RET_OUT         => EX_MEM_REG_OUT(6),
            RTI_OUT         => EX_MEM_REG_OUT(7),
            StackOpType_OUT => EX_MEM_REG_OUT(9 downto 8),
            PC_OUT          => EX_MEM_REG_OUT(41 downto 10),
            StoreData_OUT   => EX_MEM_REG_OUT(73 downto 42),
            ALUResult_OUT   => EX_MEM_REG_OUT(105 downto 74),
            CCR_OUT         => EX_MEM_REG_OUT(108 downto 106),
            Rdst_OUT        => EX_MEM_REG_OUT(111 downto 109)
        );

    IF_MEM_Stage_inst : entity work.IF_MEM_Stage
        port map(
            clk                 => clk,
            rst                 => rst,
            HWInt               => HWInt,
            MemOp_Priority_IN   => WB_D_OUT(164),
            PCWrite             => WB_D_OUT(165),
            SWInt               => WB_D_OUT(13),
            interrupt_index     => WB_D_OUT(118),
            IDEX_ConditionalJMP => EX_OUT(109),
            IDEX_Imm            => EX_OUT(141 downto 110),
            IFID_Imm            => WB_D_OUT(149 downto 118),
            IFID_JMPCALL        => WB_D_OUT(14),
            IFID_SWP            => WB_D_OUT(162),
            IFID_Imm32_SIGNAL   => WB_D_OUT(163),
            IFID_Rdst           => WB_D_OUT(155 downto 153),
            IFID_Rsrc           => WB_D_OUT(158 downto 156),
            MemToReg_IN         => EX_MEM_REG_OUT(0),
            RegWrite_IN         => EX_MEM_REG_OUT(1),
            PCStore_IN          => EX_MEM_REG_OUT(2),
            MemOp_Inst_IN       => EX_MEM_REG_OUT(3),
            MemRead_IN          => EX_MEM_REG_OUT(4),
            MemWrite_IN         => EX_MEM_REG_OUT(5),
            RET_IN              => EX_MEM_REG_OUT(6),
            RTI_IN              => EX_MEM_REG_OUT(7),
            StackOpType_IN      => EX_MEM_REG_OUT(9 downto 8),
            PC_IN               => EX_MEM_REG_OUT(41 downto 10),
            StoreData_IN        => EX_MEM_REG_OUT(73 downto 42),
            ALUResult_IN        => EX_MEM_REG_OUT(105 downto 74),
            CCR_IN              => EX_MEM_REG_OUT(108 downto 106),
            Rdst_IN             => EX_MEM_REG_OUT(111 downto 109),
            IF_Imm              => IF_MEM_OUT(31 downto 0),
            EXMEM_MemOp_Inst    => IF_MEM_OUT(32),
            EXMEM_RTI           => IF_MEM_OUT(33),
            MemToReg_OUT        => IF_MEM_OUT(34),
            RegWrite_OUT        => IF_MEM_OUT(35),
            PC_OUT              => IF_MEM_OUT(67 downto 36),
            readData_OUT        => IF_MEM_OUT(99 downto 68),
            ALUResult_OUT       => IF_MEM_OUT(131 downto 100),
            writeAddr_OUT       => IF_MEM_OUT(134 downto 132),
            IFID_FLUSH          => IF_MEM_OUT(135),
            Fetched_Inst        => IF_MEM_OUT(167 downto 136)
        );

    MEMWBRegister_inst : entity work.MEMWBRegister
        port map(
            clk           => clk,
            rst           => rst,
            en            => WB_D_OUT(167),
            flush         => '0',
            MemToReg_IN   => IF_MEM_OUT(34),
            RegWrite_IN   => IF_MEM_OUT(35),
            MEMResult_IN  => IF_MEM_OUT(99 downto 68),
            ALUResult_IN  => IF_MEM_OUT(131 downto 100),
            Rdst_IN       => IF_MEM_OUT(134 downto 132),
            MemToReg_OUT  => MEM_WB_REG_OUT(0),
            RegWrite_OUT  => MEM_WB_REG_OUT(1),
            MEMResult_OUT => MEM_WB_REG_OUT(33 downto 2),
            ALUResult_OUT => MEM_WB_REG_OUT(65 downto 34),
            Rdst_OUT      => MEM_WB_REG_OUT(68 downto 66)
        );

    forwardunit_inst : entity work.forwardUnit
        port map(
            ID_EX_Rsrc1     => IDEX_REG_OUT(136 downto 134),
            ID_EX_Rsrc2     => IDEX_REG_OUT(139 downto 137),
            EX_MEM_Rdst     => EX_MEM_REG_OUT(111 downto 109),
            MEM_WB_Rdst     => MEM_WB_REG_OUT(68 downto 66),
            EX_MEM_RegWrite => EX_MEM_REG_OUT(5),
            MEM_WB_RegWrite => MEM_WB_REG_OUT(1),
            ID_EX_Swap      => IDEX_REG_OUT(155),
            ForwardA        => First_Operand_Signal,
            ForwardB        => Second_Operand_Signal
        );
    ---------------Forwarding--------------------------------

    First_Operand_Data_Signal <= WB_D_OUT(199 downto 168) when First_Operand_Signal = "01" else
                                 EX_MEM_REG_OUT(105 downto 74) when First_Operand_Signal = "10" else
                                 IDEX_REG_OUT(63 downto 32);

    Second_Operand_Data_Signal <= WB_D_OUT(199 downto 168) when Second_Operand_Signal = "01" else
                                  EX_MEM_REG_OUT(105 downto 74) when Second_Operand_Signal = "10" else
                                  IDEX_REG_OUT(95 downto 64);
end architecture RTL;
