; 8086 PROGRAM TO MOVE STRING FROM RIGHT TO LEFT EDGE
.MODEL SMALL
.STACK 100H
.DATA
    PROMPT    DB  'Enter a string: $'
    BUFFER    DB  81          ; Max input length (80 chars + 1 for CR)
              DB  ?           ; Actual length (filled by DOS)
              DB  81 DUP('$') ; Input storage + CR + '$' termination
    DELAY     DW  2           ; Adjust this value to control speed

.CODE
START:
    MOV AX, @DATA
    MOV DS, AX

    ; Display input prompt
    MOV AH, 09H
    LEA DX, PROMPT
    INT 21H

    ; Read string input
    MOV AH, 0AH
    LEA DX, BUFFER
    INT 21H

    ; Clear screen
    MOV AX, 0600H     ; AH=06h (scroll), AL=00h (full screen)
    MOV BH, 07h       ; Attribute (white on black)
    MOV CX, 0000h     ; Upper-left corner (0,0)
    MOV DX, 184FH     ; Lower-right corner (24,79)
    INT 10H

    ; Animation setup
    MOV CL, BUFFER + 1 ; Get string length
    MOV CH, 0
    JCXZ EXIT          ; Exit if empty string
    MOV BX, CX         ; Save length in BX

    ; Total steps = 80 + string length
    ADD CX, 80

    ; Animation loop
    MOV DI, 0          ; DI = current step

MOVE_STRING:
    ; Calculate current column (79 - DI)
    MOV AX, 79
    SUB AX, DI
    CMP AX, 0          ; Stop if column < 0
    JL EXIT

    ; Set cursor position
    MOV DH, 12         ; Center row
    MOV DL, AL         ; Current column
    MOV AH, 02H
    MOV BH, 00H
    INT 10H

    ; Display string
    MOV AH, 09H
    LEA DX, BUFFER + 2
    INT 21H

    ; Delay
    CALL DELAY_FUNC

    ; Clear string by overwriting with spaces
    MOV AH, 09H
    MOV AL, ' '        ; Space character
    MOV BH, 00H
    MOV CX, BX         ; Length of string
    INT 10H

    ; Next step
    INC DI
    LOOP MOVE_STRING

EXIT:
    MOV AX, 4C00H
    INT 21H

; Delay subroutine
DELAY_FUNC PROC
    PUSH CX
    MOV CX, DELAY
OUTER_LOOP:
    PUSH CX
    MOV CX, 0FFFFH
INNER_LOOP:
    LOOP INNER_LOOP
    POP CX
    LOOP OUTER_LOOP
    POP CX
    RET
DELAY_FUNC ENDP

END START