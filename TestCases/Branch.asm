# all numbers in hex format
# we always start by reset signal
# this is a commented line
# you should ignore empty lines

.ORG 0  #this is the reset address
200

.ORG 1  #this is the address of the empty stack exception handler
400

.ORG 2  #this is the address of INT0
800

.ORG 3  #this is the address of INT1
0A00

# INT0
.ORG 800
ADD R0,R0,R0    R0 = 0, Z=1
OUT R6
RTI

# INT1
.ORG 0A00
NOP
OUT R1 // R1=80 
RTI

.ORG 200
IN R1     #R1=30
IN R2     #R2=50
IN R3     #R3=100
IN R4     #R4=300
IN R6     #R6=FFFF 
IN R7     #R7=FFFF   
Push R4   #sp=3FFFE, M[3FFFF]=300
JMP 30
INC R7	  # this statement shouldn't be executed,
 
#check flag fowarding
 
.ORG 30
AND R5,R1,R5   #R5=0 , Z = 1
INT0
JZ  50      #Jump taken, Z = 0
INC R7      #this statement shouldn't be executed

#check on flag updated on jump
.ORG 50
JZ 100      #Jump Not taken

#check destination forwarding
NOT R5     #R5=FFFFFFFF, Z = 0,
INC R5     #R5=0, Z=1, C=1
IN  R6     #R6=400, flag no change
JZ  400     #jump taken, Z = 0
INC R1     #shouldn't be executed

#check on load use
.ORG 400
POP R6     #R6=300, SP=3FFFF
Call 300    #SP=3FFFE, M[3FFFF] = PC + 1
INT1
INC R6	  #R6=401, this statement shouldn't be executed till call returns, C--> 0, N-->0,Z-->0
NOP
NOP

.ORG 300
Add R6,R3,R6 #R6=400
Add R1,R1,R2 #R1=80, C->0,N=0, Z=0
RET
INC R7           #this shouldnot be executed

.ORG 500
NOP
NOP