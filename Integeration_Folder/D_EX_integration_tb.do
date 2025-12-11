# D_EX_integration Testbench Script for ModelSim
# Run with: do D_EX_integration_tb.do

# Create work library if not exists
if {[file exists work]} {
    vdel -lib work -all
}
vlib work

# Compile all required files
vcom -2008 ALU/ALU.vhd
vcom -2008 ALU/Flags_Reg.vhd
vcom -2008 regFile.vhd
vcom -2008 ControlUnit.vhdl
vcom -2008 IFIDRegister.vhdl
vcom -2008 IDEXRegister.vhdl
vcom -2008 EXMEMRegister.vhdl
vcom -2008 WB_D_Stage.vhd
vcom -2008 EX_Stage.vhd
vcom -2008 D_EX_integration.vhd
vcom -2008 D_EX_integration_tb.vhd

# Start simulation
vsim -t ns work.D_EX_integration_tb

# Add waves for debugging
add wave -divider "Clock and Reset"
add wave -position insertpoint sim:/d_ex_integration_tb/clk
add wave -position insertpoint sim:/d_ex_integration_tb/rst

add wave -divider "IFID Inputs"
add wave -position insertpoint -radix hexadecimal sim:/d_ex_integration_tb/IFID_Instruction_IN
add wave -position insertpoint -radix hexadecimal sim:/d_ex_integration_tb/IFID_PC_IN
add wave -position insertpoint -radix hexadecimal sim:/d_ex_integration_tb/IFID_Immediate_IN
add wave -position insertpoint sim:/d_ex_integration_tb/IFID_SWP_IN
add wave -position insertpoint sim:/d_ex_integration_tb/IFID_flush

add wave -divider "WB Stage Inputs"
add wave -position insertpoint sim:/d_ex_integration_tb/WB_WriteAddr
add wave -position insertpoint -radix hexadecimal sim:/d_ex_integration_tb/WB_ALU_Data
add wave -position insertpoint -radix hexadecimal sim:/d_ex_integration_tb/WB_Memory_Data
add wave -position insertpoint sim:/d_ex_integration_tb/WB_MemToReg
add wave -position insertpoint sim:/d_ex_integration_tb/WB_RegWrite

add wave -divider "Flush Signals"
add wave -position insertpoint sim:/d_ex_integration_tb/IDEX_flush
add wave -position insertpoint sim:/d_ex_integration_tb/EXMEM_flush

add wave -divider "External Inputs"
add wave -position insertpoint -radix hexadecimal sim:/d_ex_integration_tb/INPort
add wave -position insertpoint sim:/d_ex_integration_tb/HWInt
add wave -position insertpoint sim:/d_ex_integration_tb/EXMEM_MemOp_IN

add wave -divider "EXMEM Control Outputs"
add wave -position insertpoint sim:/d_ex_integration_tb/EXMEM_MemToReg_OUT
add wave -position insertpoint sim:/d_ex_integration_tb/EXMEM_RegWrite_OUT
add wave -position insertpoint sim:/d_ex_integration_tb/EXMEM_PCStore_OUT
add wave -position insertpoint sim:/d_ex_integration_tb/EXMEM_MemOp_Inst_OUT
add wave -position insertpoint sim:/d_ex_integration_tb/EXMEM_MemRead_OUT
add wave -position insertpoint sim:/d_ex_integration_tb/EXMEM_MemWrite_OUT
add wave -position insertpoint sim:/d_ex_integration_tb/EXMEM_RET_OUT
add wave -position insertpoint sim:/d_ex_integration_tb/EXMEM_RTI_OUT
add wave -position insertpoint sim:/d_ex_integration_tb/EXMEM_StackOpType_OUT

add wave -divider "EXMEM Data Outputs"
add wave -position insertpoint -radix hexadecimal sim:/d_ex_integration_tb/EXMEM_PC_OUT
add wave -position insertpoint -radix hexadecimal sim:/d_ex_integration_tb/EXMEM_StoreData_OUT
add wave -position insertpoint -radix hexadecimal sim:/d_ex_integration_tb/EXMEM_ALUResult_OUT
add wave -position insertpoint sim:/d_ex_integration_tb/EXMEM_CCR_OUT
add wave -position insertpoint sim:/d_ex_integration_tb/EXMEM_Rdst_OUT

add wave -divider "Control Outputs"
add wave -position insertpoint -radix hexadecimal sim:/d_ex_integration_tb/OUTPORT
add wave -position insertpoint sim:/d_ex_integration_tb/ConditionalJMP
add wave -position insertpoint sim:/d_ex_integration_tb/RegWrite_Fwd
add wave -position insertpoint sim:/d_ex_integration_tb/HLT_OUT
add wave -position insertpoint sim:/d_ex_integration_tb/PCWrite_OUT
add wave -position insertpoint sim:/d_ex_integration_tb/MemOp_Priority_OUT
add wave -position insertpoint sim:/d_ex_integration_tb/Imm32_OUT

add wave -divider "Enable Outputs"
add wave -position insertpoint sim:/d_ex_integration_tb/IFID_EN_OUT
add wave -position insertpoint sim:/d_ex_integration_tb/IDEX_EN_OUT
add wave -position insertpoint sim:/d_ex_integration_tb/EXMEM_EN_OUT
add wave -position insertpoint sim:/d_ex_integration_tb/MEMWB_EN_OUT

add wave -position insertpoint sim:/d_ex_integration_tb/DUT/IDEX_Reg_inst

# Configure wave window
configure wave -namecolwidth 250
configure wave -valuecolwidth 100
configure wave -timelineunits ns

# Run simulation
run 1000 ns

# Zoom to fit
wave zoom full

echo "Simulation complete. Check waveform for results."
