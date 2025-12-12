library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SP_Block is
    port(
        clk : in std_logic;
        rst : in std_logic;
        StackOpType_IN : in std_logic_vector(1 downto 0);
        Stack_OUT : out std_logic_vector(31 downto 0)
    );
end entity SP_Block;

architecture RTL of SP_Block is
    signal Stack_Q : std_logic_vector(31 downto 0);
begin

    Stack_OUT <= 
        std_logic_vector(unsigned(Stack_Q) + unsigned(1)) WHEN StackOpType_IN = "11" 
        ELSE Stack_Q WHEN StackOpType_IN = "10"
        ELSE (others => '0');
    stack_reg : process (clk, rst) is
    begin
        if rst = '1' then
            Stack_Q <= (17 downto 0 => '1', others => '0');
        elsif rising_edge(clk) then
            if StackOpType_IN(1) = '1' then
                case StackOpType_IN(0) is
                    when '1' => 
                        Stack_Q <= std_logic_vector(unsigned(Stack_Q) + unsigned(1));
                    when others => 
                        Stack_Q <= std_logic_vector(unsigned(Stack_Q) - unsigned(1));
                end case;
            end if;
        end if;
    end process stack_reg;
    
end architecture RTL;
