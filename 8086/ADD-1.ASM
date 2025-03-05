.MODEL SMALL
.STACK 100H
.DATA
    MSG1 DB 'Sum of elements between 50 and 150: $'
    TABLE DB 45, 70, 75, 155, 130, 90, 200, 120, 50, 150  ; Sample data
    COUNT DW 10     ; Number of elements in TABLE
    SUM DW 0        ; Variable to store the sum
    BUFFER DB 6 DUP('0'), '$'  ; Buffer with proper termination

.CODE
MAIN PROC
    ; Initialize Data Segment
    MOV AX, @DATA
    MOV DS, AX

    ; Display Message
    MOV DX, OFFSET MSG1
    MOV AH, 09H
    INT 21H

    ; Initialize registers
    MOV CX, COUNT  ; Load loop counter
    LEA SI, TABLE  ; Load address of the table
    MOV AX, 0      ; Clear AX (used for sum)

SUM_LOOP:
    MOV BL, [SI]   ; Load value from table
    CMP BL, 51
    JB SKIP        ; If value ≤ 50, skip addition
    CMP BL, 149
    JA SKIP        ; If value ≥ 150, skip addition

    ADD AL, BL     ; Add valid number to sum
    ADC AH, 0      ; Add carry if any (for 16-bit sum)

SKIP:
    INC SI         ; Move to next element
    LOOP SUM_LOOP  ; Repeat for all elements

    ; Store result in SUM
    MOV SUM, AX

    ; Convert Sum (Hex to Decimal)
    MOV AX, SUM    ; Load sum into AX
    MOV CX, 0      ; Clear CX (will count digits)
    MOV SI, OFFSET BUFFER + 5  ; Point to last digit in buffer

DECIMAL_CONVERSION:
    MOV DX, 0      ; Clear DX before division
    MOV BX, 10     ; Divisor = 10
    DIV BX         ; AX / 10 -> Quotient in AX, Remainder in DX
    ADD DL, '0'    ; Convert remainder to ASCII
    MOV [SI], DL   ; Store ASCII digit in buffer
    DEC SI         ; Move buffer pointer left
    INC CX         ; Increase count of stored digits
    CMP AX, 0      ; If quotient is 0, stop
    JNE DECIMAL_CONVERSION

    INC SI         ; Move SI to the first valid digit
    MOV DX, SI     ; Load string address in DX
    MOV AH, 09H    ; DOS print string function
    INT 21H

    ; Exit Program
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN