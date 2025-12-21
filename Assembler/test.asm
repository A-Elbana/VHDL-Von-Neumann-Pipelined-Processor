# ============================================
# Comprehensive Test Suite for VHDL Processor
# Tests all instruction types and formats
# ============================================

# ========== Basic Instructions ==========
NOP
NOP
HLT

# ========== Arithmetic Operations ==========
# Load immediate values
LDM R0, 0x10          # Load 16 (hex)
LDM R1, 42            # Load 42 (decimal)
LDM R2, 0b1010        # Load 10 (binary)
LDM R3, -5            # Load -5 (negative)
LDM R4, 0xFF          # Load 255
LDM R5, 0x2A          # Load 42 in hex
LDM R6, 100           # Load 100
LDM R7, 0x00          # Load 0

# Addition operations
ADD R0, R1, R2        # R0 = R1 + R2
ADD R3, R4, R5        # R3 = R4 + R5
ADD R6, R0, R1        # R6 = R0 + R1
ADD R7, R2, R3        # R7 = R2 + R3

# Subtraction operations
SUB R0, R1, R2        # R0 = R1 - R2
SUB R3, R4, R5        # R3 = R4 - R5
SUB R6, R7, R0        # R6 = R7 - R0

# Increment operations
INC R0                # R0 = R0 + 1
INC R1                # R1 = R1 + 1
INC R2                # R2 = R2 + 1
INC R3                # R3 = R3 + 1

# Immediate addition
IADD R0, R1, 10       # R0 = R1 + 10
IADD R2, R3, 0x20     # R2 = R3 + 32
IADD R4, R5, -15      # R4 = R5 - 15
IADD R6, R7, 0b1111   # R6 = R7 + 15

# ========== Logical Operations ==========
# AND operations
AND R0, R1, R2        # R0 = R1 & R2
AND R3, R4, R5        # R3 = R4 & R5
AND R6, R0, R1        # R6 = R0 & R1

# NOT operations
NOT R0                # R0 = ~R0
NOT R1                # R1 = ~R1
NOT R2                # R2 = ~R2
NOT R3                # R3 = ~R3

# ========== Data Movement ==========
# Move operations
MOV R0, R1            # R0 = R1
MOV R2, R3            # R2 = R3
MOV R4, R5            # R4 = R5
MOV R6, R7            # R6 = R7
MOV R1, R0            # R1 = R0
MOV R3, R2            # R3 = R2

# Swap operations
SWAP R0, R1           # Swap R0 and R1
SWAP R2, R3           # Swap R2 and R3
SWAP R4, R5           # Swap R4 and R5
SWAP R6, R7           # Swap R6 and R7

# ========== Stack Operations ==========
# Push operations
PUSH R0               # Push R0 onto stack
PUSH R1               # Push R1 onto stack
PUSH R2               # Push R2 onto stack
PUSH R3               # Push R3 onto stack

# Pop operations
POP R4                # Pop from stack to R4
POP R5                # Pop from stack to R5
POP R6                # Pop from stack to R6
POP R7                # Pop from stack to R7

# ========== Memory Operations ==========
# Load from memory (with offset)
LDD R0, 0(R1)         # R0 = MEM[R1 + 0]
LDD R2, 4(R3)         # R2 = MEM[R3 + 4]
LDD R4, -8(R5)        # R4 = MEM[R5 - 8]
LDD R6, 16(R7)        # R6 = MEM[R7 + 16]
LDD R1, 4(R2)         # R1 = MEM[R2 + 4]

# Store to memory (with offset)
STD R0, 0(R1)         # MEM[R1 + 0] = R0
STD R2, 4(R3)         # MEM[R3 + 4] = R2
STD R4, -8(R5)        # MEM[R5 - 8] = R4
STD R6, 32(R7)        # MEM[R7 + 32] = R6
STD R1, 8(R2)         # MEM[R2 + 8] = R1

# ========== I/O Operations ==========
# Input operations
IN R0                 # Read input to R0
IN R1                 # Read input to R1
IN R2                 # Read input to R2
IN R3                 # Read input to R3

# Output operations
OUT R0                # Output R0
OUT R1                # Output R1
OUT R2                # Output R2
OUT R3                # Output R3
OUT R4                # Output R4
OUT R5                # Output R5

# ========== Control Flow ==========
# Set carry flag
SETC                  # Set carry flag

# Jump operations (various formats)
JMP 0x100             # Jump to address 256
JMP 1000              # Jump to address 1000
JMP 0b1100100         # Jump to address 100

# Conditional jumps
JZ 0x200              # Jump if zero flag set
JZ 500                # Jump if zero flag set
JN 0x300              # Jump if negative flag set
JN 600                # Jump if negative flag set
JC 0x400              # Jump if carry flag set
JC 700                # Jump if carry flag set

# Function call operations
CALL 0x500            # Call function at address 1280
CALL 2000             # Call function at address 2000
CALL 0b1111101000     # Call function at address 1000

# Return operations
RET                   # Return from function
RET                   # Return from function
RET                   # Return from function

# ========== Interrupt Operations ==========
# Interrupt operations
INT 0                 # Interrupt index 0
INT 1                 # Interrupt index 1

# Return from interrupt
RTI                   # Return from interrupt
RTI                   # Return from interrupt

# ========== Complex Program Flow ==========
# Initialize registers
LDM R0, 0             # Initialize counter
LDM R1, 10            # Loop limit
LDM R2, 1             # Increment value
LDM R3, 0             # Accumulator

# Loop-like structure (simulated)
ADD R3, R3, R2        # Accumulate
INC R0                # Increment counter
SUB R1, R1, R2        # Decrement limit
JZ 0x1000             # Jump if limit is zero

# More arithmetic
ADD R4, R0, R1        # R4 = R0 + R1
SUB R5, R1, R0        # R5 = R1 - R0
AND R6, R0, R1        # R6 = R0 & R1
NOT R7                # R7 = ~R7

# Data movement chain
MOV R0, R1            # R0 = R1
MOV R1, R2            # R1 = R2
MOV R2, R3            # R2 = R3
MOV R3, R4            # R3 = R4
MOV R4, R5            # R4 = R5
MOV R5, R6            # R5 = R6
MOV R6, R7            # R6 = R7

# Stack operations sequence
PUSH R0               # Save R0
PUSH R1               # Save R1
PUSH R2               # Save R2
ADD R0, R1, R2        # Modify R0
POP R2                # Restore R2
POP R1                # Restore R1
POP R0                # Restore R0

# Memory operations sequence
LDM R0, 0x1000        # Base address
LDM R1, 42            # Value to store
STD R1, 0(R0)         # Store at base
STD R1, 4(R0)         # Store at base+4
STD R1, 8(R0)         # Store at base+8
LDD R2, 0(R0)         # Load from base
LDD R3, 4(R0)         # Load from base+4
LDD R4, 8(R0)         # Load from base+8

# More immediate operations
IADD R0, R0, 1        # R0 = R0 + 1
IADD R1, R1, 2        # R1 = R1 + 2
IADD R2, R2, 0x10     # R2 = R2 + 16
IADD R3, R3, -5       # R3 = R3 - 5
IADD R4, R4, 0b1111   # R4 = R4 + 15

# Conditional operations with different immediate formats
LDM R0, 0             # Zero value
JZ 0x2000             # Jump if zero (hex address)
LDM R1, -1            # Negative value
JN 0x3000             # Jump if negative (hex address)
SETC                  # Set carry
JC 0x4000             # Jump if carry (hex address)

# Function call sequence
CALL 0x5000           # Call function 1
CALL 0x6000           # Call function 2
CALL 0x7000           # Call function 3
RET                   # Return
RET                   # Return
RET                   # Return

# Interrupt sequence
INT 0                 # Trigger interrupt 0
RTI                   # Return from interrupt
INT 1                 # Trigger interrupt 1
RTI                   # Return from interrupt

# Final operations
MOVS R0, R1           # Move with flags
MOVS R2, R3           # Move with flags
SWAP R4, R5           # Swap registers
SWAP R6, R7           # Swap registers

# I/O sequence
IN R0                 # Read input
IN R1                 # Read input
ADD R2, R0, R1        # Process input
OUT R2                # Output result
OUT R0                # Output original
OUT R1                # Output original

# Final cleanup
NOP                   # No operation
NOP                   # No operation
HLT                   # Halt processor
