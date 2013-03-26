	org		0x0000

	ori		$sp, $zero, 0x4000
	ori		$3, $zero, 15
	ori		$4, $zero, 8
	ori		$5, $zero, 3
	ori		$6, $zero, 17
	ori		$7, $zero, 6

# Push the stack
	ADDIU $sp, $sp, -4
	SW $3, 0($sp)
	ADDIU $sp, $sp, -4
	SW $4, 0($sp)
	ADDIU $sp, $sp, -4
	SW $5, 0($sp)
	ADDIU $sp, $sp, -4
	SW $6, 0($sp)
	ADDIU $sp, $sp, -4
	SW $7, 0($sp)


	jal mult
	jal mult
	jal mult
	jal mult

#	15 * 8 * 3 * 17 * 6  should be at 0x3FFC
	halt




	org 0x0800
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

	org		0x3FF8
	cfw		5
	cfw		10

