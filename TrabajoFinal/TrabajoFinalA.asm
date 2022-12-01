.data
Mes: .asciiz "ENEFEBMARABRMAYJUNJULAGOSEPOCTNOVDIC"
.text
Epoch:
	
	addi $sp,$sp,-32
	sw $s1,0($sp)
	sw $s2,4($sp)
	sw $s3,8($sp)
	sw $s4,12($sp)
	sw $s5,16($sp)
	sw $s6,20($sp)
	sw $s7,24($sp)
	sw $ra,28($sp)
	#Comienzo
	add $s4, $zero, $zero
	add $s6,$zero,$zero
	move $s7, $a1
	
	jal atoi #llamada a atoi para obtener el valor de la hora y la direccion de la cadena una vez obtenida la hora
	move $s1, $v0
	#Comprobamos que la hora es correcta
	slti $t1,$s1,24
	slt $t2,$s1,$zero
	move $a0, $v1
	beq $t1,$zero,FormatoHoraInvalido

		bne $t2,$zero,FormatoHoraInvalido
		
	#Comprobamos que el formato sea valido, es decir, que esten separados por ":"
	lb $t1, -1($a0)
	addi $t3,$zero,58
	lb $t2, 0($a0)
	addi $t4,$zero,32
	bne $t1, $t3, FormatoHoraInvalido
	beq $t2, $t4, FormatoHoraInvalido
	jal atoi2 #Obtenemos el valor de los minutos y la nueva direccion de la cadena una vez obtenidos los minutos
	move $s2, $v0
	#Comprobamos que el valor de los minutos sea valido
	slti $t1,$s2,60
	slt $t2,$s2,$zero
	move $a0, $v1
	beq $t1,$zero,FormatoHoraInvalido
		bne $t2,$zero,FormatoHoraInvalido
	#Comprobamos que el formato sea valido, es decir, que esten separados por ":"
	lb $t1, -1($a0)
	addi $t3,$zero,58
	lb $t2, 0($a0)
	addi $t4,$zero,32
	bne $t1, $t3, FormatoHoraInvalido
	beq $t2, $t4, FormatoHoraInvalido
	jal atoi2 #Obtenemos el valor de los segundos y la nueva direccion de la cadena una vez ontenidos los segundos
	move $s3, $v0
	#Comprobamos que el valor de los segundos sea valido
	slti $t1,$s3,60
	slt $t2,$s3,$zero
	move $a0, $v1
	lb $t3, 0($a0)
	lb $t5,1($a0)
	lb $t6,2($a0)
	addi $t7,$zero,77
	addi $t4,$zero,71
	addi $t8,$zero,84
	beq $t1,$zero,FormatoHoraInvalido
		bne $t2,$zero,FormatoHoraInvalido
	
	#Comprobamos si ha introducido el GMT
	#Tambien comprobamos que el formato de este sea correcto y su valor sea valido
	
	bne $t3, $t4, NoHayGMT
	bne $t5,$t7,HusoInvalido
	bne $t6,$t8,HusoInvalido
	GMT:
		lb $t1, 3($a0)
		addi $t5,$zero,32
		addi $a0, $a0, 3
		addi $t6, $zero, 43
		addi $t7, $zero, 45
		
		beq $t1, $t5, NoHayGMT1
		
		
		bne $t1, $t6, ComprobacionGMT
		j SigoGMT
		
	ComprobacionGMT:
		
		bne $t1, $t7, HusoInvalido
		
	SigoGMT:
		jal atoi
		slti $t3, $v0, -12
		slti $t4, $v0, 13
		bne $t3, $zero, HusoInvalido
		beq $t4, $zero, HusoInvalido
		move $a0, $v1
		bne $t5, 45, GMTPositivo
		add $s1, $s1, $v0
		j NoHayGMT
	GMTPositivo:
		addi $t1, $zero, -1
		mul $v0, $v0, $t1 
		move $a0, $v1
		addi $t2, $zero, 24
		add $s1, $s1, $v0
		j NoHayGMT
		
		
	NoHayGMT1:
		addi $a0, $a0, 1
	NoHayGMT:
		jal atoi #Obtenemos el valor del dia y la nueva direccion de la cadena una vez obtenido el dia
		move $a0, $v1
		lb $t1, -1($a0)
		addi $t2,$zero,47
		add $s4, $v0, $s4
		
	
	
		#Pasamos a obtener el mes introducido por el usuario
		#Para ello vamos comparando los caracteres introducidos con una cadena definida por nosostros que contiene todos los meses posibles
		
		bne $t1, $t2, FechaInvalida
		la $t1, Mes
		addi $s5, $zero, 1
		lb $t3,0($a0)
		lb $t4,1($a0)
		lb $t5,2($a0)
		addi $a0,$a0,3
	BucleMes:
		slti $t2, $s5,13
		lb $t0, 0($t1)
		beq $t2, $zero, FechaInvalida
		bne $t0, $t3, SiguientePrimeraVez
		lb $t0, 1($t1)
		addi $t1, $t1, 1
		bne $t0, $t4, SiguienteSegundaVez
		lb $t0, 1($t1)
		addi $t1, $t1, 1
		bne $t0, $t5, SiguienteTerceraVez
		j ObtenidoMes
		SiguientePrimeraVez:
			addi $t1, $t1, 3
			addi $s5, $s5, 1
			j BucleMes
		SiguienteSegundaVez:
			addi $t1, $t1, 2
			addi $s5, $s5, 1
			j BucleMes
		SiguienteTerceraVez:
			addi $t1, $t1, 1
			addi $s5, $s5, 1
			j BucleMes
	
	# Ya tengo el mes en $s5

	ObtenidoMes:
	lb $t1, 0($a0)
	addi $t2,$zero,47
	addi $a0, $a0, 1
	
	
	bne $t1, $t2, FechaInvalida
	jal atoi #Obtenemos el valor del anno
	#Comprobamos si este valor es correcto y en que formato lo ha introducido (2 digitos o 4 digitos)
	slti $t1,$v0,100 # Anno en $v0
	addi $t2,$zero,69
	slt $t2,$t2,$v0
	
	beq $t1,$zero,AñoSiglo21
		
		
		beq $t2,$zero,AñoSiglo21
		addi $v0,$v0,1900
	AñoSiglo21:
	slti $t3,$v0,101
	addi $t2,$zero,1969
	beq $t3,$zero,AñoCuatroCifras
	addi $v0,$v0,2000
	AñoCuatroCifras:
	slti $t1,$v0,2101
	addi $t3,$zero,2100
	slt $t5,$t2,$v0
	addi $t4,$zero,1970
	beq $t1,$zero,IntervaloFechaInvalido
	beq $t5,$zero,IntervaloFechaInvalido
	beq $v0,$t3,Limite
	slt $t1,$s1, $zero
	beq $v0,$t4,LimiteInferior
	j NoLimite
Limite:
	slti $t2,$s5,3
	slti $t1,$s1, 24
	addi $s6,$s6,-1
	bne $t2,$zero,SumoLimite
	j NoSumoLimite
SumoLimite:
	addi $s6,$s6,1
NoSumoLimite:
	beq $t1, $zero, CuidadoPorArriba
	j NoLimite

CuidadoPorArriba:
   	beq $s4, 31, CuidadoPorArriba2
    	j NoLimite
CuidadoPorArriba2:
    	beq $s5, 12, IntervaloFechaInvalido
    	j NoLimite
LimiteInferior:
	
	bne $t1, $zero, CuidadoPorDebajo
	j NoLimite

CuidadoPorDebajo:
    	beq $s4, 1, CuidadoPorDebajo2
    	j NoLimite

CuidadoPorDebajo2:
    	beq $s5, 1, IntervaloFechaInvalido
NoLimite:
		
		#Una vez que ya tenemos el dia, el mes y el anno, ya podemos comprobar si la fecha introducida es correcta
		slt $t1,$zero,$s4
		addi $t2,$zero,2
		andi $t3,$v0,3
		
		beq $t1,$zero,FechaInvalida
		beq $s5,$t2,FebreroAnyo
		beq $t3,$zero,Bisiesto
		j CalculoIntervalo 
	FebreroAnyo:
		addi $t4,$zero,2100
		andi $t2,$v0,3 #Determinamos si el anno es bisiesto
		slti $t5,$s4,29
		beq $v0,$t4,NoBisiesto 	#Caso especial del anno 2100
		beq $t2,$zero,FebreroBisiesto
	NoBisiesto:
		
		beq $t5,$zero,FechaInvalida
		addi $s5,$zero,31
		j Calculos
	FebreroBisiesto:
		slti $t1,$s4,30
		addi $s5,$zero,31 #Numero de dias transcurridos hasta el inicio de febrero
		beq $t1,$zero,FechaInvalida
		j Calculos
		Bisiesto:
		slti $t2,$s5,3#Comprobamos si el mes en caso de ser anno bisiesto es mayor que 2 para tenerlo en cuenta luego en el calculo del intervalo
		bne $t2,$zero,CalculoIntervalo
		addi $s6,$s6,1
	
	
	CalculoIntervalo:
	
	addi $t2,$zero,3
	addi $t3,$zero,4
	addi $t4,$zero,5
	addi $t5,$zero,6
	addi $t6,$zero,7
	addi $t7,$zero,8
	addi $t8,$zero,9
	addi $t9,$zero,10
	addi $a0,$zero,11
	addi $a1,$zero,12
	beq $s5,$t2,Marzo
	beq $s5,$t3,Abril
	beq $s5,$t4,Mayo
	beq $s5,$t5,Junio
	beq $s5,$t6,Julio
	beq $s5,$t7,Agosto
	beq $s5,$t8,Septiembre
	beq $s5,$t9,Octubre
	beq $s5,$a0,Noviembre
	beq $s5,$a1,Diciembre
	
Enero:	
	slti $t1,$s4,32
	add $s5,$zero,$zero
	beq $t1,$zero,FechaInvalida
	j Calculos
Marzo:	
	slti $t1,$s4,32
	addi $s5,$zero,59 #Numero de dias transcurridos hasta el inicio de marzo
	beq $t1,$zero,FechaInvalida
	j Calculos
Abril:	
	slti $t1,$s4,31
	addi $s5,$zero,90 #Numero de dias transcurridos hasta el inicio de abril
	beq $t1,$zero,FechaInvalida
	j Calculos
Mayo:	
	slti $t1,$s4,32
	addi $s5,$zero,120 #Numero de dias transcurridos hasta el inicio de mayo
	beq $t1,$zero,FechaInvalida
	j Calculos
Junio:	
	slti $t1,$s4,31
	addi $s5,$zero,151 #Numero de dias transcurridos hasta el inicio de junio
	beq $t1,$zero,FechaInvalida
	j Calculos
Julio:	
	slti $t1,$s4,32
	addi $s5,$zero,181 #Numero de dias transcurridos hasta el inicio de julio
	beq $t1,$zero,FechaInvalida
	j Calculos
Agosto:	
	slti $t1,$s4,32
	addi $s5,$zero,212 #Numero de dias transcurridos hasta el inicio de agosto
	beq $t1,$zero,FechaInvalida
	j Calculos
Septiembre:
	slti $t1,$s4,31	
	addi $s5,$zero,243 #Numero de dias transcurridos hasta el inicio de septiembre
	beq $t1,$zero,FechaInvalida
	j Calculos
Octubre:
	slti $t1,$s4,32	
	addi $s5,$zero,273 #Numero de dias transcurridos hasta el inicio de octubre
	beq $t1,$zero,FechaInvalida
	j Calculos
Noviembre:
	slti $t1,$s4,31	
	addi $s5,$zero,304 #Numero de dias transcurridos hasta el inicio de noviembre
	beq $t1,$zero,FechaInvalida
	j Calculos
Diciembre:
	slti $t1,$s4,32	
	addi $s5,$zero,334 #Numero de dias transcurridos hasta el inicio de diciembre
	beq $t1,$zero,FechaInvalida
	
Calculos:#Calculamos el tiempo en segundos
	addi $t0,$zero,60 #Segundos en un minuto
	addi $t1,$zero,3600 #Segundos en una hora
	addi $t3,$zero,86400 #Segundos en un dia
	addi $t4,$zero,31536000 #Segundos en un anno
	mul $s2,$s2,$t0
	mul $s1,$s1,$t1
	add $s3,$s3,$s2
	add $s3,$s3,$s1
	mul $s5,$s5,$t3
	mul $s4,$s4,$t3
	add $s4,$s4,$s5
	addi $t5,$v0,-1970
	add $s3,$s4,$s3
	mul $t5,$t5,$t4
	
	#ahora tenemos que calcular el numero de annos bisiestos
	addi $t9,$v0,-1972
	addi $t6,$zero,4
	divu $t9,$t6
	mfhi $t7
	add $s3,$s3,$t5
	mflo $t8
  	bne $t7,$zero,NoResta
  	addi $t8,$t8,-1
NoResta: 	#Con la comprobacion que hicimos previemente para saber si hay que tener en cuenta que el anno actual es bisiesto
	add $t8,$t8,$s6
	mul $t8,$t8,$t3
	
	add $a0,$s3,$t8 #resultado final en segundos
	move $a2, $s7
	jal itoa
	j TodoCorrectoPrincipal
	
	
	
	#Para devolverlo como una cadena de caracteres utilizaremos la funcion itoa diseñada en una de las practicas anteriores

	FechaInvalida:
		li $v0,1
		j ExitEpoch
	
	FormatoHoraInvalido:
		li $v0,2
		j ExitEpoch
	
	IntervaloFechaInvalido:
		li $v0, 3
		j ExitEpoch	
	
	HusoInvalido:
		li $v0, 4
		j ExitEpoch
	
	TodoCorrectoPrincipal:
		li $v0, 0
	
	ExitEpoch:
	lw $s1,0($sp)
	lw $s2,4($sp)
	lw $s3,8($sp)
	lw $s4,12($sp)
	lw $s5,16($sp)
	lw $s6,20($sp)
	lw $s7,24($sp)
	lw $ra,28($sp)
	addi $sp,$sp,32
	jr $ra




#A continuacion se incluye la funcion atoi que utilizaremos para convertir los datos pasados por cadena de caracteres a enteros
#Aun hay que realizar algunas modificaciones para que se adapte mejor a este nuevo programa
atoi:
	add $t6, $zero, $zero
	Espacios:	
		lb $t1,0($a0)
		addi $t4,$zero,32
		addi $a0,$a0,1
		beq $t1,$t4,Espacios
		
	FinEspacios:
	
	add $v0,$zero,$zero
	addi $t8,$zero,45
	addi $t9,$zero,43
	addi $t4, $zero, 10
	addi $t2,$zero,58
	addi $t5,$zero,47
		
		beq $t1, $t8, Negativo #Comprobamos si el primer elemento es el signo -, de modo que el numero seria negativo 
		bne $t1,$t9,SignoMas #Comprobamos si es el signo +
	PrimerElemento:
			lb $t1,0($a0)
			addi $a0,$a0,1
	SignoMas:
			slt $t9,$t5,$t1

			j Comprobacion
			
		Bucle1_atoi:
			lb $t1,0($a0)
			addi $a0,$a0,1
			slt $t8,$t1,$t2
			slt $t9,$t5,$t1
			beq $t8,$zero,TodoCorrecto #Comprobamos si es un caracter permitido
			j ComprobacionBucle
		Sigo:
			mulu $v0,$v0,$t4
			
			addi $t1, $t1, -48

		Sigo3:
			add $v0,$v0,$t1

			j Bucle1_atoi
	
	Comprobacion:#Comprobamos si el caracter es valido
		
		addi $t1, $t1, -48
	 	j Sigo3
	 	
	ComprobacionBucle:#Comprobamos si el caracter es valido y en caso de no serlo se finaliza la ejecucion y se devuelve el valor actual de $v0
		beq $t9,$zero, TodoCorrecto
		j Sigo
	 	
	 Negativo:
	 	# Flag de valor negativo
	 	addi $t6, $zero, -1
	 	
	 	j PrimerElemento
	 		
	
	TodoCorrecto:
		bne $t6,-1,Positivo
		mul $v0,$v0,$t6
	Positivo:
		move $v1, $a0 # Devuelvo direccion de la cadena
	
	Exit_atoi:
		jr $ra


atoi2:
	add $t6, $zero, $zero
	lb $t1,0($a0)
	addi $a0,$a0,1
	
	add $v0,$zero,$zero
	addi $t8,$zero,45
	addi $t9,$zero,43
	addi $t4, $zero, 10
	addi $t2,$zero,58
	addi $t5,$zero,47
		
		beq $t1, $t8, Negativo2 #Comprobamos si el primer elemento es el signo -, de modo que el numero seria negativo 
		bne $t1,$t9,SignoMas2 #Comprobamos si es el signo +
	PrimerElemento2:
			lb $t1,0($a0)
			addi $a0,$a0,1
	SignoMas2:
			slt $t9,$t5,$t1

			j Comprobacion2
			
		Bucle1_atoi2:
			lb $t1,0($a0)
			addi $a0,$a0,1
			slt $t8,$t1,$t2
			slt $t9,$t5,$t1
			beq $t8,$zero,TodoCorrecto2 #Comprobamos si es un caracter permitido
			j ComprobacionBucle2
		Sigo2:
			mulu $v0,$v0,$t4
			
			addi $t1, $t1, -48

		Sigo32:
			add $v0,$v0,$t1

			j Bucle1_atoi2
	
	Comprobacion2:#Comprobamos si el caracter es valido
		
		addi $t1, $t1, -48
	 	j Sigo32
	 	
	ComprobacionBucle2:#Comprobamos si el caracter es valido y en caso de no serlo se finaliza la ejecucion y se devuelve el valor actual de $v0
		beq $t9,$zero, TodoCorrecto2
		j Sigo2
	 	
	 Negativo2:
	 	# Flag de valor negativo
	 	addi $t6, $zero, -1
	 	
	 	j PrimerElemento2
	 		
	
	TodoCorrecto2:
		bne $t6,-1,Positivo2
		mul $v0,$v0,$t6
	Positivo2:
		move $v1, $a0 # Devuelvo direccion de la cadena
	
	Exit_atoi2:
		jr $ra
#A continuacion se incluye la funcion itoa que emplearemos para devolver el resultado como cadena de caracteres en la direccion marcada por $a1
#Aun hay que hacer algunas modificaciones para que se adapte mejor a este programa

itoa:
		
		
		add $t3, $a0, $zero	
		
		Bucle:
			#Dividimos el numero repetidas veces entre 10 y utilizamos los restos, ya que se corresponden con las cifras del numero
			#Calculamos el valor en ascii de cada digito sumandole 48, asi ya obtenemos los caracteres que encesitamos
			#El bucle se repite hasta que el cociente es 0 y por lo tanto no quedan mas cifras
			addi $t0, $zero, 48
			addi $t9, $zero, 10
			add $t6, $a2, $zero
		Iteraciones:
			divu $t3, $t9
			mfhi $t4
			mflo $t3
			or $t4, $t4, $t0
			sb $t4, 0($t6)
			addi $t6, $t6, 1	
			beq $t3, $zero, Invertir
			j Iteraciones
		
		Invertir: #Invertimos el orden de los caracteres para obtener la cadena resultado correcta
			# Para ello utilizamos dos punteros a2 y t6 que recorren las posiciones de memoria desde extremos opuestos hasta encontrarse.
			#Ademas van intercambiando los elementos de cada posicion.
			sb $zero, 0($t6)
			addi $t6, $t6, -1

		Bucle1:
			lb $t7, 0($a2)
			lb $t8, 0($t6)
			addi $t6, $t6, -1
			addi $a2, $a2, 1
			slt $t2,$t6,$a2
			sb $t7, 1($t6)
			sb $t8, -1($a2)
			
			bne $t2, $zero, Exit # Condicion de acabado
			j Bucle1
		
			
	Exit:
		jr $ra
				
		
	
