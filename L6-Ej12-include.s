#-- Ejemplo de la directiva include
#-- NO HAY .include EN VENUS
#-- Pero se puede simular con un simple copy-paste

	#-- Incluir fichero con los códigos
	#-- de los servicios del Sistema operativo
	.include "servicios.s"
	
	.data
msg1:   .string "HOLA!!"
	
	.text
	
	#-- Imprimir la cadena
	la a1, msg1
	li a0, PRINT_STRING
	ecall
	
	#-- Terminar
	li a0, EXIT
	ecall

