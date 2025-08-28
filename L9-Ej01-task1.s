##-- Esquema de un programa que realiza la tarea 1, 
#--  entre otras cosas
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
	
	
	#-- Se realizan las inicializaciones u otras acciones necesarias
	#-- ....
	
	#-- Acción de la Tarea 1: La simulamos imprimiendo un 
	#-- mensaje en la consola, pero la tarea podría ser cualquiera
	#-- que necesitasemos en nuestro proyecto
	la a1, msg_tarea1
	li a0, PRINT_STRING
	ecall
	
	#-- ....
	#-- Por aqui habria más código
	#-- ...
	
	#-- PUNTO DE SALIDA
	li a0, EXIT
	ecall
	#-----------------------------------------------------------------------
	
