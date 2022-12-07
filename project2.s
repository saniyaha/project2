# Project 2
# ID = 03020812, N = (03020812 % 11) + 26 = 31, M = 31 - 10 = 21
.data
input: .space 1001 # Space required to save the input values
newLine: .asciiz "\n" 
cancel: .asciiz "Unrecognized input"
comma: .asciiz ","

.text
main:
# Storing N in registers t1
li $t1, 31 

# Ask user for input value
la $a0, input
li $a1, 1001
li $v0, 8
syscall

# Preprocessing (Remove leading and Trailing)
addi $a1, $zero, 0

adjustStart:
addu $t4,$a0,$a1                           
lbu $t0, 0($t4)                             
beq $t0,32,moveF
beq $t0,9, moveF
bge $a1,1000,endadjustStart
j endadjustStart

moveF:
addi $a1,$a1,1                             
j adjustStart           

endadjustStart:  
move $a0, $t4 # start of string
addi $a2, $zero, 1000
sub $a2, $a2, $a1 # end of string

adjustEnd:
addi $a1, $zero, 0
addi $t2, $zero, 0

length:
addu $t4,$a0,$a1                           
lbu $t0, 0($t4)  
beq $t0, 10, endadjustEnd                           
blt $t0, 48, notChar 
blt $t0, 118, charCount # probably a character 

j notChar

charCount: addi $t2, $t2, 1
notChar: addi $a1,$a1,1                             

bgt $t2, 4,endadjustEnd
bgt $a1, $a2, endadjustEnd
j length                             

endadjustEnd:  
move $a1, $t2

beqz $a1, wrongInput 
bgt $a1, 4, wrongInput 


# Start
addi $t3, $zero, 0 # Register to store final result. Initialized with 0
jal begin

# Print output 
li $v0, 4
la $a0, newLine
syscall
li $v0, 1
add $a0, $zero, $a1
syscall
li $v0, 4
la $a0, comma
syscall
li $v0, 1
add $a0, $zero, $t3
syscall
j exit


begin:
add $t0, $zero, $a0
add $t2, $zero, $a1

mainLoop:
beq $t2, 1, bit0
beq $t2, 2, bit1
beq $t2, 3, bit2
beq $t2, 4, bit3
continue:
lb $s0, ($t0)
blt $s0, 48, wrongInput # invalid char

# Use case for char between 0 and 9 (ascii 48 and 57) 
number:
sub $s1, $s0, 48
bgt $s1, 9, Upper
j addAll

# Use case for char between A and X (ascii 65 and 88) 
Upper:
sub $s1, $s0, 55
bgt $s1, 30, Lower
blt $s1, 10, wrongInput
j addAll

# Use case for char between a and x (ascii 97 and 120) 
Lower:
sub $s1, $s0, 87
bgt $s1, 30, wrongInput
blt $s1, 10, wrongInput
j addAll

# Adds up the current value of char (if possible) to the total sum in output register
addAll:
mul $s1, $s1, $s2 # multiply char
add $t3, $t3, $s1 # add to output register

# Go to next character in the input string
addi $t0, $t0, 1
sub $t2, $t2, 1
bne $t2, 0, mainLoop
jr $ra


bit0:
addi $s2, $zero, 1 
j continue
bit1:
addi $s2, $zero, 31
j continue 
bit2:
addi $s2, $zero, 961
j continue
bit3:
addi $s2, $zero, 29791
j continue


wrongInput:
# Print New line before printing output 
li $v0, 4
la $a0, newLine
syscall

li $v0, 4
la $a0, cancel
syscall

# Exit Code
exit:
li $v0, 10
syscall
