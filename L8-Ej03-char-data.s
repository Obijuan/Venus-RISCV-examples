#-- Ejemplo de almacenamiento en memoria
#-- de la cadena "255" y del número 255 

	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
	.equ EXIT         10
	
	.data
cad:   .string "255"
num:   .byte 255
	

    .text
    nop
