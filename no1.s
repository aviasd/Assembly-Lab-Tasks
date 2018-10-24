# Title: Lab1        	Filename:
# Author:       	Date:
# Description:
# Input: $s0= a word hexa 8 digit number
# Output: $t0= the number of even hexa digits
################# Data segment #####################
.data
first: .word  0x12345678

################# Code segment #####################
.text
.globl main
main:	# main program entry

	lw $s0, first		# load the word to be checked	
	li $t0, 8		# t0 = even counter = 8
	
even_loop_counter:
	andi $t2, $s0, 1			# mask the even bit of the hexa digit (lsb) in $s0
	sub $t0, $t0, $t2			# t0 = even counter - even bit
	srl $s0, $s0, 4				# go to next hexa digit	
	bne $s0, $zero, even_loop_counter	# if we didn't finish the word, do the loop again

li $v0, 10	# Exit program
syscall

