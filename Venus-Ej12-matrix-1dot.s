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


    #--- Encender un led de la matriz
    li a1, 0      #-- Coordenada y (fila)
    li a2, 0x0001 #-- Leds a encender en la fila
    li a0, MATRIX_WRITE
    ecall

    #-- Terminar
    li a0, EXIT
    ecall 
