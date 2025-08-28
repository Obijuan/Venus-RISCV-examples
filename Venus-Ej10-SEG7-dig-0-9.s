#---------------------------------------------------
# Imprimir un numero en el display derecho
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

.text

    #-- Imprimir un digito
    li a1, DIG9  #-- Valor a escribir
    li a2, 0xFF  #-- Indicar segmentos a modificar
    li a0, WRITE_7SEG
    ecall
    
    #-- Terminar
    li a0, EXIT
    ecall
