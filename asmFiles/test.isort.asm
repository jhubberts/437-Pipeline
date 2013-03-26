org 0x0000

	# $1 <= A*
	# $2 <= len
	# $3 <= i
	# $4 <= j
	# $5 <= tmp
	# MIPS ONLY VARIABLES
	# $6 <= load_dest
	# $7 <= store_value
	# $8 <= slt_check

	# Set stack pointer
	ori $sp, $zero, 0x4000

	# Set the array pointer to 0x800
	ori $1, $zero, 0x800

	# Set the array length to 100 words (400 bytes)
	ori $2, $zero, 400

	#for(i=1;...;...)
	ori $3, $zero, 4

outer:
	#for(...;i<len;...)
	slt $8, $3, $2
	beq $8, $zero, exitouter

	#tmp=A[i];
	addu $6, $1, $3
	lw $5, 0($6)

	#j=i;
	or $4, $zero, $3

inner:
	#while(j<=0 && (tmp<A[j-1))
	slti $8, $4, 4
	bne $8, $zero, exitinner
	addu $6, $1, $4
	lw $7, -4($6)
	slt $8, $5, $7
	beq $8, $0, exitinner
	
	#A[j]=A[j-1]
	addu $6, $1, $4
	lw $7, -4($6)
	sw $7, 0($6)

	#j=j-1;
	addiu $4, $4, -4
	j inner
exitinner:

	#A[j]=tmp;
	addu $6, $1, $4
	sw $5, 0($6)

	#for(...;...;i++)
	addiu $3, $3, 4
	j outer

exitouter:

halt

sortdata:
org 0x0800
cfw 0x087d
cfw 0x5fcb
cfw 0xa41a
cfw 0x4109
cfw 0x4522
cfw 0x700f
cfw 0x766d
cfw 0x6f60
cfw 0x8a5e
cfw 0x9580
cfw 0x70a3
cfw 0xaea9
cfw 0x711a
cfw 0x6f81
cfw 0x8f9a
cfw 0x2584
cfw 0xa599
cfw 0x4015
cfw 0xce81
cfw 0xf55b
cfw 0x399e
cfw 0xa23f
cfw 0x3588
cfw 0x33ac
cfw 0xbce7
cfw 0x2a6b
cfw 0x9fa1
cfw 0xc94b
cfw 0xc65b
cfw 0x0068
cfw 0xf499
cfw 0x5f71
cfw 0xd06f
cfw 0x14df
cfw 0x1165
cfw 0xf88d
cfw 0x4ba4
cfw 0x2e74
cfw 0x5c6f
cfw 0xd11e
cfw 0x9222
cfw 0xacdb
cfw 0x1038
cfw 0xab17
cfw 0xf7ce
cfw 0x8a9e
cfw 0x9aa3
cfw 0xb495
cfw 0x8a5e
cfw 0xd859
cfw 0x0bac
cfw 0xd0db
cfw 0x3552
cfw 0xa6b0
cfw 0x727f
cfw 0x28e4
cfw 0xe5cf
cfw 0x163c
cfw 0x3411
cfw 0x8f07
cfw 0xfab7
cfw 0x0f34
cfw 0xdabf
cfw 0x6f6f
cfw 0xc598
cfw 0xf496
cfw 0x9a9a
cfw 0xbd6a
cfw 0x2136
cfw 0x810a
cfw 0xca55
cfw 0x8bce
cfw 0x2ac4
cfw 0xddce
cfw 0xdd06
cfw 0xc4fc
cfw 0xfb2f
cfw 0xee5f
cfw 0xfd30
cfw 0xc540
cfw 0xd5f1
cfw 0xbdad
cfw 0x45c3
cfw 0x708a
cfw 0xa359
cfw 0xf40d
cfw 0xba06
cfw 0xbace
cfw 0xb447
cfw 0x3f48
cfw 0x899e
cfw 0x8084
cfw 0xbdb9
cfw 0xa05a
cfw 0xe225
cfw 0xfb0c
cfw 0xb2b2
cfw 0xa4db
cfw 0x8bf9
cfw 0x12f7
