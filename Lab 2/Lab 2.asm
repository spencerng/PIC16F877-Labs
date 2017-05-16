;Write an MPASM program for the PIC 16F887 Microcontroller
;that will light 8 LEDs in a round robin fashion. Basically a ;Chaser Light.
;A switch determines the direction of the moving lights
;(1: Left to Right, 0: Right to Left).
;Use the delay loop generation technique to
;generate a one second delay.


MAIN_PROG CODE

START

#include <p16f887.inc>



LEDS EQU PORTB
SWITCH_BIT EQU 0
COUNT1 EQU 0x20
COUNT2 EQU 0x21
STATE EQU 0x22

reset:
    ORG 0x0000
    GOTO setup

int:
    ORG 0x004
    GOTO isr


MOVLF macro k, f
	MOVLW k
	MOVWF f
endm

MOVFF macro source, dest
	MOVF source, 0
	MOVWF dest
endm

setup:
	MOVLF b'10000000', 0x23
	MOVLF b'01000000', 0x24
	MOVLF b'00100000', 0x25
	MOVLF b'00010000', 0x26
	MOVLF b'00001000', 0x27
	MOVLF b'00000100', 0x28
	MOVLF b'00000010', 0x29
	MOVLF b'00000001', 0x2A
	MOVLF 0x23, STATE
    BANKSEL PORTA
    CLRF PORTA
    BANKSEL TRISA
    BSF TRISA, SWITCH_BIT ; 1 is input
    BANKSEL ANSEL
    CLRF ANSEL ; digital I/O
    BANKSEL TRISB
    CLRF TRISB ; all LED outputs
    BANKSEL PORTB

;overhead: 7-8 us
main:
	MOVF STATE, 0
	MOVWF FSR
	MOVF INDF, 0
	MOVWF PORTB
	CALL oneSecDelay
    BTFSS PORTA, SWITCH_BIT 
    GOTO rotateLeft ; switch=0, right to left
    GOTO rotateRight ; switch=1, left to right

rotateLeft:
	DECF STATE
	MOVF STATE, 0
	SUBLW 0x22
	MOVLW 0x2A
	BTFSC STATUS, Z
	MOVWF STATE
	GOTO main
    
rotateRight:
    INCF STATE
    MOVF STATE, 0
	SUBLW 0x2B
	MOVLW 0x23
	BTFSC STATUS, Z
	MOVWF STATE
    GOTO main
    
oneSecDelay:
	MOVLW d'4'
	MOVWF COUNT1
	innerLoop1:
		CALL twoFiftyMicroDelay
		DECFSZ COUNT1
		GOTO innerLoop1
	RETURN

;3 us overhead
twoFiftyMicroDelay:
	MOVLW d'41'
	MOVWF COUNT2
	innerLoop2: 
		NOP
		NOP
		NOP
		DECFSZ COUNT2
		GOTO innerLoop2
	RETURN
		

isr:
    NOP
    BCF INTCON, 0
    BCF INTCON, 1
    RETFIE

_end:
    END
