
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
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
end entity ALU;

architecture ALU_Arch of ALU is

    component FullAddSub IS
        GENERIC(n : INTEGER := 32);
        PORT(
            A, B          : IN  STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            CBin, control : IN  STD_LOGIC;
            res           : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            CBout         : OUT STD_LOGIC
        );
    END component FullAddSub;

    signal ADD_RES, INC_RES, SUB_RES, MOV_RES, AND_RES, NOT_RES : std_logic_vector(n - 1 downto 0) := (others => '0');
    signal Carry_ADD, Carry_INC, Carry_SUB                      : std_logic                        := '0';
begin
    ADD_RESULT : FullAddSub
        generic map(
            n => n
        )
        port map(
            A       => A,
            B       => B,
            CBin    => '0',
            control => '1',
            res     => ADD_RES,
            CBout   => Carry_ADD
        );
    SUB_RESULT : FullAddSub
        generic map(
            n => n
        )
        port map(
            A       => A,
            B       => B,
            CBin    => '0',
            control => '0',
            res     => SUB_RES,
            CBout   => Carry_SUB
        );
    INC_RESULT : FullAddSub
        generic map(
            n => n
        )
        port map(
            A       => A,
            B       => (0 => '1', others => '0'),
            CBin    => '0',
            control => '1',
            res     => INC_RES,
            CBout   => Carry_INC
        );
    AND_RES <= A AND B;
    MOV_RES <= A;
    NOT_RES <= NOT A;
    Result  <= ADD_RES WHEN FunctionOpcode = "000" AND ALUOP = "11" ELSE
               NOT_RES WHEN FunctionOpcode = "001" AND ALUOP = "11" ELSE
               INC_RES WHEN FunctionOpcode = "010" AND ALUOP = "11" ELSE
               MOV_RES WHEN FunctionOpcode = "011" AND ALUOP = "11" ELSE
               SUB_RES WHEN FunctionOpcode = "101" AND ALUOP = "11" ELSE
               AND_RES WHEN FunctionOpcode = "110" AND ALUOP = "11" ELSE
               B WHEN ALUOP = "01" ELSE
               (others => '0');

    --Z FLAG
    CCR(0) <= '1' WHEN FunctionOpcode = "000" AND ALUOP = "11" AND unsigned(ADD_RES) = 0 ELSE
              '1' WHEN FunctionOpcode = "001" AND ALUOP = "11" AND unsigned(NOT_RES) = 0 ELSE
              '1' WHEN FunctionOpcode = "010" AND ALUOP = "11" AND unsigned(INC_RES) = 0 ELSE
              '1' WHEN FunctionOpcode = "101" AND ALUOP = "11" AND unsigned(SUB_RES) = 0 ELSE
              '1' WHEN FunctionOpcode = "110" AND ALUOP = "11" AND unsigned(AND_RES) = 0 ELSE
              '0';
    --N FLAG
    CCR(1) <= ADD_RES(N - 1) WHEN FunctionOpcode = "000" AND ALUOP = "11" ELSE
              NOT_RES(N - 1) WHEN FunctionOpcode = "001" AND ALUOP = "11" ELSE
              INC_RES(N - 1) WHEN FunctionOpcode = "010" AND ALUOP = "11" ELSE
              SUB_RES(N - 1) WHEN FunctionOpcode = "101" AND ALUOP = "11" ELSE
              AND_RES(N - 1) WHEN FunctionOpcode = "110" AND ALUOP = "11" ELSE
              '0';
    --C FLAG
    CCR(2) <= Carry_ADD WHEN FunctionOpcode = "000" AND ALUOP = "11" ELSE
              Carry_INC WHEN FunctionOpcode = "010" AND ALUOP = "11" ELSE
              Carry_SUB WHEN FunctionOpcode = "101" AND ALUOP = "11" ELSE
              '1' WHEN FunctionOpcode = "100" AND ALUOP = "11" ELSE
              '0';

    --CCR ENABLE

    --00 disable
    --01 C-flag only
    --10 N-flag and Z-flag only
    --11 all flags
    Carry_Reg_en <= "11" WHEN FunctionOpcode = "000" AND ALUOP = "11" ELSE --add
                    "10" WHEN FunctionOpcode = "001" AND ALUOP = "11" ELSE --not
                    "11" WHEN FunctionOpcode = "010" AND ALUOP = "11" ELSE --inc
                    "11" WHEN FunctionOpcode = "101" AND ALUOP = "11" ELSE --sub
                    "10" WHEN FunctionOpcode = "110" AND ALUOP = "11" ELSE --and
                    "01" WHEN FunctionOpcode = "100" AND ALUOP = "11" ELSE --setc
                    "00";
    
end architecture ALU_Arch;
