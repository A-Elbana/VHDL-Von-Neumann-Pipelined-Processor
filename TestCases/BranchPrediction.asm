# all numbers in hex format
# we always start by reset signal
#this is a commented line

#you should ignore empty lines

.ORG 0
200

.ORG 200
LDM R2,0A #R2=0A
LDM R0,0  #R0=0
LDM R1,50 #R1=50
LDM R3,20 #R3=20
LDM R4,2  #R4=2
JMP 20    #Jump to 20

.ORG 20
SUB R7, R2, R0  //R2 - R0
JZ 50 #jump to 50 if R0=R2
ADD R4,R4,R4 #R4 = R4*2
OUT R4    #4, 8, 10, 20, 40, 80, 100, 200, 400
INC R0
JMP 20 #jump to 20


.ORG 50
LDM R0,0 #R0=0
LDM R2,8 #R2=8
LDM R3,60 #R3=60
LDM R4,3  #R4=3
JMP 60 #jump to 60

.ORG 60
ADD R4,R4,R4 #R4 = R4*2
OUT R4  #6, C, 18, 30, 60, C0, 180, 300
INC R0
AND R5,R2,R0 #when R0 < R2(8) answer will be zero
JZ 60 #jump if R0 < R2 to 60
INC R4
OUT R4  #181