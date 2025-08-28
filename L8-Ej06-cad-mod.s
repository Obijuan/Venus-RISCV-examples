#-- Recorrer una cadena definida en tiempo de compilacion
#-- sustituyendo el carácter 'a' por 'i'

	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
	.equ EXIT         10
	
	.data
cad:	.string "Holaaaa"

	.text
	
	#-- Usamos el registro t0 como puntero
	#-- t0 apunta al comienzo de la cadena
	la t0, cad
	
	#-- Bucle principal para recorrer la cadena
bucle:
	#-- Leer el caracter. Se almacena en t1
	lb t1, 0(t0)
	
	#-- Evaluar la condicion de terminacion
	#-- Si t1 es 0 --> Terminar
	beq t1, zero, fin

	#-- Comprobar si t1 = 'a'
	li t2, 'a'
	beq t1,t2,encontrado
	
	#-- El caracter NO es una 'a'
	#-- Pasar al siguiente caracter
	addi t0, t0, 1
	
	#-- Repetir el bucle
	j bucle
	
encontrado:  #-- El caracter actual es una 'a'
	#-- Escribir en esa posicion una 'i'
	li t2, 'i'
	sb t2, 0(t0)
	
	#-- Repetir bucle
	j bucle
		
fin:

	#-- Imprimir la cadena modificada
	la a1, cad
	li a0, PRINT_STRING
	ecall
	
	#-- Terminar
	li a0, EXIT
	ecall
