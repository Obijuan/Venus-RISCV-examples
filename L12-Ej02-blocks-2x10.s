#-- Ejemplo de reserva de dos
#-- bloques de 10 bytes
#-- Se escriben 2 palabras en cada bloque
	
	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
    .equ SBRK         9
	.equ EXIT         10
	
	#-- Tamaño del bloque a reservar
	.equ TAM 10
	
	.text

	#-- Reserva de 1 bloque de 10 bytes
	li a1, TAM
	li a0, SBRK
	ecall
	
	#-- Almacenamos dos palabras en 
	#-- en bloque
	li t0, 0xCACABACA
	li t1, 0xCAFEB0B0
	sw t0, 0(a0)
	sw t1, 4(a0)
	
	#-- Reservamos otro bloque de 10 bytes
	li a1, TAM
	li a0, SBRK
	ecall
	
	#-- Almacenamos otras dos palabras
	li t0, 0xB0CAF0CA
	li t1, 0xDED0FE00
	sw t0, 0(a0)
	sw t1, 4(a0)
	
	#-- Terminar
	li a0, EXIT
	ecall
