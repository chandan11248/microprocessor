.MODEL SMALL
.STACK 100H
.DATA
    inputString DB 50 DUP('$')  ; Buffer to store the input string
    vowels DB 50 DUP('$')       ; Buffer to store vowels
    consonants DB 50 DUP('$')   ; Buffer to store consonants
    promptMsg DB 'Enter a string: $'
    vowelsMsg DB 10, 13, 'Vowels: $'
    consonantsMsg DB 10, 13, 'Consonants: $'

.CODE
MAIN PROC
    ; Initialize data segment
    MOV AX, @DATA
    MOV DS, AX

    ; Display prompt message
    LEA DX, promptMsg
    MOV AH, 09H
    INT 21H

    ; Read input string from user
    LEA DX, inputString
    MOV AH, 0AH
    INT 21H

    ; Initialize pointers and counters
    LEA SI, inputString + 1  ; Point to the length of the input
    MOV CL, [SI]             ; Load length of the input
    MOV CH, 00H              ; Clear upper byte of CX
    INC SI                   ; Point to the first character of the input

    LEA DI, vowels           ; Point to the vowels buffer
    LEA BX, consonants       ; Point to the consonants buffer

ProcessLoop:
    MOV AL, [SI]             ; Load the current character
    CMP AL, '$'              ; Check for end of string
    JE DoneProcessing        ; If end of string, exit loop

    ; Check if the character is a vowel (A, E, I, O, U or a, e, i, o, u)
    CMP AL, 'A'
    JE IsVowel
    CMP AL, 'E'
    JE IsVowel
    CMP AL, 'I'
    JE IsVowel
    CMP AL, 'O'
    JE IsVowel
    CMP AL, 'U'
    JE IsVowel
    CMP AL, 'a'
    JE IsVowel
    CMP AL, 'e'
    JE IsVowel
    CMP AL, 'i'
    JE IsVowel
    CMP AL, 'o'
    JE IsVowel
    CMP AL, 'u'
    JE IsVowel

    ; If not a vowel, it is a consonant
    MOV [BX], AL             ; Store consonant in consonants buffer
    INC BX                   ; Move to the next position in consonants buffer
    JMP NextChar

IsVowel:
    MOV [DI], AL             ; Store vowel in vowels buffer
    INC DI                   ; Move to the next position in vowels buffer

NextChar:
    INC SI                   ; Move to the next character in input string
    LOOP ProcessLoop         ; Repeat for all characters

DoneProcessing:
    ; Display vowels message
    LEA DX, vowelsMsg
    MOV AH, 09H
    INT 21H

    ; Display vowels
    LEA DX, vowels
    MOV AH, 09H
    INT 21H

    ; Display consonants message
    LEA DX, consonantsMsg
    MOV AH, 09H
    INT 21H

    ; Display consonants
    LEA DX, consonants
    MOV AH, 09H
    INT 21H

    ; Terminate the program
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN