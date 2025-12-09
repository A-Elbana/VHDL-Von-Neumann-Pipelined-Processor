library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MEMWBRegister is
    port(
        clk                          : in  std_logic;
        rst                          : in  std_logic;
        en                           : in  std_logic;
        flush                        : in  std_logic;
        MemToReg_IN, RegWrite_IN     : in  std_logic; -- WB Signals
        MemToReg_OUT, RegWrite_OUT   : out std_logic; -- WB Signals
        MEMResult_IN, ALUResult_IN   : in  std_logic_vector(31 downto 0); -- Data
        MEMResult_OUT, ALUResult_OUT : out std_logic_vector(31 downto 0); -- Data
        Rdst_IN                      : in  std_logic_vector(2 downto 0); -- Data
        Rdst_OUT                     : out std_logic_vector(2 downto 0) -- Data
    );
end entity MEMWBRegister;

architecture RTL of MEMWBRegister is
begin

    MEMWB_REG : process(clk, rst) is
    begin
        if rst = '1' then
            -- WB Signals
            MemToReg_OUT <= '0';
            RegWrite_OUT <= '0';

            -- Data
            MEMResult_OUT <= (others => '0');
            ALUResult_OUT <= (others => '0');
            Rdst_OUT      <= (others => '0');

        elsif rising_edge(clk) then
            if flush = '1' then
                -- Pipeline bubble
                MemToReg_OUT <= '0';
                RegWrite_OUT <= '0';

                MEMResult_OUT <= (others => '0');
                ALUResult_OUT <= (others => '0');
                Rdst_OUT      <= (others => '0');

            elsif en = '0' then
                -- Normal latch transfer
                MemToReg_OUT <= MemToReg_IN;
                RegWrite_OUT <= RegWrite_IN;

                MEMResult_OUT <= MEMResult_IN;
                ALUResult_OUT <= ALUResult_IN;
                Rdst_OUT      <= Rdst_IN;
            end if;
        end if;
    end process MEMWB_REG;

end architecture RTL;

