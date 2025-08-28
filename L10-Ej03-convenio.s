	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
	.equ EXIT         10

main:
    jal tarea1

    li a0, EXIT
    ecall

#-- Ejemplo de subrutina
#-- que respeta el convenio 
#-- aunque no está implementada todavía
#-- Es un boceto

	.globl tarea1
			
	.text

#-----------------------------------------
#-- Subrutina Tarea 1
#--------------------------------------------

	.data
msg1:	.string "Tarea 1\n"

	.text
	#--- Punto de entrada de la subrutina
tarea1:	
	#-- Imprimir un mensaje
	la a1, msg1
	li a0, PRINT_STRING
	ecall
	
	#-- Antes de modificar s0, hay que almacenarlo
	#-- en la pila:
	
	#-- GUARDA S0 EN LA PILA
	
	#-- USAR S0. Modificarlo
	addi s0,s0,1
	
	#-- RECUPERAR s0 de la PILA
	
	#-- De esta forma es como si no se hubiese modificado

	#-- Punto de salida
	ret	

