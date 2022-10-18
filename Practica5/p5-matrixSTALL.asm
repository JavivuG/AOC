.text
    
#calcula maximo y minimo de un vector 
#a0 --> puntero a vector
#a1 --> N
#devuelve
#v0 --> maximo
#v1 --> minimo


vecMaxMin: 
	li $v0, 0x80000000  	#minimo de los enteros
	li $v1, 0x7FFFFFFF   	#maximo de los enteros
	li $t0, 0		#contador bucle
vecMaxMin_loop:
	lw $t1, 0($a0)		#CARGO PALABRA
	addi $a0, $a0, 4
	addi $t0, $t0, 1
	bgt $v0, $t1, check_min #si v0 es mayor que el valor leido, no actualizo el maximo
	move $v0, $t1
check_min:
	blt $v1, $t1, incr_punt #si v1 es menor que el valor leido, no actulizo el minimo
	move $v1, $t1
incr_punt:
	bne $t0, $a1, 	vecMaxMin_loop
	jr $ra	
                                                            



#a0 --> puntero a matrix enteros NxN A
#a1 --> puntero a matrix enteros NxN B
#a2 --> puntero a matrix enteros NxN C (resultado
#a3 --> N

MatMul:

	li $t0, 0   	#i
_loopI: li $t1, 0	#j
_loopJ: li $t2, 0	#k	
	li $t3, 0 	#c[i][j]

_loopK: #calculamos dirección a[i][k] y cargamos el dato
	mul $t4, $t0, $a3      	#i*N
	mul $t5, $t2, $a3      	#k*N
	mul $t6, $t0, $a3      	#i*N
	add $t4, $t4, $t2	#i*N+k
	add $t5, $t5, $t1	#k*N+j
	add $t6, $t6, $t1	#i*N+j
	sll $t4, $t4, 2		#(i*N+k)*4
	sll $t5, $t5, 2		#(k*N+j)*4
	sll $t6, $t6, 2		#(i*N+j)*4
	add $t4, $t4, $a0	# A + (i*N+k)*4
	add $t5, $t5, $a1	# A + (k*N+j)*4
	add $t6, $t6, $a2	# C + (i*N+j)*4
	lw $t4, 0($t4)
	lw $t5, 0($t5)	
	#calculamos dirección b[k][j] y cargamos el dato	
	mul $t4, $t4, $t5      # A[i][k]*B[k][j]
	addi $t2, $t2, 1	#k++
	
	add $t3, $t3, $t4

	bne $t2, $a3, _loopK
	#calculamos dirección c[i][j] y guardamos el resultado

	
	
	addi $t1, $t1, 1	#j++
	
	sw $t3, 0($t6)
	
	bne $t1, $a3, _loopJ
	addi $t0, $t0, 1
	bne $t0, $a3, _loopI
	jr $ra
