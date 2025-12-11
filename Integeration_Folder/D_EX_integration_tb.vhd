library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity D_EX_integration_tb is
end entity D_EX_integration_tb;

architecture testbench of D_EX_integration_tb is

    -- Component declaration
    component D_EX_integration is
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
    end component D_EX_integration;

    -- Clock period
    constant CLK_PERIOD : time := 10 ns;

    -- Input signals
    signal clk                 : std_logic                     := '0';
    signal rst                 : std_logic                     := '0';
    signal INPort              : std_logic_vector(31 downto 0) := (others => '0');
    signal HWInt               : std_logic                     := '0';
    signal IFID_Immediate_IN   : std_logic_vector(31 downto 0) := (others => '0');
    signal IFID_PC_IN          : std_logic_vector(31 downto 0) := (others => '0');
    signal IFID_Instruction_IN : std_logic_vector(31 downto 0) := (others => '0');
    signal IFID_SWP_IN         : std_logic                     := '0';
    signal IFID_flush          : std_logic                     := '0';
    signal WB_WriteAddr        : std_logic_vector(2 downto 0)  := (others => '0');
    signal WB_Memory_Data      : std_logic_vector(31 downto 0) := (others => '0');
    signal WB_ALU_Data         : std_logic_vector(31 downto 0) := (others => '0');
    signal WB_MemToReg         : std_logic                     := '0';
    signal WB_RegWrite         : std_logic                     := '0';
    signal IDEX_flush          : std_logic                     := '0';
    signal EXMEM_flush         : std_logic                     := '0';
    signal EXMEM_MemOp_IN      : std_logic                     := '0';

    -- Output signals
    signal EXMEM_MemToReg_OUT    : std_logic;
    signal EXMEM_RegWrite_OUT    : std_logic;
    signal EXMEM_PCStore_OUT     : std_logic;
    signal EXMEM_MemOp_Inst_OUT  : std_logic;
    signal EXMEM_MemRead_OUT     : std_logic;
    signal EXMEM_MemWrite_OUT    : std_logic;
    signal EXMEM_RET_OUT         : std_logic;
    signal EXMEM_RTI_OUT         : std_logic;
    signal EXMEM_StackOpType_OUT : std_logic_vector(1 downto 0);
    signal EXMEM_PC_OUT          : std_logic_vector(31 downto 0);
    signal EXMEM_StoreData_OUT   : std_logic_vector(31 downto 0);
    signal EXMEM_ALUResult_OUT   : std_logic_vector(31 downto 0);
    signal EXMEM_CCR_OUT         : std_logic_vector(2 downto 0);
    signal EXMEM_Rdst_OUT        : std_logic_vector(2 downto 0);
    signal OUTPORT               : std_logic_vector(31 downto 0);
    signal ConditionalJMP        : std_logic;
    signal RegWrite_Fwd          : std_logic;
    signal HLT_OUT               : std_logic;
    signal PCWrite_OUT           : std_logic;
    signal MemOp_Priority_OUT    : std_logic;
    signal Imm32_OUT             : std_logic;
    signal IFID_EN_OUT           : std_logic;
    signal IDEX_EN_OUT           : std_logic;
    signal EXMEM_EN_OUT          : std_logic;
    signal MEMWB_EN_OUT          : std_logic;

    -- Test control
    signal test_done : boolean := false;

begin

    -- Device Under Test instantiation
    DUT : D_EX_integration
        port map(
            clk                   => clk,
            rst                   => rst,
            INPort                => INPort,
            HWInt                 => HWInt,
            IFID_Immediate_IN     => IFID_Immediate_IN,
            IFID_PC_IN            => IFID_PC_IN,
            IFID_Instruction_IN   => IFID_Instruction_IN,
            IFID_SWP_IN           => IFID_SWP_IN,
            IFID_flush            => IFID_flush,
            WB_WriteAddr          => WB_WriteAddr,
            WB_Memory_Data        => WB_Memory_Data,
            WB_ALU_Data           => WB_ALU_Data,
            WB_MemToReg           => WB_MemToReg,
            WB_RegWrite           => WB_RegWrite,
            IDEX_flush            => IDEX_flush,
            EXMEM_flush           => EXMEM_flush,
            EXMEM_MemOp_IN        => EXMEM_MemOp_IN,
            EXMEM_MemToReg_OUT    => EXMEM_MemToReg_OUT,
            EXMEM_RegWrite_OUT    => EXMEM_RegWrite_OUT,
            EXMEM_PCStore_OUT     => EXMEM_PCStore_OUT,
            EXMEM_MemOp_Inst_OUT  => EXMEM_MemOp_Inst_OUT,
            EXMEM_MemRead_OUT     => EXMEM_MemRead_OUT,
            EXMEM_MemWrite_OUT    => EXMEM_MemWrite_OUT,
            EXMEM_RET_OUT         => EXMEM_RET_OUT,
            EXMEM_RTI_OUT         => EXMEM_RTI_OUT,
            EXMEM_StackOpType_OUT => EXMEM_StackOpType_OUT,
            EXMEM_PC_OUT          => EXMEM_PC_OUT,
            EXMEM_StoreData_OUT   => EXMEM_StoreData_OUT,
            EXMEM_ALUResult_OUT   => EXMEM_ALUResult_OUT,
            EXMEM_CCR_OUT         => EXMEM_CCR_OUT,
            EXMEM_Rdst_OUT        => EXMEM_Rdst_OUT,
            OUTPORT               => OUTPORT,
            ConditionalJMP        => ConditionalJMP,
            RegWrite_Fwd          => RegWrite_Fwd,
            HLT_OUT               => HLT_OUT,
            PCWrite_OUT           => PCWrite_OUT,
            MemOp_Priority_OUT    => MemOp_Priority_OUT,
            Imm32_OUT             => Imm32_OUT,
            IFID_EN_OUT           => IFID_EN_OUT,
            IDEX_EN_OUT           => IDEX_EN_OUT,
            EXMEM_EN_OUT          => EXMEM_EN_OUT,
            MEMWB_EN_OUT          => MEMWB_EN_OUT
        );

    -- Clock generation process
    clk_process : process
    begin
        while not test_done loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process clk_process;

    -- Stimulus process
    stimulus_proc : process
        -- Helper procedure to build instruction
        -- Instruction format: [31:27] OpCode | [26:24] Rdst | [23:21] Rsrc1 | [20:18] Rsrc2 | [17:3] unused | [2:0] Func
        procedure build_instruction(
            opcode : in std_logic_vector(4 downto 0);
            rdst   : in std_logic_vector(2 downto 0);
            rsrc1  : in std_logic_vector(2 downto 0);
            rsrc2  : in std_logic_vector(2 downto 0);
            func   : in std_logic_vector(2 downto 0)
        ) is
        begin
            IFID_Instruction_IN <= opcode & rdst & rsrc1 & rsrc2 & "000000000000000" & func;
        end procedure;

    begin
        -- ========================================
        -- Test 1: Reset Test
        -- ========================================
        report "Test 1: Reset Test";
        rst <= '1';
        wait for CLK_PERIOD * 2;
        rst <= '0';
        wait for CLK_PERIOD;

        -- Verify outputs are cleared after reset
        assert EXMEM_MemToReg_OUT = '0' report "Reset failed: EXMEM_MemToReg_OUT not cleared" severity error;
        assert EXMEM_RegWrite_OUT = '0' report "Reset failed: EXMEM_RegWrite_OUT not cleared" severity error;
        assert EXMEM_ALUResult_OUT = x"00000000" report "Reset failed: EXMEM_ALUResult_OUT not cleared" severity error;

        -- ========================================
        -- Test 2: NOP Instruction Pipeline Flow
        -- ========================================
        report "Test 2: NOP Instruction Pipeline Flow";
        -- NOP instruction (assuming opcode 00000 is NOP)
        build_instruction("00000", "000", "000", "000", "000");
        IFID_PC_IN        <= x"00000004";
        IFID_Immediate_IN <= x"00000000";
        IFID_SWP_IN       <= '0';

        -- Wait for instruction to propagate through pipeline
        -- Cycle 1: IFID -> Decode
        wait for CLK_PERIOD;
        -- Cycle 2: Decode -> IDEX
        wait for CLK_PERIOD;
        -- Cycle 3: IDEX -> EX
        wait for CLK_PERIOD;
        -- Cycle 4: EX -> EXMEM
        wait for CLK_PERIOD;

        -- ========================================
        -- Test 3: Write to Register File and Read Back
        -- ========================================
        report "Test 3: Write to Register File and Read Back";
        -- First write a value to R1 via WB stage
        WB_WriteAddr <= "001";          -- R1
        WB_ALU_Data  <= x"DEADBEEF";
        WB_MemToReg  <= '0';            -- Select ALU data
        WB_RegWrite  <= '1';            -- Enable write

        wait for CLK_PERIOD;

        -- Now issue instruction that reads from R1 (Rsrc1 = R1)
        -- Using ADD R2, R1, R0 as example
        build_instruction("00001", "010", "001", "000", "000");
        IFID_PC_IN <= x"00000008";

        wait for CLK_PERIOD * 4;        -- Let it flow through pipeline

        -- ========================================
        -- Test 4: ALU Operation Test (ADD)
        -- ========================================
        report "Test 4: ALU Operation Test";
        -- Write values to R1 and R2
        WB_WriteAddr <= "001";
        WB_ALU_Data  <= x"00000005";
        WB_RegWrite  <= '1';
        wait for CLK_PERIOD;

        WB_WriteAddr <= "010";
        WB_ALU_Data  <= x"00000003";
        WB_RegWrite  <= '1';
        wait for CLK_PERIOD;

        WB_RegWrite <= '0';

        -- ADD R3, R1, R2 (should compute 5 + 3 = 8)
        build_instruction("00001", "011", "001", "010", "000");
        IFID_PC_IN <= x"0000000C";

        wait for CLK_PERIOD * 4;

        -- ========================================
        -- Test 5: Flush Test (IFID Flush)
        -- ========================================
        report "Test 5: IFID Flush Test";
        -- Issue an instruction
        build_instruction("00001", "100", "001", "010", "001");
        IFID_PC_IN <= x"00000010";

        wait for CLK_PERIOD;

        -- Apply flush
        IFID_flush <= '1';
        wait for CLK_PERIOD;
        IFID_flush <= '0';

        wait for CLK_PERIOD * 3;

        -- ========================================
        -- Test 6: Flush Test (IDEX Flush)
        -- ========================================
        report "Test 6: IDEX Flush Test";
        build_instruction("00001", "101", "001", "010", "010");
        IFID_PC_IN <= x"00000014";

        wait for CLK_PERIOD * 2;

        -- Apply IDEX flush
        IDEX_flush <= '1';
        wait for CLK_PERIOD;
        IDEX_flush <= '0';

        wait for CLK_PERIOD * 2;

        -- ========================================
        -- Test 7: Flush Test (EXMEM Flush)
        -- ========================================
        report "Test 7: EXMEM Flush Test";
        build_instruction("00001", "110", "001", "010", "011");
        IFID_PC_IN <= x"00000018";

        wait for CLK_PERIOD * 3;

        -- Apply EXMEM flush
        EXMEM_flush <= '1';
        wait for CLK_PERIOD;
        EXMEM_flush <= '0';

        wait for CLK_PERIOD;

        -- ========================================
        -- Test 8: Input Port Test
        -- ========================================
        report "Test 8: Input Port Test";
        INPort <= x"12345678";

        -- Issue IN instruction (assuming specific opcode enables InputOp)
        -- This depends on your control unit implementation
        build_instruction("01100", "111", "000", "000", "000");
        IFID_PC_IN <= x"0000001C";

        wait for CLK_PERIOD * 4;

        -- ========================================
        -- Test 9: Immediate Value Test
        -- ========================================
        report "Test 9: Immediate Value Test";
        IFID_Immediate_IN <= x"0000ABCD"; -- 16-bit immediate (sign extended)
        build_instruction("00010", "001", "010", "000", "000"); -- Assuming ADDI-like
        IFID_PC_IN        <= x"00000020";

        wait for CLK_PERIOD * 4;

        -- ========================================
        -- Test 10: Pipeline Continuity Test
        -- ========================================
        report "Test 10: Pipeline Continuity Test - Multiple Instructions";
        -- Feed multiple instructions back-to-back
        WB_RegWrite <= '0';

        -- Instruction 1
        build_instruction("00001", "001", "010", "011", "000");
        IFID_PC_IN <= x"00000024";
        wait for CLK_PERIOD;

        -- Instruction 2
        build_instruction("00001", "010", "011", "100", "001");
        IFID_PC_IN <= x"00000028";
        wait for CLK_PERIOD;

        -- Instruction 3
        build_instruction("00001", "011", "100", "101", "010");
        IFID_PC_IN <= x"0000002C";
        wait for CLK_PERIOD;

        -- Instruction 4
        build_instruction("00001", "100", "101", "110", "011");
        IFID_PC_IN <= x"00000030";
        wait for CLK_PERIOD;

        -- Wait for all to complete
        wait for CLK_PERIOD * 4;

        -- ========================================
        -- Test 11: Hardware Interrupt Test
        -- ========================================
        report "Test 11: Hardware Interrupt Test";
        HWInt      <= '1';
        build_instruction("00000", "000", "000", "000", "000");
        IFID_PC_IN <= x"00000034";
        wait for CLK_PERIOD * 2;
        HWInt      <= '0';
        wait for CLK_PERIOD * 3;

        -- ========================================
        -- Test 12: SWP (Swap) Test
        -- ========================================
        report "Test 12: SWP Test";
        IFID_SWP_IN <= '1';
        build_instruction("00011", "001", "010", "000", "000"); -- SWP instruction
        IFID_PC_IN  <= x"00000038";
        wait for CLK_PERIOD * 2;
        IFID_SWP_IN <= '0';
        wait for CLK_PERIOD * 3;

        -- ========================================
        -- End of Tests
        -- ========================================
        report "All tests completed!";
        test_done <= true;
        wait;

    end process stimulus_proc;

    -- Monitor process for debugging
    monitor_proc : process(clk)
    begin
        if rising_edge(clk) then
            -- Uncomment below lines for detailed debugging
            -- report "EXMEM_ALUResult_OUT = " & to_hstring(EXMEM_ALUResult_OUT);
            -- report "EXMEM_PC_OUT = " & to_hstring(EXMEM_PC_OUT);
            -- report "EXMEM_RegWrite_OUT = " & std_logic'image(EXMEM_RegWrite_OUT);
        end if;
    end process monitor_proc;

end architecture testbench;
