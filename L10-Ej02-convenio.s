#-- Ejemplo de programa principal 
#-- que VIOLA EL CONVENIO  
#-- de uso de registros de la ABI del RISCV
#---------¡¡¡¡¡¡CUIDADO!!!!!

	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
	.equ EXIT         10
	
	.text
	
	#-- Inicializar el registro t0
	li t0, 25
	
	#--- Llamar a la tarea1
	jal tarea1
	
	#-- Imprimir el valor de t0
	#--- ¡¡¡¡NOOOOOOO!!!! NO PODEMOS USAR t0
	#--- de esa forma. Se ha llamada a tarea 1
	#--- por lo que debemos suponer que t0
	#--- no conserva su valor!!!
	mv a1,t0
	li a0, PRINT_INT
	ecall
	
	#--- NOTA: Si ejecutamos este programa, funciona correctamente
	#-- Se imprime el valor 25
	#-- Porque la subrutina tarea1 la hemos hecho nosotros 
	#-- y no se está modificando t0
	#-- Pero No podemos suponer que t0 preserva su valor
	#-- (El convenio nos dice lo contrario)
	#-- Si quieres tener garantizado que se preserve su valor...
	#-- debes usar los registros estáticos
	
	#-- Terminar
	li a0, EXIT
	ecall
	
	
#-----------------------------------------
#-- Subrutina Tarea 1
#-- Estaría definida en otro fichero, pero 
#-- la incluimos aquí por comodidad
#--------------------------------------------

	.data
msg1:	.string "Tarea 1\n"

	.text
	#--- Punto de entrada de la subrutina
tarea1:	
	#-- Imprimir un mensaje
	la a1, msg1
	li a0, PRINT_STRING
	ecall

	#-- Punto de salida
	ret	

