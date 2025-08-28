#-- Ejemplo de escritura de un byte
#-- Se modifica el primer caracter de l cadena

	#-- Código de servicios del S.O
	.equ EXIT         10
	.equ PRINT_STRING 4
	

	.data
	
cad1:	.string "Hola\n"

	.text
	
	#-- Puntero de acceso a la cadena
	la t0, cad1
	
	#-- Imprimir la cadena original
	mv a1, t0
	li a0, PRINT_STRING
	ecall
	
	#-- Modificar el primer caracter por una 'B'
	li t1, 'B'
	sb t1, 0(t0)
	
	#-- Imprimir la nueva cadena
	mv a1, t0
	li a0, PRINT_STRING
	ecall
	
	#-- Terminar
	li a0, EXIT
	ecall 
    