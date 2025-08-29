#-------------------------------------------
#-- Pixel rebotando en la pantalla
#-------------------------------------------

#-- Servicios del sistema operativo
.equ EXIT         10    #-- Terminar el programa
.equ MATRIX_WRITE 0x110 #-- Escribir en la matriz de leds
.equ WRITE_7SEG   0x120 #-- Escribir en el display de 7 segmentos 
.equ SET_LEDs     0x121 #-- Encender LEDs
.equ READ_BUTTONS 0x122 #-- Leer botones


.equ BUTTON_0     0x01
.equ BUTTON_1     0x02

#-- Limites de la zona visual
.equ MAX_X  15  #-- maxima posicion en X
.equ MIN_X   0  #-- Minima posicion en X
.equ MAX_Y  11  #-- maxima posicion en Y
.equ MIN_Y   0  #-- Minima posicion en Y

.data

#-----------------------------------
#-- Estructura de datos del pixel 
#-----------------------------------
#-- Constantes de acceso a los campos del pixel
.equ X  0
.equ Y  0x4
.equ VX 0x8
.equ VY 0xC
.equ OLD_Y 0x10
pixel0:
    .word 1  #-- Coordenada x
    .word 0  #-- Coordenada y
    .word 1  #-- Velocidad en x
    .word 1  #-- Velocidad en y
    .word 0  #-- Posicion y anterior

.text

    #-- Configurar
    #-- s0: Apunta al pixel actual
    la s0, pixel0

bucle:

    #-- Dibujar pixel en posicion actual
    jal plot

    #-- Comprobar colision en eje x
    jal check_colision_x

    #-- Comprobar colision en eje y
    jal check_colision_y

    #-- Actualizar estado particula
    jal update

    #-- Esperar
    jal wait

    #-- Repetir
    j bucle

    li a0, EXIT
    ecall



#--------------------------------------------------------
#-- Comprobar la colision en el eje x
#-- Si hay colision se cambia el signo de la velocidad
#--------------------------------------------------------
check_colision_x:
    #-- Comprobar colisiones en x. Lo que se hace es
    #-- cambiar el valor de las velocidades en funcion
    #-- de la posicion y la velocidad actual
    #-- Leer posicion x actual
    lw t0, X(s0)
    #-- Leer velocidad x actual
    lw t1, VX(s0)

    #-- Caso 1: Movimiento positivo. Si la posicion siguiente
    #-- futura sale fuera de los limites, cambiar el signo de
    #-- la velocidad
    #-- Calcular siguiente position futura
    add t2, t0, t1

    #-- Si posicion futura es mayor que el limite x,
    #-- hay rebote en x...
    li t3, MAX_X
    bgt t2, t3, bounce_x

    #-- No hay rebote por la derecha
    #-- Comprobar siguiente caso

    #-- Caso 2: Movimiento negativo. Si la posicion siguiente
    #-- es menor a 0, cambiar signo de la velocidad
    li t3, MIN_X
    blt t2, t3, bounce_x

    #-- Continuar
    j 1f

bounce_x:
    #-- Cambiar la velocidad x de signo
    neg t1, t1

    #-- Almacenar nueva velocidad
    sw t1, VX(s0)

1:
    ret


#--------------------------------------------------------
#-- Comprobar la colision en el eje y
#-- Si hay colision se cambia el signo de la velocidad
#--------------------------------------------------------
check_colision_y:
    #-- Comprobar colisiones en y. Lo que se hace es
    #-- cambiar el valor de las velocidades en funcion
    #-- de la posicion y la velocidad actual
    #-- Leer posicion y actual
    lw t0, Y(s0)
    #-- Leer velocidad y actual
    lw t1, VY(s0)

    #-- Caso 1: Movimiento positivo. Si la posicion siguiente
    #-- futura sale fuera de los limites, cambiar el signo de
    #-- la velocidad
    #-- Calcular siguiente position futura
    add t2, t0, t1

    #-- Si posicion futura es mayor que el limite y,
    #-- hay rebote en x...
    li t3, MAX_Y
    bgt t2, t3, bounce_y

    #-- No hay rebote por la derecha
    #-- Comprobar siguiente caso

    #-- Caso 2: Movimiento negativo. Si la posicion siguiente
    #-- es menor a 0, cambiar signo de la velocidad
    li t3, MIN_Y
    blt t2, t3, bounce_y

    #-- Continuar
    j 1f

bounce_y:
    #-- Cambiar la velocidad x de signo
    neg t1, t1

    #-- Almacenar nueva velocidad
    sw t1, VY(s0)

1:
    ret


#-------------------------------------------
#-- Actualizar el estado de la particula
#-- Se un tic de simulacion
#-- VARIABLES GLOBALES:
#--   s0: Puntero a la estructura del pixel
#-------------------------------------------
update:

    #-- Almacenar la posicion y actual
    #-- (para recordarla)
    #-- Al dibujar un pixel se borra el anterior, si esta
    #-- estaba en una fila diferente
    lw t0, Y(s0)
    sw t0, OLD_Y(s0)

    #----------- Actualizar la coordenada x
    lw t0, X(s0)  #-- Leer posicion x
    lw t1, VX(s0) #-- Leer velocidad en x

    #-- Calcular nueva posicion: x = x + vx
    add t0, t0, t1

    #-- Almacenar nueva posicion x
    sw t0, X(s0)

    #----------- Actualizar la coordenada y
    lw t0, Y(s0)  #-- Leer posicion y
    lw t1, VY(s0) #-- Leer velocidad en y

    #-- Calcular nueva posicion: y = y + vy
    add t0, t0, t1

    #-- Almacenar nueva posicion y
    sw t0, Y(s0)    

    ret

#-------------------------------------------
#-- Dibujar el pixel en su posicon actual
#-- VARIABLES GLOBALES:
#--   s0: Puntero a la estructura del pixel
#-------------------------------------------
plot:

    #-- Leer coordenada x
    lw t0, X(s0)

    li t1, 0x8000  #-- Posicion 0

    #-- Desplazar hacia la derecha t0 posiciones
    #-- para obtener el valor a escribir en la matriz
    srl t1, t1, t0

    #-- Obtener la posicion y
    lw a1, Y(s0)

    #-- Obtener linea con pixel en x
    mv a2, t1

    #-- Pintar la linea!
    li a0, MATRIX_WRITE
    ecall

    #-- Borrar el pixel anterior, si es que estaba
    #-- en una linea diferente

    #-- Leer 'y' actual
    lw t0, Y(s0)

    #-- Leer 'y' anterior
    lw t1, OLD_Y(s0)

    #-- Si son iguales, terminamos
    beq t0, t1, plot_end

    #-- Son diferentes, hay que borrar la enterior
    mv a1, t1  #-- y = yold
    li a2, 0   #-- x: Todos los pixeles a 0
    li a0, MATRIX_WRITE
    ecall

plot_end:
    ret


wait:
    li t0, 0x40
1:
    beq t0, zero, 2f
    nop
    addi t0,t0,-1
    j 1b

2:
    ret