	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
	.equ EXIT         10


#----------------------------------------------------------
#-- PROGRAMA PRINCIPAL
#--
#--  Calculo del factorial de 3, llamando a subrutinas
#-- de niveles inferiores
#----------------------------------------------------------
	
	#-- Constante. Queremos calcular el factorial de N
	.equ N 3
	
	.data
msg1:	.string "\n\nFactorial de "	
msg2:   .string ": "
		
	.text 
	
	
	#-- Calcular el factorial
	jal fact3
	
	#-- a0 contiene el factorial de 3 
	#-- Lo guardamos en s0 para no perderlo
	mv s0, a0
	
	#-- Imprimir mensaje:
	la a1, msg1
	li a0, PRINT_STRING
	ecall
	
	#-- Imprimir N
	li a1, N 
	li a0, PRINT_INT
	ecall
	
	#-- Fin del mensaje
	la a1, msg2
	li a0, PRINT_STRING
	ecall
	
	#-- Recuperar a0
	mv a1, s0
	
	#-- Imprimir el resultado
	li a0, PRINT_INT
	ecall
	
	#-- Imprimir \n
	li a1, '\n'
	li a0, PRINT_CHAR
	ecall
	
	#-- Terminar
	li a0, EXIT
	ecall


#----------------------------------------------------
#-- Subrutina que calcula el factorial del 3
#-- ENTRADAS:
#--   Ninguna
#-- SALIDAS:
#--   Devuelve 6
#----------------------------------------------------

	#-- Punto de entrada
	.globl fact3
	
	.data
msg:	.string "\n> Fact3: "
	
	.text
	
fact3:

	#-- Necesitamos pila para guardar
	#-- la direccion de retorno
	addi sp, sp, -16
	sw ra, 12(sp)

	#-- Calcular el factorial de 2
	jal fact2
	
	#-- Calcular 3 * fact2
	li t0, 3
	mul t1, a0, t0 
	
	
	#-- Imprimir mensaje
	la a1, msg
	li a0, PRINT_STRING
	ecall
	
	#-- Recuperar a0
	mv a1, t1
	
	#-- Imprimir el valor de factorial
	li a0, PRINT_INT
	ecall
	
	#-- Recuperar direccion de retorno
	lw ra, 12(sp)
	addi sp, sp, 16
	
    #-- Valor a retornar
    mv a0, t1

	ret


#----------------------------------------------------
#-- Subrutina que calcula el factorial del 2
#-- ENTRADAS:
#--   Ninguna
#-- SALIDAS:
#--   Devuelve 2 * fact1()
#----------------------------------------------------

	#-- Punto de entrada
	.globl fact2
	
	.data
fact2_msg:	.string "\n> Fact2: "
	
	.text
	
fact2:

	#-- Necesitamos pila para guardar
	#-- la direccion de retorno
	addi sp, sp, -16
	sw ra, 12(sp)

	#-- Calcular el factorial de 1
	jal fact1
	
	#-- Calcular 2 * fact1
	li t0, 2
	mul t1, a0, t0 
	
	#-- t1 contiene el resultado
	
        #-- Imprimir mensaje
	la a1, fact2_msg
	li a0, PRINT_STRING
	ecall
	
	#-- Imprimir el valor de factorial
	mv a1, t1
	li a0, PRINT_INT
	ecall
	
	#-- Recuperar direccion de retorno
	lw ra, 12(sp)
	addi sp, sp, 16
	
    #-- Valor a retornar
    mv a0, t1

	#-- Terminar
	ret


#----------------------------------------------------
#-- Subrutina que calcula el factorial del 1
#-- ENTRADAS:
#--   Ninguna
#-- SALIDAS:
#--   Devuelve 1
#----------------------------------------------------

	#-- Punto de entrada
	.globl fact1
	
	.data
fact1_msg:	.string "\n> Fact1: 1"
	
	.text
	
fact1:

	#-- NO necesitamos pila
	#-- La direccion de retorno está en ra
	
	#-- Imprimir mensaje
	la a1, fact1_msg
	li a0, PRINT_STRING
	ecall

	#-- Devolver 1
	li a0, 1	
	ret

