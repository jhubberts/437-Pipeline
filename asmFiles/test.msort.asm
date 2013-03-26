#####################
# ISORT INIT - CORE 0
org 0x0000

	# $1 <= A*
	# $2 <= len
	# $9 <= core

	# Set the array pointer to 0x400
	ori $1, $zero, sortdata

	# Set the core register to 0
	ori $9, $zero, 0

	# Now sort
	j isort

#####################
# ISORT INIT - CORE 1
org 0x0200

	# $1 <= A*
	# $2 <= len
	# $9 <= core

	# Set the array pointer to 0x400 + 50 words (200 bytes)
	ori $1, $zero, sortdata
	addi $1, $1, 200

	# Set the core register to 1
	ori $9, $zero, 1

	# Now sort
	j isort

#########################
# ISORT BODY - BOTH CORES

isort:

	# $1 <= A*
	# $2 <= len
	# $3 <= i
	# $4 <= j
	# $5 <= tmp
	# MIPS ONLY VARIABLES
	# $6 <= load_dest
	# $7 <= store_value
	# $8 <= slt_check
	# $9 <= core
	# $29 <= sp

	# Set the array length to 50 words (200 bytes)
	ori $2, $zero, 200

	# Set stack pointer
	ori $sp, $zero, 0x4000

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

	ori $1, $zero, 1
	# If core 0 completed, go to mstart0
	beq $zero, $9, minit0

	# Otherwise, if core 1 completed, go to mstart1
	ori $2, $zero, p1done
	sw $1, 0($2)
	j mstart1

minit0:
	ori $2, $zero, p0done
	sw $1, 0($2)
	j mstart0

##############
#BEGIN MERGE 0

	#A* <= $1 The pointer to the bottom of the first subarray
	#B* <= $2 The pointer to the bottom of the second subarray
	#SP_BOT <= $3 The pointer to the bottom of the sorted stack
	#$4

mstart0:
	ori $1, $zero, p1done
	lw $1, 0($1)
	slt $1, $zero, $1
	beq $1, $zero, mstart0

# TURN OFF CORE 0
halt

##############
#BEGIN MERGE 1

mstart1:
	ori $1, $zero, p0done
	lw $1, 0($1)
	slt $1, $zero, $1
	beq $1, $zero, mstart1

# MERGE

	# $1 <= A*
	# $2 <= B*
	# $3 <= SORTED*

	# $4 <= sortdata[A]
	# $5 <= sortdata[B]
	# $6 <= sortdata[A] < sortdata[B] ? 1 : 0

	# $10 <= A* max
	# $11 <= B* max
	# $12 <= SORTED* max

	#Initialize subpointer A at sortdata word 0 (byte 0)
	ori $1, $zero, sortdata
	addiu $10, $1, 200 # word 50 of sortdata

	#Initialize subpointer B at sortdata word 50 (byte 200)
	addiu $2, $1, 200
	addiu $11, $2, 200 # word 100 of sortdata 

	#Initialize the sorted data pointer at sorteddata word 0 (byte 0)
	ori $3, $zero, sorteddata
	addiu $12, $3, 400 # Word 100 of sorteddata

mouter:
	beq $3, $12, mexitouter

	# Load sortdata[A] and sortdata[B]
	lw $4, 0($1)
	lw $5, 0($2)

	beq $1, $10, bdump
	beq $2, $11, adump

	# If sortdata[A] < sortdata[B], dump a. Otherwise, dump b.
	slt $6, $4, $5
	bne $6 ,$zero, adump
	j bdump

adump:

	# Store sortdata[A] to sorteddata[SORTED]
	sw $4, 0($3)

	# Increment A*
	addiu $1, $1, 4
	j sortedinc

bdump:

	# Store sortdata[B] to sorteddata[SORTED]
	sw $5, 0($3)

	# Increment B*
	addiu $2, $2, 4
	j sortedinc

sortedinc:
	addiu $3, $3, 4
	j mouter

mexitouter:
	halt
	
#Unsorted data array
sortdata: 
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

#Flag specifying whether or not the first subarray is sorted
p0done:
cfw 0x0000

#Flag specifying whether or not the second subarray is sorted
p1done:
cfw 0x0000

#Empty Array used for saving merge data
sorteddata:
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
cfw 0x0000
