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
		
		beq $t1, 45, Negativo
		bne $t1,43,SignoMas
		addi $a0,$a0,1
		j PrimerElemento
	SignoMas:
		blt $t1, 58, Comprobacion
		j ErrorCaracter
	PrimerElemento:
			lb $t1,0($a0)
			blt $t1,58,Comprobacion
			j ErrorCaracter
			
		Bucle1:
			lb $t1,0($a0)
			blt $t1,58,ComprobacionBucle
			j TodoCorrecto
		Sigo:

			mulu $v0,$v0,$t4
			mfhi $t7
			
			bne $t7, $zero, ErrorOverflow
			blt $v0,$zero,ErrorOverflow
			
			addi $t1, $t1, -48
			
			addu $t7, $v0, $t1
			xor $t0, $v0, $t7
			xor $t3, $t1, $t7
			and $t0, $t0, $t3
			blt $t0, $zero, ErrorOverflow
			
			add $v0,$v0,$t1
			blt $v0,$zero,ErrorOverflow
			addi $a0,$a0,1
			j Bucle1
	

	Comprobacion:
		
		bge $t1, 48, Sigo
	 	#beq $t1,43,Bucle1
	 	j ErrorCaracter
	 	
	ComprobacionBucle:
		bge $t1, 48, Sigo
		beq $t1,$zero,TodoCorrecto
		j TodoCorrecto
	 	
	 Negativo:
	 	# Flag de valor negativo
	 	addi $t6, $zero, -1
	 	addi $a0,$a0,1
	 	j PrimerElemento
	
	ErrorCaracter:
		li $v1, 1
		j Exit
		
	ErrorOverflow:
		li $v1,2
		j Exit
	
	TodoCorrecto:
		bne $t6,-1,Positivo
		mul $v0,$v0,$t6
	Positivo:
		li $v1,0
	
	Exit:
		jr $ra
