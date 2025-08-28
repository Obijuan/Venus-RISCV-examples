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
#-- 
#-- ENTRADA: 
#--   a0: Puntero al primer elemento de la lista
#--
#-- SALIDA: Ninguna
#------------------------------------------------------------
	
	.globl print
	
	.text
print:	
	#-- Usamos t0 para recorer la lista
	mv t0, a0

next:	
	#-- Comprobar si hemos llegado al final
	#-- Si el puntero es NULL, terminamos
	beq t0, zero, fin

	#-----Hay nodo: Imprimir su valor
	#-- Leer numero
	lw a1, NUM(t0)
	
	#-- Imprimirlo en la consola
	li a0, PRINT_INT
	ecall
	
	#-- Imprimir un salto de linea
	li a1, '\n'
	li a0, PRINT_CHAR
	ecall
	
	#-- Actualizar t0 para apuntar al siguiente nodo
	#-- t0 = t0->next
	lw t0, NEXT(t0)
	
	#-- Repetir
	j next
	
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
