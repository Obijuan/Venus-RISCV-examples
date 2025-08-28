#-- Ejemplo de programa principal 
#-- que cumple correctamente con el convenio
#-- de uso de registros de la ABI del RISCV

	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
	.equ EXIT         10
	
	.text
	
	li s0, 25
	
	#--- Llamar a la tarea1
	jal tarea1
	
	#-- Imprimir el valor de s0
	#-- Al llamar a tarea1 SU VALOR SE HA PRESERVADO
	mv a1,s0
	li a0, PRINT_INT
	ecall
	
	#-- Terminar
	li a0, EXIT
	ecall
	
#-----------------------------------------
#-- Subrutina Tarea 1
#-- Estaría definida en otro fichero, pero 
#-- la incluimos aquí por comodidad
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

	#-- Punto de salida
	ret	

