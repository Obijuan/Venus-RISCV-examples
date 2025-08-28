#-- Comparar el valor de dos registros
#-- Si son iguales imprime el mensaje "IGUALES"
#-- Si son diferentes, se imprime "DIFERENTES"
#-- Se utiliza la instruccion bne

	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
	.equ EXIT         10
	
	#-- Valores constantes a comparar
	.equ VALOR1 10
	.equ VALOR2 10
	
	.data
	
	#-- Mensajes a imprimir en la consola
msg_iguales:     .string "IGUALES\n"
msg_diferentes:  .string "DIFERENTES\n"

	.text
	
	#-- Inicializar los registro t0 y t1 con dos valores
	li t0, VALOR1
	li t1, VALOR2
	
	#-- Realizar la comparacion de t0 y t1
	bne t0, t1, diferentes
	
	#-- Son iguales
	la a1, msg_iguales
	li a0, PRINT_STRING
	ecall
	
	#-- Ir al PUNTO DE SALIDA
	j fin
	
	#-- Son diferentes
diferentes:

	la a1, msg_diferentes
	li a0, PRINT_STRING
	ecall

	#-- PUNTO DE SALIDA
fin:	
	#-- Terminar
	li a0, EXIT
	ecall
