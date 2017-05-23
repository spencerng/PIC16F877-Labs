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

#include <p16f887.inc>
#include "../Functions.inc"

LESS EQU b'00000001'
EQUAL EQU b'00000010'
GREATER EQU b'00000100'
A_VAL EQU 0x20
B_VAL EQU 0x21

setup:
    BANKSEL PORTA
    CLRF PORTA
    BANKSEL TRISB
	MOVLF b'11111111', TRISB ; 1 is input
    BANKSEL TRISA
    CLRF TRISA ; all LED outputs
	BANKSEL ANSEL
    CLRF ANSEL ; digital I/O
	BANKSEL PORTA
    
main:
    MOVF PORTB
	MOVFF PORTB, B_VAL
	SWAPF PORTB, 0
	MOVWF A_VAL
	BCF A_VAL, 7
	BCF A_VAL, 6
	BCF A_VAL, 5
	BCF A_VAL, 4
	BCF B_VAL, 7
	BCF B_VAL, 6
	BCF B_VAL, 5
	BCF B_VAL, 4


checkEqual:
    MOVF A_VAL, 0
	SUBLW B_VAL
	BTFSC STATUS, Z
	GOTO isEqual

	
;does less than ie (101-111) always result in C=0?
;does greater than ie (111-101) always result in C=1?
checkGreater:
	MOVF B_VAL, 0
	SUBWF A_VAL ; A-B
	BTFSS STATUS, C 
	GOTO isLess
	GOTO isGreater 
    
isEqual:
	MOVLF EQUAL, PORTA
	GOTO main
	
isLess:
	MOVLF LESS, PORTA
	GOTO main
	
isGreater:
	MOVLF GREATER, PORTA
	GOTO main

_end:
	END