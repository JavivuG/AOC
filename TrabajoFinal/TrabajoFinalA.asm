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
	#Llamada a atoi para convertir la cadena a entero
	#Esta atoi estara modificada para que para que finalice cuando se encuentre ":" asi podremos ir obteniendo los distintos valores de la hora,minutos y segundos
	#Ademas emplearemos el registro $v2 para que devuelva la nueva direccion de la cadena, ya que primero leeremos la hora, luego minutos y por ultimo segundos
	#suponiendo que el valor de la hora esta en $s1
	#Comienzo
	add $s6,$zero,$zero
	move $s7, $a1
	
	jal atoi
	move $s1, $v0
	move $a0, $v1
	slti $t1,$s1,24
	beq $t1,$zero,FormatoHoraInvalido
		slt $t1,$s1,$zero
		bne $t1,$zero,FormatoHoraInvalido
		
	#suponiendo que en $s2 estan los minutos
	lb $t1, 0($a0)
	beq $t1, 32, FormatoHoraInvalido
	jal atoi
	move $s2, $v0
	move $a0, $v1
	slti $t1,$s2,60
	beq $t1,$zero,FormatoHoraInvalido
		slt $t1,$s2,$zero
		bne $t1,$zero,FormatoHoraInvalido
		
	#suponiendo que en $s3 estan los segundos
	lb $t1, 0($a0)
	beq $t1, 32, FormatoHoraInvalido
	jal atoi
	move $s3, $v0
	move $a0, $v1
	slti $t1,$s3,60
	beq $t1,$zero,FormatoHoraInvalido
		slt $t1,$s3,$zero
		bne $t1,$zero,FormatoHoraInvalido
	#Aqui realizaremos el analisis del huso horario, pero todavia no esta implementado
	
	lb $t1, 0($a0)
	bne $t1, 71, NoHayGMT
	
	GMT:
		addi $a0, $a0, 3
		jal atoi
		slti $t3, $v0, -12
		bne $t3, $zero, HusoInvalido
		slti $t3, $v0, 13
		beq $t3, $zero, HusoInvalido
		move $a0, $v1
		addi $t2, $zero, 24
		add $s1, $s1, $v0
		div $s1, $t2
		mfhi $s1
		
		
	#Volveremos a usar la funcion atoi pere en este caso que convierta la cadena hasta que se encuentre con "/" que es el formato que tendra la fecha
	#Para la lectura de los meses lo tendremos que hacer de forma distinta, ya que vienen expresados con letra
	#Esa modificacion de atoi tadavia no esta realizada, ademas utilizaremos $v2 de la misma manera que hacemos en la lectura de la hora
	#Suponiendo que $s6 contiene el valor del año
	#Primero veremos que valor la corresponde
	
	# Guardo el dia en $s4
	NoHayGMT:
		jal atoi
		move $s4, $v0
		move $a0, $v1
	
	
		#Obtengo el mes
		la $t1, Mes
		addi $s5, $zero, 1
	BucleMes:
		lb $t0, 0($t1)
		lb $t3, 0($a0)
		slti $t2, $s5,13
		beq $t2, $zero, FechaInvalida
		bne $t0, $t3, SiguientePrimeraVez
		addi $a0, $a0, 1
		addi $t1, $t1, 1
		lb $t0, 0($t1)
		lb $t3, 0($a0)
		bne $t0, $t3, SiguienteSegundaVez
		addi $a0, $a0, 1
		addi $t1, $t1, 1
		lb $t0, 0($t1)
		lb $t3, 0($a0)
		bne $t0, $t3, SiguienteTerceraVez
		j ObtenidoMes
		SiguientePrimeraVez:
			addi $t1, $t1, 3
			addi $s5, $s5, 1
			j BucleMes
		SiguienteSegundaVez:
			addi $t1, $t1, 2
			addi $s5, $s5, 1
			addi $a0, $a0, -1
			j BucleMes
		SiguienteTerceraVez:
			addi $t1, $t1, 1
			addi $s5, $s5, 1
			addi $a0, $a0, -2
			j BucleMes
	
	# Ya tengo el mes en $s5

	ObtenidoMes:
	addi $a0, $a0, 2
	#Obtengo el anyo
	jal atoi
	slti $t1,$v0,100 # Anyo en $v0
	beq $t1,$zero,AñoSiglo21
		addi $t2,$zero,69
		slt $t1,$t2,$v0
		beq $t1,$zero,AñoSiglo21
		addi $v0,$v0,1900
	AñoSiglo21:
	slti $t1,$v0,101
	beq $t1,$zero,AñoCuatroCifras
	addi $v0,$v0,2000
	AñoCuatroCifras:
	slti $t1,$v0,2101
	beq $t1,$zero,IntervaloFechaInvalido
	addi $t2,$zero,1969
	slt $t1,$t2,$v0
	beq $t1,$zero,IntervaloFechaInvalido
	bne $v0,2100,NoLimite
	addi $s6,$s6,-1
NoLimite:

		
		#Tambien comprobaremos que el mes sea correcto

		#En funcion del mes que sea y suponiendo que $s4 se encuentra el dia
		slt $t1,$zero,$s4
		beq $t1,$zero,FechaInvalida
		beq $s5,1,Meses31
		beq $s5,2,FebreroAnyo
		beq $s5,3,Meses31
		beq $s5,4,Meses30
		beq $s5,5,Meses31
		beq $s5,6,Meses30
		beq $s5,7,Meses31
		beq $s5,8,Meses31
		beq $s5,9,Meses30
		beq $s5,10,Meses31
		beq $s5,11,Meses30
		beq $s5,12,Meses31
	Meses31:
		slti $t1,$s4,32
		beq $t1,$zero,FechaInvalida
		andi $t2,$v0,3 #Determinamos si el año es bisiesto	
		beq $t2,$zero,Bisiesto
		j CalculoIntervalo
	Meses30:
		slti $t1,$s4,31
		beq $t1,$zero,FechaInvalida
		andi $t2,$v0,3 #Determinamos si el año es bisiesto	
		beq $t2,$zero,Bisiesto
		j CalculoIntervalo
	FebreroAnyo:
		beq $v0,2100,NoBisiesto 
		andi $t2,$v0,3 #Determinamos si el año es bisiesto	
		beq $t2,$zero,Bisiesto
	NoBisiesto:
		slti $t1,$s4,29
		beq $t1,$zero,FechaInvalida
		j CalculoIntervalo
	FebreroBisiesto:
		slti $t1,$s4,30
		Bisiesto:
		slti $t2,$s5,3#Comprobamos si el mes en caso de ser año bisiesto es mayor que 2 para tenerlo en cuenta luego en el calculo del intervalo
		bne $t2,$zero,NoSumaUno
		addi $s6,$s6,1
NoSumaUno:	
	beq $t1,$zero,FechaInvalida
	
	CalculoIntervalo:
Enero:	
	bne $s5,1,Febrero
	add $s5,$zero,$zero
	j Calculos
Febrero:
	bne $s5,2,Marzo
	addi $s5,$zero,31
	j Calculos
Marzo:	
	bne $s5,3,Abril
	addi $s5,$zero,59
	j Calculos
Abril:	
	bne $s5,4,Mayo
	addi $s5,$zero,90
	j Calculos
Mayo:	
	bne $s5,5,Junio
	addi $s5,$zero,120
	j Calculos
Junio:	
	bne $s5,6,Julio
	addi $s5,$zero,151
	j Calculos
Julio:	
	bne $s5,7,Agosto
	addi $s5,$zero,181
	j Calculos
Agosto:	
	bne $s5,8,Septiembre
	addi $s5,$zero,212
	j Calculos
Septiembre:	
	bne $s5,9,Octubre
	addi $s5,$zero,243
	j Calculos
Octubre:	
	bne $s5,10,Noviembre
	addi $s5,$zero,273
	j Calculos
Noviembre:	
	bne $s5,11,Diciembre
	addi $s5,$zero,304
	j Calculos
Diciembre:	
	bne $s5,12,Calculos
	addi $s5,$zero,334
	
Calculos:
	addi $t0,$zero,60
	addi $t1,$zero,3600
	addi $t2,$zero,2592000
	addi $t3,$zero,86400
	addi $t4,$zero,31536000
	mul $s2,$s2,$t0
	mul $s1,$s1,$t1
	add $s3,$s3,$s2
	add $s3,$s3,$s1
	#suponiendo que en $s5 este el numero de mes
	mul $s5,$s5,$t3
	mul $s4,$s4,$t3
	add $s4,$s4,$s5
	addi $t5,$v0,-1970
	add $s3,$s4,$s3
	mul $t5,$t5,$t4
	add $s3,$s3,$t5
	#ahora tenemos que calcular el numero de años bisiestos
	addi $t9,$v0,-1972
	addi $t6,$zero,4
	divu $t9,$t6
	mfhi $t7
	mflo $t8
  	bne $t7,$zero,NoResta
  	addi $t8,$t8,-1
NoResta: 	#Con la comprobacion que hicimos previemente para saber si hay que tener en cuenta que el año actual es bisiesto
	add $t8,$t8,$s6
	mul $t8,$t8,$t3
	
	add $a0,$s3,$t8 #resultado final en segundos
	addi $a1, $zero, 1
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
.data
.text
atoi:
	addi $t4,$zero,32
	Espacios:	
		lb $t1,0($a0)
		addi $a0,$a0,1
		beq $t1,$t4,Espacios
		
	FinEspacios:
	
	add $v0,$zero,$zero
	addi $t4, $zero, 10
	addi $t2,$zero,58
	addi $t5,$zero,47
	addi $a1,$zero,0x0ccccccd
		
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
			
		Bucle1_atoi:
			lb $t1,0($a0)
			addi $a0,$a0,1
			slt $t8,$t1,$t2
			slt $t9,$t5,$t1
			beq $t8,$zero,TodoCorrecto #Comprobamos si es un caracter permitido
			j ComprobacionBucle
		Sigo:
			mulu $v0,$v0,$t4
			slt $t0,$v0,$zero
			
			slt $a2,$a1,$v0
			bne $t0,$zero,ErrorOverflow #Como siempre trabajamos con numeros positivos, si aparece un numero negativo es que ha habido overflow
			addi $t1, $t1, -48
			bne $a2,$zero,PosibleOverflow #Comporbamos el overflow solo cuando este cerca de producirse
		Sigo3:
			add $v0,$v0,$t1

			j Bucle1_atoi
	
	CasoEspecial: #Detectamos si es el caso especial y si lo es cargamos el valor correspondiente en $v0
		bne $t6, -1, Sigo2  
		bne $t1, 8, Sigo2
		li $v0,0x80000000
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
			
			j Bucle1_atoi
	ErrorCaracter:
		li $v1, 1
		j Exit_atoi
		
	ErrorOverflow:
		li $v1,2
		j Exit_atoi
	
	TodoCorrecto:
		bne $t6,-1,Positivo
		mul $v0,$v0,$t6
	Positivo:
		move $v1, $a0 # Devuelvo direccion de la cadena
	
	Exit_atoi:

		jr $ra

#A continuacion se incluye la funcion itoa que emplearemos para devolver el resultado como cadena de caracteres en la direccion marcada por $a1
#Aun hay que hacer algunas modificaciones para que se adapte mejor a este programa
.data
.text
itoa:

	addi $t9, $zero, 2
	div $a1, $t9
	mfhi $t0 # Resto 
	mflo $t1 # Cociente
	blt $t0,$zero,bits321 #Si el resto es negativo significa que el parametro a1 es negativo, por ello lo tomaremos como si fuese un 0
	blt $t1,3,a1Valido #Comprueba si el valor de a1 esta entre los especificados
	j bits321 #En caso contrario salta a la opcion por defecto
	
	
a1Valido:
	beq $t0, $zero, Par
	
	Impar: # Binario natural
		#Seleccionamos el modo correcto de acuerdo a lo pasado en el parametro a1
		beq $t1, $zero, bits32
		beq  $t1, 1, bits16
		
		bits8:
			andi $t3, $a0, 255
			j Bucle	
				
		bits16:
			andi $t3, $a0, 65535
			j Bucle	
			
		bits32: 
			add $t3, $a0, $zero
			j Bucle	
		
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
			sb $t7, 0($t6)
			sb $t8, 0($a2)
			addi $t6, $t6, -1
			addi $a2, $a2, 1

			blt $t6, $a2, Exit # Condicion de acabado
			j Bucle1
		
	
	Par: # Complemento a 2
		#Seleccionamos el modo correcto
		beq $t1, $zero, bits321
		beq  $t1, 1, bits161
		
		
		bits81:
			andi $t3, $a0, 255
			andi $t1,$a0,0x00000080
			beq $t1,$zero,Bucle #Determinamos si es positivo o negtivo. Si es positivo se realiza el mismo proceso que en binario natural
			addi $t1,$zero,'-'
			sb $t1, 0($a2)
			addi $a2,$a2,1
			#Si es negativo calculamos el complemento a 2, seleccionamos los bits que necesitamos, asi ya podemos utilizar el porceso del binario natural
			ori $t3,$a0,0xffffff00
			xori $t3,$t3,0xffffffff
			addi $t3,$t3,1
			andi $t3,$t3,0x0000007f
			bne $t3,$zero,Bucle
			ori $t3,$t3,0x00000080
			j Bucle
			
			Positivo8:
			
			Negativo8:
			
		bits161:
			andi $t3, $a0, 65535
			andi $t1,$a0,0x00008000
			beq $t1,$zero,Bucle #Determinamos si es positivo o negtivo. Si es positivo se realiza el mismo proceso que en binario natural
			addi $t1,$zero,'-'
			sb $t1, 0($a2)
			addi $a2,$a2,1
			#Si es negativo calculamos el complemento a 2, seleccionamos los bits que necesitamos, asi ya podemos utilizar el porceso del binario natural
			ori $t3,$a0,0xffff0000
			xori $t3,$a0,0xffffffff
			addi $t3,$t3,1
			andi $t3,$t3,0x00007fff
			bne $t3,$zero,Bucle
			ori $t3,$t3,0x00008000
			
			j Bucle
			
			
			Positivo16:
			
			Negativo16:
		
		bits321:
			andi $t1,$a0,0x80000000
			add $t3,$a0,$zero
			beq $t1,$zero,Bucle#Determinamos si el numero es positivo o negativo. En caso de ser positivo el procedimiento es el mismo que en binario natural.
			addi $t1,$zero,'-' #En caso de ser negativo almacenamos el caracter - en la primera posicion de memoria
			sb $t1, 0($a2)
			addi $a2,$a2,1
			andi $t1,$a0,0x7fffffff
			beq $t1,$zero,Overflow #Detectamos si se trata del caso extremo
			xori $t3,$a0,0xffffffff #Calculamos el complemento a 2 del numero, de modo que obtenemos su valor positivo
			addi $t3,$t3,1
			andi $t3,$t3,0x7fffffff
			bne $t3,$zero,Bucle	#Ahora que el valor es positivo 
Overflow:		#Caso extremo en el cual recibe el -2^31 cuyo opuesto no se puede representar, ya que ocupa mas de 32 bits
			#Como se trata de un unico caso aislado lo resolvemos directamente almacenando los caracteres correspondientes
			#Hemos considerado esta manera, ya que al ser un unico caso es mas eficiente (menos instrucciones) que evaluarlo con un bucle como hacemos con el resto
			#Ademas realizar operaciones aritmeticas con este valor conlleva un gran riesgo de desbordamiento
			addi $t1,$zero,'2'
			sb $t1, 0($a2)
			addi $t1,$zero,'1'
			sb $t1, 1($a2)
			addi $t1,$zero,'4'
			sb $t1, 2($a2)
			addi $t1,$zero,'7'
			sb $t1, 3($a2)
			addi $t1,$zero,'4'
			sb $t1, 4($a2)
			addi $t1,$zero,'8'
			sb $t1, 5($a2)
			addi $t1,$zero,'3'
			sb $t1, 6($a2)			
			addi $t1,$zero,'6'
			sb $t1, 7($a2)			
			addi $t1,$zero,'4'
			sb $t1, 8($a2)
			addi $t1,$zero,'8'
			sb $t1, 9($a2)
			sb $zero, 10($a2)
			
			
			
			
			
	Exit:
		jr $ra
				
		
	
