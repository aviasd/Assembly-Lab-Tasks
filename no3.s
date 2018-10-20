# Title:Lab3       	Filename:
# Author:       	Date:
# Description:
# Input: 
# Output:
################# Data segment #####################
.data

msg1: .asciiz  "\n Please enter a char to display\n"
msg2: .asciiz  "\n Please enter the num of time to dispaly (0-9)\n"
msg3: .asciiz  "\n Your character is not a digit\n"



################# Code segment #####################
.text
.globl main
main:	# main program entry
	
	li $s1, 48		# $s1 = '0'
	li $s2, 57		# $s2 = '9'

	la $a0,msg1		# Please enter a char to display
	li $v0,4	        # system call to print
	syscall			# out a string 		
	 
	li $v0,12        	# get char from the user
	syscall			# in a character 
	
	move $t1,$v0      	# keep the char in a temp ($t1) 
	j first
	
again:	la $a0,msg3		# "Your character is not a digit"
	li $v0,4	        # system call to print
	syscall			# out a string 
	
first:	la $a0,msg2		# "Please enter the num of time to dispaly (0-9)"
	li $v0,4	        # system call to print
	syscall			# out a string 	
	li $v0,12        	# system call to get char from the user
	syscall			# in a character
	move $t2, $v0		# keep the number of times in a temp ($t2) 
	li $a0, '\n'		# go 1 line down
	li $v0,11		# system call to print char
	syscall			# out a character 	
	blt $t2, $s1, again	# digit < '0' ?
	bgt $t2, $s2, again	# digit > '9' ?
	
loop:	move $a0, $t1		# print the char
	li $v0,11		# system call to print char
	syscall			# out a character 
	addi $t2, $t2, -1	# counter--
	bgt $t2, $s1, loop	# conter > '0' ?
	
	li $v0, 10		# Exit program
	syscall
