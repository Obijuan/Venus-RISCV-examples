#-- Ejemplo de reserva de una palabra
	
	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
    .equ SBRK         9
	.equ EXIT         10

	.text

	#-- Reserva de 1 palabra (4 bytes)
	li a1, 4
	li a0, SBRK   #-- Servicio Sbrk
	ecall
	
	#-- En a0 tenemos el puntero a la zona de 
	#-- memoria asignada
	
	#-- Guardamos una palabra de prueba
	#-- en esa dirección
	li t0, 0xCACABACA
	sw t0, 0(a0)
	
	#-- Terminar
	li a0, EXIT
	ecall

