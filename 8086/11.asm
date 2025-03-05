.model small
.stack 100h

.data
; Sample data: 10 numbers. You can modify these values.
table1   db  10,20,30,40,50,60,70,80,90,100 
n        db  10

; Allocate enough space for the output string.
; Each number can be up to 3 characters + 1 space; add one extra byte for the '$' terminator.
table2   db  50 dup(0)

.code
start:
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

    ; ----- Clear the screen -----
    ; Use BIOS interrupt 10h, function 06h to scroll entire screen clearing it.
    mov ah, 06h      
    mov al, 0        ; number of lines to scroll (0 means clear entire screen)
    mov bh, 07h      ; background attribute (white on black)
    mov cx, 0        ; upper left corner (row=0, col=0)
    mov dx, 184Fh    ; lower right corner (row=24, col=79 in hex form)
    int 10h

    ; ----- Process each element in table1 -----
    mov si, offset table1     ; pointer to input array
    mov di, offset table2     ; pointer to output string
    mov cl, [n]             ; number of elements to process

process_loop:
    mov al, [si]            ; get one element from table1

    ; Decide whether the number has one, two, or three digits.
    cmp al, 100
    jae three_digit         ; number >= 100 (three digits)
    cmp al, 10
    jae two_digit           ; number is between 10 and 99 (two digits)
    jmp one_digit           ; number is less than 10

one_digit:
    ; For a one-digit number, simply convert it to ASCII.
    add al, '0'
    mov [di], al
    inc di
    jmp add_space

two_digit:
    ; For a two-digit number: divide by 10 to get tens and ones.
    mov ah, 0               ; clear AH to form AX with the number
    mov bl, 10
    div bl                  ; divide AX by 10: quotient in AL, remainder in AH
    ; Convert quotient (tens digit)
    add al, '0'
    mov [di], al
    inc di
    ; Convert remainder (ones digit)
    mov al, ah
    add al, '0'
    mov [di], al
    inc di
    jmp add_space

three_digit:
    ; For a three-digit number: first divide by 100.
    mov ah, 0               ; clear AH
    mov bl, 100
    div bl                  ; quotient in AL is hundreds digit, remainder in AH
    add al, '0'
    mov [di], al
    inc di
    ; Now convert the remainder to tens and ones.
    mov al, ah              ; remainder becomes the new number
    xor ah, ah              ; clear AH for next division
    mov bl, 10
    div bl                  ; quotient in AL is tens digit, remainder in AH is ones digit
    add al, '0'
    mov [di], al
    inc di
    mov al, ah
    add al, '0'
    mov [di], al
    inc di

add_space:
    ; Add a space separator after each number.
    mov byte ptr [di], ' '
    inc di

    inc si                  ; move to next element in table1
    loop process_loop

    ; Terminate the string with a '$' (DOS function 09h requires this).
    mov byte ptr [di], '$'

    ; ----- Display the Final Result -----
    mov dx, offset table2   ; DS:DX points to our output string
    mov ah, 09h             ; DOS function 09h – display string
    int 21h

    ; Wait for a key press before exiting.
    mov ah, 00h
    int 16h

    ; Terminate the program.
    mov ax, 4C00h
    int 21h

end start
