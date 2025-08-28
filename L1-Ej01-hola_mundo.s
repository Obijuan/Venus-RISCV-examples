#-- Programa hola mundo en RISC-V
#-- Esto son comentarios
	.data
str: .string "Hola mundo en RISC-V!\n"
	
	.text
	
main:	
	
	la a1, str
	li a0, 4   
	ecall
	
	li a0, 10
	ecall	

