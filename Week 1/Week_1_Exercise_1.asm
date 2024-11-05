.data
name:               .space  50
yourname:           .asciiz "Please enter your name: "
hello_space:        .asciiz "Hello, "
exclamation_mark:   .asciiz "!"
.text
main:
    li      $v0,            4
    la      $a0,            yourname
    syscall                                                     # Print string
    li      $v0,            8
    la      $a0,            name
    li      $a1,            50
    syscall                                                     # Read string
    la      $t0,            name
    #
find_newline:
    lb      $t1,            0($t0)
    beqz    $t1,            Print
    li      $t2,            10
    beq     $t1,            $t2,                delete_newline
    addi    $t0,            $t0,                1
    j       find_newline

delete_newline:
    sb      $zero,          0($t0)
Print:
    li      $v0,            4
    la      $a0,            hello_space
    syscall                                                     # Print "Hello "
    la      $a0,            name
    syscall                                                     # Print name
    la      $a0,            exclamation_mark
    syscall                                                     # Print name
    li      $v0,            10
    syscall                                                     # Exit
