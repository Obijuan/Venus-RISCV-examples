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
#-- No está implementada, es un boceto de
#-- lo que se debería hacer para no violar
#-- el convenio
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
	
	#--- Como necesitaremos t0 tras llamar a la 
	#--- subrutina, hay que guardar su valor
	
	#--- GUARDAR t0 EN LA PILA
	
	#-- Llamar a tarea 2
	jal tarea2
	
	#--- RECUPERAR EL VALOR DE t0 de la PILA
	
	#-- Ahora ya podemos usar su valor normalente
	addi t0,t0,1

	#-- Punto de salida
	ret	

tarea2:
    ret