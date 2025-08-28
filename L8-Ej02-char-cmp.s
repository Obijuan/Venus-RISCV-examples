##-- Diferencia entre el número 2 y el carácter '2'

	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
	.equ EXIT         10
	
	.data
msg1:   .string "Caracter '2': "
msg2:   .string "\nNumero 2: "
	
	.text
	
	#--- Cargamos en t0 el código ASCII de un carácter
	li t0, '2'
	li t1, 2
	
	#-- Imprimir mensaje 1
	la a1, msg1
	li a0, PRINT_STRING
	ecall
	
	#-- Imprimir t0 como  numero, usando PRINT_INT
	mv a1, t0
	li a0, PRINT_INT
	ecall
	
	#-- Imprimir mensaje 2
	la a1, msg2
	li a0, PRINT_STRING
	ecall
	
	
	#-- Imprimir t1 como número, usando PRINT_INT
	mv a1, t1
	li a0, PRINT_INT
	ecall 
	
	#--- Terminar
	li a0, EXIT
	ecall

