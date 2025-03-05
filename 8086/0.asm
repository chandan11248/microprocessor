.MODEL SMALL
.STACK 100H
.DATA
msg  DB 'ENTER THE STRING: $'  ; Display message

a    DB 10     ; Max input size (can be changed)
     DB ?      ; DOS will fill this with actual input length
buffer DB 10 DUP('$') ; Space for input + termination

newline DB 0Dh, 0Ah, '$'  ; New line for better formatting

.CODE
main PROC
    mov ax, @data
    mov ds, ax

    ; Display message
    mov ah, 09h
    lea dx, msg
    int 21h

    ; Take input from user
    mov ah, 0ah
    lea dx, a
    int 21h

    ; Add '$' terminator manually for display
    mov bl, a+1    ; Get actual length of input
    mov bh, 0      ; Clear high byte
    mov byte ptr buffer[bx], '$' ; Add string terminator

    ; Print a new line
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Display user input
    mov ah, 09h
    lea dx, buffer
    int 21h

    ; Terminate program
    mov ah, 4Ch
    int 21h

main ENDP
END main