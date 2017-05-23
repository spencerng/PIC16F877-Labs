;Write an MPASM program for the PIC 16F887 Microcontroller
;that will light 8 LEDs in a round robin fashion. Basically a ;Chaser Light.
;A switch determines the direction of the moving lights
;(1: Left to Right, 0: Right to Left).
;Use the delay loop generation technique to
;generate a one second delay.

MAIN_PROG CODE

START

#include <p16f887.inc>

SWITCH_BIT EQU 0
COUNT1 EQU 0x20
COUNT2 EQU 0x21
COUNT3 EQU 0x30
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
    MOVLF 0x25, STATE
    BANKSEL TRISB
    BSF TRISB, SWITCH_BIT ; 1 is input
    BANKSEL TRISC
    CLRF TRISC ; all LED outputs
	BANKSEL ANSEL
    CLRF ANSEL ; digital I/O
    BANKSEL PORTA

;total overhead (incl. rotates but not delay): 17-23 us
;delay is actually 1.000036-1.000042 s 
main:
	MOVFF STATE, FSR
	MOVFF INDF, PORTC
	CALL oneSecDelay
	MOVF PORTB
    BTFSS PORTB, SWITCH_BIT 
    GOTO rotateLeft ; switch=0, right to left
    GOTO rotateRight ; switch=1, left to right

;overhead: 7-12 us
rotateLeft:
	DECF STATE
	MOVF STATE, 0
	SUBLW 0x22
	BTFSC STATUS, Z
	CALL lastState
	GOTO main
	
lastState:
	MOVLF 0x2A, STATE
	RETURN
	
rotateRight:
    INCF STATE
    MOVF STATE, 0
	SUBLW 0x2B
	BTFSC STATUS, Z
	CALL firstState
    GOTO main
	
firstState:
    MOVLF 0x23, STATE
	RETURN

;overhead: 3 us, tL = 250.004 ms
;actually 1.000019 s (incl. overhead)
oneSecDelay:
	MOVLF d'4', COUNT3
	innerLoop3:
		CALL twoFiftyMilliDelay
		DECFSZ COUNT3
		GOTO innerLoop3
	RETURN

;overhead: 3 us, tL = 1.004 ms (incl. inner loop)
;actually 249.999 ms (incl. overhead)
twoFiftyMilliDelay:
	MOVLF d'249', COUNT1
	innerLoop1:
		CALL oneMilliDelay
		DECFSZ COUNT1
		GOTO innerLoop1
	RETURN

;3 us overhead, tL = 6 us
;actually 999 us (incl. overhead)
oneMilliDelay:
	MOVLF d'166', COUNT2
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
