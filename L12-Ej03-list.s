	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
    .equ SBRK         9
	.equ EXIT         10


#-- Prueba de la creación de un nodo

	.text
	
	#-- Crear un nodo con NUM=1, NEXT=0
	mv a0, zero
	li a1, 1
	jal create
	
	
	#-- Terminar
	li a0, EXIT
	ecall



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
