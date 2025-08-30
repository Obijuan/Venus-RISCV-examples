#-------------------------------------------------------------------------
#-- Particulas con aceleracion
#-- Todos los parametros estan definidos en un mundo virtual de 256x256
#-- Este mundo se mapea a la pantalla de 16x12 pixeles
#-- Se usa la técnica de subpixel
#-------------------------------------------------------------------------

    #-- Servicios del sistema operativo
    .equ EXIT         10    #-- Terminar el programa
    .equ MATRIX_WRITE 0x110 #-- Escribir en la matriz de leds
    .equ WRITE_7SEG   0x120 #-- Escribir en el display de 7 segmentos 
    .equ SET_LEDs     0x121 #-- Encender LEDs
    .equ READ_BUTTONS 0x122 #-- Leer botones

    #-- Mascara de acceso a los botones
    .equ BUTTON_MASK  0x03
    .equ BUTTON_0     0x01
    .equ BUTTON_1     0x02

    #-- Limites del mundo virtual
    .equ WX_MAX 255
    .equ WX_MIN 0
    .equ WY_MAX 255
    .equ WY_MIN 0

    #-- Limites de la pantalla virtual
    .equ MAX_X  15  #-- maxima posicion en X
    .equ MIN_X   0  #-- Minima posicion en X
    .equ MAX_Y  11  #-- maxima posicion en Y
    .equ MIN_Y   0  #-- Minima posicion en Y

    .data
#-------------------------
#-- Memoria de pantalla 
#-- (Pantalla virtual)  
#-------------------------
screen:
    .word 0x0000   #-- Fila 0
    .word 0x0000   #-- Fila 1
    .word 0x0000   #-- Fila 2
    .word 0x0000   #-- Fila 3
    .word 0x0000   #-- Fila 4
    .word 0x0000   #-- Fila 5
    .word 0x0000   #-- Fila 6
    .word 0x0000   #-- Fila 7
    .word 0x0000   #-- Fila 8
    .word 0x0000   #-- Fila 9
    .word 0x0000   #-- Fila 10
    .word 0x0000   #-- Fila 11

.data

#-----------------------------------
#-- Estructura de datos de la bola 
#-----------------------------------
#-- Constantes de acceso a los campos de la bola
.equ X  0
.equ Y  0x4
.equ VX 0x8
.equ VY 0xC
.equ AX 0x10
.equ AY 0x14
ball0:
    .word 0  #-- Coordenada x
    .word 0  #-- Coordenada y
    .word 0  #-- Velocidad en x
    .word 0  #-- Velocidad en y
    .word 0  #-- Aceleracion en x
    .word 0  #-- Aceleracion en y

    ##-- TODO
ball1:
    .word 0  #-- Coordenada x
    .word 0x10  #-- Coordenada y
    .word 11  #-- Velocidad en x
    .word 0  #-- Velocidad en y

ball2:
    .word 0  #-- Coordenada x
    .word 0x20  #-- Coordenada y
    .word 12  #-- Velocidad en x
    .word 0  #-- Velocidad en y

ball3:
    .word 0  #-- Coordenada x
    .word 0x30  #-- Coordenada y
    .word 13  #-- Velocidad en x
    .word 0  #-- Velocidad en y

#--- Tabla de punteros a las bolas a animar
tabla_bolas:
    .word ball0
    # .word ball1
    # .word ball2
    # .word ball3
    .word 0

    .text

    #-- Puntero a la tabla de bolas
    la s0, tabla_bolas

bucle:
    #-- Borrar pantalla virtual
    li a0, 0x0000
    jal screen_fill

    #-- Simular todas las bolas
    mv a0, s0
    jal sim_all

    #-- Refrescar pantalla
    jal screen_refresh

    #-- Esperar
    #jal wait

    #-------- Comprobar el boton 0
    #-- Leer botones
    li a0, READ_BUTTONS
    ecall

    #-- Aislar el boton 0
    andi t0, a0, BUTTON_0

    #------- Si Boton 0 NO apretado, repetir
    li t1, 1
    bne t0, t1, bucle

    #--- Boton apretado: asignar gravedad y vel ini!
    la t0, ball0
    li t1, -1
    sw t1, AY(t0) 

    li t1, 16
    sw t1, VY(t0)

    li t1, 7
    sw t1, VX(t0)

    sw zero, X(t0)

    j bucle

#------------------------------------------------------
#-- Simular una tabla completa de bolas
#-- ENTRADAS:
#--   a0: Puntero a la tabla de bolas
#------------------------------------------------------
sim_all:
    #-- Crear pila y guardar direccion de retorno
    addi sp, sp, -16
    sw ra, 12(sp)

    #-- Guardar registros estaticos
    sw s0, 0(sp)
    sw s1, 4(sp)

    #-- s0: Direccion de la tabla
    mv s0, a0

2:

    #-- Leer puntero a la bola actual
    lw s1, 0(s0)

    #-- Si es NULL, hemos terminado
    beq s1, zero, 1f

    #-- Simular la bola actual
    mv a0, s1
    jal ball_sim

    #-- Apuntar a la siguiente bola de la tabla
    addi s0,s0,4

    #-- Siguiente bola
    j 2b

    #-- Terminar
1:
    #-- Recuperar registros estaticos
    lw s0, 0(sp)
    lw s1, 4(sp)

    #-- Recuperar direccion de retorno y reponer la pila
    lw ra, 12(sp)
    addi sp, sp, 16
    ret

#-------------------------------------------------------
#-- Simular la bola indicada
#-- Se realizan todos los calculos y se dibuja la bola
#-- en la pantalla virtual
#-- ENTRADA:
#--   a0: Puntero a la bola a simular
#-------------------------------------------------------
ball_sim:
    #-- Crear pila y guardar direccion de retorno
    addi sp, sp, -16
    sw ra, 12(sp)

    #-- Guardar registros estaticos
    sw s0, 0(sp)

    #-- s0: Puntero a la bola
    mv s0, a0

    #-- Condicion de detencion: Si se alcanza la posicion x=0,
    #-- con una velocidad negativa, detener todo!
    #-- Detener todo significa hacer vx=0, ax=0
    mv a0, s0
    lw t0, X(a0)  #-- Leer la posicion x
    lw t1, VX(a0) #-- Leer la velocidad x

    #-- Si x<=0 & vx<0, --> x=0, vx=0, ax=0
    bgt t0, zero, 1f  #-- si x>0, seguir...
    bge t1, zero, 1f  #-- si vx>=0, seguir...
    
    #-- Detener la Bola!
    #-- x=0, vx=0, ax=0
    sw zero, X(a0)
    sw zero, VX(a0)
    sw zero, AX(a0)

1:

    #-- Condicion de detencion en eje y
    mv a0, s0
    lw t0, Y(a0)  #-- Leer la posicion y
    lw t1, VY(a0) #-- Leer la velocidad y

    #-- Si y<=0 & vy<0, --> y=0, vy=0, ay=0
    bgt t0, zero, 2f  #-- si y>0, seguir...
    bge t1, zero, 2f  #-- si vy>=0, seguir...
    
    #-- Detener la Bola!
    #-- y=0, vy=0, ay=0
    sw zero, Y(a0)
    sw zero, VY(a0)
    sw zero, AY(a0)

    #-- Detencion en y implica detencion en x en este ejemplo
    sw zero, VX(a0)
    sw zero, AX(a0)

2:

    #-- Comprobar colision en eje x
    #mv a0, s0
    #jal check_colision_x

    #-- Comprobar colision en eje y
    #mv a0, s0
    #jal check_colision_y

    #-- Dibujar la bola actual
    mv a0, s0
    jal ball_draw

    #-- Actualizar estado bola
    mv a0, s0
    jal ball_update

    #-- Recuperar registros estaticos
    lw s0, 0(sp)

    #-- Recuperar direccion de retorno y reponer la pila
    lw ra, 12(sp)
    addi sp, sp, 16
    ret


#--------------------------------------------------------
#-- Comprobar la colision en el eje y
#-- Si hay colision se cambia el signo de la velocidad
#-- ENTRADA:
#--   a0: Puntero a bola a dibujar
#--------------------------------------------------------
check_colision_y:
    #-- Comprobar colisiones en y. Lo que se hace es
    #-- cambiar el valor de las velocidades en funcion
    #-- de la posicion y la velocidad actual
    #-- Leer posicion y actual
    lw t0, Y(a0)
    #-- Leer velocidad y actual
    lw t1, VY(a0)

    #-- Caso 1: Movimiento positivo. Si la posicion siguiente
    #-- futura sale fuera de los limites, cambiar el signo de
    #-- la velocidad
    #-- Calcular siguiente position futura
    add t2, t0, t1

    #-- Si posicion futura es mayor que el limite y,
    #-- hay rebote
    li t3, WY_MIN
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
    sw t1, VY(a0)

1:
    ret


#--------------------------------------------------------
#-- Comprobar la colision en el eje x
#-- Si hay colision se cambia el signo de la velocidad
#-- ENTRADA:
#--   a0: Puntero a bola a dibujar
#--------------------------------------------------------
check_colision_x:
    #-- Comprobar colisiones en x. Lo que se hace es
    #-- cambiar el valor de las velocidades en funcion
    #-- de la posicion y la velocidad actual
    #-- Leer posicion x actual
    lw t0, X(a0)
    #-- Leer velocidad x actual
    lw t1, VX(a0)

    #-- Caso 1: Movimiento positivo. Si la posicion siguiente
    #-- futura sale fuera de los limites, cambiar el signo de
    #-- la velocidad
    #-- Calcular siguiente position futura
    add t2, t0, t1

    #-- Si posicion futura es mayor que el limite x,
    #-- hay rebote en x...
    li t3, WX_MAX
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
    sw t1, VX(a0)

1:
    ret



#---------------------------------------------
#-- Dibujar la bola actual
#-- ENTRADA:
#--   a0: Puntero a bola a dibujar
#---------------------------------------------
ball_draw:
    #-- Crear pila y guardar direccion de retorno
    addi sp, sp, -16
    sw ra, 12(sp)

    #-- Guadar la direccion de la bola en t0
    mv t0, a0

    #-- Leer coordenadas x, y de la bola
    lw a0, X(t0)  #-- Posicion x
    lw a1, Y(t0)  #-- Posicion y

    #-- MAPEAR las coordenadas del mundo virtual en 
    #-- la pantalla virtual de 16x12
    #-- Tecnica de subpixel:
    #-- Nos quedamos solo con los 4 bits de mayor peso, los de
    #-- menor peso los despreciamos
    andi a0, a0, 0xFF  #-- Recortar posicion a 8 bits
    srli a0, a0, 4     #-- Quedarse con los 4 bits de mayor peso

    #-- Repetimos para posicion y
    andi a1, a1, 0xFF
    srli a1, a1, 4

    #-- Dibujar la bola en la pantalla virtual
    jal screen_plot

    #-- Recuperar direccion de retorno y reponer la pila
    lw ra, 12(sp)
    addi sp, sp, 16
    ret

#-------------------------------------------
#-- Actualizar el estado de la bola
#-- Se un tic de simulacion
#-- ENTRADA:
#--   a0: Puntero a la bola
#-------------------------------------------
ball_update:

    #----------- Actualizar la coordenada x
    lw t0, X(a0)  #-- Leer posicion x
    lw t1, VX(a0) #-- Leer velocidad en x

    #-- Calcular nueva posicion: x = x + vx
    add t0, t0, t1

    #-- Almacenar nueva posicion x
    sw t0, X(a0)

    #---------- Actualizar la velocidad x
    lw t0, VX(a0)  #-- Leer vx
    lw t1, AX(a0)  #-- Leer ax

    #-- Calcular la nueva velocidad: vx = vx + ax
    add t0, t0, t1

    #-- Almacenar nueva velocidad x
    sw t0, VX(a0)

    #----------- Actualizar la coordenada y
    lw t0, Y(a0)  #-- Leer posicion y
    lw t1, VY(a0) #-- Leer velocidad en y

    #-- Calcular nueva posicion: y = y + vy
    add t0, t0, t1

    #-- Almacenar nueva posicion y
    sw t0, Y(a0)    

    #---------- Actualizar la velocidad y
    lw t0, VY(a0)  #-- Leer vy
    lw t1, AY(a0)  #-- Leer ay

    #-- Calcular la nueva velocidad: vy = vy + ay
    add t0, t0, t1

    #-- Almacenar nueva velocidad y
    sw t0, VY(a0)

    ret

#---------------------------------------------
#-- Dibujar una linea horizontal completa, de
#-- extremo a extremo
#-- a0: Coordena 'y' donde poner la linea
#---------------------------------------------
lineah_all:
    #-- Crear pila y guardar direccion de retorno
    addi sp, sp, -16
    sw ra, 12(sp)

    #-- Guardar registros estaticos
    sw s0, 0(sp)
    sw s1, 4(sp)

    li s0, 0   #-- contador x
    mv s1, a0  #-- contador y 

1:
    #-- plot(x,y)
    mv a0, s0
    mv a1, s1
    jal screen_plot

    #-- Incrementar coordenada x
    addi s0, s0, 1

    #-- Si no se ha llegado al limite, seguimos ploteando
    li t0, MAX_X
    ble s0, t0, 1b

    #-- Recuperar registros estaticos
    lw s0, 0(sp)
    lw s1, 4(sp)

    #-- Recuperar direccion de retorno y reponer la pila
    lw ra, 12(sp)
    addi sp, sp, 16
    ret


#----------------------------------------------
#-- Dibujar un punto en las coordenadas x,y
#-- ENTRADAS:
#--   a0: Coordenada x
#--   a1: Coordenada y
#----------------------------------------------
screen_plot:

    #-- Calcular la direccion de memoria correspondiente
    #-- addr = base + y * 4
    la t1, screen

    #-- Multiplicar por 4 la coordenada y, para que sea
    #-- direccion de palabra
    slli a1, a1, 2

    add t2, t1, a1  #-- t2 = base + 4*y

    #-- Contenido de una fila
    li t0, 0x8000

    #-- Calcular la coordenada x
    #-- Rotar el contenido x bits a la derecha
    srl t0, t0, a0

    #-- Leer contenido de la fila actual
    lw t3, 0(t2)

    #-- Fisionar el pixel nuevo con lo que habia antes
    #-- en la memoria
    or t0, t0, t3

    #-- Escribir el nuevo valor de la fila en la pantalla virtual
    sw t0, 0(t2)
    ret


#-------------------------------------------------
#-- Borrar la pantalla fisica
#-- Se borra la pantalla virtual y se refresca
#-------------------------------------------------
cls:
    #-- Funcion intermedia
    #-- Crear pila para guardar direccion de retorno
    addi sp, sp, -16
    sw ra, 12(sp)

    #-- Borrar pantalla virtual
    li a0, 0x0
    jal screen_fill

    #-- Refrescar pantalla fisica
    jal screen_refresh

    #-- Recuperar direccion de retorno
    #-- y restaurar la pila
    lw ra, 12(sp)
    addi sp, sp, 16
    ret

#-------------------------------------------------
#-- Rellenar la pantalla virtual con un patron
#-- ENTRADAS:
#--   a0: Patro a usar para el rellenado
#-------------------------------------------------
screen_fill:
    #-- Contador de lineas
    li t0, 0

    #-- Obtener direccion de la memoria virtual
    la t1, screen

    #-- Bucle
1:
    #-- Escribir patron en linea actual
    sw a0, 0(t1)

    #-- Incrementar linea
    addi t0, t0, 1

    #-- Incrementar puntero de memoria
    addi t1, t1, 4

    #-- Si no se ha alcanzado el limite superior,
    #-- se continua
    li t2, MAX_Y
    ble t0, t2, 1b 

    #-- Terminar
    ret

#----------------------------------------------
#-- Copiar en la pantalla virtual una region
#-- de memoria de su mismo tamaño
#-- ENTRADA:
#--   a0: Direccion de memoria de los datos a volcar
#----------------------------------------------
screen_copy:
    #-- t0: Contador de lineas (linea actual)
    li t0, 0

    mv t1, a0      #-- t1: Puntero fuente (lectura)
    la t2, screen  #-- t2: Puntero destino (escritura)

    #-- En destino se escribe de direcciones altas a bajas
    addi t2,t2, 44

1:
    #-- Leer palabra fuente
    lw t3, 0(t1)

    #-- Escribir en destino
    sw t3, 0(t2)

    #-- Incrementar contador
    addi t0,t0, 1

    #-- actualizar punteros de memoria
    addi t1, t1, 4
    addi t2, t2, -4

    #-- Si no se ha alcanzado el limite superior,
    #-- se continua
    li t4, MAX_Y
    ble t0, t4, 1b 

    ret

#-------------------------------------------------
#-- Refrescar la pantalla fisica a partir de la
#-- pantalla virtual
#-------------------------------------------------
screen_refresh:

    #-- Obtener la direccion de la memoria de video
    la t3, screen

    #-- Fila actual
    li t0, 0

    #-- Bucle principal
1:
    #------- Volcar la pantalla virtual actual a la fisica
    #-- Leer valor de la fila actual
    lw t1, 0(t3)

    #-- Escribir la fila en la pantalla real
    mv a1, t0

    #-- Valor de la linea actual
    mv a2, t1

    #-- Pintar la linea!
    li a0, MATRIX_WRITE
    ecall

    #-- Incrementar contador
    addi t0,t0, 1

    #-- Incrementar puntero de memoria
    addi t3, t3, 4

    #-- Si no se ha alcanzado el limite superior,
    #-- se continua
    li t2, MAX_Y
    ble t0, t2, 1b 

    #-- Limite superior alcanzado
    #-- Terminar!

    ret


#-------------------------------------
#-- Esperar
#-------------------------------------s
wait:
    li t0, 0x1
1:
    beq t0, zero, 2f
    nop
    addi t0,t0,-1
    j 1b

2:
    ret