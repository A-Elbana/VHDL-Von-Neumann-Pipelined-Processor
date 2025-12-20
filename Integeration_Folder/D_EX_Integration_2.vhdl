library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity D_EX_Integration_2 is
    port(
        clk, rst : in std_logic
    );
end entity D_EX_Integration_2;

architecture RTL of D_EX_integration_2 is
    signal IFID_REG_OUT             : std_logic_vector(97 downto 0);
    signal HWInt                    : std_logic;
    signal INPort                   : std_logic_vector(31 downto 0) := x"ABABABAB";
    signal WB_D_OUT                 : std_logic_vector(163 downto 0);
    signal IDEX_REG_OUT             : std_logic_vector(159 downto 0);
    signal SIM_INPUT_Immediate_IN   : std_logic_vector(31 downto 0);
    signal SIM_INPUT_PC_IN          : std_logic_vector(31 downto 0);
    signal SIM_INPUT_Instruction_IN : std_logic_vector(31 downto 0);

begin
    IFIDRegister_inst : entity work.IFIDRegister
        port map(
            clk                     => clk,
            rst                     => rst,
            en                      => WB_D_OUT(0),
            flush                   => '0',
            SWP_IN                  => WB_D_OUT(162),
            SECOND_Imm32_SIGNAL_IN  => WB_D_OUT(163),
            Immediate_IN            => SIM_INPUT_Immediate_IN,
            PC_IN                   => SIM_INPUT_PC_IN,
            Instruction_IN          => SIM_INPUT_Instruction_IN,
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
            WriteAddr              => (2 downto 0 => '0'),
            Memory_Data            => (31 downto 0 => '0'),
            ALU_Data               => (31 downto 0 => '0'),
            clk                    => clk,
            rst                    => rst,
            MemToReg               => '0',
            MEMWBRegWrite_IN       => '0',
            HWInt                  => HWInt,
            EXMEM_MemOp            => '0',
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
            MemOp_Priority         => open,
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
            PCWrite                => open,
            IFID_EN                => WB_D_OUT(0),
            IDEX_EN                => WB_D_OUT(1),
            EXMEM_EN               => open,
            MEMWB_EN               => open,
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
            ReadData1      => IDEX_REG_OUT(63 downto 32),
            ReadData2      => IDEX_REG_OUT(95 downto 64),
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
            M_out_Control  => open,
            WB_out_Control => open,
            PC_Out         => open,
            ALUResult      => open,
            StoreData      => open,
            OUTPORT        => open,
            CCR            => open,
            ConditionalJMP => open,
            EX_Imm => open
        );

end architecture RTL;
