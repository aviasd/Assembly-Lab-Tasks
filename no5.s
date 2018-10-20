# Title: lab5       	 Filename:
# Author:      ID:    	  Date:
# Description: String and ASCII games
# Input: 
# Output:
################# Data segment #####################
.data
buf:    .space    19
str:	.asciiz "Please enter a string\n"
msg1:   .asciiz "\nThe swaped string is:\n"
msg2:   .asciiz "\nThe reversed string is:\n"
msg3:   .asciiz "\nThe number of <a> in the string is: " 
msg4:   .asciiz "\nThe number of <ab> in the string is: "         
msg5:   .asciiz "\nThe number of <abc> in the string is: "
     

################# Code segment #####################
.text
.globl main
main:	# main program entry

	la $s7, buf		# $s7 = the address of the input string
		
	li $v0, 4
	la $a0, str		# "please enter a string"
	syscall

##########################################
# get string from the user (syscall 8)
##########################################

	li $a1, 19		# the max size of the input string
	move $a0, $s7		# saves the string in the address of the start of the input string ($s7)
	li $v0, 8
	syscall
								
################################################
#1) Swap from big --> small , small --> big
################################################
		
	li $v0, 4
	la $a0, msg1		# "The swaped string is:"
	syscall
	
	li $t0, 65		# $t0 = 'A'
	li $t1, 90		# $t1 = 'Z'
	li $t2, 97		# $t2 = 'a'
	li $t3, 122		# $t3 = 'z'
	move $s0, $s7		# the address of the start of the input string ($s7)
	
loop1:	lb $a0, ($s0)		# loads a char into $a0
	beq $a0, $0, start2	# char = '\0' ?
	add $s0, $s0, 1		# the next char
	blt $a0, $t0, print	# char < 'A' ?
	bgt $a0, $t3, print	# char > 'z' ?
	ble $a0, $t1, big	# char <= 'Z' ?
	bge $a0, $t2, small	# char >= 'a' ?
	
print:	li $v0, 11		# prints the char
	syscall
	j loop1

big:	add $a0, $a0, 0x20	# for capital letters, takes the small letters
	j print

small:	sub $a0, $a0, 0x20	# for small letters, takes the capital letters
	j print


################################################
#2) print the string reverse 
#################################################
start2:	li $v0, 4
	la $a0, msg2		# "The reversed string is:"
	syscall
	sub $s0, $s0, 1		# the address of the end of the input string ($s0)

loop2:	sub $s0, $s0, 1		# the next char
	blt $s0, $s7, start3	# char not in input ?
	lb $a0, ($s0)		# loads a char into $a0
	li $v0, 11		# prints the char
	syscall
	j loop2
	
################################################
#3) count the number of <a> in the string 
#################################################	
start3:	li $v0, 11
	la $a0, '\n'
	syscall
	move $s1, $0		# counter = 0 ($s1)
	li $v0, 4
	la $a0, msg3		# "The number of <a> in the string is: "
	syscall
	
loop3:	add $s0, $s0, 1		# the next char
	lb $a0, ($s0)		# loads a char into $a0
	beq $a0, $0, end3	# char = '\0' ?
	bne $a0, 97, loop3	# char != 'a' ?
	add $s1, $s1, 1		# counter++ ($s1)
	j loop3

end3:	move $a0, $s1		# loads the counter into $a0 for printing
	li $v0, 1
	syscall	
################################################
#4) count the number of <ab> in the string 
#################################################	
	
start4:	move $s1, $0		# counter = 0 ($s1)
	li $v0, 4
	la $a0, msg4		# "The number of <ab> in the string is: " 
	syscall
	sub $s0, $s0, 1		# the address of the end of the input string ($s0)
	
searchB:sub $s0, $s0, 1		# the next char	
	blt $s0, $s7, end4	# char not in input ?
	lb $a0, ($s0)		# loads a char into $a0
	bne $a0, 98, searchB	# char != 'b' ?
	
searchA:sub $s0, $s0, 1 	# the next char	
	blt $s0, $s7, end4	# char not in input ?
	lb $a0, ($s0)		# loads a char into $a0
	beq $a0, 98, searchA	# char = 'b' ?
	bne $a0, 97, searchB	# char != 'a' ?
	add $s1, $s1, 1		# counter++ ($s1)
	j searchB
	
end4:	move $a0, $s1		# loads the counter into $a0 for printing
	li $v0, 1
	syscall
################################################
#5) count the number of <abc> in the string 
#################################################	
	
start5:	move $s1, $0		# counter = 0 ($s1)
	li $v0, 4
	la $a0, msg5		# "The number of <abc> in the string is: "
	syscall
	
sA5:	add $s0, $s0, 1		# the next char	
	lb $a0, ($s0)		# loads a char into $a0
	beq $a0, $0, end5	# char = '\0' ?
	bne $a0, 97, sA5	# char != 'a' ?
	
sB5:	add $s0, $s0, 1		# the next char	
	lb $a0, ($s0)		# loads a char into $a0
	beq $a0, $0, end5	# char = '\0' ?
	beq $a0, 97, sB5	# char = 'a' ?
	bne $a0, 98, sA5	# char != 'b' ?
	
sC5:	add $s0, $s0, 1		# the next char	 
	lb $a0, ($s0)		# loads a char into $a0
	beq $a0, $0, end5	# char = '\0' ?
	beq $a0, 97, sB5	# char = 'a' ?
	bne $a0, 99, sA5	# char != 'c' ?
	add $s1, $s1, 1		# counter++ ($s1)
	j sA5

end5:	move $a0, $s1		# loads the counter into $a0 for printing
	li $v0, 1
	syscall		
exit:
	li $v0, 10
	syscall


