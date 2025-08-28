#-- Conversion de una cadena de 2 dígitos a número

	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
	.equ EXIT         10

	.data

msg1:   .string "\nCadena: "
msg2:   .string "\nNumero: "

	#-- Cadena a convertir a numero
cadnum:	.string "23"
			
	.text
	
	#-- Imprimir mensaje 1
	la a1, msg1
	li a0, PRINT_STRING
	ecall
	
	#-- Imprimir cadena a convertir
	la a1, cadnum
	li a0, PRINT_STRING
	ecall
	
	#--- Calcular la expresion de conversion
	#--- t3 = (d1 -'0') * 10 + (d0 - '0')
	
	##-- Leer digito de mayor peso
	##-- t1 = d1
	lb t1, 0(a1)
	
	#-- Convertir el dígito ASCII a número
	li t6, '0'
	sub t1, t1, t6  #-- t1 = t1 - '0'
	
	##-- Leer digito de menor peso
	##-- t0 = d0
	lb t0, 1(a1)
	
	#-- Covnertirlo a numero
	sub t0, t0, t6  #-- t0 = t0 - '0'
	
	#-- Calcular d1 * 10
	li t5, 10
	mul t2, t1, t5
	
	#-- Calcular t3 = d1 * 10 + d0
	add t3, t2, t0
	
	#-- Imprimir mensaje 2
	la a1, msg2
	li a0, PRINT_STRING
	ecall
	
	#-- Imprimir el numero calculado
	mv a1, t3
	li a0, PRINT_INT
	ecall

fin:		
	#-- Terminar
	li a0, EXIT
	ecall
