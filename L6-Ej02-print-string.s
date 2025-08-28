#-- Ejemplo impresion de una cadena

	#-- Codigo de los servicios del Sistema Operativo
	.equ EXIT         10
	.equ PRINT_STRING 4

	.data
	
	#-- Definimos las cadenas en
	#-- tiempo de compilacion
cad1: 	.string "En un lab de la URJC"
cad2:	.string " de cuyo numero no quiero acordarme"
	
	
	.text
	
	#------ Imprimir la primera cadena
	
	#-- Situar en a0 la direccion de la cadena
	la a1, cad1
	
	#-- Imprimir la cadena
	li a0, PRINT_STRING
	ecall 
	
	#-- Terminar
	li a0, EXIT
	ecall