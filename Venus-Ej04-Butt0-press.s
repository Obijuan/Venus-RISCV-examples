#---------------------------------------------------
# Ejemplo de lectura del boton 0
# Al apretar el botón 0 se enciende el led verde y
# se termina el programa
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

bucle:
    #-- Leer botones
    li a0, READ_BUTTONS
    ecall

    #-- Aislar los dos bits de los botones
    andi a0, a0, BUTTON_MASK

    #-- Leer boton 0
    andi t0, a0, BUTTON_0

    #------- Boton 0 apretado?

    #-- No apretado, seguir leyendo
    beqz t0, bucle

    #-- Botón 0 apretado
    #-- Encender led verde
    li a1, LED_GREEN_ON
    li a0, SET_LEDs
    ecall

    #-- Terminar el programa
    li a0, EXIT
    ecall

