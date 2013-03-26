org 0x0000
	ori $sp, $0, 0x3FF0
	addu $fp, $sp, $0

	jal main
	nop
	halt


quicksort:
	
	addiu	$sp,$sp,-64	#allocate a local frame
	sw	$31,60($sp)	#save the return address
	sw	$fp,56($sp)	#save the caller's frame point
	addu	$fp,$sp,$0	#set our frame pointer to the stack pointer

#save the arguments
	sw	$a0,64($fp)	#array pointer
	sw	$a1,68($fp)
	sw	$a2,72($fp)
#initialize the variables
	sw	$0,52($fp) #pivotNewIndex
	sw	$0,48($fp) #pivotIndex
	sw	$0,44($fp) #pivotValue
	sw	$0,40($fp) #storeIndex
	sw	$0,36($fp) #temp
	sw	$0,32($fp) #i

	lw	$v1,72($fp)	#right
	lw	$v0,68($fp)	#left
	nop
	slt	$2,$2,$3	#if right > left
	beq	$2,$0,L2	#the the array is sorted
	nop
	
	lw	$3,72($fp) 
	lw	$2,68($fp)
	nop
	subu	$3,$3,$2  #right - left
	lw	$2,68($fp) #left
	nop
	addu	$2,$3,$2 # +left
	sw	$2,48($fp)
	lw	$2,48($fp)
	nop
	sll	$2,$2,2    #divide by 2
	lw	$3,64($fp)
	nop
	addu	$2,$3,$2
	lw	$2,0($2)
	nop
	sw	$2,44($fp)
	lw	$2,48($fp)
	nop
	sll	$2,$2,2
	lw	$3,64($fp)
	nop
	addu	$2,$3,$2
	lw	$3,72($fp)
	nop
	sll	$3,$3,2
	lw	$4,64($fp)
	nop
	addu	$3,$4,$3
	lw	$3,0($3)
	nop
	sw	$3,0($2)
	lw	$2,72($fp)
	nop
	sll	$2,$2,2
	lw	$3,64($fp)
	nop
	addu	$2,$3,$2
	lw	$3,44($fp)
	nop
	sw	$3,0($2)
	lw	$2,68($fp) #left
	nop
	sw	$2,40($fp)
	lw	$2,68($fp) 
	nop
	sw	$2,32($fp) #i = left
	j	L3
	nop
	
L5:
	lw	$2,32($fp) #i
	nop
	sll	$2,$2,2    #i = i * 4
	lw	$3,64($fp) #array
	nop
	addu	$2,$3,$2  #i = array +i
	lw	$3,0($2)   #load whats in array
	lw	$2,44($fp)    #pivotValue
	nop
	slt	$2,$2,$3  #pivotvalue < what in array
	bne	$2,$0,L4 #basically if array[i] <= pivotValue
	nop
	
	lw	$2,32($fp)
	nop
	sll	$2,$2,2
	lw	$3,64($fp)
	nop
	addu	$2,$3,$2
	lw	$2,0($2)
	nop
	sw	$2,36($fp)
	lw	$2,32($fp)
	nop
	sll	$2,$2,2
	lw	$3,64($fp)
	nop
	addu	$2,$3,$2
	lw	$3,40($fp)
	nop
	sll	$3,$3,2
	lw	$4,64($fp)
	nop
	addu	$3,$4,$3
	lw	$3,0($3)
	nop
	sw	$3,0($2)
	lw	$2,40($fp)
	nop
	sll	$2,$2,2
	lw	$3,64($fp)
	nop
	addu	$2,$3,$2
	lw	$3,36($fp)
	nop
	sw	$3,0($2)
	lw	$2,40($fp)
	nop
	addiu	$2,$2,1 # store index = store index + 1
	sw	$2,40($fp)
L4:
	lw	$2,32($fp) #i
	nop
	addiu	$2,$2,1
	sw	$2,32($fp) #i = i + 1
L3:
	lw	$3,32($fp) #i
	lw	$2,72($fp) #right
	nop
	slt	$2,$3,$2 
	bne	$2,$0,L5 #for loop checking
	nop

#swap after the for loop	
	lw	$2,40($fp)
	nop
	sll	$2,$2,2
	lw	$3,64($fp)
	nop
	addu	$2,$3,$2
	lw	$2,0($2)
	nop
	sw	$2,36($fp)
	lw	$2,40($fp)
	nop
	sll	$2,$2,2
	lw	$3,64($fp)
	nop
	addu	$2,$3,$2
	lw	$3,72($fp)
	nop
	sll	$3,$3,2
	lw	$4,64($fp)
	nop
	addu	$3,$4,$3
	lw	$3,0($3)
	nop
	sw	$3,0($2)
	lw	$2,72($fp)
	nop
	sll	$2,$2,2
	lw	$3,64($fp)
	nop
	addu	$2,$3,$2
	lw	$3,36($fp)
	nop
	sw	$3,0($2)
	lw	$2,40($fp)
	nop
	sw	$2,52($fp) #pivotNewIndex
	lw	$2,52($fp) 
	nop
	addiu	$2,$2,-1  #pivotNewIndex-1
	lw	$4,64($fp) #array
	lw	$5,68($fp) #left
	addu	$6,$2,$0  #a3 = pivotNew index - 1
	jal	quicksort
	nop
	
	sw	$2,28($fp)
	lw	$2,52($fp)
	nop
	addiu	$2,$2,1 #pivotNewIndex + 1
	lw	$a0,64($fp) #array
	addu	$a1,$2,$0 
	lw	$a2,72($fp) #right
	jal	quicksort
	nop
	
	sw	$2,24($fp)
L2:
	addu	$2,$0,$0
	addu	$sp,$fp,$0
	lw	$31,60($sp)  #load the return address
	lw	$fp,56($sp)  #set the frame pointer to the callers frame
	addiu	$sp,$sp,64   #deallocate our stack space
	jr	$31 #return
	nop
	
main:
	
	addiu	$sp,$sp,-80 #allocate stack space
	sw	$31,76($sp) #store return addres
	sw	$fp,72($sp) #store frame pointer
	addu	$fp,$sp,$0  #set the stack pointer to our frame
######
	ori $2, $zero, 17 
	sw $2,28($fp) # array pointer points to address 0xFEF   
	ori $2, $zero, 63
	sw $2,32($fp) 
	ori $2, $zero, 75
	sw $2,36($fp) 
	ori $2, $zero, 27
	sw $2,40($fp) 
	ori $2, $zero, 33
	sw $2,44($fp) 
	ori $2, $zero, 13
	sw $2,48($fp) 
	ori $2, $zero, 52
	sw $2,52($fp) 
	ori $2, $zero, 41
	sw $2,56($fp)
	ori $2, $zero, 84
	sw $2,60($fp) 
	ori $2, $zero, 9
	sw $2,64($fp)

	addiu	$2,$fp,28
	addu	$4,$2,$0
	addu	$5,$0,$0
	ori	$6, $zero, 9
	jal	quicksort
	nop
	
	sw	$2,24($fp)
	addu	$2,$0,$0
	addu	$sp,$fp,$0
	lw	$31,76($sp)
	lw	$fp,72($sp)
	addiu	$sp,$sp,80
	jr	$31
	nop
	
        halt
