	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
	.equ EXIT         10


main:
    jal tarea1

    li a0, EXIT
    ecall

#-- Ejemplo de subrutina
#-- que VIOLA EL CONVENIO  
#-- de uso de registros de la ABI del RISCV
#---------¡¡¡¡¡¡CUIDADO!!!!!

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
	
	#-- INCORRECTO! NO PODEMOS MODIFICAR
	#-- NINGUN registro estatico
	addi s0,s0,1

	#-- Punto de salida
	ret	

