##-- Ejemplo de subrutina
##-- Funcion para devolver el incremento de su parámetro

	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
	.equ EXIT         10

	#-- Valor a incrementar
	.equ VALOR 2

	.text
	
	#----------------------------------------------
	#-- PROGRAMA PRINCIPAL
	#----------------------------------------------
	
	
	#-- Imprimir el valor original
	li a1, VALOR
	li a0, PRINT_INT
	ecall
	
	#-- Llamar a la subrutina de incrementar
	li a0, 2
	jal incrementar
	
	#-- Guardar a0 en t0
	mv t0, a0
	
	#-- Imprimir '\n'
	li a1, '\n'
	li a0, PRINT_CHAR
	ecall
	
	#-- Imprimir el valor incrementado
	mv a1, t0
	li a0, PRINT_INT
	ecall
	
	#-- Terminar
	li a0, EXIT
	ecall
	
#--------------------------------------------
#-- Funcion de incremento:
#--   Entradas: a0: numero a incrementar
#-- Salidas:
#--   a0: Numero incrementado
#--------------------------------------------
incrementar:

	#-- Incrementar a0
	addi a0, a0, 1
	
	#-- Retornar
	ret

