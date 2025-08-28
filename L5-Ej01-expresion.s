#-- Calculo de la expresión (a - b) + (c + 5)
#-- Usamos los nombres ABI de los registros
#-- Asignación: t0 = a,  t1 = b,  t2 = c
#-- Resultado en t6
#-- Evaluar para a=1, b=2, c=3

	.text
	
	#-- Inicialización de los registros
	#-- t0 = a = 1
	li t0, 1
	
	#-- t1 = b = 2
	li t1, 2
	
	#-- t2 = c = 3
	li t2, 3
	
	#-------- Realizar el calculo de la expresión
	#-- t3 = (a - b)
	sub t3, t0, t1  
	
	#-- t4 = c + 5
	addi t4, t2, 5
	
	#-- t6 = t3 + t4 = (a - b) + (c + 5)
	add t6, t3, t4
	
	#-- Terminar
	li a0, 10
	ecall
