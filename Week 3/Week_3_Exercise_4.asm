.data
circle_points_msg:  .asciiz "Number of points within the circle: "
pi_estimate_msg:    .asciiz "\nCalculated PI number: "
output_file:        .asciiz "PI.TXT"                                # Output file name
buffer:             .space  256                                     # Buffer for file I/O

.text
                    .globl  main

main:
    # Step 1: Initialize random number generation with time as seed
    li      $v0,            30                                      # Syscall 30: Get current time
    syscall
    move    $a0,            $v0                                     # Store the time in $a0 as seed

    li      $v0,            40                                      # Syscall 40: Set random seed
    syscall

    # Initialize counters
    li      $t0,            50000                                   # Total number of points
    li      $t1,            0                                       # Counter for points inside the circle

loop:
    # Generate random x-coordinate (0 < x < 1)
    li      $v0,            43                                      # Syscall 43: Generate random integer
    syscall
    andi    $t2,            $v0,                65535               # Mask to 16 bits for better precision
    mtc1    $t2,            $f0                                     # Move integer to floating-point register
    li      $t3,            65535                                   # Load 65535 into $t3
    mtc1    $t3,            $f1                                     # Move 65535 to floating-point register
    cvt.s.w $f0,            $f0                                     # Convert $f0 to single precision float
    cvt.s.w $f1,            $f1                                     # Convert $f1 to single precision float
    div.s   $f0,            $f0,                $f1                 # Scale to (0, 1) by dividing by 65535

    # Generate random y-coordinate (0 < y < 1)
    li      $v0,            43                                      # Syscall 43: Generate random integer
    syscall
    andi    $t2,            $v0,                65535               # Mask to 16 bits for better precision
    mtc1    $t2,            $f2                                     # Move integer to floating-point register
    cvt.s.w $f2,            $f2                                     # Convert $f2 to single precision float
    div.s   $f2,            $f2,                $f1                 # Scale to (0, 1) by dividing by 65535

    # Check if the point is inside the unit circle (x^2 + y^2 <= 1)
    mul.s   $f3,            $f0,                $f0                 # x^2
    mul.s   $f4,            $f2,                $f2                 # y^2
    add.s   $f5,            $f3,                $f4                 # x^2 + y^2
    li      $t3,            1                                       # Load 1 into $t3
    mtc1    $t3,            $f6                                     # Move 1 to floating-point register
    cvt.s.w $f6,            $f6                                     # Load 1.0 into $f6
    c.le.s  $f5,            $f6                                     # Check if x^2 + y^2 <= 1
    bc1t    inside_circle                                           # If true, increment the counter

    # Decrement the total number of points
    addi    $t0,            $t0,                -1
    bnez    $t0,            loop                                    # Repeat until all points are processed

    # Calculate π as 4 * (points inside circle) / (total points)
    li      $t4,            4                                       # Load 4 into $t4
    mtc1    $t4,            $f7                                     # Move 4 to floating-point register
    cvt.s.w $f7,            $f7                                     # Convert $f7 to single precision float
    mtc1    $t1,            $f8                                     # Move points inside circle to $f8
    cvt.s.w $f8,            $f8                                     # Convert $f8 to single precision float
    mul.s   $f9,            $f7,                $f8                 # 4 * (points inside circle)
    li      $t5,            50000                                   # Load total points into $t5
    mtc1    $t5,            $f10                                    # Move total points to floating-point register
    cvt.s.w $f10,           $f10                                    # Convert $f10 to single precision float
    div.s   $f11,           $f9,                $f10                # π = 4 * (points inside circle) / (total points)

    # Print the number of points inside the circle
    li      $v0,            4
    la      $a0,            circle_points_msg
    syscall
    li      $v0,            1
    move    $a0,            $t1
    syscall

    # Print the estimated value of π
    li      $v0,            4
    la      $a0,            pi_estimate_msg
    syscall
    li      $v0,            2                                       # Syscall for printing float
    mov.s   $f12,           $f11                                    # Move π to $f12 for printing
    syscall

    # Exit the program
    li      $v0,            10
    syscall

inside_circle:
    addi    $t1,            $t1,                1                   # Increment the counter
    j       loop                                                    # Continue the loop
