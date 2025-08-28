#---------------------------------------------------
# Ejemplo de lectura de los botonones 0 y 1
# Con el botón 0 se enciende el LED verde
# Con el botón 1 se apaga el LED verde
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
    #-- Encender led verde
    li a1, LED_GREEN_ON
    li a0, SET_LEDs
    ecall
    j bucle

boton1_apretado:
    #-- Apagar led verde
    li a1, LEDS_OFF
    li a0, SET_LEDs
    ecall
    j bucle



