# Title: Lab2       	Filename:
# Author:       	Date:
# Description:
# Input: 
# Output:
################# Data segment #####################
.data

msg1: .asciiz  "\n Please enter a letter a-z \n"
msg2: .asciiz  "\n Your character is not a letter \n"

################# Code segment #####################
.text
.globl main
main:	# main program entry

	la $a0,msg1		# put string address into a0
	li $v0,4        	# system call to print
	syscall			# out a string	
	li $v0,12     	  	# system call to get a character from the user
	syscall         	# in a letter
	add $s0, $0, $v0 	# keep the letter in $s0
	li $a0,'\n'		# print an "Enter" in I/O
	li $v0,11 		# system call to print a character
	syscall 		# out a letter
	li $t0, 65		# $t0 = 'A'
	li $t1, 90		# $t1 = 'Z'
	li $t2, 97		# $t2 = 'a'
	li $t3, 122		# $t3 = 'z'
	blt $s0, $t0, notGood	# char < 'A' ?
	bgt $s0, $t3, notGood	# char > 'z' ?
	ble $s0, $t1, big	#  'A' < char < 'Z' ?
	bge $s0, $t2, small	#  'a' < char < 'z' ?
	
notGood:
	la $a0,msg2		# put string address into a0
	li $v0,4        	# system call to print
	syscall			# out a string
	j end			
	
big:
	move $a0, $s0		# print a letter in I/O
	li $v0,11 		# system call to print a character
	syscall			# out a letter
	addi $s0, $s0, 1	# $s0 = the next letter
	ble $s0, $t1, big 	# char < 'Z' ?
	j end
	
small:
	move $a0, $s0		# print a letter in I/O
	li $v0,11 		# system call to print a character
	syscall			# out a letter
	addi $s0, $s0, 1	# $s0 = the next letter
	ble $s0, $t3, small	# char < 'z' ?
	j end
	
end:	
	li $v0, 10		# Exit program
	syscall

