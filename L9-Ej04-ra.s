##-- Entendiendo las instrucciones jal/ret

	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
	.equ EXIT         10

	.text
	
	#-- Salto a la subrutina
	jal subrutina
	
retorno:  #-- Aquí se retorna. Ponemos una etiqueta
          #-- para ver la direccion en la tabla de simbolos
	
	#-- Terminar
	li a0, EXIT
	ecall
	
#-- Punto de entrada de la subrutina	
subrutina:

	#-- Punto de salida de la subrutina
	ret
