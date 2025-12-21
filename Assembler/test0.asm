ADD R3, R3, R2
IADD R2, R3, 0x20     # R2 = R3 + 32
MOV R3, R2            # R3 = R2
INC R0
IN R0
OUT R0
SUB R1, R1, R2
LDM R1, 0x10
STD R2, 4(R3)         # MEM[R3 + 4] = R2
LDD R2, 4(R3)         # R2 = MEM[R3 + 4]
NOT R7                # R7 = ~R7
SETC
HLT                   # Halt processor