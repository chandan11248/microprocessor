; Program: Count Vowels in a User-entered String (8086 Assembly)
; Assembled with MASM/TASM

.MODEL SMALL
.STACK 100h

.DATA
    prompt     DB "Enter a string: $"
    ; Input buffer for DOS function 0Ah:
    ;   - first byte: maximum length (80)
    ;   - second byte: actual number of characters read (filled by DOS)
    ;   - following bytes: storage for characters
    inputBuffer DB 80,0,80 DUP('$')
    vowelMsg   DB 13,10, "Number of vowels: $"

.CODE
MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX

    ; Display the prompt
    LEA DX, prompt
    MOV AH, 09h
    INT 21h

    ; Read string from the user (buffered input)
    LEA DX, inputBuffer
    MOV AH, 0Ah
    INT 21h

    ; Get the number of characters entered (stored in second byte)
    MOV CL, [inputBuffer+1]
    ; Point SI to the first character (buffer offset +2)
    LEA SI, inputBuffer+2

    XOR BX, BX      ; BX will hold the vowel count

CountLoop:
    CMP CL, 0
    JE  DisplayResult

    MOV AL, [SI]
    ; Convert lowercase to uppercase if needed.
    CMP AL, 'a'
    JB  CheckVowel
    CMP AL, 'z'
    JA  CheckVowel
    SUB AL, 20h

CheckVowel:
    ; Check if the character is one of the vowels.
    CMP AL, 'A'
    JE  Increment
    CMP AL, 'E'
    JE  Increment
    CMP AL, 'I'
    JE  Increment
    CMP AL, 'O'
    JE  Increment
    CMP AL, 'U'
    JE  Increment
    JMP NextChar

Increment:
    INC BX

NextChar:
    INC SI
    DEC CL
    JMP CountLoop

DisplayResult:
    ; Display the result message
    LEA DX, vowelMsg
    MOV AH, 09h
    INT 21h

    ; Convert the vowel count (in BX) to decimal and print it.
    MOV AX, BX
    CALL PrintNumber

    ; Wait for a key press before exiting
    MOV AH, 1
    INT 21h

    MOV AH, 4Ch
    INT 21h
MAIN ENDP

;-----------------------------------------------------
; Procedure: PrintNumber
; Purpose:   Prints the unsigned number in AX in decimal.
; Uses a push/pop method to reverse the remainders.
;-----------------------------------------------------
PrintNumber PROC
    PUSH BX
    PUSH CX
    PUSH DX
    CMP AX, 0
    JNE PN_NotZero
    ; Special case: number is zero.
    MOV DL, '0'
    MOV AH, 02h
    INT 21h
    JMP PN_Done

PN_NotZero:
    XOR CX, CX         ; CX will count the digits
PN_Loop:
    XOR DX, DX
    MOV BX, 10
    DIV BX             ; AX = quotient, DX = remainder
    PUSH DX            ; save remainder (digit)
    INC CX
    CMP AX, 0
    JNE PN_Loop

PN_Print:
    POP DX           ; get one digit (0–9)
    ; Convert digit to ASCII character.
    MOV AL, DL
    ADD AL, '0'
    MOV DL, AL
    MOV AH, 02h
    INT 21h
    LOOP PN_Print

PN_Done:
    POP DX
    POP CX
    POP BX
    RET
PrintNumber ENDP

END MAIN
