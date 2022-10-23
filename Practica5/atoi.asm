.data
.text
atoi:

		
		lb $t1,0($a0)
		addi $a0,$a0,1
		beq $t1,32,atoi
		
	FinEspacios:
	
	add $v0,$zero,$zero
	addi $t4, $zero, 10
	addi $t2,$zero,58
	addi $t5,$zero,47
		
		beq $t1, 45, Negativo #Comprobamos si el primer elemento es el signo -, de modo que el numero seria negativo 
		bne $t1,43,SignoMas #Comprobamos si es el signo +
	PrimerElemento:
			lb $t1,0($a0)
			addi $a0,$a0,1
	SignoMas:
			
			

			slt $t8,$t1,$t2
	
			slt $t9,$t5,$t1
			beq $t8,$zero,ErrorCaracter #Comprobamos si es un caracter permitido
			j Comprobacion
			
		Bucle1:
			lb $t1,0($a0)
			addi $a0,$a0,1
			slt $t8,$t1,$t2
			slt $t9,$t5,$t1
			beq $t8,$zero,TodoCorrecto #Comprobamos si es un caracter permitido
			j ComprobacionBucle
		Sigo:
			mulu $v0,$v0,$t4
			blt $v0,$zero,ErrorOverflow #Como siempre trabajamos con numeros positivos, si aparece un numero negativo es que ha habido overflow
			addi $t1, $t1, -48
			bge $v0,0x0ccccccd,PosibleOverflow #Comporbamos el overflow solo cuando este cerca de producirse
		Sigo3:
			add $v0,$v0,$t1

			j Bucle1
	
	CasoEspecial: #Detectamos si es el caso especial y si lo es cargamos el valor correspondiente en $v0
		bne $t6, -1, Sigo2  
		bne $t1, 8, Sigo2
		li $v0,0x80000000
		add $t6, $zero, $zero
		j Positivo
	
	Comprobacion:#Comprobamos si el caracter es valido
		
		beq $t9, $zero, ErrorCaracter
		addi $t1, $t1, -48
	 	j Sigo3
	 	
	ComprobacionBucle:#Comprobamos si el caracter es valido y en caso de no serlo se finaliza la ejecucion y se devuelve el valor actual de $v0
		beq $t9,$zero, TodoCorrecto
		j Sigo
	 	
	 Negativo:
	 	# Flag de valor negativo
	 	addi $t6, $zero, -1
	 	
	 	j PrimerElemento
	 	
	 PosibleOverflow:#Comporbamos todos los posibles casos de overflow
	 		beq $v0, 2147483640, CasoEspecial #Detectamos si es el caso extremo
	 		mfhi $t7
	 		addi $t0,$zero,0x7ffffff0
	 		slt $t0,$v0,$t0
			bne $t7, $zero, ErrorOverflow
			bne  $t0,$zero,Sigo3
	 		
	 Sigo2:
	 		addu $t7, $v0, $t1
			xor $t0, $v0, $t7
			xor $t3, $t1, $t7
			and $t0, $t0, $t3
			slt $t0,$t0,$zero
			bne $t0, $zero, ErrorOverflow
			add $v0,$v0,$t1
			
			j Bucle1
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
