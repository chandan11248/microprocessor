.MODEL SMALL
.STACK 100H
.DATA
    prompt db 'Enter the value of n: $'
    result db 'The sum of the series is: $'
    n db ?
    sum dw 0
.CODE
MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX

    ; Display prompt to enter n
    LEA DX, prompt
    MOV AH, 09H
    INT 21H

    ; Read n from user
    MOV AH, 01H
    INT 21H
    SUB AL, '0'       ; Convert ASCII to integer
    MOV n, AL

    ; Calculate the sum of the series
    MOV CL, n         ; CL = n (counter)
    MOV BL, 1         ; BL = i (starting from 1)
    MOV AX, 0         ; AX = sum (initialize to 0)

CALCULATE:
    MOV AL, BL        ; AL = i
    INC BL            ; BL = i + 1
    MUL BL            ; AX = i * (i + 1)
    ADD sum, AX       ; Add to sum
    LOOP CALCULATE    ; Repeat until CL = 0

    ; Display result message
    LEA DX, result
    MOV AH, 09H
    INT 21H

    ; Convert sum to ASCII and print
    MOV AX, sum
    CALL PRINT_NUMBER

    ; Exit program
    MOV AH, 4CH
    INT 21H
MAIN ENDP

; Procedure to print a number in AX
PRINT_NUMBER PROC
    MOV CX, 0         ; Initialize digit count
    MOV BX, 10        ; Base 10

DIVIDE:
    XOR DX, DX        ; Clear DX
    DIV BX            ; AX = AX / 10, DX = remainder
    PUSH DX           ; Save remainder (digit)
    INC CX            ; Increment digit count
    CMP AX, 0         ; Check if quotient is 0
    JNE DIVIDE        ; Repeat if not zero

PRINT:
    POP DX            ; Get digit from stack
    ADD DL, '0'       ; Convert to ASCII
    MOV AH, 02H       ; DOS print character function
    INT 21H
    LOOP PRINT        ; Repeat for all digits
    RET
PRINT_NUMBER ENDP

END MAIN