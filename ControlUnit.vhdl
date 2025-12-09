library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ControlUnit is
    port(
        inst_bits : in std_logic_vector(4 downto 0);
        EXMEM_MemOp, HWInt : in std_logic;
        MemToReg, RegWrite, PCStore, MemOp_Inst, MemOp_Priority, MemRead : out std_logic;
        MemWrite, RET, RTI, InputOp, ALUSrc, OutOp : out std_logic;
        SWINT, JMPCALL, HLT, PCWrite, SWP, Imm32 : out std_logic;
        IFID_EN, IDEX_EN, EXMEM_EN, MEMWB_EN : out std_logic;
        StackOpType, ALUOPType, JMPType : out std_logic_vector(1 downto 0)

    );
end entity ControlUnit;

architecture RTL of ControlUnit is
    
    signal decoded_inst : std_logic_vector(31 downto 0);
    signal Imm : std_logic;
    signal RETURNINST : std_logic;
    
begin

    decoded_inst(to_integer(unsigned(inst_bits))) <= '1';

    MemToReg <= decoded_inst(7) -- POP
        or decoded_inst(19); -- LDD
        
    RegWrite <= decoded_inst(2) -- ALUOP
        or decoded_inst(4) -- IN
        or decoded_inst(7) -- POP
        or decoded_inst(9) -- IADD
        or decoded_inst(10) -- LDM
        or decoded_inst(19) -- LDD
        or decoded_inst(31); -- SWAP
        
    
    PCStore <= decoded_inst(15) -- CALL
        or decoded_inst(17); -- INT
    
    MemOp_Inst <= decoded_inst(7) -- POP
        or decoded_inst(19) -- LDD
        or decoded_inst(16) -- RET
        or decoded_inst(18) -- RTI
        or decoded_inst(6) -- PUSH
        or decoded_inst(15) -- CALL
        or decoded_inst(20); -- STD

    MemRead <= decoded_inst(7) -- POP
        or decoded_inst(19) -- LDD
        or decoded_inst(16) -- RET
        or decoded_inst(18); -- RTI

    MemWrite <= decoded_inst(6) -- PUSH
        or decoded_inst(15) -- CALL
        or decoded_inst(20); -- STD

    RETURNINST <= decoded_inst(16) -- RET
        or decoded_inst(18); -- RTI
    
    RET <= RETURNINST;
    
    RTI <= decoded_inst(18); -- RTI

    InputOp <= decoded_inst(4); -- IN

    OutOp <= decoded_inst(3); -- OUT

    ALUSrc <= decoded_inst(9) -- IADD
    or decoded_inst(10) -- LDM
    or decoded_inst(19) -- LDD
    or decoded_inst(20); -- STD

    SWINT <= decoded_inst(17); -- INT

    JMPCALL <= decoded_inst(14) -- JMP
        or decoded_inst(15); -- CALL
    
    HLT <= decoded_inst(1); -- HLT

    SWP <= decoded_inst(31); -- SWAP

    PCWrite <= decoded_inst(1) -- HLT
    or decoded_inst(31) -- SWAP
    or (EXMEM_MemOp and not Imm);
    -- This is the Stack Operation Discriminator bit
    StackOpType(0) <= decoded_inst(7) -- POP
    or RETURNINST; -- Return Instructions
    -- This is the Stack Enable bit
    StackOpType(1) <= decoded_inst(15) -- CALL
    or decoded_inst(17) -- INT
    or decoded_inst(7) -- POP
    or RETURNINST; -- Return Instructions

    ALUOPType(0) <= decoded_inst(10) -- LDM
    or decoded_inst(19) -- LDD
    or decoded_inst(20) -- STD
    or decoded_inst(2) -- ALUOP
    or decoded_inst(9) -- IADD
    or decoded_inst(6); -- PUSH

    ALUOPType(1) <= decoded_inst(19) -- LDD
    or decoded_inst(20) -- STD
    or decoded_inst(2) -- ALUOP
    or decoded_inst(9); -- IADD

    JMPType(0) <= decoded_inst(11) -- JZ
    or decoded_inst(13); -- JC

    JMPType(1) <= decoded_inst(12) -- JN
    or decoded_inst(13); -- JC

    Imm <= decoded_inst(15) -- CALL
    or decoded_inst(10) -- LDM
    or decoded_inst(19) -- LDD
    or decoded_inst(20) -- STD
    or decoded_inst(11) -- JZ
    or decoded_inst(12) -- JN
    or decoded_inst(13) -- JC
    or decoded_inst(14) -- JMP
    or decoded_inst(9); -- IADD

    Imm32 <= Imm;
    MemOp_Priority <= (EXMEM_MemOp and not Imm) or HWInt;
    IFID_EN <= Imm or (EXMEM_MemOp and not Imm) or RETURNINST;
    IDEX_EN <= Imm;
    EXMEM_EN <= Imm;
    MEMWB_EN <= Imm;
end architecture RTL;
