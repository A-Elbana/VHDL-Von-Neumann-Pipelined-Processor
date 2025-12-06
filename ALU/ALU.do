vsim -gui work.alu
add wave -position insertpoint  \
sim:/alu/A \
sim:/alu/ALUOP \
sim:/alu/B \
sim:/alu/CCR \
sim:/alu/FunctionOpcode \
sim:/alu/Result 
force -freeze sim:/alu/ALUOP 11 0
force -freeze sim:/alu/A 32'hAA 0
force -freeze sim:/alu/B 32'h55 0 
force -freeze sim:/alu/FunctionOpcode 000 0
run
force -freeze sim:/alu/FunctionOpcode 001 0
run
force -freeze sim:/alu/FunctionOpcode 010 0
run
force -freeze sim:/alu/FunctionOpcode 011 0
run
force -freeze sim:/alu/FunctionOpcode 100 0
run
force -freeze sim:/alu/FunctionOpcode 101 0
run
force -freeze sim:/alu/FunctionOpcode 110 0
run
force -freeze sim:/alu/ALUOP 01 0
run
