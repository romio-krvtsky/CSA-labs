.globl iterative
.globl recursive

.data
n:                   .word 5
expected_value:      .word 13
done_mes_iterative:  .asciiz "\nthe iterative function returned the expected value:\n"
err_mes_iterative:   .asciiz "\nthe iterative function did not return the expected value:\n"
done_mes_recursive:  .asciiz "\nthe recursive function returned the expected value:\n"
err_mes_recursive:   .asciiz "\nthe recursive function did not return the expected value:\n"
returned_value_mes:  .asciiz "\nreturned value:\n"

.text
main:
    la t0, n
    lw a1, 0(t0) # a1 = n
    jal recursive
    
    add t1, x0, a0
    
    la a0, returned_value_mes
    jal print_str
    
    add a0, x0, t1
    jal print_result
    
    la t0, expected_value
    lw a1, 0(t0) # a1 = expected_value
    
    bne a1, a0, recursive_error
    la a0, done_mes_recursive
    jal print_str
    
    la t0, expected_value
    lw a0, 0(t0) # a1 = expected_value
    jal print_result
    j end_recursive_error
    
recursive_error:
	la a0, err_mes_recursive
    jal print_str
    
    la t0, expected_value
    lw a0, 0(t0) # a1 = expected_value
    jal print_result
    
end_recursive_error:

    la t0, n
    lw a1, 0(t0) # a1 = n
    jal iterative
    
    add t1, x0, a0
    la a0, returned_value_mes
    jal print_str
    
    add a0, x0, t1
    jal print_result
    
    la t0, expected_value
    lw a1, 0(t0) # a1 = expected_value
    
    bne a1, a0, iterative_error
    la a0, done_mes_iterative
    jal print_str
    
    la t0, expected_value
    lw a0, 0(t0) # a1 = expected_value
    jal print_result
    
    j end_iterative_error
    
iterative_error:
	la a0, err_mes_iterative
    jal print_str
    
    la t0, expected_value
    lw a0, 0(t0) # a1 = expected_value
    jal print_result
    
end_iterative_error:

exit:

    addi a0, x0, 10
    ecall # Exit


iterative: # we will return sum over the a0 register

	addi sp, sp, -4   # save registers
    sw s0, 0(sp)
    
    xor s0, s0, s0
    add s0, x0, a1   # s0 = n
    xor a0, a0, a0   # a0 = sum = 0

loop:
    beq s0, x0, exit_from_iterative  # if m == 0 goto exit
    add a0, a0, s0    # sum += i
    addi s0, s0, -1   # n -= 1
    j loop
    
exit_from_iterative:
	lw s0, 0(sp)
    addi sp, sp, 4
	jr ra

recursive:
	addi sp, sp, -8  # save a1 register that stores n
    sw ra, 0(sp)
    sw a1, 4(sp)
    
	bne a1, x0, else  # if n == 0 return 0
    xor a0, a0, a0
    lw a1, 4(sp)
    addi sp, sp, 8
    jr ra
    
else:
	
    addi, a1, a1, -1  # if n!=0 return n + recursive(n - 1)
	jal recursive
    lw ra, 0(sp)
    lw a1, 4(sp)
    addi sp, sp, 8
    add a0, a0, a1
    jr ra	
    
print_str:
    mv a1, a0
    li a0, 4 # tells ecall to print the string that a1 points to
    ecall
    jr ra
    
print_result:
	addi sp, sp, -8
    sw a1, 0(sp)
    sw a0, 4(sp)
    
	xor a1, a1, a1
    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result
    
    lw a0, 4(sp)
    lw a1, 0(sp)
    addi sp, sp, 8
    jr ra
	