	org 0x0000
start:
	ori $1, $0, 256
	ori $2, $0, 0x01
	bne	$2, $0, foobar2000
	halt
foobar2000:
	lui $4, 0xBEEF
	xori $5, $4, 0xDEAD
	sw $5, 44($1)
	halt
