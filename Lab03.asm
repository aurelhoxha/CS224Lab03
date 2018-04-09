.data
 	welcomeMessage: .asciiz "--------------------------------------------------------------------------------------\nWelcome to my IEEE 754 floating-point PROGRAM\nThis program prompts the user to enter the number of elements we want in the array!\nThen it check if the number is correct and do several commands with the array.\n--------------------------------------------------------------------------------------\n"
 	menuOptions: .asciiz "1. Use the slow sort\n2. Use the fast sort\n3. Start from a new Array\n4. Quit the Program\n"
 	chooseOption: .asciiz "Please enter your option: "
 	promptArray: .asciiz "Enter the number of the elements you want in the array!\nLet it be a smaller number as the lab says!!!!!\nPlease enter your number: "
	space: 	.asciiz " "
	numbersPrint: .asciiz "Numbers are: "
	newLine: .asciiz "\n"
	promptError: .asciiz "The array size should not pass 938039\n"
	thanks: .asciiz "Thank you for using my Program.\nI hope I won't see you again!\n"
	successful: .asciiz "Array is created successfully!"
	arrayTime: .asciiz "The time that assembler took to create the array is: "
	slowTime: .asciiz  "The time that assembler took to slowSort the array is: "
	fastTime: .asciiz  "The time that assembler took to fastSort the array is: "
	milliseconds: .asciiz " milliseconds"
.text
main_method:

	la $a0, welcomeMessage
	li $v0, 4
	syscall
	
arrayCreation:
	jal createAndFillArray
	move $a0,$v0
	move $a1, $v1
	jal printArray
	move $t8, $a0
	move $t9, $a1
	
menu:
	la $a0, menuOptions
	li $v0, 4
	syscall
	
	la $a0, chooseOption
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $t0, $v0
	move $a0, $t8
	move $a1, $t9
	add $t1, $zero, $zero
	beq $t0, 1, callSlowSort
	beq $t0, 2, callFastSort
	beq $t0, 3, startOver
	beq $t0, 4, quitProgram
	j menu
	
startOver:
	j arrayCreation
	
callSlowSort:
	li $v0, 30
	syscall
	move $s6,$a0
	
	move $a0, $t8
	move $a1, $t9
	jal slowSort
	
	li $v0, 30
	syscall
	sub $s7, $a0, $s6
	
	li $v0,4
	la $a0, slowTime
	syscall
	
	li $v0, 1
	move $a0, $s7
	syscall
	
	li $v0, 4
	la $a0, milliseconds
	syscall
	
	li $v0,4
	la $a0, newLine
	syscall
	
	move $a0, $t8
	move $a1, $t9
	jal printArray
	j menu
callFastSort:
	li $v0, 30
	syscall
	move $s6,$a0
	
	move $a0, $t8
	addi $a1, $zero, 0
	subi $a2, $t9, 1
	jal quickSort
	
	li $v0, 30
	syscall
	sub $s7, $a0, $s6
	
	li $v0,4
	la $a0, fastTime
	syscall
	
	li $v0, 1
	move $a0, $s7
	syscall
	
	li $v0, 4
	la $a0, milliseconds
	syscall
	
	li $v0,4
	la $a0, newLine
	syscall
	
	move $a0, $t8
	move $a1, $t9
	j menu
quitProgram:
	la $a0, thanks
	li $v0, 4
	syscall
	
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
	here:	
	move $a0, $t0
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
fastSort:
	addi $sp, $sp, -4
	sw $ra, 0($sp)

	
	move $a2, $a1	
	move $a1, $zero
	jal quickSort
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	
	jr $ra
	

######################### quickSort start #######################
# input:
#	$a0 - array start
# 	$a1 - low
# 	$a2 - high
# vars:
# 	$t3 = pi
quickSort:
	move $t0, $a0
	move $t1, $a1
	move $t2, $a2
	
	addi $sp, $sp, -16
	sw $t1, 0($sp)
	sw $t2, 4($sp)
	sw $ra, 8($sp)


	bge $t1, $t2, endQuickSort
		
		
		jal partition
		
		move $t3, $v0
		sw $t3, 12($sp)
		
		lw $a1, 0($sp)
		move $a2, $t3
		addi $a2, $a2, -1
		jal quickSort
		
		lw $a1, 12($sp)
		lw $a2, 4($sp)
		addi $a1, $a1, 1
		jal quickSort
		
	
endQuickSort:
	
	lw $ra, 8($sp)
	addi $sp, $sp, 16
	
	jr $ra
####################### quickSort finish ##########################

######################## partition start ##########################
# input:
#	$a0 - array start
# 	$a1 - low
# 	$a2 - high
# vars:
# 	$t3 = pivot
#	$t4 = i
#	$t5 = j
# 	$t6 = temp1
# 	$t7 = temp2
partition:
	move $t0, $a0
	move $t1, $a1
	move $t2, $a2
	
	sll $t2,$t2,2
	add $t9, $t0, $t2
	lw $t3, 0($t9)
	move $t2, $a2
	
	addi $t4, $t1, -1
	
	addi $t5, $t1, 0
	
partiotionFor:
	bge $t5, $t2, done2
		sll $t6, $t5, 2
		add $t6, $t6, $t0
		lw $t7, 0($t6)
		
		
		blt $t7, $t3, doneInner
			
			addi $t4, $t4, 1
			sll $t8, $t4, 2
			add $t8, $t8, $t0
			lw $t9, ($t8)
			
			sw $t9, ($t6)
			sw $t7, ($t8)
				
		doneInner:
		
		addi $t5, $t5, 1
		
	j partiotionFor
	
done2:

	addi $t4, $t4, 1
	sll $t6, $t4, 2
	sll $t8, $a2, 2
	add $t6, $t6, $t0
	add $t8, $t8, $t0
	lw $t7, ($t6)
	lw $t9, ($t8)
	
	sw $t7, ($t8)
	sw $t9, ($t6)
	
	move $v0, $t4

	jr $ra
