# all numbers in hex format
# we always start by reset signal
# this is a commented line
# you should ignore empty lines

.ORG 0  #this is the reset address
200

.ORG 200
IN R2               #R2=10FE19
IN R3               #R3=21FFFF
IN R4               #R4=E5F320
LDM R1, FFF5
PUSH R1      	    #SP=3FFFE, M[3FFFF] = FFF5
PUSH R2      	    #SP=3FFFD, M[3FFFE] = 10FE19
POP R1       	    #SP=3FFFE, R1 = 10FE19
POP R2       	    #SP=3FFFF, R2 = FFF5
IN R0           #R0=101B0
STD R2, 50(R0)    #M[10200] = FFF5
STD R1, 51(R0)    #M[10201] = 10FE19
LDD R3, 51(R0)    #R3 = 10FE19
LDD R4, 50(R0)    #R4 = FFF5
STD R3, 0(R4)     #M[FFF5] = 10FE19
STD R4, 0(R4)     #M[FFF5] = FFF5
LDD R5, 0(R4)     #R5 = FFF5

