; Write an MPASM program for the PIC16F887 microcontroller 
; that will toggle an LED when pressing a push button using a polling scheme.
    

    
MAIN_PROG CODE

START

#include <p16f887.inc>
 
LED_BIT EQU 0
BUTTON_BIT EQU 0
prevState EQU 0x020 ; previous state of PORTA
currentState EQU 0x021 ; temp current state of push button, 0 or 1
ledState EQU 0x022 ; 0=off, 1=on
 
 
reset:
    ORG 0x0000
    GOTO setup


setup:
    BANKSEL PORTA
	CLRF PORTA
	BANKSEL TRISA
    BSF TRISA, BUTTON_BIT ; 1 is input
	BANKSEL TRISB
	BCF TRISB, LED_BIT ; 0 is output
	BANKSEL ANSEL
	CLRF ANSEL
	BANKSEL PORTA
	BSF PORTB, LED_BIT
	MOVLW 0
	MOVWF prevState
	

    
main:
	MOVLW PORTA
	MOVWF currentState
	XORWF prevState, 0
	XORWF PORTB
	MOVLW currentState
	MOVWF prevState
	GOTO main

ledOn:
	BSF PORTB, LED_BIT
	GOTO main

ledOff:
	BCF PORTB, LED_BIT
	GOTO main

    
_end: 
    END