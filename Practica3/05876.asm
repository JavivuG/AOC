

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
				
		
	
	
