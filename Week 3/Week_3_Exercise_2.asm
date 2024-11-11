.data
prompt_u:               .asciiz "Please insert u: "
prompt_v:               .asciiz "Please insert v: "
prompt_a:               .asciiz "Please insert a: "
prompt_b:               .asciiz "Please insert b: "
prompt_c:               .asciiz "Please insert c: "
prompt_d:               .asciiz "Please insert d: "
prompt_e:               .asciiz "Please insert e: "
result_msg:             .asciiz "The result is: "
.text
main:
li $t0, 0 # $t0 = 0
mtc1 $t0, $f20
cvt.s.w $f20, $f20 # $f20 = 0
li $t0, 1 # $t0 = 1
mtc1 $t0, $f21
cvt.s.w $f21, $f21 # $f21 = 1
li $t0, 2 # $t0 = 2
mtc1 $t0, $f22
cvt.s.w $f22, $f22 # $f22 = 2
li $t0, 6 # $t0 = 6
mtc1 $t0, $f23
cvt.s.w $f23, $f23 # $f23 = 6
li $t0, 7 # $t0 = 7
mtc1 $t0, $f24
cvt.s.w $f24, $f24 # $f24 = 7
# Read input u
li $v0, 4
la $a0, prompt_u
syscall
li $v0, 6 # syscall for reading double
syscall
mov.s   $f1, $f0 # $f1 = u
# Read input v
li $v0, 4
la $a0, prompt_v
syscall
li $v0, 6 # syscall for reading double
syscall
mov.s   $f2, $f0 # $f2 = v
# Read input a
li $v0, 4
la $a0, prompt_a
syscall
li $v0, 6 # syscall for reading double
syscall
mov.s   $f3, $f0 # $f3 = a
# Read input b
li $v0, 4
la $a0, prompt_b
syscall
li $v0, 6 # syscall for reading double
syscall
mov.s   $f4, $f0 # $f4 = b
# Read input c
li $v0, 4
la $a0, prompt_c
syscall
li $v0, 6 # syscall for reading double
syscall
mov.s   $f5, $f0 # $f5 = c
# Read input d
li $v0, 4
la $a0, prompt_d
syscall
li $v0, 6 # syscall for reading double
syscall
mov.s   $f6, $f0 # $f6 = d
# Read input e
li $v0, 4
la $a0, prompt_e
syscall
li $v0, 6 # syscall for reading double
syscall
mov.s   $f7, $f0 # $f7 = e

# Calculate d^4
mov.s $f8, $f21
mul.s $f8, $f6, $f6 # $f8 = d^2
mul.s $f8, $f8, $f8 # $f8 = d^4
# Calculate e^3
mov.s $f9, $f21
mul.s $f9, $f7, $f7 # $f9 = e^2
mul.s $f9, $f9, $f7 # $f9 = e^3
# Calculate d^4 + e^3
add.s $f10, $f8, $f9 # $f10 = d^4 + e^3
# Calculate A
div.s $f11, $f3, $f10 # A = a / (d^4 + e^3)
div.s $f11, $f11, $f24 # A = (a / (d^4 + e^3)) / 7
# Calculate B
div.s $f12, $f4, $f10 # B = b / (d^4 + e^3)
div.s $f12, $f12, $f23 # B = (b / (d^4 + e^3)) / 6
# Calculate C
div.s $f13, $f5, $f10 # C = c / (d^4 + e^3)
div.s $f13, $f13, $f22 # C = (c / (d^4 + e^3)) / 2
# Calculate u
mov.s $f30, $f20 # First
mov.s $f14, $f21
mul.s $f14, $f1, $f1 # $f14 = u^2
mul.s $f15, $f13, $f14 # $f15 = C * u^2
add.s $f30, $f30, $f15 # $f30 = C * u^2
mul.s $f14, $f14, $f14 # $f14 = u^4
mul.s $f14, $f14, $f1 # f14 = u^5
mul.s $f14, $f14, $f1 # f14 = u^6
mul.s $f15, $f12, $f14 # $f15 = B * u^6
add.s $f30, $f30, $f15 # $f30 = B * u^6 + C * u^2
mul.s $f14, $f14, $f1 # f14 = u^7
mul.s $f15, $f11, $f14 # $f15 = A * u^7
add.s $f30, $f30, $f15 # $f30 = A * u^7 + B * u^6 + C * u^2
# Calculate v
mov.s $f31, $f20 # Second
mov.s $f14, $f21
mul.s $f14, $f2, $f2 # $f14 = v^2
mul.s $f15, $f13, $f14 # $f15 = C * v^2
add.s $f31, $f31, $f15 # $f31
mul.s $f14, $f14, $f14 # $f14 = v^4
mul.s $f14, $f14, $f2 # f14 = v^5
mul.s $f14, $f14, $f2 # f14 = v^6
mul.s $f15, $f12, $f14 # $f15 = B * v^6
add.s $f31, $f31, $f15 # $f30 = B * v^6 + C * v^2
mul.s $f14, $f14, $f2 # f14 = v^7
mul.s $f15, $f11, $f14 # $f15 = A * v^7
add.s $f31, $f31, $f15 # $f30 = A * v^7 + B * v^6 + C * v^2
# Final
sub.s $f29, $f30, $f31
li $t0, 10000
mtc1 $t0, $f15
cvt.s.w $f15, $f15
mul.s $f29, $f29, $f15
round.w.s $f29, $f29
cvt.s.w $f29, $f29
div.s $f29, $f29, $f15
li $v0, 2
mov.s $f12, $f29
syscall

