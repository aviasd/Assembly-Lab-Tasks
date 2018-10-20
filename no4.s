# Title: Lab 4       	Filename:
# Author:       	Date:
# Description:
# Input: a number between 1-99
# Output: An isosceles triangle
################# Data segment #####################
.data

msg1: .asciiz "\n Please enter a number between 1-99: \n"
msg2: .asciiz "Wrong input"

################# Code segment #####################
.text
j main
wrong:
	la $a0, msg2	# put string address into a0
	li $v0, 4	# system call to print
	syscall		# out a string 		

.globl main
main:	# main program entry
	
  	la $a0, msg1		# put string address into a0
	li $v0, 4		# system call to print
	syscall			# out a string 			


	li $v0, 5  		# get a number from the user
	syscall			# in a number 	
	bgt $v0, 99, wrong	# number > 99 ?
	blt $v0, 1, wrong	# number < 1 ?
	
	move $t0, $v0		# $t0 = the number of lines to print
	sub $t0, $t0, 1		# $t0 = the number of spaces in every line
	addi $t1, $0, 1		# $t1 = the number of '*' in every line
	move $t2, $0		# counter = 0 ($t2)
	
	
space1:	li $a0, ' '		# loads the char ' ' to print		
	li $v0, 11		# system call to print a char
	syscall			# out a char 
	add $t2, $t2, 1		# counter++
	ble $t2, $t0, space1	# counter <= number of spaces?
	move $t2, $0		# counter = 0
	
char:	li $a0, '*'		# loads the char '*' to print
	li $v0, 11		# system call to print a char
	syscall			# out a char 
	add $t2, $t2, 1		# counter++
	blt $t2, $t1, char	# counter < number of '*'?
	move $t2, $0		# counter = 0
	
space2:	li $a0, ' '		# loads the char ' ' to print
	li $v0, 11		# system call to print a char
	syscall			# out a char 
	add $t2, $t2, 1		# counter++
	ble $t2, $t0, space2	# counter <= number of spaces?
	
	li $a0, '\n'		# goes one line down
	li $v0, 11		# system call to print a char
	syscall			# out a char 
	
	beq $t0, $0, end	# number of spaces in a line = 0 ? => no more lines ?
	sub $t0, $t0, 1		# next line, less spaces
	add $t1, $t1, 2		# next line, more '*'
	move $t2, $0		# counter = 0
	j space1
	
end:
	li $v0, 10	# Exit program
	syscall

