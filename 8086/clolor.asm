.MODEL SMALL
.STACK 100H
.DATA
    PROMPT      DB 'Enter a string: $'
    BUFFER      DB 100          ; Max input length
                DB ?           ; Actual input length
                DB 100 DUP('$') ; Input storage

.CODE
MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX

    ; Clear the entire screen with blue background
    MOV AX, 0600H     ; AH=06h (scroll up), AL=00h (full screen)
    MOV BH, 17H       ; Attribute: blue background (1), white text (7)
    MOV CX, 0000H     ; Upper-left corner (0,0)
    MOV DX, 184FH     ; Lower-right corner (24,79)
    INT 10H

    ; Define the window (row 3, column 10 to row 21, column 10)
   

    ; Display prompt
    MOV AH, 09H
    LEA DX, PROMPT
    INT 21H

    ; Read string input
    MOV AH, 0AH
    LEA DX, BUFFER
    INT 21H

    ; Process string to convert to lowercase
    LEA SI, BUFFER + 2  ; Point to start of string
    MOV CL, [BUFFER + 1] ; Get actual input length
    MOV CH, 0           ; Clear CH (CX = CL)
    JCXZ DISPLAY_RESULT ; Skip if empty string

CONVERT_TO_LOWER:
    MOV AL, [SI]        ; Load character into AL
    CMP AL, 'A'
    JB  NEXT_CHAR       ; Skip if character < 'A'
    CMP AL, 'Z'
    JA  NEXT_CHAR       ; Skip if character > 'Z'
    ADD AL, 32          ; Convert uppercase to lowercase
    MOV [SI], AL        ; Store modified character
NEXT_CHAR:
    INC SI              ; Move to next character
    LOOP CONVERT_TO_LOWER ; Repeat for all characters

 MOV AX, 0600H     ; AH=06h (scroll up), AL=00h (full screen)
    MOV BH, 07H       ; Attribute: black background (0), white text (7)
    MOV CX, 030AH     ; Upper-left corner (row 3, column 10)
    MOV DX, 150AH     ; Lower-right corner (row 21, column 10)
    INT 10H

DISPLAY_RESULT:
    ; Set cursor position (row 21, column 10)
    MOV AH, 02H
    MOV BH, 00H      ; Page 0
    MOV DH, 21       ; Row 21
    MOV DL, 10       ; Column 10
    INT 10H

    ; Display modified string
    MOV AH, 09H
    LEA DX, BUFFER + 2
    INT 21H

    ; Exit program
    MOV AH, 4CH
    INT 21H
MAIN ENDP
END MAIN