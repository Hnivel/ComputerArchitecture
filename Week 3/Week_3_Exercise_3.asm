.data
input_filename: .asciiz "raw_input.txt"
output_filename: .asciiz "formatted_result.txt"
output_header: .asciiz "-----Student personal information-----\n"
label_name: .asciiz "Name: "
label_id: .asciiz "ID: "
label_address: .asciiz "Address: "
label_age: .asciiz "Age: "
label_religion: .asciiz "Religion: "
buffer_read: .space 128
.text
# Open file
li $v0, 13
la $a0, input_filename
li $a1, 0 # Read
li $a2, 0
syscall
# Read file
li $v0, 14  
la $a1, buffer_read # 
li $a2, 128 # 
move $a0, $s0
syscall
move $s1, $a1
# Close file
li $v0, 16                  # Syscall for close file
move $a0, $s0               # File descriptor
syscall
# Create and open output file for writing
li $v0, 13                  # Syscall for open file
la $a0, output_filename     # Output file name
li $a1, 1                   # Open in write-only mode
li $a2, 0x180               # Create file with RW permissions
syscall
# Print header to terminal and write to file
la $a0, output_header
jal print_and_write
# Print "Name: "
la $a0, label_name
jal print_and_write
move $a0, $s1
jal print_field
# Print "ID: "
la $a0, label_id
jal print_and_write
addi $a0, $s1, 11           # Adjust pointer to start of ID
jal print_field
# Print "Address: "
la $a0, label_address
jal print_and_write
addi $a0, $s1, 19
jal print_field
# Print "Age: "
la $a0, label_age
jal print_and_write
addi $a0, $s1, 68
jal print_field
# Print "Religion: "
la $a0, label_religion
jal print_and_write
addi $a0, $s1, 71
jal print_field

# Close the output file
li $v0, 16                  
move $a0, $s2     
syscall
# Exit
li $v0, 10
syscall
# Print and write
print_and_write:
# Print to terminal
li $v0, 4
syscall

    # Write to output file
    move $a0, $s2               # Output file descriptor
    li $v0, 15                  # Syscall for writing to file
    move $a1, $a0               # Address of string to write
    li $a2, 128                 # Number of bytes to write (adjust as needed)
    syscall
    jr $ra                      # Return

# Procedure to print a specific field (prints until comma or newline)
print_field:
    li $v0, 4                   # Syscall to print string
    syscall

    # Write to output file
    li $v0, 15                  # Syscall for writing to file
    move $a0, $s2               # Output file descriptor
    li $a2, 128                 # Number of bytes to write (adjust as needed)
    syscall
    jr $ra
# Error handling for file open
file_open_error:
    li $v0, 10                  # Exit program if file open failed
    syscall