.data
atoi:
	add $t0, $a0, $zero # Direccion de la cadena en $t0
	add $t5, $zero, $zero
	addi $t3, $zero, 1 
	add $t4, $zero, 10

		lb $t1, 0($t0)
		beq $t1, 45, Negativo
		beq $t1, 43, Sigo # En el caso de que sea positivo
		blt $t1, 58, Comprobacion
		beq $t3, 1, ErrorCaracter
	
		Bucle1:
			addi $t1, $t1, -48
			mul $t1, $t1, $t3
			add $t5, $t5, $t1
			mul $t3, $t3, $t4 # Actualizo $t3 multiplicandolo por 10 en cada iteracion 
	
		Sigo:
			addi $t0, $t0, 1 # Incremento el apuntador
			beq $t1, $zero, Exit # Si llego al terminador de cadena salgo
			j Bucle

	Comprobacion:
		bge $t1, 48, Bucle1
	 
	 Negativo:
	 	# Flag de valor negativo
	 	addi $t6, $zero, 1
	 	j Sigo
		
		
	ErrorCaracter:
		li $v1, 1
		j Exit
	
	TodoCorrecto:
		add $v0, $t5, $zero
		li $v1, 0
	
	Exit:
		jr $ra