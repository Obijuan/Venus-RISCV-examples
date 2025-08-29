#-------------------------------------------
#-- Desplazar un pixel a la derecha usando
#-- el botón 1
#-------------------------------------------

#-- Servicios del sistema operativo
.equ EXIT         10    #-- Terminar el programa
.equ MATRIX_WRITE 0x110 #-- Escribir en la matriz de leds
.equ WRITE_7SEG   0x120 #-- Escribir en el display de 7 segmentos 
.equ SET_LEDs     0x121 #-- Encender LEDs
.equ READ_BUTTONS 0x122 #-- Leer botones


.equ BUTTON_0     0x01
.equ BUTTON_1     0x02


.text

    #-- Pixel en una fila
    li s0, 0x0800

    #-- s1: Sentido del movimiento
    #-- 0: Movimiento hacia la derecha
    #-- 1: Movimiento hacia la izquierda
    li s1, 0

bucle:
    #--- Mostrar el pixel
    li a1, 0      #-- Coordenada y (fila)
    mv a2, s0
    li a0, MATRIX_WRITE
    ecall

    #-- Esperar

    #-- Espera manual: Botón 1
    #jal wait_butt1

    #-- Espera automomatica
    jal wait

    #-- Calcular el sentido del desplazamiento 
    #-- segun la posicion
    
    #-- Si el sentido es hacia la derecha y se alcanza
    #-- la posicion derecha, aplicar un cambio de sentido
    beq s1, zero, check_right

    #-- Sentido: izquierda
    #-- Comprobar si hay rebote
    li t1,0x8000
    beq s0,t1, rebote
    j next

check_right:
    #-- Sentido actual derecha
    #-- Comprobar posicion
    li t1,1
    beq s0,t1, rebote
    j next

rebote:
    #-- Cambiar el sentido del movimiento
    xori s1,s1,1

next:
    #-- Calcular la siguiente posicion del pixel
    #-- Depende del sentido del movimiento
    #-- Sentido: derecha
    beq s1, zero, move_right

    #-- Sentido: izquierda
    slli s0, s0, 1
    j bucle

    #-- Sentido: derecha
move_right:
    #-- Desplazar pixel 1 bit a la izquierda
    srli s0, s0, 1

    #-- Repetir
    j bucle



wait_butt1:
    #-- Leer botones
    li a0, READ_BUTTONS
    ecall

    #-- Aislar el boton 0
    andi t0, a0, BUTTON_1

    #--- Si no está apretado, esperar
    li t1, 1
    beq t0, zero, wait_butt1

    ret

wait:
    li t0, 0x40
1:
    beq t0, zero, wait_end
    nop
    addi t0,t0,-1
    j 1b

wait_end:
    ret