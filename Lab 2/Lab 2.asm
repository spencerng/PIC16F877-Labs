;Write an MPASM program for the PIC microcontroller that controls 
;three LEDs located on PORTA. Each LED represents the comparison 
;result of two numbers provided via port B.
;LED Status:
;RA0: A < B
;RA1: A = B
;RA2: A > B
; A on B7:B4, B on B3:B0

MAIN_PROG CODE

START

#include "p16f887.inc"

; CONFIG1
; __config 0xFFF1
 __CONFIG _CONFIG1, _FOSC_XT & _WDTE_OFF & _PWRTE_OFF & _MCLRE_ON & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_ON
; CONFIG2
; __config 0xFFFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF


LEDS EQU PORTB
SWITCH_BIT EQU 0

reset:
    ORG 0x0000
    GOTO setup

int:
    ORG 0x004
    GOTO isr

setup:
    BANKSEL PORTA
    CLRF PORTA
    BANKSEL TRISA
    BSF TRISA, SWITCH_BIT ; 1 is input
    BANKSEL ANSEL
    CLRF ANSEL ; digital I/O
    BANKSEL TRISB
    CLRF TRISB ; all LED outputs
    MOVLW b'100000'
    BANKSEL PORTB
    MOVWF PORTB

main:
    BANKSEL PORTA
    BTFSS PORTA, SWITCH_BIT 
    GOTO rotateLeft ; switch=0, right to left
    GOTO rotateRight ; switch=1, left to right

rotateLeft:
    BANKSEL PORTB
    RLF PORTB
    GOTO main
    
rotateRight:
    BANKSEL PORTB
    RRF PORTB
    GOTO main

isr:
    NOP
    BCF INTCON, 0
    BCF INTCON, 1
    RETFIE

_end:
    END
