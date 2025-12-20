library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IFIDRegister is
    port(
        clk                                    : in  std_logic;
        rst                                    : in  std_logic;
        en                                     : in  std_logic;
        flush                                  : in  std_logic;
        SECOND_Imm32_SIGNAL_IN                 : in  std_logic;
        Imm32_SIGNAL                           : in  std_logic;
        SWP_IN                                 : in  std_logic;
        Immediate_IN, PC_IN, Instruction_IN    : in  std_logic_vector(31 downto 0);
        SWP_OUT                                : out std_logic;
        Immediate_OUT, PC_OUT, Instruction_OUT : out std_logic_vector(31 downto 0);
        SECOND_Imm32_SIGNAL_OUT                : out std_logic
    );
end entity IFIDRegister;

architecture RTL of IFIDRegister is

begin

    IFID_REG : process(clk, rst) is
    begin
        if rst = '1' then
            Immediate_OUT           <= (others => '0');
            PC_OUT                  <= (others => '0');
            Instruction_OUT         <= (others => '0');
            SWP_OUT                 <= '0';
            SECOND_Imm32_SIGNAL_OUT <= '0';
        elsif rising_edge(clk) then
            if flush = '1' then
                Immediate_OUT           <= (others => '0');
                PC_OUT                  <= (others => '0');
                Instruction_OUT         <= (others => '0');
                SWP_OUT                 <= '0';
                SECOND_Imm32_SIGNAL_OUT <= '0';
            elsif en = '0' then
                Immediate_OUT           <= Immediate_IN;
                PC_OUT                  <= PC_IN;
                Instruction_OUT         <= Instruction_IN;
                SWP_OUT                 <= SWP_IN;
                SECOND_Imm32_SIGNAL_OUT <= SECOND_Imm32_SIGNAL_IN;
            elsif Imm32_SIGNAL = '1' then
            Immediate_OUT    <= Immediate_IN;
            SECOND_Imm32_SIGNAL_OUT <= SECOND_Imm32_SIGNAL_IN;
            end if;
        end if;
    end process IFID_REG;

end architecture RTL;
