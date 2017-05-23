;Write an MPASM program for the PIC microcontroller that
;controls 7 LEDs located to PORTD. The 7 LEDs are all OFF at
;power-up & upon reset. The 7 LEDs keep track of the number of
;button presses displaying the count in binary. Use Polling scheme.
    

MAIN_PROG CODE

START

#include <p16f887.inc>
#include "../Functions.inc"
 
BUTTON_BIT EQU 0
 
 
reset:
    ORG 0x0000
    GOTO setup

setup:
	BANKSEL TRISB
    BSF TRISB, BUTTON_BIT ; 1 is input
	BANKSEL TRISC
	CLRF TRISC ; all output for led
	BANKSEL PORTA
	CLRF PORTC
	
switchOff:
	MOVF PORTB											
	BTFSS PORTB, BUTTON_BIT
	GOTO switchOff

addOne:
	INCF PORTC

waitForSwitchOff:
	MOVF PORTB
	BTFSC PORTB, BUTTON_BIT
	GOTO waitForSwitchOff
	GOTO switchOff
    
_end: 
    END