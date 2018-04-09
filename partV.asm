.data
	promptArray: .asciiz "Enter the number of the elements you want in the array!\nLet it be a smaller number as the lab says!!!!!\nPlease enter your number: "
	space: 	.asciiz " "
	numbersPrint: .asciiz "Numbers are: "
	newLine: .asciiz "\n"
	promptError: .asciiz "The array size should not pass 938039\n"
.text
main_method:
	jal createAndFillArray
	move $a0, $v0
	move $a1, $v1
	jal printArray
	jal slowSort
	#Tell the assembler the program ends here
	jal printArray
	li $v0,10
	syscall
createAndFillArray:
	addi $sp, $sp, -24
	sw $ra, 20($sp)
	sw $t0, 16($sp)
	sw $t1, 12($sp)
	sw $t2, 8($sp)
	sw $t3, 4($sp)
	sw $t4, 0($sp)
	
	askAgain:
	#Prompt the user to enter the number of the elements
	la $a0, promptArray
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	#Save the number of the elements
	move $t0, $v0
	bge $t0, 938040, errorMessage
	sll $t0, $t0, 2
	j here
	errorMessage:
	li $v0,4
	la $a0, promptError
	syscall
	j askAgain
	
	#Allocate space for our numbers
here:	move $a0, $t0
	li $v0, 9
	syscall 
	
	move $t1, $v0
	move $t2, $t1
		
	add $t3, $t2, $t0
	addingLoop:	
		beq $t2, $t3, finishAdding
		jal get_rand_FP
		move $t4, $v0
		
		sw $t4, ($t2)
		add $t2, $t2, 4
		j addingLoop
	finishAdding:
		move $v0, $t1
		srl  $t0, $t0, 2
		move $v1, $t0
		lw $t4, 0($sp)
		lw $t3, 4($sp)
		lw $t2, 8($sp)
		lw $t1, 12($sp)
		lw $t0, 16($sp)
		lw $ra, 20($sp)	
		addi $sp, $sp, 24
		jr $ra
get_rand_FP:
		#Save the return register to the stack
		addi $sp, $sp, -20
		sw $a1, 16($sp)
		sw $a0, 12($sp)
		sw $ra, 8($sp)
		sw $t0, 4($sp)
		sw $t2, 0($sp)

		#RETURN A RANDOM INTEGER
	generateNumber:	
		li $v0, 41         
		xor $a0, $a0, $a0  
		syscall
		
		move $t2, $a0
		jal special_case
		move $t0, $v0
		bne $t0, 1, doneRandom
		j generateNumber
	doneRandom:
		move $v0, $t2
		
		lw $t2, 0($sp)
		lw $t0, 4($sp)
		lw $ra, 8($sp)
		lw $a0, 12($sp)
		lw $a1, 16($sp)
		addi $sp, $sp, 20
		jr $ra


special_case:
		addi $sp, $sp, -8
		sw $t0, 4($sp)
		sw $t1, 0($sp)
		move $t0, $a0
		srl $t0, $t0, 23
		and $t0, $t0, 255
		beq $t0,255, special
		beq $t0,0,special
		j done
	special:
		addi $t1, $t1, 1
		j done
	done:
		bne $t0, 1 , notSpecial
		add $v0, $0, $t1
	notSpecial:
		add $v0, $0, $t1
		lw $t1, 0($sp)
		lw $t0, 4($sp)
		addi $sp, $sp, 8
		jr $ra
CompareFP:
	addi $sp, $sp, -32
	sw $ra, 28($sp)
	sw $t0, 24($sp)
	sw $t1, 20($sp)
	sw $t2, 16($sp)
	sw $t3, 12($sp)
	sw $t4, 8($sp)
	sw $t5, 4($sp)
	sw $t6, 0($sp)
	
	#Make space to save sign, exponent and fraction for the first number
	move $t0, $a0
	move $t1, $a0
	move $t2, $a0
	
	#Make space to save sign, exponent and fraction for the second number
	move $t3, $a1
	move $t4, $a1
	move $t5, $a1
	
	#Save the sign of the first one
	andi $t0, $t0, 0x80000000
	srl  $t0, $t0, 31 
	#Save the exponent of the first one
	andi $t1, $t1, 0x7F800000
	srl  $t1, $t1, 23
	#Save the fraction for the first one
	andi $t2, $t2, 0x7FFFFF
	
	#Save the sign of the second one
	andi $t3, $t3, 0x80000000
	srl  $t3, $t3, 31 
	#Save the exponent of the second one
	andi $t4, $t4, 0x7F800000
	srl  $t4, $t4, 23
	#Save the fraction for the second one
	andi $t5, $t5, 0x7FFFFF
	
	#Check Condition
	bgt $t0, $t3, secondBiggerSign
	bgt $t3, $t0, firstBiggerSign
	bgt $t1, $t4, firstBiggerExponent
	bgt $t4, $t1, secondBiggerExponent
	bgt $t2, $t5, firstBiggerFraction
	bgt $t5, $t2, secondBiggerFraction
	j sameNumber

#UPDATE THE BIGGER AND THE SMALLER VALUE	
	secondBiggerSign:
	move $v0, $a1
	move $v1, $a0
	j compareDone
	firstBiggerSign:
	move $v0, $a0
	move $v1, $a1
	j compareDone
	firstBiggerExponent:
	move $v0, $a0
	move $v1, $a1
	j compareDone
	secondBiggerExponent:
	move $v0, $a1
	move $v1, $a0
	j compareDone
	firstBiggerFraction:
	move $v0, $a0
	move $v1, $a1
	j compareDone
	secondBiggerFraction:
	move $v0, $a1
	move $v1, $a0
	j compareDone
	sameNumber:
	move $v0, $a0
	move $v1, $a1
	j compareDone
	compareDone:
	lw $t6, 0($sp)
	lw $t5, 4($sp)
	lw $t4, 8($sp)
	lw $t3, 12($sp)
	lw $t2, 16($sp)
	lw $t1, 20($sp)
	lw $t0, 24($sp)
	lw $ra, 28($sp)
	addi $sp, $sp, 32
	jr $ra
slowSort:
	addi $sp, $sp, -52
	sw $a1, 48($sp)
	sw $a0, 44($sp)
	sw $ra, 40($sp)
	sw $t0, 36($sp)
	sw $t1, 32($sp)
	sw $t2, 28($sp)
	sw $t3, 24($sp)
	sw $t4, 20($sp)
	sw $t5, 16($sp)
	sw $t6, 12($sp)
	sw $t7, 8($sp)
	sw $t8, 4($sp)
	sw $t9, 0($sp)
	
	move $t0, $a0
	move $t1, $t0
	
	
	move $t2, $a1
	sll $t2, $t2, 2
	add $t2, $t2, $t1
	addi $t1, $t1, 4
	outerLoop:
		beq $t1, $t2, finishOuterLoop
		add $t4, $zero, $t0
	innerLoop:
		sub $t3, $t2, $t1
		add $t3, $t3, $t0
		beq $t4, $t3, finishInnerLoop
		lw $a0, ($t4)
		add $t4, $t4, 4
		lw $a1, ($t4)
		jal CompareFP
		move $t5, $v0
		move $t6, $v1
		sw $t6, ($t4)
		sub $t4, $t4, 4
		sw $t5, ($t4)
		add $t4, $t4, 4
		j innerLoop
	finishInnerLoop:
		add $t1, $t1, 4
		j outerLoop
	finishOuterLoop:
	move $v0, $t0
	
	lw $t9, 0($sp)
	lw $t8, 4($sp)
	lw $t7, 8($sp)
	lw $t6, 12($sp)
	lw $t5, 16($sp)
	lw $t4, 20($sp)
	lw $t3, 24($sp)
	lw $t2, 28($sp)
	lw $t1, 32($sp)
	lw $t0, 36($sp)
	lw $ra, 40($sp)
	lw $a0, 44($sp)
	lw $a1, 48($sp)
	addi $sp, $sp, 52
	jr $ra
printArray:
	addi $sp, $sp , -28
	sw $a1, 24($sp)
	sw $a0, 20($sp)
	sw $ra, 16($sp)
	sw $t0, 12($sp)
	sw $t1, 8($sp)
	sw $t2, 4($sp)
	sw $t3, 0($sp)
	move $t0, $a0
	move $t2, $t0
	move $t1, $a1
	sll $t1, $t1, 2
	add $t1, $t1, $t0
	
	li $v0, 4
	la $a0, numbersPrint
	syscall
	printingLoop:
		beq $t2, $t1,finishPrinting
		lw $t3, ($t2)
		
		li $v0,1
		move $a0, $t3
		syscall
		
		li $v0,4
		la $a0, space
		syscall
		
		add $t2, $t2, 4
		j printingLoop
finishPrinting:
		li $v0,4
		la $a0, newLine
		syscall
		lw $t3, 0($sp)
		lw $t2, 4($sp)
		lw $t1, 8($sp)
		lw $t1, 12($sp)
		lw $ra, 16($sp)
		lw $a0, 20($sp)
		lw $a1, 24($sp)
		addi $sp, $sp, 28
		
	jr $ra
