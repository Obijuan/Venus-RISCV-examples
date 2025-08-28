#-- Ejemplo de uso de bucles
#-- El programa imprime los números de 1 al 10
#-- en la consola y termina

	.equ PRINT_INT    1
	.equ PRINT_STRING 4
	.equ PRINT_CHAR   11
	.equ EXIT         10
	
	#-- Valor maximo del contador
	.equ MAX 10
	
	#-- Caracter de salto de linea (\n)
	.equ LF 10
	
	.text
	
	#-- t0 lo usamos de contador: 1,2,3,4...
	li t0, 0
	
bucle:
	#-- Incrementar el contador
	addi t0, t0, 1
	
	#-- Imprimir su valor
	mv a1, t0
	li a0, PRINT_INT
	ecall
	
	#-- Imprimir '\n' para separar los numeros
	li a1, LF
	li a0, PRINT_CHAR
	ecall
	
	#-- Si t0 < MAX repetir
	li t1, MAX
	blt t0, t1, bucle
	
	#-- Terminar
	li a0, EXIT
	ecall

