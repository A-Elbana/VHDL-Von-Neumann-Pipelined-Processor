library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EX_Stage is
    port(
        --some signal can be done on the cpu module like the pc and M/WB_control
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
        ConditionalJMP                        : out std_logic;
        EX_Imm : out std_logic_vector(31 downto 0)
    );
end entity EX_Stage;

architecture EX_Stage_Arch of EX_Stage is

    component ALU is
        GENERIC(n : INTEGER := 32);
        --CCR[0]=Z-flag
        --CCR[1]=N-flag
        --CCR[2]=C-flag
        PORT(
            A, B           : IN  std_logic_vector(n - 1 DOWNTO 0);
            FunctionOpcode : IN  std_logic_vector(2 downto 0);
            ALUOP          : IN  std_logic_vector(1 downto 0);
            CCR            : OUT std_logic_vector(2 downto 0);
            Result         : OUT std_logic_vector(n - 1 DOWNTO 0);
            Carry_Reg_en   : OUT std_logic_vector(1 downto 0)
        );
    end component ALU;
    component Flags_Reg is
        port(
            clk             : in  std_logic;
            rst             : in  std_logic;
            IN_FLAGS_ALU    : in  std_logic_vector(2 downto 0);
            IN_FLAGS_MEMORY : in  std_logic_vector(2 downto 0);
            ALU_ENABLE      : in  std_logic_vector(1 downto 0);
            MEMORY_ENABLE   : in  std_logic;
            CCR             : out std_logic_vector(2 downto 0)
        );
    end component Flags_Reg;

    signal ALU_Second_Operand  : std_logic_vector(31 downto 0) := (others => '0');
    signal ALUResult_Signal    : std_logic_vector(31 downto 0) := (others => '0');
    signal CCR_singal          : std_logic_vector(2 downto 0)  := (others => '0');
    signal CCR_singal_Out      : std_logic_vector(2 downto 0)  := (others => '0');
    signal Carry_Reg_en_signal : std_logic_vector(1 downto 0)  := (others => '0');

begin

    ALU_Second_Operand <= ReadData2 when AluSrc = '0' else
                          Imm when AluSrc = '1';
    WB_out_Control     <= WB_control;
    M_out_Control      <= M_control;
    StoreData          <= ReadData2;
    PC_Out             <= PC;
    EX_Imm <= Imm;
    alu_inst : ALU
        generic map(
            n => 32
        )
        port map(
            A              => ReadData1,
            B              => ALU_Second_Operand,
            FunctionOpcode => func,
            ALUOP          => ALUOP,
            CCR            => CCR_singal,
            Result         => ALUResult_Signal,
            Carry_Reg_en   => Carry_Reg_en_signal
        );
    ALUResult          <= ALUResult_Signal WHEN InputOp = '0' ELSE
                          INPort WHEN InputOp = '1';

    flags_reg_inst : Flags_Reg
        port map(
            clk             => clk,
            rst             => rst,
            IN_FLAGS_ALU    => CCR_singal,
            IN_FLAGS_MEMORY => "001",
            ALU_ENABLE      => Carry_Reg_en_signal,
            MEMORY_ENABLE   => '0',
            CCR             => CCR_singal_Out
        );
    CCR            <= CCR_singal_Out;
    --Jump type JZ = 01 / JN = 10 / JC = 11
    --CCR[0]=Z-flag
    --CCR[1]=N-flag
    --CCR[2]=C-flag
    ConditionalJMP <= CCR_singal_Out(0) WHEN JumpType = "01" ELSE
                      CCR_singal_Out(1) WHEN JumpType = "10" ELSE
                      CCR_singal_Out(2) WHEN JumpType = "11" ELSE
                      '0';

    OUTPORT <= ALUResult_Signal WHEN OutOP = '1' ELSE
               (others => '0');

end architecture EX_Stage_Arch;
