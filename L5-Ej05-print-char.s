#-- Ejemplo de uso del servicio PrintChar
#-- para imprimir un carácter ASCII
#-- Se imprime una 'A' seguida de un salto de línea

	.equ PRINT_CHAR 11
	.equ EXIT 10

	.text
	
	#-- Imprimir una A, usando su codigo ASCII
	li a1, 0x41
	li a0, PRINT_CHAR
	ecall
	
	#-- Imprimir un salto de linea, usando '\n'
	li a1, '\n'
	li a0, PRINT_CHAR
	ecall
	
	#-- Terminar
	li a0, EXIT
	ecall
