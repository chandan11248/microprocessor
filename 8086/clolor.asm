.MODEL SMALL
.STACK 100H
.DATA
a DB 'chandan $'  ; Replace 'Your Name' with the desired name
    COLOR EQU 0D5H       ; Pink text (D) on black background (5)

.CODE
MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX

    ; Set video mode (80x25 text mode)
    MOV AH, 00H
    MOV AL, 03H
    INT 10H

    ; Set cursor position (row 12, column 35)
    MOV AH, 02H
    MOV BH, 00H      ; Page 0
    MOV DH, 12       ; Row 12
    MOV DL, 35       ; Column 35
    INT 10H

    ; Print name with pink color
    MOV AH, 09H      ; BIOS function: Write character and attribute
    LEA DX, a     ; Load address of name
    MOV CX, 1        ; Number of times to write (1 for each character)
    MOV BL, COLOR    ; Attribute: Pink text on black background
PRINT_LOOP:
    LODSB            ; Load next character into AL
    CMP AL, '$'      ; Check for end of string
    JE END_PRINT
    INT 10H          ; Print character with attribute
    INC DL           ; Move to next column
    MOV AH, 02H      ; Set cursor position
    INT 10H
    JMP PRINT_LOOP

END_PRINT:
    ; Wait for a key press
    MOV AH, 00H
    INT 16H

    ; Exit program
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN