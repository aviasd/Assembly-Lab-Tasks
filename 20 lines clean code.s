# Lab 7: Floating Point Addition
# Created 2/12/99 by Travis Furrer & David Harris
#
#--------------------------------
# <Please put your name here>
#--------------------------------


# The numbers below are loaded into memory (the Data Segment)
# before your program runs.  You can use a lw instruction to
# load these numbers into a register for use by your code.

        .data
atest:  .word 0x40000000 # you can change this to anything you want
btest:  .word 0x40000000 # you can change this to anything you want
smask:  .word 0x007FFFFF # significant mask
emask:  .word 0x7F800000 # exponent mask
ibit:   .word 0x00800000 # bit 24 for the '1' to be added
obit:   .word 0x01000000 # bit 25, signals overflow in the added significants
        .text

# The main program computes e using the infinite series, and
# calls your flpadd function (below).
#
# PLEASE DO NOT CHANGE THIS PART OF THE CODE
#
# The code uses the registers as follows:
#    $s0 - 1 (constant integer)
#    $s1 - i (loop index variable)
#    $s2 - temp
#    $f0 - 1 (constant single precision float)
#    $f1 - e (result accumulator)
#    $f2 - 1/i!
#    $f3 - i!
#    $f4 - temp
        
main:   li $s0,1                # load constant 1
        mtc1 $s0,$f0            # copy 1 into $f0
        cvt.s.w $f0,$f0         # convert 1 to float
        mtc1 $0,$f1             # zero out result accumulator
        li $s1,0                # initialize loop index
tloop:  addi $s2,$s1,-11        # Have we summed the first 11 terms?
        beq $s2,$0,end          # If so, terminate loop
        bnez $s1,fact           # If this is not the first time, skip init
        mov.s $f3,$f0           # Initialize 0! = 1
        j dfact                 # bypass fact
fact:   mtc1 $s1,$f4            # copy i into $f4
        cvt.s.w $f4,$f4         # convert i to float
        mul.s $f3,$f3,$f4       # update running fact
dfact:  div.s $f2,$f0,$f3       # compute 1/i!
        #add.s $f1,$f1,$f2      # we use your flpadd function instead!
	mfc1 $a0,$f1            #\  These lines should do the same thing
        mfc1 $a1,$f2            # \ as the commented out line above.
        jal flpadd              # / This is where we call your function.
        mtc1 $v0,$f1            #/
################# printing the float number ###################	
	li $v0, 2
        mov.s $f12,$f1          	
	syscall
	li $v0, 11
	li $a0, ' ' 
	syscall
	syscall	
################################################################
        addi $s1,$s1,1          # increment i
        j tloop                 #
end:    
	li $v0,10   		# exit program
	syscall                 #

# If you have trouble getting the right values from the program
# above, you can comment it out and do some simpler tests using
# the following program instead.  It allows you to add two numbers
# (specified as atest and btest, above), leaving the result in $v0.

#main:   lw $a0,atest
#        lw $a1,btest
#        jal flpadd
#end:    j end



# Here is the function that performs floating point addition of
# single-precision numbers.  It accepts its arguments from
# registers $a0 and $a1, and leaves the sum in register $v0
# before returning.
#
# Make sure not to use any of the registers $s0-$s7, or any
# floating point registers, because these registers are used
# by the main program.  All of the registers $t0-$t9, however,
# are okay to use.
#
# YOU SHOULD NOT USE ANY OF THE MIPS BUILT-IN FLOATING POINT
# INSTRUCTIONS.  Also, don't forget to add comments to each line
# of code that you write.
#
# Remember the single precision format (see page 276):
#          bit 31 = sign (1 bit)
#      bits 30-23 = exponent (8 bits)
#       bits 22-0 = significand (23 bits)
#
#
#
#	Explain your registers here:
#	$t0 - exponent of the first number
#	$t1 - exponent of the second number
#	$t2 - significant of the first number
#	$t3 - significant of the second number
#	$t4 - the hidden bit
#	$t5 - the overflow bit
#	$t6 - difference between the exponent of first number and the exponent of the second number
#	$t7 - the exponent of the result
#	$t8 - the significant of the result
#	$t9 - temp

#Enter your code here
	
	
flpadd:	bnez $a0, start # if we are running for the first time, return $a1
	move $v0, $a1 # $a0 = 0 so we return $a1
	jr $ra

# 20 real lines of code (clean code)
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
start:	srl $t0, $a0, 23	# $t0 - exponent of the bigger number (real size) - exponent1				#/
	srl $t1, $a1, 23	# $t1 - exponent of the smaller number (real size) - exponent2				#/
	sll $t2, $a0, 9		# clearing the bigger number								#/
	srl $t2, $t2, 9		# $t2 - significant of the bigger number - significant1					#/
	sll $t3, $a1, 9		# clearing the smaller number								#/
	srl $t3, $t3, 9		# $t3 - significant of the smaller number - significant2				#/
	sub $t6, $t0, $t1	# $t6 - difference between exponent1 and exponent2					#/	
	addi $t4, $0, 1		# making the hidden bit									#/
	sll $t4, $t4, 23	# $t4 - the hidden bit (bit 24)								#/
	add $t2, $t2, $t4	# $t2 - sgnificant1 plus the hidden bit							#/
	add $t3, $t3, $t4	# $t3 - sgnificant2 plus the hidden bit							#/
	srlv $t3, $t3, $t6	# do srl to the smaller number significant to align it with the bigger one		#/
	add $t8, $t2, $t3	# add the two sigificants								#/
	srl $t5, $t8, 24	# get the overflow bit (bit number 25)							#/
	beqz $t5, noOverflow	# if the overflow bit equals 0, go to noOverflow					#/
overflow:														#/
	srl $t8, $t8, 1		# decrease the digits of the significant by 1						#/
	addi $t0, $t0, 1	# increase the exponent by 1								#/
noOverflow:														#/
	sub $t8, $t8, $t4	# clear the hidden bit									#/
	sll $t7, $t0, 23	# $t7 - exponent1 (of the bigger number) ready to be inserted to the new number		#/
	add $v0, $t8, $t7	# connect the significant and exponent and put it in $v0				#/
#/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	
	jr $ra			# return
