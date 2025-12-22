vsim work.memory
add wave -position insertpoint sim:/memory/*

# Define Clock: 100ns period
force -freeze sim:/memory/clk 1 0, 0 {50 ns} -r 100

# 1. Test File Initialization (Reading from out1.txt)
# This assumes out1.txt has data at address 0 and 1
force -freeze sim:/memory/MemRead 1 0
force -freeze sim:/memory/Address 32#00000000 0
run 100 ns
force -freeze sim:/memory/Address 32#00000001 0
run 100 ns

# 2. Test HWInt (Asynchronous Write)
# This should write even if the clock hasn't reached a rising edge
force -freeze sim:/memory/HWInt 1 0
force -freeze sim:/memory/Address 32#00000005 0
force -freeze sim:/memory/writeData 32#AAAA5555 0
run 10 ns; # Check wave here - write should be immediate
force -freeze sim:/memory/HWInt 0 0

# 3. Test MemWrite (Synchronous Write)
force -freeze sim:/memory/MemWrite 1 0
force -freeze sim:/memory/Address 32#0000000A 0
force -freeze sim:/memory/writeData 32#12345678 0
run 100 ns; # Write happens at the rising edge

# 4. Verify Reads and Bounds
force -freeze sim:/memory/MemWrite 0 0
force -freeze sim:/memory/MemRead 1 0
force -freeze sim:/memory/Address 32#00000005 0
run 100 ns
force -freeze sim:/memory/Address 32#0000000A 0
run 100 ns

# 5. Out of Bounds Test (Address > 262143)
# Should return 32'b0 per your updated code
force -freeze sim:/memory/Address 32#00040001 0
run 100 ns