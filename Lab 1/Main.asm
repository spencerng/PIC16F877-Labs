; Write an MPASM program for the PIC16F887 microcontroller 
; that will toggle an LED when pressing a push button using a polling scheme.
    

    
MAIN_PROG CODE

START

#include <p16f887.inc>
 
LED_BIT EQU 1
BUTTON_BIT EQU 0
prevState EQU 0x020 ; previous state of PORTA
currentState EQU 0x021 ; temp current state of push button, 0 or 1
ledState EQU 0x022 ; 0=off, 1=on
 
 
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
    BSF TRISA, BUTTON_BIT ; 1 is input
    BCF TRISA, LED_BIT ; 0 is output
    BANKSEL ANSEL
    CLRF ANSEL ; digital I/O
    MOVLW 0x00
    MOVWF prevState
    MOVWF ledState
    
main:
    BANKSEL PORTA
    MOVF PORTA, 0
    MOVWF currentState
    SUBWF prevState, 0
    BANKSEL STATUS
    BTFSS STATUS, Z ; checks for no change
    GOTO checkChange ; result of subtraction is not 0, input changed
    GOTO store ; result of subtraction is 1, input unchanged
    
checkChange:
    BTFSC currentState, BUTTON_BIT ; skip if button went 1 to 0
    COMF ledState ; executes when button went from 0 to 1
    BTFSS ledState, 0 ; skip if LED state is 1
    GOTO ledOff
    GOTO ledOn
    
ledOn:
    BSF currentState, LED_BIT
    GOTO store

ledOff:
    BCF currentState, LED_BIT
    GOTO store
    
store:
    MOVF currentState, 0
    BANKSEL PORTA
    MOVWF PORTA
    MOVWF prevState
    GOTO main
    
isr:
    NOP
    BCF INTCON, 0
    BCF INTCON, 1
    RETFIE
    
_end: 
    END