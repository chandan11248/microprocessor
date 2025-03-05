.MODEL SMALL  
.STACK 100H  
.DATA  
BUFFER_SIZE DB 20           ; Maximum input length  
ACTUAL_LEN  DB ?            ; Actual length of input (filled by DOS)  
BUFFER      DB 20 DUP('$')  ; Storage space for user input  

NEWLINE     DB 0Dh, 0Ah, '$' ; Newline for output  

.CODE  
MAIN PROC  
    MOV AX, @DATA  
    MOV DS, AX  

    ; Take input from user
    MOV DX, OFFSET BUFFER_SIZE  ; Correct way to pass buffer  
    MOV AH, 0AH                 ; DOS input function  
    INT 21H                     ; Call DOS  

    ; Add string terminator ('$') for correct printing  
    MOV AL, ACTUAL_LEN   ; Get actual input length  
    MOV AH, 0            ; Clear AH to use AX as index  
    MOV SI, AX           ; Use SI as a valid index register  
    MOV BYTE PTR BUFFER[SI], '$'  ; Add '$' at the end of input  

    ; Print newline  
    MOV DX, OFFSET NEWLINE  
    MOV AH, 09H  
    INT 21H  

    ; Print the entered text  
    MOV DX, OFFSET BUFFER  ; Correct way to print the buffer  
    MOV AH, 09H            ; DOS print function  
    INT 21H                ; Call DOS  

    ; Exit program  
    MOV AX, 4C00H  
    INT 21H  

MAIN ENDP  
END MAIN  