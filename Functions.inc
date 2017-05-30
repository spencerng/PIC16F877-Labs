MOVLF macro k, f
	MOVLW k
	MOVWF f
endm

MOVFF macro source, dest
	MOVF source, 0
	MOVWF dest
endm

SWAP macro reg1, reg2, tempAddress
	MOVF reg1, 0
	MOVWF tempAddress
	MOVF reg2, 0
	MOVWF reg1
	MOVF tempAddress, 0
	MOVWF reg2
endm

ADDLF macro k, f
	MOVF f, 0
	ADDLW k
	MOVWF f
endm

ADDFF macro reg1, reg2, sumLoc
	MOVWF reg2, 0
	ADDWF reg1, 0
	MOVWF sumLoc
endm

SUBLF macro k, f
	MOVF f, 0
	SUBLW k
	MOVWF f
endm

MULTLW macro k, countAddress, tempAddress
	MOVWF tempAddress
	MOVLF k, countAddress
	MOVLW 0
	loop:
		ADDWF tempAddress, 0
		DECFSZ countAddress
		GOTO loop
	NOP
endm

MULTFF macro reg1, reg2, countAddress, resultAddress
	MOVFF reg2, countAddress
	MOVLF 0, resultAddress
	loop:
		ADDFF reg1, resultAddress, resultAdress
		DECFSZ countAddress
		GOTO loop
	NOP
endm

;compute REG/W, remainder is ignored
DIVWF macro REG, temp, result
	CLRF temp
	CLRF result
	MOVWF temp
	loop:
		MOVF temp, 0
		SUBWF REG
		BTFSC STATUS, C
		GOTO OP
		exitm
	OP:
		INC result
		GOTO loop
endm

;compute reg%w
MODWF macro reg, temp, result
	MOVFF reg, temp
	loop:
		SUBWF reg
		BTFSC STATUS, C
		goto loop
	MOVFF reg, result
	MOVFF temp, reg

endm