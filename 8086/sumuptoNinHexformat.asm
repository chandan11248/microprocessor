.MODEL SMALL
.STACK 100H
.DATA
    PROMPT      DB 'Enter the value of n: $'
    RESULT      DB 0DH, 0AH, 'Sum in hexadecimal: $'
    BUFFER      DB 5 DUP('$')          ; Buffer to store hex result

.CODE
MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX

    ; Display prompt
    MOV AH, 09H
    LEA DX, PROMPT
    INT 21H

    ; Read input (single digit, 1-9)
    MOV AH, 01H
    INT 21H
    SUB AL, '0'     ; Convert ASCII to numerical value
    MOV CL, AL       ; Store n in CL
    MOV CH, 0        ; Clear CH (CX = CL)

    ; Calculate sum of first n natural numbers
    XOR AX, AX      ; Clear AX (sum = 0)
    MOV BX, 1       ; BX = current number
SUM_LOOP:
    ADD AX, BX      ; Add current number to sum
    INC BX          ; Increment current number
    LOOP SUM_LOOP   ; Repeat until CX = 0

    ; Convert sum to hexadecimal
    LEA SI, BUFFER + 4  ; Point to end of buffer
    MOV CX, 4           ; 4 hex digits (16-bit number)
    MOV BX, AX          ; Store sum in BX

CONVERT_HEX:
    XOR DX, DX          ; Clear DX for division
    MOV AX, BX          ; Load sum into AX
    MOV BX, 16          ; Divisor = 16
    DIV BX              ; AX = quotient, DX = remainder
    MOV BX, AX          ; Store quotient in BX
    ; Convert remainder to hex character
    CMP DL, 9
    JBE DIGIT           ; If DL <= 9, it's a digit
    ADD DL, 7           ; Adjust for A-F (10-15)
DIGIT:
    ADD DL, '0'         ; Convert to ASCII
    MOV [SI], DL        ; Store digit in buffer
    DEC SI              ; Move to next position
    LOOP CONVERT_HEX

    ; Display result message
    MOV AH, 09H
    LEA DX, RESULT
    INT 21H

    ; Display hexadecimal result
    mov ah,09h
    LEA DX, BUFFER
    INT 21H

    ; Exit program
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN