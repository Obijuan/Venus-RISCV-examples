##-- Esquema de un programa que realiza la tarea 1, 
#--  La tarea 1 se realiza al comienzo y al final
#--  Está estructura en UN UNICO PROGRAMA PRINCIPAL

	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
	.equ EXIT         10
	
	.data
	
msg_tarea1:	.string "\nTAREA 1\n"
	
	.text 
	
	
	#------------------------ PROGRAMA PRINCIPAL (MAIN)-------------------------
	#-- PUNTO DE ENTRADA
	
	#-- Comienzo
	#-- Ejecutar la Tarea 1
	la a1, msg_tarea1
	li a0, PRINT_STRING
	ecall
	
	#-- ....
	#-- Otros cálculos y operaciones de mi programa
	#-- ...
	
	#-- Final
	#-- Ejecutar la Tarea 1
	la a1, msg_tarea1
	li a0, PRINT_STRING
	ecall
	
	#-- PUNTO DE SALIDA
	li a0, EXIT
	ecall
	#-----------------------------------------------------------------------
