.data
Cero: .float 0.0

.text
RegulaFalsi:
	addi $sp, $sp, -20#Se guarda en la pila
	swc1 $f12, 0($sp)
	swc1 $f13, 4($sp)
	swc1 $f14, 8($sp)
	swc1 $f15, 12($sp)
	sw $ra, 16($sp)	

	# $f7 almacena la constante cero
	la $t0, Cero # Cargo cero en registro temporal
	lwc1 $f7,0($t0)
	
	mov.s $f15, $f12 # Pongo la tolerania en $f15
	c.le.s 1 $f15, $f7 # Si tolerancia es menor o igual que cero
	bc1t 1, ErrorTolerancia
	
	c.eq.s 1 $f13, $f14 # Si son iguales los extremos entonces salgo
	bc1t 1 ErrorIntervalo
	
	Bucle:
		mov.s $f12,$f13 # Paso el valor (a) a $f12
		jal F
		
		mov.s $f1,$f0 # f(a) en $f1
		mov.s $f12,$f14 # Paso el valor (b) a $f12
		jal F
		
		mov.s $f2,$f0# f(b) en $f2
		mul.s $f3,$f13,$f2
		mul.s $f4,$f14,$f1
		sub.s $f4,$f3,$f4
		sub.s $f3,$f2,$f1
		div.s $f4,$f4,$f3
		mov.s $f12,$f4 # c en $f4
		jal F
		mov.s $f5,$f0 # f(c) en $f5
		
		c.eq.s 1, $f5, $f7 # Compruebo si la imagen de c es menor que la tolerancia
		bc1t 1, SolucionCorrecta #
		
		abs.s $f5, $f5
		c.lt.s 1, $f5, $f15
		bc1t 1, SolucionCorrecta
		
		mul.s $f6, $f1, $f5 # Si f(a)*f(c) son < 0 entonces son de distinto signo
		c.lt.s 1, $f6, $f7
		bc1t 1, AsignoB
		
		AsignoA:
			mov.s $f13, $f4 # Asigno a A C
			j Bucle
		AsignoB:
			mov.s $f14, $f4 # Asigno a B C
			j Bucle
		
		SolucionCorrecta:
			li $v0, 0 # Solucion correcta
			mov.s $f0, $f4 # Devuelvo en $f0 el valor c
			j Exit
	
	ErrorIntervalo:
		li $v0, 1 # ERROR: Intervalos iguales o intervalos igual a cero
		j Exit

	ErrorTolerancia:
		li $v0, 2 # ERROR: Tolerancia igual o menor que cero
		j Exit

	Exit:
		lwc1 $f12, 0($sp)
		lwc1 $f13, 4($sp)
		lwc1 $f14, 8($sp)
		lwc1 $f15, 12($sp)
		lw $ra, 16($sp)	
		addi $sp, $sp, 20 #Se restaura la pila
		jr $ra	

