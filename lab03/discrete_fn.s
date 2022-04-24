.globl f

.data
# asciiz ��������� ������������ ��� ���������� �����
# asciiz ������������� ������� ������� ������ � ����� ������
# FIXME ��������� ������, ����� ��� �������� ���������� ���������� �������� 
case1:   .asciiz "f(x) should be y, and it is: "
case2:   .asciiz "f(x) should be y, and it is: "
case3:   .asciiz "f(x) should be y, and it is: "
case4:   .asciiz "f(x) should be y, and it is: "
case5:   .asciiz "f(x) should be y, and it is: "
case6:   .asciiz "f(x) should be y, and it is: "
case7:   .asciiz "f(x) should be y, and it is: "
case8:   .asciiz "f(x) should be y, and it is: "
max_val: .word 7
min_val: .word 0

# FIXME ���������� �������� �� ������ �������� � ���� ������� 
output: .word   6, 61, 17, -38, 19, 42, 5

.text
main:
	######### ������� �������, ������ 1 (case1) #########
    # ��������� ����� ������ case1 � a0
    # ��� �������� ���������� ������� print_str
    la a0, case1 
    # ������� ������ �� ������ case1
    jal print_str 
    # ��������� ������ �������� ������� f � a0
    # FIXME ���������� ������ �������� case1
    li a0, -3 
    # ��������� ������ �������� ������� f � a1
    # `output` -- ��� ��������� �� ������, ������� �������� ��������� �������� �������� f
    la a1, output
    # ��������� f(case1)
    jal f     
    # f ������ ��������� f(-3) � �������� a0
    # ����� ���������� ��� �������� �� ������� print_int
    # print_int ������� �������� ��������� � �������� a0
    # �������� ��� ��������� � a0, �� ��������� �����������
    jal print_int
    # print a new line
    jal print_newline

	######### ������� �������, ������ 2 (case2) #########
    la a0, case2
    jal print_str
    # FIXME ���������� ������ �������� case1
    li a0, -2
    la a1, output
    jal f                
    jal print_int
    jal print_newline

	######### ������� �������, ������ 3 (case3) #########
    la a0, case3
    jal print_str
    # FIXME ���������� ������ �������� case1
    li a0, -1
    la a1, output
    jal f               
    jal print_int
    jal print_newline

	######### ������� �������, ������ 4 (case4) #########
    la a0, case4
    jal print_str
    # FIXME ���������� ������ �������� case1
    li a0, 0
    la a1, output
    jal f               
    jal print_int
    jal print_newline

	######### ������� �������, ������ 5 (case5) #########
    la a0, case5
    jal print_str
    # FIXME ���������� ������ �������� case1
    li a0, 1
    la a1, output
    jal f                
    jal print_int
    jal print_newline

	######### ������� �������, ������ 6 (case6) #########
    la a0, case6
    jal print_str
    # FIXME ���������� ������ �������� case1
    li a0, 2
    la a1, output
    jal f               
    jal print_int
    jal print_newline

	######### ������� �������, ������ 7 (case7) #########
    la a0, case7
    jal print_str
    # FIXME ���������� ������ �������� case1
    li a0, 3
    la a1, output
    jal f                
    jal print_int
    jal print_newline
    
  	######### (case8) #########
    la a0, case8
    jal print_str
    # FIXME ���������� ������ �������� case1
    li a0, 4
    la a1, output
    jal f                
    jal print_int
    jal print_newline


	# �������� 10 � ecall ����� ��������� ���������
    li a0, 10
    ecall

# f ��������� ��� ���������:
# a0 �������� ��� �������� �� ����� ��������� ������� f
# a1 ����� ��������� ("output") �������, ����������� ��� ���������� ��������.
f:

	addi sp, sp -8
    sw s0, 0(sp)
    sw s1, 4(sp)
    
    xor s0, s0, s0
    xor s1, s1, s1
    
    addi s0, a0, 3 # s0 = index + 3

    la t0, max_val
    lw t1, 0(t0)    # t1 = max_val
    
    bge s0, t1, default
    
    la t0, min_val
    lw t1, 0(t0)    # t1 = min_val
    
    blt s0, t1, default
    slli s0, s0, 2  # s0 *= 4
    add s1, a1, s0  # s1 = arr + so
    lw a0, 0(s1)    # a0 = *(arr + 4 * (index - 3))
    j after_default
default:

	xor a0, a0, a0
    addi a0, x0, -1
after_default:
    
    lw s0, 0(sp)
    lw s1, 4(sp)
    addi sp, sp, 8
    jr ra               

# �������� ���� ����� �����
# ����: a0: ����� �� ������
# ������ �� ����������
print_int:
	# to print an integer, we need to make an ecall with a0 set to 1
    # the thing that will be printed is stored in register a1
    # this line copies the integer to be printed into a1
    mv a1, a0
    # set register a0 to 1 so that the ecall will print
    li a0, 1
    # print the integer
    ecall
    # return to the calling function
    jr    ra

# �������� ������
print_str:
    mv a1, a0
    li a0, 4 # tells ecall to print the string that a1 points to
    ecall
    jr    ra

print_newline:
    li a1, '\n'
    li a0, 11 # tells ecall to print the character in a1
    ecall
    jr    ra