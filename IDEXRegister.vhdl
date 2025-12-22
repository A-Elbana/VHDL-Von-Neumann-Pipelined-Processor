library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IDEXRegister is
    port(
        clk                                                                        : in  std_logic;
        rst                                                                        : in  std_logic;
        en                                                                         : in  std_logic;
        flush                                                                      : in  std_logic;
        MemToReg_IN, RegWrite_IN                                                   : in  std_logic; -- WB Signals
        PCStore_IN, MemOp_Inst_IN, MemRead_IN, MemWrite_IN, RET_IN, RTI_IN         : in  std_logic; -- M Signals
        HWINT_IN                                                                   : in  std_logic;
        ALUSrc_IN, OutOp_IN, SWINT_IN, JMPCALL_IN, SECOND_SWP_IN, InputOp_IN       : in  std_logic; -- EX Signals
        ALUOPType_IN, JMPType_IN                                                   : in  std_logic_vector(1 downto 0); -- EX Signals
        StackOpType_IN                                                             : in  std_logic_vector(1 downto 0); -- M Signals
        PC_IN, ReadData1_IN, ReadData2_IN, Immediate_IN                            : in  std_logic_vector(31 downto 0); -- Data
        Rsrc1_IN, Rsrc2_IN, Rdst_IN, Funct_IN                                      : in  std_logic_vector(2 downto 0); -- Data
        MemToReg_OUT, RegWrite_OUT                                                 : out std_logic; -- WB Signals
        PCStore_OUT, MemOp_Inst_OUT, MemRead_OUT, MemWrite_OUT, RET_OUT, RTI_OUT   : out std_logic; -- M Signals
        HWINT_OUT                                                                  : OUT std_logic;
        ALUSrc_OUT, OutOp_OUT, SWINT_OUT, JMPCALL_OUT, SECOND_SWP_OUT, InputOp_OUT : out std_logic; -- EX Signals
        ALUOPType_OUT, JMPType_OUT                                                 : out std_logic_vector(1 downto 0); -- EX Signals
        StackOpType_OUT                                                            : out std_logic_vector(1 downto 0); -- M Signals
        PC_OUT, ReadData1_OUT, ReadData2_OUT, Immediate_OUT                        : out std_logic_vector(31 downto 0); -- Data
        Rsrc1_OUT, Rsrc2_OUT, Rdst_OUT, Funct_OUT                                  : out std_logic_vector(2 downto 0) -- Data
    );
end entity IDEXRegister;

architecture RTL of IDEXRegister is
begin

    IDEX_REG : process(clk, rst) is
    begin
        if rst = '1' then
            -- WB Signals
            MemToReg_OUT <= '0';
            RegWrite_OUT <= '0';

            -- M Signals
            PCStore_OUT     <= '0';
            MemOp_Inst_OUT  <= '0';
            MemRead_OUT     <= '0';
            MemWrite_OUT    <= '0';
            RET_OUT         <= '0';
            RTI_OUT         <= '0';
            InputOp_OUT     <= '0';
            HWINT_OUT       <= '0';
            StackOpType_OUT <= (others => '0');

            -- EX Signals
            ALUSrc_OUT     <= '0';
            OutOp_OUT      <= '0';
            SWINT_OUT      <= '0';
            JMPCALL_OUT    <= '0';
            SECOND_SWP_OUT <= '0';
            ALUOPType_OUT  <= (others => '0');
            JMPType_OUT    <= (others => '0');

            -- Data
            PC_OUT        <= (others => '0');
            ReadData1_OUT <= (others => '0');
            ReadData2_OUT <= (others => '0');
            Immediate_OUT <= (others => '0');
            Rsrc1_OUT     <= (others => '0');
            Rsrc2_OUT     <= (others => '0');
            Rdst_OUT      <= (others => '0');
            Funct_OUT     <= (others => '0');

        elsif rising_edge(clk) then
            if flush = '1' then

                MemToReg_OUT <= '0';
                RegWrite_OUT <= '0';

                PCStore_OUT     <= '0';
                MemOp_Inst_OUT  <= '0';
                MemRead_OUT     <= '0';
                MemWrite_OUT    <= '0';
                RET_OUT         <= '0';
                RTI_OUT         <= '0';
                InputOp_OUT     <= '0';
                HWINT_OUT       <= '0';
                StackOpType_OUT <= (others => '0');

                ALUSrc_OUT     <= '0';
                OutOp_OUT      <= '0';
                SWINT_OUT      <= '0';
                JMPCALL_OUT    <= '0';
                SECOND_SWP_OUT <= '0';
                ALUOPType_OUT  <= (others => '0');
                JMPType_OUT    <= (others => '0');

                PC_OUT        <= (others => '0');
                ReadData1_OUT <= (others => '0');
                ReadData2_OUT <= (others => '0');
                Immediate_OUT <= (others => '0');
                Rsrc1_OUT     <= (others => '0');
                Rsrc2_OUT     <= (others => '0');
                Rdst_OUT      <= (others => '0');
                Funct_OUT     <= (others => '0');

            elsif en = '0' then

                MemToReg_OUT <= MemToReg_IN;
                RegWrite_OUT <= RegWrite_IN;

                PCStore_OUT     <= PCStore_IN;
                MemOp_Inst_OUT  <= MemOp_Inst_IN;
                MemRead_OUT     <= MemRead_IN;
                MemWrite_OUT    <= MemWrite_IN;
                RET_OUT         <= RET_IN;
                RTI_OUT         <= RTI_IN;
                InputOp_OUT     <= InputOp_IN;
                HWINT_OUT       <= HWINT_IN;
                StackOpType_OUT <= StackOpType_IN;

                ALUSrc_OUT     <= ALUSrc_IN;
                OutOp_OUT      <= OutOp_IN;
                SWINT_OUT      <= SWINT_IN;
                JMPCALL_OUT    <= JMPCALL_IN;
                SECOND_SWP_OUT <= SECOND_SWP_IN;
                ALUOPType_OUT  <= ALUOPType_IN;
                JMPType_OUT    <= JMPType_IN;

                PC_OUT        <= PC_IN;
                ReadData1_OUT <= ReadData1_IN;
                ReadData2_OUT <= ReadData2_IN;
                Immediate_OUT <= Immediate_IN;
                Rsrc1_OUT     <= Rsrc1_IN;
                Rsrc2_OUT     <= Rsrc2_IN;
                Rdst_OUT      <= Rdst_IN;
                Funct_OUT     <= Funct_IN;
            end if;
        end if;
    end process IDEX_REG;

end architecture RTL;

