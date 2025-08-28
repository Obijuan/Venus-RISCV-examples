#-- Ejemplo de manejo de cadenas
#-- Determinar si una cadena es un palindromo o no
#-- El usuario debe introducir la palabra por la consola
#-- Ejemplos de palindromos:  rotor

	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
	.equ EXIT         10


	.data
	
	#-- Cadena a comprobar si es palindromo o no
cadena:	.string "rotor\n"

pal_si:  .string "ES UN PALINDROMO"
pal_no:  .string "NO es palindromo"

	.text
	
	
	#-- Inicializar los punteros a la cadena
	#-- t0: Puntero izquierdo
	#-- t1: Puntero derecho
	la t0, cadena
	mv t1, t0
	 
	#----------- Actualizar t1 para que apunte al final de la cadena
	#-- Comprobar si el caracter actual es 0
bucle1:
	lb t2, 0(t1)
	beq t2, zero, final_cadena
	
	#-- Apuntar al siguiente caracter
	addi t1, t1, 1
	j bucle1
	
final_cadena:	
	#-- t1 apunta al final de la cadena
	#-- Hay que retroceder 2 caracteres: uno es el 0, el otro \n
	addi t1, t1, -2
	
	#-- Ahora t1 apunta al último carácter ASCII legible
	#-- Que comiencen los juegos del palindromo!

bucle:		
	#-- Condicion de salida: si el puntero derecho (t1) 
        #   es menor o igual que el izquierdo (t0):Terminamos: 
        #   es un palindromo
	ble t1, t0, es_palindromo
	
	#-- Leer caracteres izquierdo (t2) y derecho (t3)
	lb t2, 0(t0)
	lb t3, 0(t1)
	
	#-- Si no son iguales: no es un palindromo
	bne t2, t3, no_palindromo
	
	#-- Actualizar los punteros
	addi t0, t0, 1  #-- Puntero izquierdo
	addi t1, t1, -1 #-- Puntero derecho
	
	#-- repetir
	j bucle
	

	#------- La palabra NO es un palindromo
no_palindromo:	
	#-- Imprimir mensaje
	la a1, pal_no
	li a0, PRINT_STRING
	ecall
	
	j fin

						
	#--------- La palabra SÍ es un palíndromo
es_palindromo:
	
	#-- Imprimir mensaje
	la a1, pal_si
	li a0, PRINT_STRING
	ecall

fin:	
	# -- Terminar
	li a0, EXIT
	ecall
