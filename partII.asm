.data 
	temp: .space 80
	space: .asciiz ", "
	prompt:.asciiz "Numbers are: \n"
.text
main_method:
		li $v0,4
		la $a0,prompt
		syscall
		
		addi $t0, $0, 40
		
		#Allocate space for our numbers
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
printingLoop:
		beq $t1, $t3,finishPrinting
		lw $t4, ($t1)
		
		li $v0,1
		move $a0, $t4
		syscall
		
		li $v0,4
		la $a0, space
		syscall
		add $t1, $t1, 4
		j printingLoop
finishPrinting:
		li $v0, 10
		syscall

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