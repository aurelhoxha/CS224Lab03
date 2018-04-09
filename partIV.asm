.data 
	prompt1: .asciiz "Enter the first number : "
	prompt2: .asciiz "Enter the second number: "
	promptBigger: .asciiz "The value of the bigger number is : "
	promptSmaller:.asciiz "The value of the smaller number is: "
	newLine: 	.asciiz "\n"
.text
main_method:

	#Prompt to the user and get the first number
	la $a0, prompt1
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $t0, $v0
	
	#Prompt to the user and get the second number
	la $a0, prompt2
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	
	move $t1, $v0
	
	#Make the arguments ready
	move $a0, $t0
	move $a1, $t1
	#Call CompareFP Function
	jal CompareFP
	
	move $t0, $v0
	move $t1, $v1
	
	#Print the message and the value for the bigger number
	la $a0, promptBigger
	li $v0, 4
	syscall
	
	move $a0, $t0
	li $v0, 1
	syscall
	
	la $a0, newLine
	li $v0, 4
	syscall
	#Print the message and the value for the smaller number
	la $a0, promptSmaller
	li $v0, 4
	syscall
	
	move $a0, $t1
	li $v0, 1
	syscall
	#Tell the compiler the program ends here
	li $v0, 10
	syscall
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
	jr $ra