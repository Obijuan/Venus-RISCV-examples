##-- Esquema de un programa que realiza la tarea 1
##-- Está dividido en el PROGRAMA PRINCIPAL y la
##-- Subrutina tarea1 

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
	jal tarea1
	
	#-- ....
	#-- Otros cálculos y operaciones de mi programa
	#-- ...
	
	#-- Final
	#-- Ejecutar la Tarea 1
	jal tarea1
	
	#-- PUNTO DE SALIDA
	li a0, EXIT
	ecall
	#-----------------------------------------------------------------------
	
	
	 #-------- SUBRUTINA TAREA 1 ----------------
tarea1:  #-- PUNTO DE ENTRADA

	 #-- Ejecutar la Tarea 1
	la a1, msg_tarea1
	li a0, PRINT_STRING
	ecall
	
	#-- PUNTO DE SALIDA
	ret
	#----------------------------------------------
