.data
integer_array: .space 20 # 20 bytes for 5 integer values
prompt_element: .asciiz "Please input element "
prompt_index: .asciiz "Please enter index: "
element_value_message: .asciiz "The value at the chosen index is: "
symbol: .asciiz ": "

.text
main:
li $t0, 0 # Initialize element index (0 to 4)
li $t1, 5 

Input:
bge $t0, $t1, Output # Exit loop if all elements are input
    
li $v0, 4
la $a0, prompt_element
syscall # Print "Please input element "
li $v0, 1 
move $a0, $t0
syscall # Print index number
li $v0, 4
la $a0, symbol
syscall
# Read integer input
li $v0, 5
syscall # Read integer
sll $t0, $t0, 2
sw $v0, integer_array($t0) # Store the value in the array at index $t0
srl $t0, $t0, 2
addi $t0, $t0, 1 # Move to the next position in array
    
j Input

Output:
    # Print "Please enter index: "
    li $v0, 4
la $a0, prompt_index
syscall # Print index prompt

li $v0, 5
syscall # Read integer input
move $t2, $v0 # Store index in $t2

# Calculate the element address: base + (index * 4)
li $t3, 4                      
mul $t2, $t2, $t3
la $t4, integer_array 
add $t4, $t4, $t2 # Calculate address of the chosen element

lw $t5, 0($t4) # Load the value at the calculated address

# Print the result message
li $v0, 4
la $a0, element_value_message
syscall
li $v0, 1
move $a0, $t5
syscall
# Exit program
li $v0, 10
syscall   
