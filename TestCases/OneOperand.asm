# all numbers in hex format
# we always start by reset signal
# this is a commented line
# you should ignore empty lines

.ORG 0  #this is the reset address
200

.ORG 200
NOT R1     #R1 = FFFF ,
NOP            #No change
INC R1     #R1 =00000 ,
IN R1	       #R1= 000E, add E on the in port
IN R2          #R2= 0010, add 10 on the in port
NOT R2     #R2= FFEF,
INC R1     #R1= 000F,
LDM R3, 0005
SUB R2, R2, R3    #R2= FFEA,  //R2 - R3
OUT R1
OUT R2