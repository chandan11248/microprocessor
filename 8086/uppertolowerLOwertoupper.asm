.MODEL SMALL
.STACK 100H
.DATA
    PROMPT      DB 'Enter a string: $'
    RESULT      DB 0DH, 0AH, 'Modified string: $'
    BUFFER      DB 100          ; Max input length
                DB ?           ; Actual input length
                DB 100 DUP('$') ; Input storage

.CODE
MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX

    ; Display prompt
    MOV AH, 09H
    LEA DX, PROMPT
    INT 21H

    ; Read string input
    MOV AH, 0AH
    LEA DX, BUFFER
    INT 21H

    ; Process string to toggle case
    LEA SI, BUFFER + 2  ; Point to start of string
    MOV CL, [BUFFER + 1] ; Get actual input length
    MOV CH, 0           ; Clear CH (CX = CL)
    JCXZ DISPLAY_RESULT ; Skip if empty string

TOGGLE_CASE:
    MOV AL, [SI]        ; Load character into AL
    CMP AL, 'A'
    JB  NEXT_CHAR       ; Skip if character < 'A'
    CMP AL, 'Z'
    JBE TO_LOWER        ; Convert uppercase to lowercase
    CMP AL, 'a'
    JB  NEXT_CHAR       ; Skip if character < 'a'
    CMP AL, 'z'
    JA  NEXT_CHAR       ; Skip if character > 'z'
    JMP TO_UPPER        ; Convert lowercase to uppercase

TO_LOWER:
    ADD AL, 20H         ; Convert uppercase to lowercase
    JMP NEXT_CHAR

TO_UPPER:
    SUB AL, 32          ; Convert lowercase to uppercase

NEXT_CHAR:
    MOV [SI], AL        ; Store modified character
    INC SI              ; Move to next character
    LOOP TOGGLE_CASE    ; Repeat for all characters

DISPLAY_RESULT:
    ; Display result message
    MOV AH, 09H
    LEA DX, RESULT
    INT 21H

    ; Display modified string
    LEA DX, BUFFER + 2
    INT 21H

    ; Exit program
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN