.data
output_1:   .asciiz "GCD = "
output_2:   .asciiz ", LCM = "
output_3:   .asciiz "Input is not positive"
.text
    li      $v0,        5
    syscall                                     # Read integer a
    move    $s0,        $v0                     # s0 = a
    slt     $t0,        $s0,        $zero
    bne     $t0,        $zero,      End
    li      $v0,        5
    syscall                                     # Read integer b
    move    $s1,        $v0                     #s1 = b
    slt     $t0,        $s1,        $zero
    bne     $t0,        $zero,      End
    slt     $t0,        $s0,        $s1         #If (a < b)
    beq     $t0,        $zero,      Temporary
    add     $t0,        $zero,      $s1
    add     $t4,        $zero,      $s0
    j       Procedure
Temporary:
    add     $t0,        $zero,      $s0
    add     $t4,        $zero,      $s1
Procedure:
    div     $s0,        $t0                     # Divide $s0 by $t0
    mfhi    $t2                                 # remainder
    div     $s1,        $t0                     # Divide $s1 by $t0
    mfhi    $t3                                 # remainder
    beqz    $t2,        Check
    addi    $t0,        $t0,        -1
    j       Procedure
Check:
    beqz    $t3,        Output
    addi    $t0,        $t0,        -1
    j       Procedure
Output:
    # Print "GCD = "
    li      $v0,        4
    la      $a0,        output_1
    syscall                                     # Print "GCD = "
    li      $v0,        1
    move    $a0,        $t0
    syscall
FindLCM:
    div     $t4,        $s0                     # Divide $t4 by $s0
    mfhi    $t2                                 # remainder
    div     $t4,        $s1                     # Divide $t41 by $s0
    mfhi    $t3                                 # remainder
    beqz    $t2,        CheckLCM
    addi    $t4,        $t4,        1
    j       FindLCM
CheckLCM:
    beqz    $t3,        OutputLCM
    addi    $t4,        $t4,        1
    j       FindLCM
OutputLCM:
    # Print "LCM = "
    li      $v0,        4
    la      $a0,        output_2
    syscall                                     # Print "LCM = "
    li      $v0,        1
    move    $a0,        $t4
    syscall
    li      $v0,        10
    syscall
End:
    # Print "LCM = "
    li      $v0,        4
    la      $a0,        output_3
    syscall
