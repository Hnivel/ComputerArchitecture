.data
prompt_a:               .asciiz "Please insert a: "
prompt_b:               .asciiz "Please insert b: "
prompt_c:               .asciiz "Please insert c: "
two_solutions_msg_x1:   .asciiz "x1 = "
two_solutions_msg_x2:   .asciiz "\nx2 = "
one_solution_msg:       .asciiz "There is one solution, x = "
no_solution_msg:        .asciiz "There is no real solution\n"

.text
main:
    # Read input a
    li      $v0,                4
    la      $a0,                prompt_a
    syscall
    li      $v0,                7                               # syscall for reading double
    syscall
    mov.d   $f26,               $f0                             # $f0 = a

    # Read input b
    li      $v0,                4
    la      $a0,                prompt_b
    syscall
    li      $v0,                7                               # syscall for reading double
    syscall
    mov.d   $f2,                $f0                             # $f2 = b

    # Read input c
    li      $v0,                4
    la      $a0,                prompt_c
    syscall
    li      $v0,                7                               # syscall for reading double
    syscall
    mov.d   $f4,                $f0                             # $f4 = c

    # Compute discriminant: discriminant = b*b - 4*a*c
    mul.d   $f6,                $f2,                    $f2     # $f6 = b * b
    li      $t0,                4                               # $t0 = 4
    mtc1    $t0,                $f8                             # $f8 = 4
    cvt.d.w $f8,                $f8                             # $f8 = 4.0
    mul.d   $f10,               $f8,                    $f26    # $f10 = 4 * a
    mul.d   $f10,               $f10,                   $f4     # $f10 = 4 * a * c
    sub.d   $f12,               $f6,                    $f10    # $f12 = b * b - 4 * a * c

    # Check if discriminant < 0 (no real solution)
    mtc1    $zero,              $f14                            # $f14 = 0
    cvt.d.w $f14,               $f14                            # $f14 = 0.0
    c.lt.d  $f12,               $f14                            # if (discriminant < 0)
    bc1t    no_real_solution

    # Check if discriminant == 0 (one solution)
    c.eq.d  $f12,               $f14                            # if (discriminant == 0)
    bc1t    one_solution

    # Compute two solutions
    li      $t0,                2                               # $t0 = 2
    mtc1    $t0,                $f8                             # $f8 = 2
    cvt.d.w $f8,                $f8                             # $f8 = 2.0
    sqrt.d  $f12,               $f12                            # sqrt(discriminant)
    neg.d   $f14,               $f2                             # -b
    add.d   $f16,               $f14,                   $f12    # -b + sqrt(discriminant)
    sub.d   $f18,               $f14,                   $f12    # -b - sqrt(discriminant)
    mul.d   $f20,               $f26,                   $f8     # 2*a
    div.d   $f22,               $f16,                   $f20    # x1 = (-b + sqrt(discriminant)) / (2*a)
    div.d   $f24,               $f18,                   $f20    # x2 = (-b - sqrt(discriminant)) / (2*a)

    # Print "x1 = " and the value of x1
    li      $v0,                4
    la      $a0,                two_solutions_msg_x1
    syscall

    li      $v0,                3                               # syscall for printing double
    mov.d   $f12,               $f22                            # move x1 to $f12 for printing
    syscall

    # Print "x2 = " and the value of x2
    li      $v0,                4
    la      $a0,                two_solutions_msg_x2
    syscall

    li      $v0,                3                               # syscall for printing double
    mov.d   $f12,               $f24                            # move x2 to $f12 for printing
    syscall

    j       end                                                 # jump to end of program

one_solution:
    # Compute and print the single solution x = -b / (2*a)
    neg.d   $f9,                $f1
    div.d   $f9,                $f9,                    $f11    # x = -b / (2*a)

    # Print "There is one solution, x = "
    li      $v0,                4
    la      $a0,                one_solution_msg
    syscall

    li      $v0,                3
    mov.d   $f12,               $f9
    syscall
    j       end

no_real_solution:
    # Print "There is no real solution"
    li      $v0,                4
    la      $a0,                no_solution_msg
    syscall

end:
    # Exit the program
    li      $v0,                10
    syscall
