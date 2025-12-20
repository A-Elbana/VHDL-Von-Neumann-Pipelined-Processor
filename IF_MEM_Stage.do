vsim -gui work.if_mem_stage
add wave -divider "ALU_Outputs"
add wave -position insertpoint  \
sim:/if_mem_stage/clk \
sim:/if_mem_stage/rst \
sim:/if_mem_stage/HWInt \
sim:/if_mem_stage/MemOp_Priority_IN \
sim:/if_mem_stage/PCWrite \
sim:/if_mem_stage/SWInt \
sim:/if_mem_stage/interrupt_index \
sim:/if_mem_stage/PCStore_IN \
sim:/if_mem_stage/MemOp_Inst_IN \
sim:/if_mem_stage/MemRead_IN \
sim:/if_mem_stage/MemWrite_IN \
sim:/if_mem_stage/RET_IN \
sim:/if_mem_stage/RTI_IN \
sim:/if_mem_stage/StackOpType_IN \
sim:/if_mem_stage/WB_control_IN \
sim:/if_mem_stage/PC_IN \
sim:/if_mem_stage/StoreData_IN \
sim:/if_mem_stage/ALUResult_IN \
sim:/if_mem_stage/CCR_IN \
sim:/if_mem_stage/Rdst_IN \
sim:/if_mem_stage/IFID_Imm \
sim:/if_mem_stage/IDEX_Imm \
sim:/if_mem_stage/IDEX_ConditionalJMP \
sim:/if_mem_stage/IFID_JMPCALL \
sim:/if_mem_stage/IFID_SWP \
sim:/if_mem_stage/IFID_Imm32_SIGNAL \
sim:/if_mem_stage/IFID_Rsrc \
sim:/if_mem_stage/IFID_Rdst \
sim:/if_mem_stage/IF_Imm \
sim:/if_mem_stage/EXMEM_MemOp_Inst \
sim:/if_mem_stage/EXMEM_RTI \
sim:/if_mem_stage/WB_control_OUT \
sim:/if_mem_stage/PC_OUT \
sim:/if_mem_stage/readData_OUT \
sim:/if_mem_stage/ALUResult_OUT \
sim:/if_mem_stage/writeAddr_OUT \
sim:/if_mem_stage/IFID_FLUSH \
sim:/if_mem_stage/Fetched_Inst \
sim:/if_mem_stage/MemWrite \
sim:/if_mem_stage/MemRead \
sim:/if_mem_stage/Address \
sim:/if_mem_stage/Address_MUX1 \
sim:/if_mem_stage/Address_MUX2 \
sim:/if_mem_stage/writeData \
sim:/if_mem_stage/writeData_MUX \
sim:/if_mem_stage/PC_REG_IN \
sim:/if_mem_stage/PC_REG_OUT \
sim:/if_mem_stage/JMPADDRRESS \
sim:/if_mem_stage/PC_TO_BE_STORED_AND_FLAGS \
sim:/if_mem_stage/STACKPOINTER \
sim:/if_mem_stage/INTINDEX \
sim:/if_mem_stage/LoadPC \
sim:/if_mem_stage/INT \
sim:/if_mem_stage/readData \
sim:/if_mem_stage/demuxInst \
sim:/if_mem_stage/SECOND_SWP_INST \
sim:/if_mem_stage/PC_IN_ADD_1 \
sim:/if_mem_stage/intermediate \
sim:/if_mem_stage/intermediate2
force -freeze sim:/if_mem_stage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/if_mem_stage/rst 1 0
force -freeze sim:/if_mem_stage/PCWrite 0 0
run 100 ps
force -freeze sim:/if_mem_stage/rst 0 0
run 100 ps