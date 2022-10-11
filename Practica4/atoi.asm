.data
.text
atoi:


	EspaciosInicio:
		
		lb $t1,0($a0)
		bne $t1,32,FinEspacios
		addi $a0,$a0,1
		j EspaciosInicio
	FinEspacios:
	
	add $v0,$zero,$zero
	add $t4, $zero, 10
		
		addi $a0,$a0,1
		beq $t1, 45, Negativo
		blt $t1, 58, Comprobacion
	
		Bucle1:
			lb $t1,0($a0)
			blt $t1,58,ComprobacionBucle
		Sigo:
		
			mul $v0,$v0,$t4
			addi $t1, $t1, -48
			add $v0,$v0,$t1
			addi $a0,$a0,1
			j Bucle1
	

	Comprobacion:
		bge $t1, 48, Bucle1
	 	beq $t1,43,Bucle1
	 	j ErrorCaracter
	ComprobacionBucle:
		bge $t1, 48, Sigo
		beq $t1,$zero,TodoCorrecto
		j ErrorCaracter
	 	
	 Negativo:
	 	# Flag de valor negativo
	 	addi $t6, $zero, -1
	 	j Sigo
	
	ErrorCaracter:
		li $v1, 1
		j Exit
	
	TodoCorrecto:
		bne $t6,-1,Positivo
		mul $v0,$v0,$t6
	Positivo:
		li $v1, 0
	
	Exit:
		jr $ra