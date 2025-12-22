vsim work.regfile
add wave -position insertpoint sim:/regfile/*

# Define Clock
force -freeze sim:/regfile/clk 1 0, 0 {50 ns} -r 100

# 1. Reset check: Initially all should be 0 
force -freeze sim:/regfile/regWrite 0 0
force -freeze sim:/regfile/readReg1 3'b000 0
force -freeze sim:/regfile/readReg2 3'b111 0
run 100 ns

# 2. Exhaustive Write: Write to every register (0 to 7)
for {set i 0} {$i < 8} {incr i} {
    force -freeze sim:/regfile/regWrite 1 0
    force -freeze sim:/regfile/writeReg [format %03b $i] 0
    force -freeze sim:/regfile/writeData [format 32#%X [expr $i + 0xABC0]] 0
    run 100 ns
}

# 3. Dual Read Test: Read different registers on Port 1 and Port 2
force -freeze sim:/regfile/regWrite 0 0
force -freeze sim:/regfile/readReg1 3'b010 0; # Reg 2
force -freeze sim:/regfile/readReg2 3'b101 0; # Reg 5
run 100 ns

# 4. Write-Through Check: Reading a register while writing to it
force -freeze sim:/regfile/regWrite 1 0
force -freeze sim:/regfile/writeReg 3'b111 0
force -freeze sim:/regfile/writeData 32#FFFFFFFF 0
force -freeze sim:/regfile/readReg1 3'b111 0; # Old value should show until next cycle [cite: 11]
run 100 ns