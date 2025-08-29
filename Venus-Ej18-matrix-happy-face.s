#-------------------------------------------------
#-- Pruebas con la matriz de LEDs
#--
#-- Problema: La matriz se actualiza fila a fila
#-- Al escribir un nuevo valor se pierde el anterior
#-- Esto hace que por ejemplo si queremos hacer un plot(x,y)
#-- Si es dentro de la misma fila, se borra lo anterior
#-- Se necesita otro enfoque:
#--
#--  PANTALLA VIRTUAL EN MEOMRIA
#--  Vamos a crear una pantalla virtual en la memoria
#--  El plot se hace en esta pantalla, y luego se vuelca a la
#--  pantalla real
#---------------------------------------------------------

    #-- Servicios del sistema operativo
    .equ EXIT         10    #-- Terminar el programa
    .equ MATRIX_WRITE 0x110 #-- Escribir en la matriz de leds
    .equ WRITE_7SEG   0x120 #-- Escribir en el display de 7 segmentos 
    .equ SET_LEDs     0x121 #-- Encender LEDs
    .equ READ_BUTTONS 0x122 #-- Leer botones

    #-- Limites de la zona visual
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

#----------------------------------------
#-- Pantrones de test para la pantalla
#----------------------------------------
happy_face:
    .word 0b1111111111111111
    .word 0b1000000000000001
    .word 0b1000000000000001
    .word 0b1001110000111001
    .word 0b1001010000101001
    .word 0b1001110000111001
    .word 0b1000000000000001
    .word 0b1000000000000001
    .word 0b1000100000010001
    .word 0b1000011111100001
    .word 0b1000000000000001
    .word 0b1111111111111111

happy_blinky:
    .word 0b1111111111111111
    .word 0b1000000000000001
    .word 0b1000000000000001
    .word 0b1001110000000001
    .word 0b1001010000111001
    .word 0b1001110000000001
    .word 0b1000000000000001
    .word 0b1000000000000001
    .word 0b1000100000010001
    .word 0b1000011111100001
    .word 0b1000000000000001
    .word 0b1111111111111111


    .text

    #-- Borrar la pantalla
    jal cls

    jal wait

    #--- Rellenar la pantalla virtual con un valor constante
    li a0, 0xAAAA  #-- Valor de relleno
    jal screen_fill
    jal screen_refresh

    jal wait

    li a0, 0xFFFF  #-- Valor de relleno
    jal screen_fill
    jal screen_refresh

    jal wait

bucle:
    #-- Imprimir en la pantalla virtual
    la a0, happy_face
    jal screen_copy
    jal screen_refresh

    jal wait
    jal wait

    la a0, happy_blinky
    jal screen_copy
    jal screen_refresh

    jal wait

    j bucle

    jal wait

    #-- Terminar
    li a0, EXIT
    ecall


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
    li t0, 0x200
1:
    beq t0, zero, 2f
    nop
    addi t0,t0,-1
    j 1b

2:
    ret