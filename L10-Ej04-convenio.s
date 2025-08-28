	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
	.equ EXIT         10

main:
    jal tarea1

    li a0, EXIT
    ecall

#-- Ejemplo de subrutina
#-- que VIOLA EL CONVENIO de USO de REGISTROS
#-- ¡¡¡CUIDADO!!
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
	
	#-- Inicializar t0 a 25
	li t0, 25
	
	#-- Llamar a tarea 2
	jal tarea2
	
	#-- ¡VIOLACION! NO podemos usar el valor de t0. Hay que  
	#-- darlo por perdido!
	addi t0,t0,1

	#-- Punto de salida
	ret	

tarea2:
    ret
    