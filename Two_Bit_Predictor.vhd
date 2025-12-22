library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Two_Bit_Predictor is
    port(
        IFID_ConditionalJumpOperation, IDEX_ConditionalJumpOperation : in  std_logic;
        IDEX_ConditionalJMP                                          : in  std_logic;
        --IFID_IMM is not extended yet
        PC, IF_IMM, IDEX_IMM                                  : in  std_logic_vector(31 downto 0);
        clk                                                          : in  std_logic;
        rst                                                          : in  std_logic;
        --taken 1, untaken 0
        prediction                                                   : out std_logic;
        Jump_Address_Selector                                        : out std_logic;
        Prediction_Result                                            : out std_logic_vector(31 downto 0)
    );
end entity Two_Bit_Predictor;

architecture Two_Bit_Predictor_Arch of Two_Bit_Predictor is
    type   Prediction_State  is (STRONG_TAKEN, STRONG_UNTAKEN, WEAK_TAKEN, WEAK_UNTAKEN);
    signal Current_State     : Prediction_State := STRONG_UNTAKEN;
    signal prediction_signal : std_logic;
    signal PC_BACK : std_logic_vector(31 downto 0);

begin
    lbl : process(clk, rst) is
    begin
        if rst = '1' then
            Current_State <= STRONG_TAKEN;

        elsif rising_edge(clk) then
            if Current_State = STRONG_TAKEN or Current_State = WEAK_TAKEN then
                PC_BACK <= PC;
            end if;
            if IDEX_ConditionalJumpOperation = '1' then
                if Current_State = STRONG_TAKEN then
                    if IDEX_ConditionalJMP = '0' then
                        Current_State <= WEAK_TAKEN;
                    end if;
                elsif Current_State = STRONG_UNTAKEN then
                    if IDEX_ConditionalJMP = '1' then
                        Current_State <= WEAK_UNTAKEN;
                    end if;
                else
                    if IDEX_ConditionalJMP = '0' then
                        Current_State <= STRONG_UNTAKEN;
                    else
                        Current_State <= STRONG_TAKEN;
                    end if;
                end if;
            end if;
        end if;

    end process;

    Prediction_Result <= std_logic_vector(unsigned(PC_BACK) + 2) when prediction_signal = '1' and IDEX_ConditionalJMP = '0' and IDEX_ConditionalJumpOperation = '1' else
                         IF_IMM when prediction_signal = '1' and IFID_ConditionalJumpOperation = '1' else
                         IDEX_IMM when prediction_signal = '0' and IDEX_ConditionalJMP = '1' and IDEX_ConditionalJumpOperation = '1' else (others => '0');

    Jump_Address_Selector <= '1' when prediction_signal = '1' and IDEX_ConditionalJMP = '0' and IDEX_ConditionalJumpOperation = '1' else
                             '1' when prediction_signal = '1' and IFID_ConditionalJumpOperation = '1' else
                             '1' when prediction_signal = '0' and IDEX_ConditionalJMP = '1' and IDEX_ConditionalJumpOperation = '1' else '0';

    prediction_signal <= '0' when (Current_State = STRONG_UNTAKEN or Current_State = WEAK_UNTAKEN) else
                         '1';

    prediction <= prediction_signal;
end architecture Two_Bit_Predictor_Arch;
