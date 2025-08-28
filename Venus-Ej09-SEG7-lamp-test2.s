#---------------------------------------------------
# Prueba de los 7 segmentos: LAMP-TEST
# Con el boton 1 se hace un lamp-test
# Con el boton 0 se apagan
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


.text

    #-- Por defecto hacer un lamp-test
    j boton1_apretado

bucle:
    #-- Leer botones
    li a0, READ_BUTTONS
    ecall

    #-- Aislar los dos bits de los botones
    andi t0, a0, BUTTON_MASK

    #------- Boton 0 apretado
    li t1, 1
    beq t0, t1, boton0_apretado

    #-- Boton 1 apretado
    li t1, 2
    beq t0, t1, boton1_apretado

    #-- Repetir
    j bucle

boton0_apretado:
    #-- Apagar todos los segmentos
    li a2, 0x00  #-- Indicar segmentos a modificar
    li a0, WRITE_7SEG
    ecall
    j bucle

boton1_apretado:
    #-- LAMP-TEST: Encender todos los segmentos
    li a1, 0xFFFF  #-- Valor a escribir
    li a2, 0xFFFF  #-- Indicar segmentos a modificar
    li a0, WRITE_7SEG
    ecall
    j bucle
    


