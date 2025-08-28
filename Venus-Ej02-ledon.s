#---------------------------------------------------
# Encender el LED verde y terminar
#---------------------------------------------------

#-- Servicios del sistema operativo
.equ EXIT 10       #-- Terminar el programa
.equ SET_LED 0x121 #-- Encender LEDs

#-- Mascaras de acceso a los LEDs
.equ LED_GREEN_ON 0x01
.equ LEDS_OFF     0x00

.text

    #-- Apagar todos los LEDs
    li a1, LEDS_OFF
    li a0, SET_LED
    ecall

    #-- Encender el LED verde
    li a1, LED_GREEN_ON
    li a0, SET_LED
    ecall

    #-- Terminar el programa
    li a0, EXIT
    ecall

