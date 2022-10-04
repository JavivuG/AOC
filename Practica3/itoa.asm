# Comprobar si es positivo o negativo. 
# binario natural son pares y complemento a 2 impares. 
# Dividir por 10. 
# or con 48. 
# Funcion que invierta una cadena
.text
itoa:
	addi $t9, $zero, 2
	div $a1, $t9
	mfhi $t0 # Resto 
	mflo $t1 # Cociente
	beq $t0, $zero, Par
	
	Impar: # Binario natural
		addi $t0, $zero, 48
		addi $t9, $zero, 10
		add $t6, $a2, $zero
		beq $t1, $zero, bits32
		beq  $t1, 1, bits16
		
		bits8:
			andi $t3, $a0, 255
			j Bucle	
				
		bits16:
			andi $t3, $a0, 65535
			j Bucle	
			
		bits32: # Falla
			add $t3, $a0, $zero
			j Bucle	
		
		Bucle:
			divu $t3, $t9
			mfhi $t4
			mflo $t3
			or $t4, $t4, $t0
			sb $t4, 0($t6)
			addi $t6, $t6, 1	
			beq $t3, $zero, Invertir
			j Bucle
		
		Invertir:
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
		beq $t1, $zero, bits32
		beq  $t1, 1, bits16
		
		bits81:
			andi $t3, $a0, 255
			blt $t3, $zero, Negativo8
			
			Positivo8:
			
			Negativo8:
			
		bits161:
			andi $t3, $a0, 65535
			blt $t3, $zero, Negativo16
			
			Positivo16:
			
			Negativo16:
		
		bits321:
			blt $t3, $zero, Negativo32
			
			Positivo32:
				
			
			Negativo32:
	Exit:
		jr $ra
				
		
	
	