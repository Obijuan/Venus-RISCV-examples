#-- Programa principal: main

	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
	.equ EXIT         10
	
	.data
msg:	.string "MENSAJE DE ERROR"
	
	
	.text
	
	#-- Cargamos en s0 la direccion de msg
	#-- Lo hacemos en s0 porque hay que llamar dos veces
	la s0, msg
	
	#-- Llamar a la funcion print_error
	mv a0, s0
	jal print_error
	
	#-- Llamar a la funcion print_error
	mv a0, s0
	jal print_error
	
	#-- Terminar
	li a0, EXIT
	ecall 

#---------------------------------------------
#-- SUBRUTINA: Print_error(*error)
#--
#-- Se imprime el mensaje de error apuntado por el parametro error.
#-- Tanto antes como despues del mensaje se imprimen dos líneas
#-- de asteriscos para resaltarlo
#-- 
#--   Entrada:
#--      a0: Puntero al mensaje de error a sacar
#--
#--   Salida: Ninguna
#-----------------------------------------------------  

	.globl print_error
	
	.equ TAM 40

	.text
	
	#-- Punto de entrada
print_error:	

	#-- Necesitamos crear la pila para guardar la direccion de 
	#-- retorno (es una subrutina intermedia)
	addi sp, sp, -16
	
	#-- Guardamos la direccion de retorno
	sw ra, 12(sp)
	
	#-- En a0 tenemos el puntero a la cadena a imprimir....
	#-- Pero primero hay que llamar a la funcion linea
	#-- pasando como parametro el valor 40 en a0
	#-- Para no perder lo que hay en a0, lo guardamos
	#-- en la pila. Por ejemplo en la posicion por debajo de ra
	sw a0, 8(sp)
	
	#-- Imprimir '\n'
	li a1, '\n'
	li a0, PRINT_CHAR
	ecall
	
	#-- Imprimir una linea de 40 asteriscos
	#-- linea(40)
	li a0, TAM
	jal linea
	
	#-- Imprimir '\n'
	li a1, '\n'
	li a0, PRINT_CHAR
	ecall
	
	#-- Recuperar la direccion del mensaje. La metemos en a1
	lw a1, 8(sp)
	
	#-- Llamamos a PRINT_STRING
	li a0, PRINT_STRING
	ecall
	
	#-- Imprimir '\n'
	li a1, '\n'
	li a0, PRINT_CHAR
	ecall
	
	#-- Imprimir la linea inferior
	li a0, TAM
	jal linea
	
	#-- Imprimir '\n'
	li a1, '\n'
	li a0, PRINT_CHAR
	ecall
	
	#-- Recuperar la direccion de retorno
	lw ra, 12(sp)
	
	#-- Recuperar la pila
	addi sp, sp, 16
	
	#-- Punto de salida
	ret



#-----------------------------------------------------
#-- SUBRUTINA LINEA
#---  * Entrada: a0: numero de asteriscos a imprimir
#---  * Salida: Ninguna
#-----------------------------------------------------
	
	.globl linea
	
	.text

linea:  #-- PUNTO DE ENTRADA	
	#--- Estamos dentro de una subrutina
	#--- usamos SIEMPRE registros temporales
	#-- t0: contador. Inicializado a 0
	li t0, 0
	
	#-- a0 contiene el numero de asteriscos
	#-- Lo guardamos en t1 para no perderlo
	mv t1, a0
	
bucle:

	#-- Si t0 > t1 --> Terminar
	bge t0, t1, fin

	#-- Imprimir un asterisco
	li a1, '*'
	li a0, PRINT_CHAR
	ecall
	
	#-- Incrementar contador de asteriscos
	addi t0, t0, 1
	
	#-- Repetir bucle
	j bucle
			
	
fin:	
	#-- Retornar
	ret

