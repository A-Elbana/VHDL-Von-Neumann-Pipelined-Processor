vlib work
vcom forwardUnit.vhd
vsim forwardUnit

add wave -position insertpoint  \
sim:/forwardUnit/ID_EX_Rsrc1 \
sim:/forwardUnit/ID_EX_Rsrc2 \
sim:/forwardUnit/EX_MEM_Rdst \
sim:/forwardUnit/MEM_WB_Rdst \
sim:/forwardUnit/EX_MEM_RegWrite \
sim:/forwardUnit/MEM_WB_RegWrite \
sim:/forwardUnit/ID_EX_Swap \
sim:/forwardUnit/ForwardA \
sim:/forwardUnit/ForwardB

# Initialize ID_EX_Swap to 0
force -freeze sim:/forwardUnit/ID_EX_Swap 0 0

# ----------------------------------------
# Test 1: No Hazards
# R1=1, R2=2. Matches: None.
# ----------------------------------------
force -freeze sim:/forwardUnit/ID_EX_Rsrc1 3'd1 0
force -freeze sim:/forwardUnit/ID_EX_Rsrc2 3'd2 0
force -freeze sim:/forwardUnit/EX_MEM_Rdst 3'd3 0
force -freeze sim:/forwardUnit/MEM_WB_Rdst 3'd4 0
force -freeze sim:/forwardUnit/EX_MEM_RegWrite 1 0
force -freeze sim:/forwardUnit/MEM_WB_RegWrite 1 0
run
# Expect: ForwardA = 00, ForwardB = 00

# ----------------------------------------
# Test 2: EX Hazard on Src1 (ForwardA)
# R1=1, match with EX_MEM_Rdst=1
# ----------------------------------------
force -freeze sim:/forwardUnit/EX_MEM_Rdst 3'd1 0
run
# Expect: ForwardA = 10 (Forward form EX), ForwardB = 00

# ----------------------------------------
# Test 3: MEM Hazard on Src1 (ForwardA)
# R1=1, match with MEM_WB_Rdst=1
# EX_MEM_Rdst changed to 3 (no match)
# ----------------------------------------
force -freeze sim:/forwardUnit/EX_MEM_Rdst 3'd3 0
force -freeze sim:/forwardUnit/MEM_WB_Rdst 3'd1 0
run
# Expect: ForwardA = 01 (Forward from MEM), ForwardB = 00

# ----------------------------------------
# Test 4: Priority Check (Simultaneous EX and MEM Match)
# R1=1, EX=1, MEM=1. EX should win.
# ----------------------------------------
force -freeze sim:/forwardUnit/EX_MEM_Rdst 3'd1 0
force -freeze sim:/forwardUnit/MEM_WB_Rdst 3'd1 0
run
# Expect: ForwardA = 10 (EX Priority), ForwardB = 00

# ----------------------------------------
# Test 5: EX Hazard on Src2 (ForwardB)
# R2=2, EX_MEM_Rdst=2
# ----------------------------------------
force -freeze sim:/forwardUnit/EX_MEM_Rdst 3'd2 0
force -freeze sim:/forwardUnit/MEM_WB_Rdst 3'd4 0
run
# Expect: ForwardA = 00, ForwardB = 10 (Forward from EX)

# ----------------------------------------
# Test 6: RegWrite Disabled Check
# R2=2, EX_MEM_Rdst=2, but RegWrite=0
# ----------------------------------------
force -freeze sim:/forwardUnit/EX_MEM_RegWrite 0 0
run
# Expect: ForwardA = 00, ForwardB = 00 (No forwarding because RegWrite is 0)

# Reset RegWrite for next tests
force -freeze sim:/forwardUnit/EX_MEM_RegWrite 1 0

# ----------------------------------------
# Test 7: Double Hazard (A and B forwarded)
# R1=1 (MEM Match), R2=2 (EX Match)
# ----------------------------------------
force -freeze sim:/forwardUnit/ID_EX_Rsrc1 3'd1 0
force -freeze sim:/forwardUnit/ID_EX_Rsrc2 3'd2 0
force -freeze sim:/forwardUnit/EX_MEM_Rdst 3'd2 0
force -freeze sim:/forwardUnit/MEM_WB_Rdst 3'd1 0
run
# Expect: ForwardA = 01 (MEM), ForwardB = 10 (EX)

# ----------------------------------------
# Test 8: Swap Disable EX Hazard
# Hazard exists on Rsrc1 (EX Match), BUT ID_EX_Swap is 1.
# Should disable forwarding (10 -> 00).
# ----------------------------------------
force -freeze sim:/forwardUnit/ID_EX_Rsrc1 3'd1 0
force -freeze sim:/forwardUnit/EX_MEM_Rdst 3'd1 0
force -freeze sim:/forwardUnit/EX_MEM_RegWrite 1 0
force -freeze sim:/forwardUnit/MEM_WB_RegWrite 0 0
force -freeze sim:/forwardUnit/ID_EX_Swap 1 0
run
# Expect: ForwardA = 00 (Forward Disabled by Swap), ForwardB = 00

# ----------------------------------------
# Test 9: Swap Allows MEM Hazard
# No EX Hazard, but MEM Hazard exists. Swap is 1.
# Should ALLOW forwarding (01).
# ----------------------------------------
force -freeze sim:/forwardUnit/EX_MEM_Rdst 3'd3 0
force -freeze sim:/forwardUnit/MEM_WB_RegWrite 1 0
force -freeze sim:/forwardUnit/MEM_WB_Rdst 3'd1 0
force -freeze sim:/forwardUnit/ID_EX_Swap 1 0
run
# Expect: ForwardA = 01 (MEM Fwd allowed even if Swap=1), ForwardB = 00
# ----------------------------------------
# Test 10: Priority Shift (EX and MEM match, but Swap=1)
# R1=1, EX_Rdst=1, MEM_Rdst=1. 
# Because Swap=1, EX is ignored, logic should pick MEM.
# ----------------------------------------
force -freeze sim:/forwardUnit/ID_EX_Rsrc1 3'd1 0
force -freeze sim:/forwardUnit/EX_MEM_Rdst 3'd1 0
force -freeze sim:/forwardUnit/MEM_WB_Rdst 3'd1 0
force -freeze sim:/forwardUnit/EX_MEM_RegWrite 1 0
force -freeze sim:/forwardUnit/MEM_WB_RegWrite 1 0
force -freeze sim:/forwardUnit/ID_EX_Swap 1 0
run
# Expect: ForwardA = 01 (MEM stage wins because EX is disabled by Swap)