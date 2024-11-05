.data
input_filename: .asciiz "raw_input.txt"
output_filename: .asciiz "formatted_result.txt"
output_header: .asciiz "-----Student personal information-----\n"
label_name: .asciiz "Name: "
label_id: .asciiz "ID: "
label_address: .asciiz "Address: "
label_age: .asciiz "Age: "
label_religion: .asciiz "Religion: "
buffer_read: .space 128        # Space for reading input

.text
main:
    # Open input file for reading
    li $v0, 13                  # Syscall for open file
    la $a0, input_filename      # File name
    li $a1, 0                   # Read-only mode
    li $a2, 0                   # Default permissions
    syscall
    move $s0, $v0               # Store file descriptor in $s0
    bltz $s0, file_open_error   # Check if file opened successfully

    # Allocate space for reading the line
    la $a1, buffer_read         # Load buffer address for reading
    li $a2, 128                 # Number of bytes to read
    li $v0, 14                  # Syscall for reading from file
    move $a0, $s0               # File descriptor
    syscall
    move $s1, $a1               # Store address of buffer

    # Close the input file
    li $v0, 16                  # Syscall for close file
    move $a0, $s0               # File descriptor
    syscall

    # Create and open output file for writing
    li $v0, 13                  # Syscall for open file
    la $a0, output_filename     # Output file name
    li $a1, 1                   # Open in write-only mode
    li $a2, 0x180               # Create file with RW permissions
    syscall
    move $s2, $v0               # Store output file descriptor in $s2
    bltz $s2, file_open_error   # Check if output file opened successfully

    # Print header to terminal and write to file
    la $a0, output_header
    jal print_and_write

    # Print and write "Name: " and the name field
    la $a0, label_name
    jal print_and_write
    move $a0, $s1               # Move to start of name
    jal print_field

    # Print and write "ID: " and the ID field
    la $a0, label_id
    jal print_and_write
    addi $a0, $s1, 11           # Adjust pointer to start of ID
    jal print_field

    # Print and write "Address: " and the address field
    la $a0, label_address
    jal print_and_write
    addi $a0, $s1, 19           # Adjust pointer to start of Address
    jal print_field

    # Print and write "Age: " and the age field
    la $a0, label_age
    jal print_and_write
    addi $a0, $s1, 68           # Adjust pointer to start of Age
    jal print_field

    # Print and write "Religion: " and the religion field
    la $a0, label_religion
    jal print_and_write
    addi $a0, $s1, 71           # Adjust pointer to start of Religion
    jal print_field

    # Close the output file
    li $v0, 16                  # Syscall for close file
    move $a0, $s2               # Output file descriptor
    syscall

    # Exit program
    li $v0, 10
    syscall

# Procedure to print to terminal and write to file
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
    jr $ra                      # Return

# Error handling for file open
file_open_error:
    li $v0, 10                  # Exit program if file open failed
    syscall
