#---------------------------------------------------
# Contador de 0 a 9 en el dígito derecho del display
#---------------------------------------------------

#-- Servicios del sistema operativo
.equ EXIT         10    #-- Terminar el programa
.equ WRITE_7SEG   0x120 #-- Escribir en el display de 7 segmentos 
.equ SET_LEDs     0x121 #-- Encender LEDs
.equ READ_BUTTONS 0x122 #-- Leer botones

#-- Mascaras de acceso a los LEDs
.equ LED_GREEN_ON 0x01
.equ LED_GREEN    0x01
.equ LED_RED_ON   0x02
.equ LED_RED      0x02
.equ LEDS_OFF     0x00
.equ LEDS_MASK    0x03

#-- Mascara de acceso a los botones
.equ BUTTON_MASK  0x03
.equ BUTTON_0     0x01
.equ BUTTON_1     0x02

#-- Digitos para el 7 segmentos derecho
.equ DIG0 0x3F
.equ DIG1 0x06
.equ DIG2 0x5B
.equ DIG3 0x4F
.equ DIG4 0x66
.equ DIG5 0x6D
.equ DIG6 0x7D
.equ DIG7 0x07
.equ DIG8 0x7F
.equ DIG9 0x67  

.data

#-- Tabla de conversion entre el digito y 
#-- los segmentos a activar para su visualizacion
table:
    .byte 0x3F  #-- Digito 0
    .byte 0x06  #-- Digito 1
    .byte 0x5B  #-- Digito 2
    .byte 0x4F  #-- Digito 3
    .byte 0x66  #-- Digito 4
    .byte 0x6D  #-- Digito 5
    .byte 0x7D  #-- Digito 6
    .byte 0x07  #-- Digito 7
    .byte 0x7F  #-- Digito 8
    .byte 0x67  #-- Digito 9

.text

    #--- t0: Puntero a la tabla de conversion
    la s0, table

    #-- t1: Digito a mostrar (Contador)
    li s1, 0

bucle:

    #-- Calcular la direccion de la tabla
    add t2, s1, s0

    #-- Mostrar el digito
    lb a1, 0(t2)
    li a2, 0xFF  #-- Indicar segmentos a modificar
    li a0, WRITE_7SEG
    ecall

    #-- Incrementar contador
    addi s1,s1, 1

    #-- Esperar a que se pulse el boton 0
    jal wait_butt0

    #-- Repetir mientras sea menor a 10
    li t3, 10
    blt s1, t3, bucle

    #-- Mostrar el digito
    li a1, DIG0
    li a2, 0xFF  #-- Indicar segmentos a modificar
    li a0, WRITE_7SEG
    ecall

    #-- Terminar
    li a0, EXIT
    ecall


wait_butt0:
    #-- Leer botones
    li a0, READ_BUTTONS
    ecall

    #-- Aislar el boton 0
    andi t0, a0, BUTTON_0

    #--- Si no está apretado, esperar
    li t1, 1
    beq t0, zero, wait_butt0

    ret
