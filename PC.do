vsim work.pc
add wave -position insertpoint sim:/pc/*

# Define Clock
force -freeze sim:/pc/clk 1 0, 0 {50 ns} -r 100

# 1. Asynchronous Reset Test
force -freeze sim:/pc/reset 1 0
force -freeze sim:/pc/PCWrite 0 0
force -freeze sim:/pc/memOP 0 0
force -freeze sim:/pc/PC_IN 32#FFFFFFFF 0
run 50 ns; # Should be 0 immediately 

# 2. Sequential Increment Test
force -freeze sim:/pc/reset 0 0
force -freeze sim:/pc/PCWrite 1 0
run 400 ns; # PC should reach 4 

# 3. Memory Operation (Jump/Load) Test
force -freeze sim:/pc/PCWrite 0 0
force -freeze sim:/pc/memOP 1 0
force -freeze sim:/pc/PC_IN 32#00000500 0
run 100 ns; # PC should become 500 

# 4. Priority Test: PCWrite vs memOP
# When both are high, code says increment takes priority 
force -freeze sim:/pc/PCWrite 1 0
force -freeze sim:/pc/memOP 1 0
force -freeze sim:/pc/PC_IN 32#00000999 0
run 100 ns; # PC should become 501, NOT 999

# 5. Stall Test: No signals active
force -freeze sim:/pc/PCWrite 0 0
force -freeze sim:/pc/memOP 0 0
run 200 ns; # PC should stay at 501