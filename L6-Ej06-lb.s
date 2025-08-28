#-- Ejemplo de lectura de un byte
#-- Se define una cadena y se imprime en la 
#-- consola su primer carácter

	#-- Código de servicios del S.O
	.equ EXIT       10
	.equ PRINT_CHAR 11
	

	.data
	
cad1:	.string "Hola"

	.text
	
	#-- Puntero de acceso a la cadena
	la t0, cad1
	
	#-- Leemos el primer caracter
	lb t1, 0(t0)
	
	#-- Imprimir el caracter
	mv a1, t1
	li a0, PRINT_CHAR
	ecall
	
	#-- Terminar
	li a0, EXIT
	ecall 

