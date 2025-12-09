library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LoadToPCFSM is
    port(
        clk             : in  std_logic;
        rst             : in  std_logic;
        interrupt_index : in  std_logic_vector(1 downto 0);
        memOp           : in  std_logic;
        INT             : in  std_logic;
        LoadPC          : out std_logic;
        int_index       : out std_logic_vector(1 downto 0);
        IFID_FLUSH         : out std_logic
    );
end entity LoadToPCFSM;

architecture RTL of LoadToPCFSM is
    type st is (IDLE, WAITING);

    signal state_reg  : st := IDLE;
    signal next_state : st := IDLE;

begin

    state_register : process(clk, rst) is
    begin
        if rst = '1' then
            state_reg <= IDLE;
        elsif rising_edge(clk) then
            state_reg <= next_state;
        end if;
    end process state_register;

    int_index_reg : process(clk, rst) is
    begin
        if rst = '1' then
            int_index <= (others => '0');
        elsif rising_edge(clk) then
            if INT = '1' then
                int_index <= interrupt_index;
            end if;

        end if;
    end process int_index_reg;

    next_state_logic : process(rst, memOp, INT, state_reg) is
    begin
        if rst = '1' then
            LoadPC  <= '0';
            IFID_FLUSH <= '0';

        else
            LoadPC  <= '0';
            IFID_FLUSH <= '0';
            case state_reg is
                when IDLE =>
                    if INT = '1' then
                        next_state <= WAITING;
                        IFID_FLUSH <= '1';
                    end if;
                when WAITING =>
                    if memOp = '0' then
                        next_state <= IDLE;
                        LoadPC <= '1';
                    end if;
                    IFID_FLUSH <= '1';
            end case;
        end if;
    end process next_state_logic;

end architecture RTL;
