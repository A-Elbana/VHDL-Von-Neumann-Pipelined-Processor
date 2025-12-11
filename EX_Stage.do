vsim -gui work.ex_stage
add wave -position insertpoint  \
sim:/ex_stage/AluOP \
sim:/ex_stage/AluSrc \
sim:/ex_stage/clk \
sim:/ex_stage/func \
sim:/ex_stage/Imm \
sim:/ex_stage/OutOP \
sim:/ex_stage/ReadData1 \
sim:/ex_stage/ReadData2 \
sim:/ex_stage/rst
add wave -position insertpoint  \
sim:/ex_stage/ALU_Second_Operand \
sim:/ex_stage/Carry_Reg_en_signal \
sim:/ex_stage/CCR_singal
add wave -position insertpoint  \
sim:/ex_stage/ALUResult \
sim:/ex_stage/CCR \
sim:/ex_stage/InputOp \
sim:/ex_stage/StoreData \
sim:/ex_stage/JumpType \
sim:/ex_stage/ConditionalJMP 
force -freeze sim:/ex_stage/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/ex_stage/rst 1 0
run
force -freeze sim:/ex_stage/rst 0 0
force -freeze sim:/ex_stage/ReadData1 16'h000000AA 0
force -freeze sim:/ex_stage/ReadData2 16'h00000055 0
force -freeze sim:/ex_stage/StoreData 16'h44444444 0
force -freeze sim:/ex_stage/InputOp 0 0
force -freeze sim:/ex_stage/OutOP 0 0
force -freeze sim:/ex_stage/Imm 16'h00FFFFFF 0
force -freeze sim:/ex_stage/AluSrc 0 0
force -freeze sim:/ex_stage/AluOP 11 0
force -freeze sim:/ex_stage/JumpType 01 0
force -freeze sim:/ex_stage/func 000 0
run
force -freeze sim:/ex_stage/func 000 0
run
force -freeze sim:/ex_stage/func 001 0
run
force -freeze sim:/ex_stage/func 010 0
run
force -freeze sim:/ex_stage/func 011 0
run
force -freeze sim:/ex_stage/func 100 0
run
force -freeze sim:/ex_stage/func 101 0
run
force -freeze sim:/ex_stage/func 110 0
run
force -freeze sim:/ex_stage/AluOP 01 0
run
