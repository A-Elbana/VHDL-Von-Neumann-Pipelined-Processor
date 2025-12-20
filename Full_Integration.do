project compileall
vsim -gui work.full_integration
add wave -divider "DEBUG Watch"
add wave -position insertpoint  \
sim:/full_integration/clk \
sim:/full_integration/rst  \
sim:/full_integration/WB_D_Stage_inst/regfile_inst/RegFile \
sim:/full_integration/EX_Stage_inst/CCR
add wave -divider "IFID_Reg_Outputs"
add wave -position insertpoint  \
sim:/full_integration/IFIDRegister_inst/SWP_OUT \
sim:/full_integration/IFIDRegister_inst/Immediate_OUT
add wave -position insertpoint -radix decimal sim:/full_integration/IFIDRegister_inst/PC_OUT
add wave -position insertpoint \
sim:/full_integration/IFIDRegister_inst/Instruction_OUT
add wave -divider "WB_D_Outputs"
add wave -position insertpoint  \
sim:/full_integration/WB_D_Stage_inst/MEMWBRegWrite_OUT 
add wave -position insertpoint -radix decimal sim:/full_integration/WB_D_Stage_inst/PC_Out 
add wave -position insertpoint \
sim:/full_integration/WB_D_Stage_inst/ReadData1 \
sim:/full_integration/WB_D_Stage_inst/ReadData2 \
sim:/full_integration/WB_D_Stage_inst/Imm_32_OUT \
sim:/full_integration/WB_D_Stage_inst/func \
sim:/full_integration/WB_D_Stage_inst/Rdst \
sim:/full_integration/WB_D_Stage_inst/Rsrc1 \
sim:/full_integration/WB_D_Stage_inst/Rsrc2 \
sim:/full_integration/WB_D_Stage_inst/MemToReg_OUT \
sim:/full_integration/WB_D_Stage_inst/RegWrite_OUT \
sim:/full_integration/WB_D_Stage_inst/PCStore \
sim:/full_integration/WB_D_Stage_inst/MemOp_Inst \
sim:/full_integration/WB_D_Stage_inst/MemOp_Priority \
sim:/full_integration/WB_D_Stage_inst/MemRead \
sim:/full_integration/WB_D_Stage_inst/MemWrite \
sim:/full_integration/WB_D_Stage_inst/RET \
sim:/full_integration/WB_D_Stage_inst/RTI \
sim:/full_integration/WB_D_Stage_inst/InputOp \
sim:/full_integration/WB_D_Stage_inst/ALUSrc \
sim:/full_integration/WB_D_Stage_inst/OutOp \
sim:/full_integration/WB_D_Stage_inst/SWINT \
sim:/full_integration/WB_D_Stage_inst/JMPCALL \
sim:/full_integration/WB_D_Stage_inst/HLT \
sim:/full_integration/WB_D_Stage_inst/PCWrite \
sim:/full_integration/WB_D_Stage_inst/SWP \
sim:/full_integration/WB_D_Stage_inst/Imm32_SIGNAL \
sim:/full_integration/WB_D_Stage_inst/IFID_EN \
sim:/full_integration/WB_D_Stage_inst/IDEX_EN \
sim:/full_integration/WB_D_Stage_inst/EXMEM_EN \
sim:/full_integration/WB_D_Stage_inst/MEMWB_EN \
sim:/full_integration/WB_D_Stage_inst/SECOND_SWP_OUT \
sim:/full_integration/WB_D_Stage_inst/StackOpType \
sim:/full_integration/WB_D_Stage_inst/ALUOPType \
sim:/full_integration/WB_D_Stage_inst/JMPType
add wave -divider "IDEX_Reg_Outputs"
add wave -position insertpoint  \
sim:/full_integration/IDEXRegister_inst/MemToReg_OUT \
sim:/full_integration/IDEXRegister_inst/RegWrite_OUT \
sim:/full_integration/IDEXRegister_inst/PCStore_OUT \
sim:/full_integration/IDEXRegister_inst/MemOp_Inst_OUT \
sim:/full_integration/IDEXRegister_inst/MemRead_OUT \
sim:/full_integration/IDEXRegister_inst/MemWrite_OUT \
sim:/full_integration/IDEXRegister_inst/RET_OUT \
sim:/full_integration/IDEXRegister_inst/RTI_OUT \
sim:/full_integration/IDEXRegister_inst/ALUSrc_OUT \
sim:/full_integration/IDEXRegister_inst/OutOp_OUT \
sim:/full_integration/IDEXRegister_inst/SWINT_OUT \
sim:/full_integration/IDEXRegister_inst/JMPCALL_OUT \
sim:/full_integration/IDEXRegister_inst/SECOND_SWP_OUT \
sim:/full_integration/IDEXRegister_inst/InputOp_OUT \
sim:/full_integration/IDEXRegister_inst/ALUOPType_OUT \
sim:/full_integration/IDEXRegister_inst/JMPType_OUT \
sim:/full_integration/IDEXRegister_inst/StackOpType_OUT
add wave -position insertpoint -radix decimal sim:/full_integration/IDEXRegister_inst/PC_OUT 
add wave -position insertpoint \
sim:/full_integration/IDEXRegister_inst/ReadData1_OUT \
sim:/full_integration/IDEXRegister_inst/ReadData2_OUT \
sim:/full_integration/IDEXRegister_inst/Immediate_OUT \
sim:/full_integration/IDEXRegister_inst/Rsrc1_OUT \
sim:/full_integration/IDEXRegister_inst/Rsrc2_OUT \
sim:/full_integration/IDEXRegister_inst/Rdst_OUT \
sim:/full_integration/IDEXRegister_inst/Funct_OUT
add wave -divider "ALU_Outputs"
add wave -position insertpoint -radix decimal \
sim:/full_integration/EX_Stage_inst/PC_Out 
add wave -position insertpoint \
sim:/full_integration/EX_Stage_inst/ALUResult \
sim:/full_integration/EX_Stage_inst/StoreData \
sim:/full_integration/EX_Stage_inst/OUTPORT \
sim:/full_integration/EX_Stage_inst/CCR \
sim:/full_integration/EX_Stage_inst/M_out_Control \
sim:/full_integration/EX_Stage_inst/WB_out_Control \
sim:/full_integration/EX_Stage_inst/ConditionalJMP
add wave -divider "EXMEM_Reg_Outputs"
add wave -position insertpoint  \
sim:/full_integration/EXMEMRegister_inst/MemToReg_OUT \
sim:/full_integration/EXMEMRegister_inst/RegWrite_OUT \
sim:/full_integration/EXMEMRegister_inst/PCStore_OUT \
sim:/full_integration/EXMEMRegister_inst/MemOp_Inst_OUT \
sim:/full_integration/EXMEMRegister_inst/MemRead_OUT \
sim:/full_integration/EXMEMRegister_inst/MemWrite_OUT \
sim:/full_integration/EXMEMRegister_inst/RET_OUT \
sim:/full_integration/EXMEMRegister_inst/RTI_OUT \
sim:/full_integration/EXMEMRegister_inst/StackOpType_OUT
add wave -position insertpoint -radix decimal sim:/full_integration/EXMEMRegister_inst/PC_OUT
add wave -position insertpoint \
sim:/full_integration/EXMEMRegister_inst/StoreData_OUT \
sim:/full_integration/EXMEMRegister_inst/ALUResult_OUT \
sim:/full_integration/EXMEMRegister_inst/CCR_OUT \
sim:/full_integration/EXMEMRegister_inst/Rdst_OUT
add wave -divider "IF_MEM_Outputs"
add wave -position insertpoint  \
sim:/full_integration/IF_MEM_Stage_inst/IF_Imm \
sim:/full_integration/IF_MEM_Stage_inst/EXMEM_MemOp_Inst \
sim:/full_integration/IF_MEM_Stage_inst/EXMEM_RTI \
sim:/full_integration/IF_MEM_Stage_inst/MemToReg_OUT \
sim:/full_integration/IF_MEM_Stage_inst/RegWrite_OUT
add wave -position insertpoint -radix decimal sim:/full_integration/IF_MEM_Stage_inst/PC_OUT
add wave -position insertpoint \
sim:/full_integration/IF_MEM_Stage_inst/readData_OUT \
sim:/full_integration/IF_MEM_Stage_inst/ALUResult_OUT \
sim:/full_integration/IF_MEM_Stage_inst/writeAddr_OUT \
sim:/full_integration/IF_MEM_Stage_inst/IFID_FLUSH \
sim:/full_integration/IF_MEM_Stage_inst/Fetched_Inst
add wave -divider "MEM_WB_Reg_Outputs"
add wave -position insertpoint  \
sim:/full_integration/MEMWBRegister_inst/MemToReg_OUT \
sim:/full_integration/MEMWBRegister_inst/RegWrite_OUT \
sim:/full_integration/MEMWBRegister_inst/MEMResult_OUT \
sim:/full_integration/MEMWBRegister_inst/ALUResult_OUT \
sim:/full_integration/MEMWBRegister_inst/Rdst_OUT
force -freeze sim:/full_integration/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/full_integration/rst 1 0
run 50 ps
force -freeze sim:/full_integration/rst 0 0
run 50 ps
