.data
prompt_element: .asciiz "Please enter a positive integer less than 16: "
output:         .asciiz "Its binary form is: "
.text
main:
    li      $v0,    4
    la      $a0,    prompt_element
    syscall                                                                 # Print "Please enter a positive integer less than 16: "
    li      $v0,    5
    syscall                                                                 # Read integer
    move    $t0,    $v0
Output:
    li      $v0,    4
    la      $a0,    output
    syscall                                                                 # Print "Its binary form is: "
    li      $t1,    4

Binary:
    # Get the binary digit
    srl     $t4,    $t0,            3
    andi    $t4,    $t4,            1
    # Print the binary digit
    li      $v0,    1
    move    $a0,    $t4
    syscall
    # Next binary digit
    sll     $t0,    $t0,            1
    addi    $t1,    $t1,            -1
    bgtz    $t1,    Binary
    li      $v0,    10
    syscall                                                                 # Exit
