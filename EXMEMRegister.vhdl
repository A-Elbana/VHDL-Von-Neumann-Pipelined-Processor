library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EXMEMRegister is
    port(
        clk                                                                      : in  std_logic;
        rst                                                                      : in  std_logic;
        en                                                                       : in  std_logic;
        flush                                                                    : in  std_logic;
        MemToReg_IN, RegWrite_IN                                                 : in  std_logic; -- WB Signals
        PCStore_IN, MemOp_Inst_IN, MemRead_IN, MemWrite_IN, RET_IN, RTI_IN       : in  std_logic; -- M Signals
        SWINT_IN : in std_logic;
        StackOpType_IN                                                           : in  std_logic_vector(1 downto 0); -- M Signals
        PC_IN, StoreData_IN, ALUResult_IN                                        : in  std_logic_vector(31 downto 0); -- Data
        CCR_IN, Rdst_IN                                                          : in  std_logic_vector(2 downto 0); -- Data
        MemToReg_OUT, RegWrite_OUT                                               : out std_logic; -- WB Signals
        PCStore_OUT, MemOp_Inst_OUT, MemRead_OUT, MemWrite_OUT, RET_OUT, RTI_OUT : out std_logic; -- M Signals
        SWINT_OUT : out std_logic;
        StackOpType_OUT                                                          : out std_logic_vector(1 downto 0); -- M Signals
        PC_OUT, StoreData_OUT, ALUResult_OUT                                     : out std_logic_vector(31 downto 0); -- Data
        CCR_OUT, Rdst_OUT                                                        : out std_logic_vector(2 downto 0) -- Data
    );
end entity EXMEMRegister;

architecture RTL of EXMEMRegister is
begin

    EXMEM_REG : process(clk, rst) is
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
            SWINT_OUT         <= '0';
            StackOpType_OUT <= (others => '0');

            -- Data
            PC_OUT        <= (others => '0');
            StoreData_OUT <= (others => '0');
            ALUResult_OUT <= (others => '0');
            CCR_OUT       <= (others => '0');
            Rdst_OUT      <= (others => '0');

        elsif rising_edge(clk) then
            if flush = '1' then
                -- Clear on flush (bubble)
                MemToReg_OUT <= '0';
                RegWrite_OUT <= '0';

                PCStore_OUT     <= '0';
                MemOp_Inst_OUT  <= '0';
                MemRead_OUT     <= '0';
                MemWrite_OUT    <= '0';
                RET_OUT         <= '0';
                RTI_OUT         <= '0';
                SWINT_OUT         <= '0';
                StackOpType_OUT <= (others => '0');

                PC_OUT        <= (others => '0');
                StoreData_OUT <= (others => '0');
                ALUResult_OUT <= (others => '0');
                CCR_OUT       <= (others => '0');
                Rdst_OUT      <= (others => '0');

            elsif en = '0' then
                -- Normal pipeline latch
                MemToReg_OUT <= MemToReg_IN;
                RegWrite_OUT <= RegWrite_IN;

                PCStore_OUT     <= PCStore_IN;
                MemOp_Inst_OUT  <= MemOp_Inst_IN;
                MemRead_OUT     <= MemRead_IN;
                MemWrite_OUT    <= MemWrite_IN;
                RET_OUT         <= RET_IN;
                RTI_OUT         <= RTI_IN;
                SWINT_OUT         <= SWINT_IN;
                StackOpType_OUT <= StackOpType_IN;

                PC_OUT        <= PC_IN;
                StoreData_OUT <= StoreData_IN;
                ALUResult_OUT <= ALUResult_IN;
                CCR_OUT       <= CCR_IN;
                Rdst_OUT      <= Rdst_IN;
            end if;
        end if;
    end process EXMEM_REG;

end architecture RTL;
