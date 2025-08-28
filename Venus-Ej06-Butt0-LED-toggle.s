#---------------------------------------------------
# Se utiliza el botón 0 para cambiar el estado
# del LED VERDE (ON/OFF).
#---------------------------------------------------

#-- Servicios del sistema operativo
.equ EXIT         10    #-- Terminar el programa
.equ SET_LEDs     0x121 #-- Encender LEDs
.equ READ_BUTTONS 0x122 #-- Leer botones

#-- Mascaras de acceso a los LEDs
.equ LED_GREEN_ON 0x01
.equ LED_RED_ON   0x02
.equ LEDS_OFF     0x00
.equ LEDS_MASK    0x03

#-- Mascara de acceso a los botones
.equ BUTTON_MASK  0x03
.equ BUTTON_0     0x01
.equ BUTTON_1     0x02

.text

    #-- Apagar todos los LEDs
    li a1, LEDS_OFF
    li a0, SET_LEDs
    ecall

    #-- Se usa el registro t2 para el estado del LED
    li t2, 0  #-- Por defecto apagado

bucle:
    #-- Leer botones
    li a0, READ_BUTTONS
    ecall

    #-- Aislar el boton 0
    andi t0, a0, BUTTON_0

    #------- Boton 0 apretado
    li t1, 1
    beq t0, t1, boton0_apretado

    #-- Repetir
    j bucle

boton0_apretado:

    #-- Cambiar el estado guardadao del LED
    xori t2, t2, 1

    #-- Actualizar los LEDS
    mv a1, t2
    li a0, SET_LEDs
    ecall
    j bucle




