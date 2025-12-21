# --- Initialization ---
LDM R0, 0x05          # R0 = 5
LDM R1, 0x0A          # R1 = 10 (10)
LDM R2, 0x02          # R2 = 2
NOP
NOP
# --- Hazard Test Block 1: Arithmetic Chain (EX to EX Forwarding) ---
ADD R3, R0, R1        # R3 = 5 + 10 = 15 (0xF)
ADD R4, R3, R2        # R4 = 15 + 2 = 17 (0x11) -> Hazard: R3 from previous EX
SUB R5, R4, R0        # R5 = 17 - 5 = 12 (0xC)  -> Hazard: R4 from previous EX

# --- Hazard Test Block 2: Multi-stage & Logic (MEM to EX Forwarding) ---
NOT R5            # R5 = ~12 (In 32-bit: 0xFFFFFFF3)
NOP
IADD R6, R5, 0x0F     # R6 = 0xFFFFFFF3 + 13 = 0x00000000 -> Result is 0
ADD R0, R6, R1        # R0 = 0 + 10 = 10 (0xA)

# --- Hazard Test Block 3: Memory Pointer Hazards ---
# Using R0 (just updated) to calculate an address
IADD R3, R0, 0x04     # R3 = 10 + 4 = 14 (0xE)
STD R1, 0(R3)         # MEM[14] = R1 (10) -> Hazard: R3 used as pointer immediately
LDD R7, 0(R3)         # R7 = MEM[14] = 10  -> Hazard: R3 used as pointer immediately

# --- Final Manipulation ---
MOV R2, R7            # R2 = 10
INC R2                # R2 = 11 (0xB)
SETC                  # Carry Flag = 1
HLT                   # End Simulation