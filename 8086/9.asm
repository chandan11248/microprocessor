.MODEL SMALL
.STACK 100H
.DATA
    msg1 DB 'Enter number of terms (1-9): $'
    msg2 DB 10,13,'Sum of sequence: $'
    sumStr DB '00000$', 0  ; String to store the final sum (initialized to "00000")

.CODE
MAIN PROC
    ; Initialize segment registers
    MOV AX, @DATA
    MOV DS, AX

    ; Display message to user
    MOV DX, OFFSET msg1
    MOV AH, 09H
    INT 21H

    ; Read user input (single digit)
    MOV AH, 01H
    INT 21H
    SUB AL, '0'  ; Convert ASCII to number
    MOV CL, AL   ; Store the input number in CL
    MOV CH, 0    ; Clear CH to use CX as a counter

    ; Initialize sum variables
    XOR AX, AX   ; AX = 0 (sum)
    MOV SI, 1    ; First term = 1
    MOV DX, 2    ; Step size = 2 (for odd indexed terms)
    MOV BX, 3    ; Step size = 3 (for even indexed terms)
    
SUM_LOOP:
    ADD AX, SI   ; Add current term to sum

    ; Determine next term
    TEST SI, 1   ; Check if the term is odd or even
    JZ EVEN_CASE ; Jump if even
    ADD SI, DX   ; If odd, add 2
    JMP CONTINUE
EVEN_CASE:
    ADD SI, BX   ; If even, add 3
CONTINUE:
    LOOP SUM_LOOP  ; Repeat loop CX times

    ; Convert sum in AX to decimal and display
    CALL CONVERT_DECIMAL

    ; Display message and sum
    MOV DX, OFFSET msg2
    MOV AH, 09H
    INT 21H

    MOV DX, OFFSET sumStr
    MOV AH, 09H
    INT 21H

    ; Exit program
    MOV AH, 4CH
    INT 21H

MAIN ENDP

; Procedure to convert AX (sum) to decimal string
CONVERT_DECIMAL PROC
    MOV CX, 0        ; Count for digits
    MOV BX, 10       ; Divisor for decimal conversion

DIV_LOOP:
    XOR DX, DX       ; Clear DX before division
    DIV BX           ; AX / 10, remainder in DX
    PUSH DX          ; Store remainder (digit) on stack
    INC CX           ; Increase digit count
    TEST AX, AX      ; Check if AX is zero
    JNZ DIV_LOOP     ; Continue if not zero

    ; Convert to ASCII and store in sumStr
    MOV DI, OFFSET sumStr + 4  ; Point to last digit position

STORE_DIGITS:
    POP DX
    ADD DL, '0'     ; Convert to ASCII
    MOV [DI], DL    ; Store in string
    DEC DI
    LOOP STORE_DIGITS

    RET
CONVERT_DECIMAL ENDP

END MAIN