; Write an MPASM program for the PIC16F887 microcontroller 
; that will toggle an LED when pressing a push button using a polling scheme.

; Spencer Ng and Hannah Daniel
; 5/16/17
    

MAIN_PROG CODE

START

#include <p16f887.inc>
 
LED_BIT EQU 0
BUTTON_BIT EQU 1
 
 
reset:
    ORG 0x0000
    GOTO setup

setup:
    BSF TRISB, BUTTON_BIT ; 1 is input
	BANKSEL TRISB
	BCF TRISB, LED_BIT ; 0 is output
	BANKSEL ANSEL
	CLRF ANSEL ; digital I/O
	BANKSEL PORTA
	BSF PORTB, LED_BIT ; turn LED on
	
switchOff:
	MOVF PORTB																																																									
	BTFSS PORTB, BUTTON_BIT
	GOTO switchOff

toggle:
	COMF PORTB

waitForSwitchOff:
	MOVF PORTB
	BTFSC PORTB, BUTTON_BIT
	GOTO waitForSwitchOff
	GOTO switchOff
    
_end: 
    END