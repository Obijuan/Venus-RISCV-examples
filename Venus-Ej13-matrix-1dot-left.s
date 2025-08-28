#-------------------------------------------
#-- Dibujar un punto en la matriz de leds
#-------------------------------------------

#-- Servicios del sistema operativo
.equ EXIT         10    #-- Terminar el programa
.equ MATRIX_WRITE 0x110 #-- Escribir en la matriz de leds
.equ WRITE_7SEG   0x120 #-- Escribir en el display de 7 segmentos 
.equ SET_LEDs     0x121 #-- Encender LEDs
.equ READ_BUTTONS 0x122 #-- Leer botones


.text

    #-- Pixel en una fila
    li t0, 0x0001

bucle:
    #--- Mostrar el pixel
    li a1, 0      #-- Coordenada y (fila)
    mv a2, t0
    li a0, MATRIX_WRITE
    ecall

    #-- Desplazar pixel 1 bit a la izquierda
    slli t0, t0, 1

    #-- Repetir
    j bucle

