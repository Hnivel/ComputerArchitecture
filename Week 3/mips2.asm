.data
filename: .asciiz "raw_input.txt"
output_filename: .asciiz "formatted_result.txt"
buffer_size: .word 256
newline: .asciiz "\n"
header: .asciiz "-----Student personal information-----\n"
name_label: .asciiz "Name: "
id_label: .asciiz "ID: "
address_label: .asciiz "Address: "
age_label: .asciiz "Age: "
religion_label: .asciiz "Religion: "

.text
.globl main

main:
    # Open the input file
    li $v0, 13
    la $a0, filename
    li $a1, 0 # Read-only
    syscall
    move $s0, $v0 # Store file descriptor

    # Allocate memory for the buffer
    li $v0, 9
    lw $a0, buffer_size
    syscall
    move $s1, $v0 # Store buffer address

    # Read the file content into the buffer
    li $v0, 14
    move $a0, $s0 # File descriptor
    move $a1, $s1 # Buffer address
    lw $a2, buffer_size # Buffer size
    syscall

    # Close the input file
    li $v0, 16
    move $a0, $s0
    syscall

    # Print the header
    li $v0, 4
    la $a0, header
    syscall

    # Parse and print the name
    la $t0, name_label
    jal print_label
    jal print_field

    # Parse and print the ID
    la $t0, id_label
    jal print_label
    jal print_field

    # Parse and print the address
    la $t0, address_label
    jal print_label
    jal print_field

    # Parse and print the age
    la $t0, age_label
    jal print_label
    jal print_field

    # Parse and print the religion
    la $t0, religion_label
    jal print_label
    jal print_field

    # Open the output file
    li $v0, 13
    la $a0, output_filename
    li $a1, 1 # Write-only
    li $a2, 644 # File permissions
    syscall
    move $s2, $v0 # Store file descriptor

    # Write the formatted result to the output file
    la $a0, header
    jal write_to_file

    la $a0, name_label
    jal write_to_file
    jal write_field_to_file

    la $a0, id_label
    jal write_to_file
    jal write_field_to_file

    la $a0, address_label
    jal write_to_file
    jal write_field_to_file

    la $a0, age_label
    jal write_to_file
    jal write_field_to_file

    la $a0, religion_label
    jal write_to_file
    jal write_field_to_file

    # Close the output file
    li $v0, 16
    move $a0, $s2
    syscall

    # Exit the program
    li $v0, 10
    syscall

print_label:
    li $v0, 4
    move $a0, $t0
    syscall
    jr $ra

print_field:
    move $t1, $s1
    li $t2, 44 # ASCII code for comma
    li $t3, 0

print_field_loop:
    lb $t4, 0($t1)
    beq $t4, $t2, print_field_end
    beq $t4, $zero, print_field_end
    li $v0, 11
    move $a0, $t4
    syscall
    addi $t1, $t1, 1
    addi $t3, $t3, 1
    j print_field_loop

print_field_end:
    addi $s1, $s1, 1
    li $v0, 4
    la $a0, newline
    syscall
    jr $ra

write_to_file:
    li $v0, 15
    move $a0, $s2 # File descriptor
    move $a1, $t0 # Buffer address
    li $a2, 256 # Buffer size
    syscall
    jr $ra

write_field_to_file:
    move $t1, $s1
    li $t2, 44 # ASCII code for comma
    li $t3, 0

write_field_loop:
    lb $t4, 0($t1)
    beq $t4, $t2, write_field_end
    beq $t4, $zero, write_field_end
    li $v0, 15
    move $a0, $s2 # File descriptor
    move $a1, $t1 # Buffer address
    li $a2, 1 # Buffer size
    syscall
    addi $t1, $t1, 1
    addi $t3, $t3, 1
    j write_field_loop

write_field_end:
    addi $s1, $s1, 1
    li $v0, 15
    move $a0, $s2 # File descriptor
    la $a1, newline
    li $a2, 1
    syscall
    jr $ra
