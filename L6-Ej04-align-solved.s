#-- Error de alineamiento: Solucionado
#-- IGUAL QUE EL ANTERIOR... VENUS NO LO DETECTA

	.equ EXIT 10

	#-- En el segmento de datos se define
	#-- una cadena y una variable (palabra)
	.data
str:	.string "Hola"

	#-- Variable
v1:     .word 4

	.text
	
	#-- t0 es el puntero a v1
	la t0, v1
	
	#-- Leer la variable v1 y meterla en el reg t1
	lw t1, 0(t0)
	
	#-- Terminar
	li a0, EXIT
	ecall
