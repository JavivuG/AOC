.data
Cero: .float 0.0

.text
RegulaFalsi:
	addi $sp, $sp, -32 #Se guarda en la pila
	swc1 $f20, 0($sp)
	swc1 $f21, 4($sp)
	swc1 $f22, 8($sp)
	swc1 $f23, 12($sp)
	swc1 $f24, 16($sp)
	swc1 $f25, 20($sp)
	swc1 $f26, 24($sp)
	sw $ra, 28($sp)	
	
	mov.s $f20,$f12 #Tolerancia en $f20
	mov.s $f21,$f13 # a en $f21
	mov.s $f22,$f14 # b en $f22

	la $t0, Cero # Cargo cero en registro temporal
	lwc1 $f26,0($t0) #$f26 contiene 0.0
	
	c.le.s 1, $f20, $f26 # Si tolerancia es menor o igual que cero
	bc1t 1, ErrorTolerancia
	
	mov.s $f12, $f21
	jal F
	mov.s $f23,$f0
	
	mov.s $f12,$f22
	jal F
	mov.s $f24, $f0
	c.eq.s 3, $f24, $f26 # Si f(b) es 0 entonces solucion
	bc1t 3, SolucionCorrecta
	
	mul.s $f1,$f23,$f24
	c.lt.s 1, $f1, $f26 # Si son iguales los extremos entonces salgo
	bc1f 1, ErrorIntervalo
	
	c.eq.s 2, $f23, $f26 # Si f(a) es 0 entonces solucion
	bc1t 2, SolucionCorrecta
	
	c.eq.s 3, $f24, $f26 # Si f(b) es 0 entonces solucion
	bc1t 3, SolucionCorrecta
	
	Bucle:
		mov.s $f12,$f21 # Paso el valor (a) a $f12
		jal F
		mov.s $f23,$f0 # f(a) en $f23
		
		mov.s $f12,$f22 # Paso el valor (b) a $f12
		jal F
		mov.s $f24,$f0# f(b) en $f24
		
		mul.s $f3,$f21,$f24
		mul.s $f4,$f22,$f23
		sub.s $f4,$f3,$f4
		sub.s $f3,$f24,$f23
		div.s $f4,$f4,$f3
		mov.s $f25,$f4
		mov.s $f12,$f25 # c en $f4
		jal F
		mov.s $f5,$f0 # f(c) en $f5
		
		abs.s $f6, $f5
		c.lt.s 1, $f6, $f20 # Si la imagen  de c es menor que la tolerancia entonces es la solucion
		bc1t 1, SolucionCorrecta
		
		mul.s $f6, $f23, $f5 # Si f(a)*f(c) son < 0 entonces son de distinto signo
		c.lt.s 1, $f6, $f26
		bc1t 1, AsignoB
		
		AsignoA:
			mov.s $f21, $f25 # Asigno a A C
			j Bucle
			
		AsignoB:
			mov.s $f22, $f25 # Asigno a B C
			j Bucle
		
	SolucionCorrecta:
		add $v0,$zero,$zero
		addi $v0,$zero,0
		bc1t 2, ImagenA
		bc1t 3, ImagenB
		mov.s $f0, $f25 # Devuelvo en $f0 el valor c
		j Exit
		
		ImagenA:
			mov.s $f0, $f23
			j Exit
		ImagenB:
			mov.s $f0, $f24
			j Exit
			
	ErrorIntervalo:
		add $v0,$zero,$zero
		addi $v0,$zero,1
		j Exit

	ErrorTolerancia:
		add $v0,$zero,$zero
		addi $v0,$zero,2
		j Exit

	Exit:
		lwc1 $f20, 0($sp)
		lwc1 $f21, 4($sp)
		lwc1 $f22, 8($sp)
		lwc1 $f23, 12($sp)
		lwc1 $f24, 16($sp)
		lwc1 $f25, 20($sp)
		lwc1 $f26, 24($sp)
		lw $ra, 28($sp)	
		addi $sp, $sp, 32 #Se restaura la pila
		jr $ra	
