.data
insert_a:   .asciiz "Insert a: "
insert_b:   .asciiz "Insert b: "
insert_c:   .asciiz "Insert c: "
insert_d:   .asciiz "Insert d: "
output_1:   .asciiz "F = "
output_2:   .asciiz ", remainder "
.text
main:
Input:
    li      $v0,    4
    la      $a0,    insert_a
    syscall                         # Print "Insert a: "
    # Read integer input
    li      $v0,    5
    syscall                         # Read integer a
    move    $s0,    $v0             ##########################
    li      $v0,    4
    la      $a0,    insert_b
    syscall                         # Print "Insert b: "
    # Read integer input
    li      $v0,    5
    syscall                         # Read integer b
    move    $s1,    $v0             ##########################
    li      $v0,    4
    la      $a0,    insert_c
    syscall                         # Print "Insert c: "
    # Read integer input
    li      $v0,    5
    syscall                         # Read integer c
    move    $s2,    $v0             ##########################
    li      $v0,    4
    la      $a0,    insert_d
    syscall                         # Print "Insert d: "
    # Read integer input
    li      $v0,    5
    syscall                         # Read integer d
    move    $s3,    $v0             ##########################

Procedure:
    add     $t0,    $s0,        $s1 # t0 = a + b
    add     $t0,    $t0,        $s2 # t0 = a + b + c
    addi    $t1,    $s0,        10  # t1 = a + 10
    sub     $t2,    $s1,        $s3 # t2 = b - d
    mul     $t3,    $s0,        2   # t3 = 2 * a
    sub     $t3,    $s2,        $t3 # t3 = c - 2 * a
    mul     $t1,    $t1,        $t2 # t1 = (a + 10) * (b - d)
    mul     $t1,    $t1,        $t3 # t1 = (a + 10) * (b - d) * (c - 2 * a)

    div     $t1,    $t0             # Divide $t1 by $t0
    mflo    $t2                     # F
    mfhi    $t3                     # remainder
Output:
    # Print "F = "
    li      $v0,    4
    la      $a0,    output_1
    syscall                         # Print "F = "
    li      $v0,    1
    move    $a0,    $t2
    syscall
    # Print ", remainder "
    li      $v0,    4
    la      $a0,    output_2
    syscall                         # Print ", remainder "
    li      $v0,    1
    move    $a0,    $t3
    syscall
    # Exit
    li      $v0,    10
    syscall
