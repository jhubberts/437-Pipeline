	org		0x0000

	ori		$sp, $zero, 0x3FF4
	ori		$13, $zero, 365
	ori		$14, $zero, 30

	#Push the year into register 10
        LW $10, 0($sp)
	ADDIU $sp, $sp, 4
	#Push the month into register 11
        LW $11, 0($sp)
	ADDIU $sp, $sp, 4
	#Push the day into register 12
        LW $12, 0($sp)
	ADDIU $sp, $sp, 4

	#Subtract 2000 from the year
	addiu $10, $10, -2000 

	#Subtract 1 from the month
	addiu $11, $11, -1
	
	
	ADDIU $sp, $sp, -4
	SW $14, 0($sp)
	ADDIU $sp, $sp, -4
	SW $11, 0($sp)
	jal mult
	LW $11, 0($sp)
	ADDIU $sp, $sp, 4
	addu $12, $11, $12

	ADDIU $sp, $sp, -4
	SW $10, 0($sp)
	ADDIU $sp, $sp, -4
	SW $13, 0($sp)
	jal mult

	LW $10, 0($sp)
	ADDIU $sp, $sp, 4
	addu $12, $10, $12

	ADDIU $sp, $sp, -4
	SW $12, 0($sp)	
	halt	

	org 0x1000
mult:
	#Load the 1st operand into $1, then increase the stack
        LW $1, 0($sp)
	ADDIU $sp, $sp, 4
	#Load the 2nd operand into $2, then increase the sack
	LW $2, 0($sp)
	ADDIU $sp, $sp, 4
	#Initialize the result to $0
	ori $3, $zero, 0x0000
check:	
	andi $4, $1, 1
        srl $1, $1, 1
	beq $4, $zero, shift
	addu $3, $3, $2
shift:
	sll $2, $2, 1
	bne $1, $zero, check
	ADDIU $sp, $sp, -4
	SW $3, 0($sp)
	jr $31

	org		0x3FF4
	cfw		2012
	cfw		12
	cfw		14

