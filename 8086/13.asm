; 8086 PROGRAM TO CONVERT LOWERCASE VOWELS TO UPPERCASE
.MODEL SMALL
.STACK 100H
.DATA
    PROMPT    DB  'Enter a string: $'
    RESULT    DB  0DH, 0AH, 'Converted string: $'
    BUFFER    DB  100          ; Maximum input length
              DB  ?           ; Actual input length (filled by DOS)
              DB  100 DUP('$') ; Input storage + '$' termination

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

    ; Process the string
    LEA SI, BUFFER + 2        ; SI points to start of input string
   MOV CL, BUFFER + 1        ; CL = number of characters entered
    MOV CH, 0                 ; Clear CH for CX loop

    JCXZ EXIT_PROGRAM         ; Skip processing if empty string

PROCESS_LOOP:
    LODSB                     ; Load character into AL, increment SI

    ; Check if character is a lowercase vowel
    CMP AL, 'a'
    JE  CONVERT
    CMP AL, 'e'
    JE  CONVERT
    CMP AL, 'i'
    JE  CONVERT
    CMP AL, 'o'
    JE  CONVERT
    CMP AL, 'u'
    JNE NEXT_CHAR

CONVERT:
    SUB AL, 20H               ; Convert to uppercase
    MOV [SI - 1], AL          ; Update character in buffer

NEXT_CHAR:
    LOOP PROCESS_LOOP

    ; Replace carriage return with '$' for printing
    MOV BL, BUFFER + 1        ; Get string length
    MOV BH, 0
    LEA SI, BUFFER + 2        ; Start of string
    ADD SI, BX                ; Move to end of string
    MOV BYTE PTR [SI], '$'    ; Replace 0DH with '$'

    ; Display result
    MOV AH, 09H
    LEA DX, RESULT
    INT 21H
    LEA DX, BUFFER + 2
    INT 21H

EXIT_PROGRAM:
    MOV AX, 4C00H
    INT 21H

END START