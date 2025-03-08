.MODEL SMALL
.STACK 100H
.DATA
    PROMPT      DB 'Enter the string: $'
    pali        DB 0DH, 0AH, 'It is a palindrome $'
    notpali     DB 0DH, 0AH, 'It is not a palindrome $'
    BUFFER      DB 20          ; Max input length
                DB ?           ; Actual input length
                DB 20 DUP('$') ; Input storage
    BUFFER1     DB 20 DUP('$') ; Reversed string storage

.CODE
MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX  ; Set ES to DS for string operations

    ; Display prompt
    MOV AH, 09H
    LEA DX, PROMPT
    INT 21H

    ; Read string input
    MOV AH, 0AH
    LEA DX, BUFFER
    INT 21H

    ; Reverse the string and store in BUFFER1
    MOV CL, [BUFFER + 1]  ; Get actual input length
    MOV CH, 0             ; Clear CH (CX = CL)
    LEA SI, BUFFER + 2    ; Point to start of input string
    LEA DI, BUFFER1       ; Point to start of reversed string
    ADD SI, CX            ; Move SI to end of input string
    DEC SI                ; Adjust for last character

REVERSE_LOOP:
    MOV AL, [SI]          ; Load character from input string
    MOV [DI], AL          ; Store character in reversed string
    INC DI                ; Move DI to next position
    DEC SI                ; Move SI to previous character
    LOOP REVERSE_LOOP     ; Repeat for all characters

    ; Compare original and reversed strings
    MOV CL, [BUFFER + 1]  ; Get actual input length
    MOV CH, 0             ; Clear CH (CX = CL)
    LEA SI, BUFFER + 2    ; Point to start of input string
    LEA DI, BUFFER1       ; Point to start of reversed string
    REPE CMPSB            ; Compare strings byte by byte
    JZ IS_PALINDROME      ; If equal, it's a palindrome

    ; Not a palindrome
    MOV AH, 09H
    LEA DX, notpali
    INT 21H
    JMP EXIT

IS_PALINDROME:
    ; It is a palindrome
    MOV AH, 09H
    LEA DX, pali
    INT 21H

EXIT:
    ; Exit program
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN