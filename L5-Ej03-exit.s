#-- Probando el servicio EXIT
#-- Buenas prácticas de programación: definimos las
#-- constantes al comienzo del programa

    #-- Código del servicio Exit, para terminar
	.equ EXIT 10

	.text
	
	#-- No se hace nada
	
	#-- Terminar
	li a0, EXIT
	ecall

