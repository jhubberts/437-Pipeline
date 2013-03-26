	org		0x0000
	ori		$29, $zero, 0x3FF8 # two spots lower

mult:
	#Load the 1st operand into $1, then increase the stack
        LW $1, 0($29)
	ADDIU $29, $29, 4
	#Load the 2nd operand into $2, then increase the sack
	LW $2, 0($29)
	ADDIU $29, $29, 4
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
	ADDIU $29, $29, -4
	SW $3, 0($29)
	halt 


	org		0x3FF8
	cfw		5
	cfw		10

