library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Flags_Reg is
    port(
        clk             : in  std_logic;
        rst             : in  std_logic;
        IN_FLAGS_ALU    : in  std_logic_vector(2 downto 0);
        IN_FLAGS_MEMORY : in  std_logic_vector(2 downto 0);
        ALU_ENABLE      : in  std_logic_vector(1 downto 0);
        MEMORY_ENABLE   : in  std_logic;
        CCR             : out std_logic_vector(2 downto 0)
    );
end entity Flags_Reg;

architecture Flags_Reg_Arch of Flags_Reg is
    signal Carry, Zero, Negative : std_logic := '0';

begin
    lbl : process(clk, rst) is
    begin
        if rst = '1' then
            Carry    <= '0';
            Zero     <= '0';
            Negative <= '0';
        elsif rising_edge(clk) then

            if MEMORY_ENABLE = '1' then
                Carry    <= IN_FLAGS_MEMORY(2);
                Negative <= IN_FLAGS_MEMORY(1);
                Zero     <= IN_FLAGS_MEMORY(0);
            elsif ALU_ENABLE = "11" then
                Carry    <= IN_FLAGS_ALU(2);
                Negative <= IN_FLAGS_ALU(1);
                Zero     <= IN_FLAGS_ALU(0);
            elsif ALU_ENABLE = "01" then
                Carry <= IN_FLAGS_ALU(2);
            elsif ALU_ENABLE = "10" then
                Negative <= IN_FLAGS_ALU(1);
                Zero     <= IN_FLAGS_ALU(0);

            end if;

        end if;
    end process;
    CCR <= Carry & Negative & Zero;
end architecture Flags_Reg_Arch;
