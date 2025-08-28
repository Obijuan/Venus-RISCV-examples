#---------------------------------------------------
# Contador en los LEDs (Rojo y verde)
#---------------------------------------------------

#-- Servicios del sistema operativo
.equ EXIT 10       #-- Terminar el programa
.equ SET_LEDs 0x121 #-- Encender LEDs

#-- Mascaras de acceso a los LEDs
.equ LED_GREEN_ON 0x01
.equ LED_RED_ON   0x02
.equ LEDS_OFF     0x00
.equ LEDS_MASK    0x03

.text

    #-- Inicializar contador
    li t0, 0

    #-- Bucle principal

bucle:
    #-- Mostrar el contador en los LEDs
    mv a1, t0
    li a0, SET_LEDs
    ecall

    #-- Incrementar el contador
    addi t0, t0, 1

    #-- Aislar los dos LEDs
    #-- Solo nos interesan los dos bits de menor peso
    andi t0, t0, LEDS_MASK

    #-- Repetir
    j bucle
  