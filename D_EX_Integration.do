vsim -gui work.d_ex_integration_2
add wave -position insertpoint  \
sim:/d_ex_integration_2/clk
add wave -position insertpoint  \
sim:/d_ex_integration_2/rst  \
sim:/d_ex_integration_2/SIM_INPUT_Immediate_IN \
sim:/d_ex_integration_2/SIM_INPUT_PC_IN \
sim:/d_ex_integration_2/SIM_INPUT_Instruction_IN
add wave -divider "IFID_Reg_Outputs"
add wave -position insertpoint  \
sim:/d_ex_integration_2/IFIDRegister_inst/SWP_OUT \
sim:/d_ex_integration_2/IFIDRegister_inst/Immediate_OUT \
sim:/d_ex_integration_2/IFIDRegister_inst/PC_OUT \
sim:/d_ex_integration_2/IFIDRegister_inst/Instruction_OUT
add wave -divider "WB_D_Outputs"
add wave -position insertpoint  \
sim:/d_ex_integration_2/WB_D_Stage_inst/MEMWBRegWrite_OUT \
sim:/d_ex_integration_2/WB_D_Stage_inst/PC_Out \
sim:/d_ex_integration_2/WB_D_Stage_inst/ReadData1 \
sim:/d_ex_integration_2/WB_D_Stage_inst/ReadData2 \
sim:/d_ex_integration_2/WB_D_Stage_inst/Imm_32_OUT \
sim:/d_ex_integration_2/WB_D_Stage_inst/func \
sim:/d_ex_integration_2/WB_D_Stage_inst/Rdst \
sim:/d_ex_integration_2/WB_D_Stage_inst/Rsrc1 \
sim:/d_ex_integration_2/WB_D_Stage_inst/Rsrc2 \
sim:/d_ex_integration_2/WB_D_Stage_inst/MemToReg_OUT \
sim:/d_ex_integration_2/WB_D_Stage_inst/RegWrite_OUT \
sim:/d_ex_integration_2/WB_D_Stage_inst/PCStore \
sim:/d_ex_integration_2/WB_D_Stage_inst/MemOp_Inst \
sim:/d_ex_integration_2/WB_D_Stage_inst/MemOp_Priority \
sim:/d_ex_integration_2/WB_D_Stage_inst/MemRead \
sim:/d_ex_integration_2/WB_D_Stage_inst/MemWrite \
sim:/d_ex_integration_2/WB_D_Stage_inst/RET \
sim:/d_ex_integration_2/WB_D_Stage_inst/RTI \
sim:/d_ex_integration_2/WB_D_Stage_inst/InputOp \
sim:/d_ex_integration_2/WB_D_Stage_inst/ALUSrc \
sim:/d_ex_integration_2/WB_D_Stage_inst/OutOp \
sim:/d_ex_integration_2/WB_D_Stage_inst/SWINT \
sim:/d_ex_integration_2/WB_D_Stage_inst/JMPCALL \
sim:/d_ex_integration_2/WB_D_Stage_inst/HLT \
sim:/d_ex_integration_2/WB_D_Stage_inst/PCWrite \
sim:/d_ex_integration_2/WB_D_Stage_inst/SWP \
sim:/d_ex_integration_2/WB_D_Stage_inst/Imm32_SIGNAL \
sim:/d_ex_integration_2/WB_D_Stage_inst/IFID_EN \
sim:/d_ex_integration_2/WB_D_Stage_inst/IDEX_EN \
sim:/d_ex_integration_2/WB_D_Stage_inst/EXMEM_EN \
sim:/d_ex_integration_2/WB_D_Stage_inst/MEMWB_EN \
sim:/d_ex_integration_2/WB_D_Stage_inst/SECOND_SWP_OUT \
sim:/d_ex_integration_2/WB_D_Stage_inst/StackOpType \
sim:/d_ex_integration_2/WB_D_Stage_inst/ALUOPType \
sim:/d_ex_integration_2/WB_D_Stage_inst/JMPType
add wave -divider "IDEX_Reg_Outputs"
add wave -position insertpoint  \
sim:/d_ex_integration_2/IDEXRegister_inst/MemToReg_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/RegWrite_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/PCStore_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/MemOp_Inst_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/MemRead_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/MemWrite_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/RET_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/RTI_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/ALUSrc_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/OutOp_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/SWINT_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/JMPCALL_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/SECOND_SWP_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/InputOp_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/ALUOPType_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/JMPType_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/StackOpType_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/PC_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/ReadData1_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/ReadData2_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/Immediate_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/Rsrc1_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/Rsrc2_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/Rdst_OUT \
sim:/d_ex_integration_2/IDEXRegister_inst/Funct_OUT
add wave -divider "ALU_Outputs"
add wave -position insertpoint  \
sim:/d_ex_integration_2/EX_Stage_inst/PC_Out \
sim:/d_ex_integration_2/EX_Stage_inst/ALUResult \
sim:/d_ex_integration_2/EX_Stage_inst/StoreData \
sim:/d_ex_integration_2/EX_Stage_inst/OUTPORT \
sim:/d_ex_integration_2/EX_Stage_inst/CCR \
sim:/d_ex_integration_2/EX_Stage_inst/M_out_Control \
sim:/d_ex_integration_2/EX_Stage_inst/WB_out_Control \
sim:/d_ex_integration_2/EX_Stage_inst/ConditionalJMP
add wave -divider "DEBUG"
add wave -position insertpoint  \
sim:/d_ex_integration_2/EX_Stage_inst/ALUResult_Signal
force -freeze sim:/d_ex_integration_2/WB_D_Stage_inst/regfile_inst/RegFile(0) 00000001 0
force -freeze sim:/d_ex_integration_2/WB_D_Stage_inst/regfile_inst/RegFile(1) 00000010 0
force -freeze sim:/d_ex_integration_2/WB_D_Stage_inst/regfile_inst/RegFile(2) 00000100 0
force -freeze sim:/d_ex_integration_2/WB_D_Stage_inst/regfile_inst/RegFile(3) 00001000 0
force -freeze sim:/d_ex_integration_2/WB_D_Stage_inst/regfile_inst/RegFile(4) 00010000 0
force -freeze sim:/d_ex_integration_2/WB_D_Stage_inst/regfile_inst/RegFile(5) 00100000 0
force -freeze sim:/d_ex_integration_2/WB_D_Stage_inst/regfile_inst/RegFile(6) 01000000 0
force -freeze sim:/d_ex_integration_2/WB_D_Stage_inst/regfile_inst/RegFile(7) 10000000 0
force -freeze sim:/d_ex_integration_2/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/d_ex_integration_2/rst 1 0
run 100 ps
force -freeze sim:/d_ex_integration_2/rst 0 0
force -freeze sim:/d_ex_integration_2/SIM_INPUT_Immediate_IN 3 0
force -freeze sim:/d_ex_integration_2/SIM_INPUT_PC_IN F 0
force -freeze sim:/d_ex_integration_2/SIM_INPUT_Instruction_IN 58000000 0
run 100 ps
force -freeze sim:/d_ex_integration_2/SIM_INPUT_Immediate_IN A0A0A0A0 0
run 100 ps
run 100 ps
