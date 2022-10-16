.data
.text
atoi:

	EspaciosInicio:#Ignoramos todos los espacios que aparezcan al principio de la cadena
		
		lb $t1,0($a0)
		bne $t1,32,FinEspacios
		addi $a0,$a0,1
		j EspaciosInicio
	FinEspacios:
	
	add $v0,$zero,$zero
	addi $t4, $zero, 10
		
		beq $t1, 45, Negativo #Comprobamos si el primer elemento es el signo -, de modo que el numero seria negativo 
		bne $t1,43,SignoMas #Comprobamos si es el signo +
		addi $a0,$a0,1
		j PrimerElemento
	SignoMas:
		blt $t1, 58, Comprobacion #Comprobamos si es un caracter permitido
		j ErrorCaracter
	PrimerElemento:
			lb $t1,0($a0)
			blt $t1,58,Comprobacion #Comprobamos si es un caracter permitido
			j ErrorCaracter
			
		Bucle1:
			lb $t1,0($a0)
			blt $t1,58,ComprobacionBucle #Comprobamos si es un caracter permitido
			j TodoCorrecto
		Sigo:
			mulu $v0,$v0,$t4
			blt $v0,$zero,ErrorOverflow #Como siempre trabajamos con numeros positivos, si aparece un numero negativo es que ha habido overflow
			addi $t1, $t1, -48
			bge $v0,0x0ccccccd,PosibleOverflow #Comporbamos el overflow solo cuando este cerca de producirse
		Sigo3:
			add $v0,$v0,$t1
			addi $a0,$a0,1
			j Bucle1
	
	CasoEspecial: #Detectamos si es el caso especial y si lo es cargamos el valor correspondiente en $v0
		bne $t6, -1, Sigo2  
		bne $t1, 8, Sigo2
		li $v0,0x80000000
		add $t6, $zero, $zero
		j TodoCorrecto
	
	Comprobacion:#Comprobamos si el caracter es valido
		
		bge $t1, 48, Sigo
	 	j ErrorCaracter
	 	
	ComprobacionBucle:#Comprobamos si el caracter es valido y en caso de no serlo se finaliza la ejecucion y se devuelve el valor actual de $v0
		bge $t1, 48, Sigo
		j TodoCorrecto
	 	
	 Negativo:
	 	# Flag de valor negativo
	 	addi $t6, $zero, -1
	 	addi $a0,$a0,1
	 	j PrimerElemento
	 	
	 PosibleOverflow:#Comporbamos todos los posibles casos de overflow
	 		
	 		mfhi $t7
			bne $t7, $zero, ErrorOverflow
			blt $v0,0x7ffffff0,Sigo3
	 		beq $v0, 2147483640, CasoEspecial #Detectamos si es el caso extremo
	 Sigo2:
	 		addu $t7, $v0, $t1
			xor $t0, $v0, $t7
			xor $t3, $t1, $t7
			and $t0, $t0, $t3
			blt $t0, $zero, ErrorOverflow
			j Sigo3
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
