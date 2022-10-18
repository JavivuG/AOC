.data
matA: .word -26, 32, 18, 24, 1,-2,0,-11,58,-5,-8,-6,-4,5,-9,4,-5,1,2,0,5,1,2,1,5
matB: .word 26,32,18,24,-8,2,4,6,8,5,1,0,14,12,-3,5,2,2,6,0,-5,-8,-9,-5,-1
matC: .space 100
matRes: .word -479,-664,15,-13,313,252,92,-29,193,54,-154,-198,-145,-213,55,105,112,60,80,-60,114,126,81,133,-46
N: .word 5

ok:  .asciiz "Resultado Correcto" 
bad_mul: .asciiz "MatMul incorrecta" 
bad_max: .asciiz "Max incorrecto" 
bad_min: .asciiz "Min incorrecto" 

.text
.macro read_str(%vector, %size)
	li $v0 8
	la $a0 %vector
	li $a1 %size
	syscall
.end_macro

.macro print_string(%string)  
  	la  $a0  %string  
  	li   $v0 4  
	syscall
.end_macro

.macro read_int($int)
	li $v0 5
	syscall
	add  $int $v0 $zero
.end_macro 

.macro print_int($int)
	add $a0 $zero $int
	li $v0 1
	syscall
.end_macro


.macro print_char_lit(%char)  
	addi   $a0 $zero %char
	li   $v0 11  
	syscall
.end_macro

.macro print_char($reg)  
	add   $a0 $zero $reg
	li   $v0 11  
	syscall
.end_macro

.macro exit
	li $v0 10
	syscall
.end_macro

la $a0, matA
la $a1, matB
la $a2, matC
li $a3, 5
jal MatMul

#Comprobamos que el resultado de la múltiplicación es correcto
la $s0, matC
la $s1, matRes
addi $t2, $s0, 100

check_mul:
lw $t0, 0($s0)
lw $t1, 0($s1)
addi $s0, $s0, 4
addi $s1, $s1, 4
bne $t0, $t1, fallo_mul
bne $t2, $s0, check_mul

la $a0, matC
li $a1, 25
jal vecMaxMin
li $t0, 313
li $t1, -664
bne $t0, $v0, fallo_max
bne $t1, $v1, fallo_min



print_string(ok)
exit

fallo_mul:
print_string(bad_mul)
exit

fallo_max:
print_string(bad_max)
exit

fallo_min: 
print_string(bad_min)
exit