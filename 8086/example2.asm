.MODEL SMALL
.STACK 100H
.DATA
    msg  DB 'Enter a number: $'  ; Message to prompt user
    num  DB ?     ; Variable to store single character input
    newline DB 0Dh, 0Ah, '$'  ; Newline for better formatting

.CODE
main PROC
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

    ; Display message
    mov ah, 09h
    lea dx, msg
    int 21h

    ; Take input from user (single character)
    mov ah, 01h
    int 21h
    mov num, al  ; Store the input in 'num'

    ; Print a newline
    mov ah, 09h
    lea dx, newline
    int 21h

    ; Display user input
    mov ah, 02h
    mov dl, num
    int 21h

    ; Exit program
    mov ah, 4Ch
    int 21h

main ENDP
END main