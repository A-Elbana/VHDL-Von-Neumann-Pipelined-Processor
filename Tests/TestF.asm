# all numbers in hex format
# we always start by reset signal
# this is a commented line
# you should ignore empty lines

.ORG 0  #this is the reset address
200

.ORG 1  #HW INT address
400

.ORG 400
SUB R2, R2, R2
RTI

.ORG 200
IN  R1            #R1=30
IN  R2            #R2=50
IN  R6            #R6=2

ADD R3,R1,R2     
AND R4,R3,R1      
NOT R4            

SWAP R2,R1        

SUB R5,R1,R2      
INC R5           

JZ  300           
ADD R6,R6,R6     
# Hardware interrupt
JZ 500

.ORG 300
ADD R7,R7,R7      

.ORG 500
OUT R1            