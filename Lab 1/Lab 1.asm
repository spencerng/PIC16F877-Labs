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
	CLRF ANSEL ; digital I/O
	BANKSEL PORTA
	BSF PORTB, LED_BIT ; turn LED on
	
switchOff:
	BTFSS PORTA, BUTTON_BIT
	GOTO switchOff

toggle:
	COMF PORTB

waitForSwitchOff:
	BTFSC PORTA, BUTTON_BIT
	GOTO waitForSwitchOff
	GOTO switchOff
    
_end: 
    END