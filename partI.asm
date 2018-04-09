.data
	promptForNumber: .asciiz "Enter the number to check if it is IEEE 754 special case: "
.text

main_method:
	#Prompt the user message
	la $a0, promptForNumber
	li $v0, 4
	syscall
	
	#Prompt to enter the number
	li $v0, 5
	syscall
	
	move $a0, $v0
	
	#Call special_case function
	jal special_case
	
	move $t2, $v0
	
	li $v0, 1
	move $a0, $t2
	syscall
	
		
	#Show the compiler that the program ends here
	li $v0, 10
	syscall
	
special_case:
		move $t0, $a0
		srl $t0, $t0,23
		andi $t0, $t0, 255
		beq $t0,255, special
		beq $t0,0,special
		j done
special:
		addi $t1, $t1, 1
		j done
done:
		add $v0, $0, $t1
		jr $ra
