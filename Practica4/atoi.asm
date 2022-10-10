.data
add $t0, $a0, $zero
addi $t3, $zero, 1
add $t4, $zero, 10

Bucle:
	lb $t1, 0($t0)
	addi $t0, $t0, 1
	blt $t1, 58, Comprobacion
	beq $t3, 1, Error
	Sigo:
	add $t2, $t1, $zero
	mul $t2, $t2, $t3
	
	mul $t3, $t3, $t4 # Actualizo $t3 multiplicandolo por 10 en cada iteracion
	beq $t0, $zero, Exit # Si llego al terminador de cadena salgo

	Comprobacion:
		bge $t1, 48, Sigo
	
ErrorCaracter:
	li $v0, 1
	j Exit
	
TodoCorrecto:
	li $v0, 0
	
Exit:
	jr $ra