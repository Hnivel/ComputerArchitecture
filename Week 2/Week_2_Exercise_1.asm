.data
input_string:   .space  100
count_array:    .space  128
newline:        .asciiz "\n"

.text
main:
    # Input
    li      $v0,            8
    la      $a0,            input_string
    li      $a1,            100
    syscall                                                     # Read string
    la      $t0,            input_string
    la      $t1,            count_array

    # Initialize count_array
    li      $t2,            128
initialize_count_array:
    sb      $zero,          0($t1)
    addi    $t1,            $t1,                    1
    subi    $t2,            $t2,                    1
    bgtz    $t2,            initialize_count_array
    la      $t0,            input_string
    # Traverse the string
count:
    lb      $t3,            0($t0)
    beq     $t3,            $zero,                  sort
    la      $t1,            count_array
    addu    $t1,            $t1,                    $t3
    lb      $t4,            0($t1)
    addi    $t4,            $t4,                    1
    sb      $t4,            0($t1)
    addi    $t0,            $t0,                    1
    j       count

    # Sort and print results
sort:
    li      $t5,            1
print_counts:
    li      $t6,            128
    li      $t7,            0
print_loop:
    la      $t1,            count_array
    addu    $t1,            $t1,                    $t7
    lb      $t4,            0($t1)
    beq     $t4,            $t5,                    print
    addi    $t7,            $t7,                    1
    subi    $t6,            $t6,                    1
    bgtz    $t6,            print_loop
    addi    $t5,            $t5,                    1
    bgt     $t5,            10,                     exit
    j       print_counts
print:
    beq     $t7,            '\n',                   check_point
    li      $v0,            11
    move    $a0,            $t7
    syscall
    li      $v0,            11
    li      $a0,            ',                      '
    syscall
    li      $a0,            ',                      '
    syscall
    li      $v0,            1
    move    $a0,            $t4
    syscall
    li      $v0,            11
    li      $a0,            '                                   ;'
    syscall
    li      $a0,            ',                      '
    syscall
check_point:
    addi    $t7,            $t7,                    1
    subi    $t6,            $t6,                    1
    bgtz    $t6,            print_loop
    j       print_counts

exit:
    li      $v0,            10
    syscall
