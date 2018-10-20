# Title: lab 6	Filename:
# Author:       	Date:
# Description:
# Input: 2 arrays of 10 word sign numbers in acending order
# Output:The number that exists in both arrays in decending order
################# Data segment #####################
.data
array1:  .space 40  # array of 10 words
array2:  .space 40 #  array of 10 words
msg1: .asciiz "Please enter 10 sign numbers in ascending order\n"
msg2: .asciiz "\nThe number that exists in both arrays in decending order are:\n"
msg3: .asciiz "\nwrong input please enter again!\n"


################# Code segment #####################
.text
.globl main
main:	# main program entry

	
	    	la $a0, msg1		# "Please enter 10 sign numbers in ascending order"
		li $v0, 4		# system call to print
		syscall			# out a string 		

		la $a1, array1		# load the start address of array1 into $a1
		jal  get_array		# activate "get_array" procedure for array1

		la $a0, msg1		# "Please enter 10 sign numbers in ascending order"
		li $v0, 4		# system call to print
		syscall			# out a string 		

		la $a1, array2		# load the start address of array2 into $a2
		jal  get_array		# activate "get_array" procedure for array2
	
		la $a0, msg2		# "The number that exists in both arrays in decending order are:"
		li $v0, 4		# system call to print
		syscall			# out a string 	
		
		la $a1, array1		# load the start address of array1 into $a1
		la $a2, array2		# load the start address of array2 into $a2
		jal  find_eq		# activate "find_eq" procedure for array1 and array2

	 	li $v0, 10		# Exit program
	 	syscall
	   

#########################################################
# Procedure: get array                             	#
# input: $a1 --> array address in memory	       	#  
# Description: save in the array 10 sign numbers   	#
# in ascending order					# 	
#########################################################	 
get_array:

# intialization	
		li $v0, 5		# system call to read integer
		syscall			# in an integer
		addi $t1, $0, 1		# counter = 1 ($t1)
		move $t0, $v0		# store newNum in temp ($t0)
		sw $t0, ($a1)		# store newNum in data

# loop for getting the array	
loopGA:		li $v0, 5		# system call to read integer
		syscall			# in an integer
		ble $v0, $t0, notGood	# newNum !> oldNum ?
		move $t0, $v0		# store newNum in temp ($t0)
		addi $a1, $a1, 4	# address for next newNum ($a1)
		addi $t1, $t1, 1	# counter++ ($t1)
		sw $t0, ($a1)		# store newNum in data
		bne, $t1, 10, loopGA	# counter != 10 ?
		
# return
		jr $ra

# if the numbers are not in ascending order
notGood:	la $a0, msg3		# "wrong input please enter again!"
		li $v0, 4		# system call to print
		syscall			# out a string 	
		j loopGA

	
#########################################################################
# Procedure find_eq							# 		 
# input: $a1, $a2 --> Address of two arrays of 10 sign numbers		#
# in ascending order				                  	# 
# output: The numbers that exists in both arrays in decending order 	#
#########################################################################

find_eq:
	
# initialization
		addi $a1, $a1, 36	# the address of the last number in array1 ($a1)
		addi $a2, $a2, 36	# the address of the last number in array2 ($a2)
		addi $t3, $0, 0		# counter of array1 = 0 ($t3)		
		addi $t4, $0, 0		# counter of array2 = 0 ($t4)

# checks weather the next numbers in both arrays are equal
loopEQ:		beq $t4, 10, returnEQ	# no more numbers in array2 ?
		beq $t3, 10, returnEQ	# no more numbers in array1 ?		
		lw $t1, ($a1)		# next number in array1 ==> temp ($t1)
		lw $t2, ($a2)		# next number in array2 ==> temp ($t2)
		bgt $t1, $t2, a1Big	# number in array1 > number in array2 ?
		bgt $t2, $t1, a2Big	# number in array2 > number in array1 ?
		
# prints space for visuality		
		addi $a0, $0, ' '	# prints space
		li $v0, 11		# system call to print char
		syscall			# out a char

# both numbers are equal so we print them (only once)		
		move $a0, $t1		# the integer to print ($t1)
		li $v0, 1		# system call to read integer
		syscall

# both numbers are equal so we take the next numbers of both arrays			
		subi $a1, $a1, 4	# takes the next number in array1
		addi $t3, $t3, 1	# counter++ ($t3 = counter of array1)
		subi $a2, $a2, 4	# takes the next number in array2
		addi $t4, $t4, 1	# counter++ ($t4 = counter of array2)
		j loopEQ
		
# if the number of array1 is bigger, we will take the next number of this array			
a1Big:		subi $a1, $a1, 4	# takes the next number in array1
		addi $t3, $t3, 1	# counter++ ($t3 = counter of array1)
		j loopEQ

# if the number of array2 is bigger, we will take the next number of this array		
a2Big:		subi $a2, $a2, 4	# takes the next number in array2
		addi $t4, $t4, 1	# counter++ ($t4 = counter of array2)
		j loopEQ


# return
returnEQ:	jr $ra