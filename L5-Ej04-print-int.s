#-- Ejemplo de uso del servicio PrintINT para
#-- sacar un entero por la consola

	#-- Servicio Print_Int
	.equ PRINT_INT 1
	
	#-- Servicio Exit
	.equ EXIT 10

	.text
	
	#-- Imprimir un numero
	li a1, 200
	
	#-- Invocar el servicio print_int
	li a0, PRINT_INT
	ecall
	
	#-- Terminar
	li a0, EXIT
	ecall

