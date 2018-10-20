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
ibit:   .word 0x00800000 # bit 23 for the '1' to be added
obit:   .word 0x01000000 # bit 42, signals overflow in the added significants
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
tloop:  addi $s2,$s1,-20        # Have we summed the first 11 terms?
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
#	$t4 - exponent mask , mask for bit 24 (to add the '1')
#	$t5 - significant mask, mask for bit 25 (to check overflow)
#	$t6 - difference between the exponent of first number and the exponent of the second number
#	$t7 - the exponent of the result
#	$t8 - the significant of the result
#	$t9 - overflow check

#Enter your code here

flpadd:	lw $t4, emask		# $t4 - exponent mask
	lw $t5, smask		# $t5 - significant mask
	and $t0, $a0, $t4	# $t0 - exponent of the first number
	and $t1, $a1, $t4	# $t1 - exponent of the second number
	and $t2, $a0, $t5	# $t2 - significant of the first number
	and $t3, $a1, $t5	# $t3 - significant of the second number
	lw $t4, ibit		# $t4 - mask for bit 24 (to add the '1')
	add $t2, $t2, $t4	# $t2 - sgnificant1 plus the '1'
	add $t3, $t3, $t4	# $t3 - sgnificant2 plus the '1'
	bgt $t1, $t0, e2big	# exponent2 > exponent1 ?
	sub $t6, $t0, $t1	# $t6 - difference between exponent1 and exponent2
	srl $t6, $t6, 23	# $t6 - the real size of the difference (without all the zeros before it)
	move $t7, $t0		# $t7 - the exponent of the result is the bigger exponent (between exponent1 and exponent2)
	bgt $t6, 31, tbig1	# the number of times to do srl > 31 ?
	srlv $t3, $t3, $t6	# do srl to the smaller number significant to align it with the bigger one
	j cont1
tbig1:	move $t3, $0		# the number is too small to be considered in the addition so it is practically '0'
	j cont1			
e2big:	sub $t6, $t1, $t0	# $t6 - difference between exponent1 and exponent2 
	srl $t6, $t6, 23	# $t6 - the real size of the difference (without all the zeros before it)
	move $t7, $t1		# $t7 - the exponent of the result is the bigger exponent (between exponent1 and exponent2)
	bgt $t6, 31, tbig2	# the number of times to do srl > 31 ?
	srlv $t2, $t2, $t6	# do srl to the smaller number significant to align it with the bigger one
	j cont1
tbig2:	move $t2, $0		# the number is too small to be considered in the addition so it is practically '0'

cont1:	add $t8, $t2, $t3	# add the two sigificants
	lw $t5, obit		# mask for bit 25 (to check overflow)
	and $t9, $t8, $t5 	# check if there was an overflow
	bne $t9, 1, cont2	# if there was no overflow jump to "cont2" lable
	srl $t8, $t8, 1		# if there was an overflow, correct the significant
	add $t7, $t7, 1		# and increase the exponent by 1
cont2:	sub $t8, $t8, $t4	# take out the '1' from the significant
	add $v0, $t8, $t7	# connect the significant and the exponent and put it in $v0
	jr $ra			# return
