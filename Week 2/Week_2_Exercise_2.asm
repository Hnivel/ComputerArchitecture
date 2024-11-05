.data
integer_array:  .space  40                                          # 10 integer values
prompt_element: .asciiz "Please insert element "
output_1:       .asciiz "The second largest value is "
output_2:       .asciiz ", found at index "
output_3:       .asciiz ", "
symbol:         .asciiz ": "
.text
main:
    li      $t0,                0                                   # Initialize element index (0 to 9)
    li      $t1,                10
Input:
    bge     $t0,                $t1,                Procedure       # Exit if all elements are inserted

    li      $v0,                4
    la      $a0,                prompt_element
    syscall                                                         # Print "Please insert element "
    li      $v0,                1
    move    $a0,                $t0
    syscall                                                         # Print index number (0 to 9)
    li      $v0,                4
    la      $a0,                symbol
    syscall
    # Read integer input
    li      $v0,                5
    syscall                                                         # Read integer
    sll     $t2,                $t0,                2
    sw      $v0,                integer_array($t2)                  # Store the value in the array at index $t0
    addi    $t0,                $t0,                1               # Move to the next position in array
    j       Input
    ######################################################################
Procedure:
    li      $t0,                0                                   # Initialize element index (0 to 9)
    li      $t2,                -10000000                           # Max
    li      $t3,                -10000000                           # PreviousMax
FindSecondMax:
    bge     $t0,                $t1,                FindIndices

    sll     $t4,                $t0,                2
    lw      $t5,                integer_array($t4)
    # Comparation
    slt     $t6,                $t2,                $t5
    beq     $t6,                $zero,              ElseCheck
    move    $t3,                $t2
    move    $t2,                $t5
    j       NextInstruction
ElseCheck:
    slt     $t6,                $t3,                $t5
    beq     $t6,                $zero,              NextInstruction
    beq     $t5,                $t2,                NextInstruction
    move    $t3,                $t5
NextInstruction:
    addi    $t0,                $t0,                1
    j       FindSecondMax

FindIndices:
    li      $t6,                0                                   # Flag
    # Print "The second largest value is "
    li      $v0,                4
    la      $a0,                output_1
    syscall
    li      $v0,                1
    move    $a0,                $t3
    syscall
    li      $v0,                4
    la      $a0,                output_2
    syscall
    li      $t0,                0
Loop:
    bge     $t0,                $t1,                End

    sll     $t4,                $t0,                2
    lw      $t5,                integer_array($t4)
    bne     $t5,                $t3,                Instruction
    beq     $t6,                $zero,              PrintNumber
    li      $v0,                4
    la      $a0,                output_3
    syscall
PrintNumber:
    add     $t6,                $t6,                1
    li      $v0,                1
    move    $a0,                $t0
    syscall                                                         # Print index number
Instruction:
    addi    $t0,                $t0,                1
    j       Loop
End:
