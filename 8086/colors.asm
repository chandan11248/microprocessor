.MODEL SMALL
.STACK 100H
.DATA
    inputWord DB 50 DUP('$')  ; Buffer to store the input word
    promptMsg DB 'Enter a word: $'
    outputMsg DB 'Alternate Case Word: $'

.CODE
MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX

    ; Clear the screen
    MOV AH, 06H    ; Scroll up function
    MOV AL, 00H    ; Clear entire screen
    MOV BH, 07H    ; Normal attribute
    MOV CX, 0000H  ; Upper left corner (0,0)
    MOV DX, 184FH  ; Lower right corner (24,79)
    INT 10H


mov ah,02h
mov bh,0
mov dx,0828h
int 10h

    ; Display prompt message
    LEA DX, promptMsg
    MOV AH, 09H
    INT 21H

    ; Read input word from user
    LEA DX, inputWord
    MOV AH, 0AH
    INT 21H

    ; Process the word to alternate case
    LEA SI, inputWord + 1  ; Point to the length of the input
    MOV CL, [SI]           ; Load length of the input
    MOV CH, 00H            ; Clear upper byte of CX
    INC SI                 ; Point to the first character of the input

    MOV BL, 01H            ; Flag to toggle case (1 for lowercase, 0 for uppercase)

ProcessLoop:
    MOV AL, [SI]           ; Load the current character
    CMP BL, 01H            ; Check if it's time for lowercase
    JE  MakeLowercase
    JMP MakeUppercase

MakeLowercase:
    OR AL, 20H             ; Convert to lowercase
    MOV BL, 00H            ; Set flag for uppercase next
    JMP NextChar

MakeUppercase:
    AND AL, 0DFH           ; Convert to uppercase
    MOV BL, 01H            ; Set flag for lowercase next

NextChar:
    MOV [SI], AL           ; Store the modified character back
    INC SI                 ; Move to the next character
    LOOP ProcessLoop       ; Repeat for all characters

    ; Display the output message
    LEA DX, outputMsg
    MOV AH, 09H
    INT 21H

    ; Display the processed word
    LEA DX, inputWord + 2  ; Point to the start of the word (skip length byte)
    MOV AH, 09H
    INT 21H

    ; Terminate the program
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN