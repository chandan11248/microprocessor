.model small
.stack 100h

.data
sum dw 0     ; Variable to store the sum

.code
start:
    mov ax, @data
    mov ds, ax

    ; Initialize sum with first two terms
    mov sum, 1      ; First term: 1
    add sum, 3      ; Second term: +3

    ; Process terms from 3 to 100
    mov cx, 3       ; Start from term 3
process_terms:
    cmp cx, 100
    jg display_result  ; Exit loop when cx > 100

    mov ax, cx
    inc ax          ; Calculate term value (current + 1)
    
    test cx, 1      ; Check if term number is odd
    jnz subtract
    add sum, ax     ; Even term: add
    jmp next_term
subtract:
    sub sum, ax     ; Odd term: subtract
    
next_term:
    inc cx          ; Move to next term
    jmp process_terms

display_result:
    ; Display hexadecimal result
    mov bx, sum     ; Load sum into BX
    mov cx, 4       ; Process 4 hexadecimal digits

print_hex:
    rol bx, 4       ; Bring next nibble to front
    mov dl, bl
    and dl, 0Fh     ; Isolate nibble
    
    ; Convert to ASCII
    add dl, '0'
    cmp dl, '9'
    jle print_char
    add dl, 7       ; Adjust for letters A-F

print_char:
    mov ah, 02h
    int 21h
    
    dec cx
    jnz print_hex

    ; Exit program
    mov ax, 4C00h
    int 21h

end start