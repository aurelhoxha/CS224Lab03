.data
	promptArray: .asciiz "Enter the number of the element you want to save in the array: "
	promptError: .asciiz "The array size should not pass 938039\n"
.text
main_method:

		askForSize:	
		#Prompt the user to enter tha value of the elements
		la $a0, promptArray
		li $v0, 4
		syscall
		
		#Save the input of the user
		li $v0, 5
		syscall
		
		move $t0, $v0
		
		bge $t0, 938040, errorMessage

		#Move the number of elements to register $a0
		move $a0, $v0
		
		#Call fillArray function
		jal fillArray
		
		move $t7, $v0
		
		lw $s4, ($t7)
		
		li $v0,1
		move $a0, $s4
		syscall
		#Tell the compiler the program ends here
		move $t3, $v0
		j doneArray
		errorMessage:
		li $v0, 4
		la $a0, promptError
		syscall
			
		doneArray:	
		li $v0, 10
		syscall
		
fillArray:
		addi $sp, $sp -24
		sw $ra, 20($sp)
		sw $t0, 16($sp)
		sw $t1, 12($sp)
		sw $t2, 8($sp)
		sw $t3, 4($sp)
		sw $t4, 0($sp)
		
		#Convert it to byte by multiplying by 4
		sll $t0, $a0, 2
		
		#Allocate space for our numbers
		move $a0, $t0
		li $v0, 9
		syscall 
		
		#Save the inital address of the array
		move $t1, $v0
		move $t2, $t1
		
		#Calculate the last address 
		add $t3, $t2, $t0
		fillLoop: 
		beq $t2, $t3, finishFill
		
		jal get_rand_FP
		#Save the element to the first position of the array
		move $t4, $v0
		
		sw $t4, ($t2)
		addi $t2, $t2, 4
		j fillLoop
		finishFill:
		move $v0, $t1
		
		lw $t3, 0($sp)
		lw $t3, 4($sp)
		lw $t2, 8($sp)
		lw $t1, 12($sp)
		lw $t0, 16($sp)
		lw $ra, 20($sp)
		addi $sp, $sp 24
		jr $ra	

get_rand_FP:
		#Save the return register to the stack
		addi $sp, $sp, -12
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
		addi $sp, $sp, 12
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