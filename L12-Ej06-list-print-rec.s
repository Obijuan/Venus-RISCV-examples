	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
    .equ SBRK         9
	.equ EXIT         10


#-- Ejemplo de creación de una lista enlazada
#-- Luego se imprime

	.text
	
	#-- Crear un nodo nuevo, inicializa a 1
	mv a0, zero
	li a1, 1
	jal create		
		
	#-- Crear otro nodo, inicializado a 2
	li a1, 2
	jal create
	
	#-- Crear otro nodo, inicializado a 3
	li a1, 3
	jal create
	
	#-- Imprimir la lista
	#-- Se pasa por a0 el puntero a la lista
	jal print

	#-- Terminar
	li a0, EXIT
	ecall

#--------------------------------------
#-- Subrutina: Imprimir el contenido de una lista enlazada
#-- Se imprime usando un algoritmo recursivo
#-- 
#-- ENTRADA: 
#--   a0: Puntero a la lista a imprimir
#--
#-- SALIDA: Ninguna
#------------------------------------------------------------
	
	.globl print
	
	.text
print:	

	#-- Si es una lista vacia, terminar
	beq a0, zero, fin

	#-- No es una lista vacia
	#-- Crear la pila para guardar la direccion de retorno
	addi sp, sp, -16
	sw ra, 12(sp)
	
	#-- Usamos t0 para acceder al nodo
	mv t0, a0
	
	#-- Imprimir el valor del nodo
	lw a1, NUM(t0)
	li a0, PRINT_INT
	ecall
	
	#-- Imprimir '\n'
	li a1, '\n'
	li a0, PRINT_CHAR
	ecall
	
	#-- Obtener el puntero al siguiente nodo
	lw a0, NEXT(t0)
	
	#-- Imprimir la sublista
	jal print
	
	lw ra, 12(sp)
	addi sp, sp, 16
	
fin:	
	#-- Terminar
	ret




#-- de la lista
#-- ENTRADAS: 
#--    a0: puntero al siguiente nodo
#--    a1: Numero a almacenar en ese nodo
#--
#-- SALIDAS:
#--    a0: Puntero al nodo creado
#-----------------------------------------------------
	
	.globl create
	
	#---- Informacion sobre el nodo
	.equ TAM 8   #-- Tamaño del nodo
	.equ NEXT 0  #-- Offset del campo NEXT
	.equ NUM 4   #-- Offset del campo NUM
	
	.text 
	
create:

	#-- Guardar los argumentos pasados en t0 y t1 respectivamente
	mv t0, a0
	mv t1, a1

	#-- Crear un nodo nuevo
	li a1, TAM
	li a0, SBRK
	ecall
	
	#-- a0 apunta al nuevo nodo
	
	#-- Inicializar los campos a los valores t0 y t1 (pasados como parametros)
	sw t0, NEXT(a0)
	sw t1, NUM(a0)

	#-- Terminar
	#-- En a0 se devuelve el puntero al nuevo nodo
	ret
