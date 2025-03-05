.model small
.stack 100h

.data
    prompt      db 'Enter a string: $'
    buffer      db 50              ; Maximum input length
                db 0               ; Actual input length
                db 50 dup(0)       ; Input buffer
    end_marker  db '$'             ; String terminator

.code
start:
    mov ax, @data
    mov ds, ax

    ; Display input prompt
    mov ah, 09h
    lea dx, prompt
    int 21h

    ; Read string input
    mov ah, 0Ah
    lea dx, buffer
    int 21h

    ; Convert to uppercase
    lea si, buffer + 2            ; Start of string
    mov cl, [buffer + 1]          ; String length
    mov ch, 0
    jcxz display                  ; Skip if empty string

convert_loop:
    cmp byte ptr [si], 'a'        ; Check lowercase range
    jb skip
    cmp byte ptr [si], 'z'
    ja skip
    sub byte ptr [si], 20h        ; Convert to uppercase
skip:
    inc si
    loop convert_loop

display:
    ; Replace carriage return with terminator
    mov bl, [buffer + 1]
    mov bh, 0
    mov [buffer + 2 + bx], '$'

    ; Set video mode (80x25 text)
    mov ax, 0003h
    int 10h

    ; Calculate center position
    mov al, [buffer + 1]          ; String length
    mov ah, 0
    shr ax, 1                     ; Divide length by 2
    mov dl, 39                    ; Window center column (0-based)
    sub dl, al                    ; Calculate start column

    ; Set cursor position
    mov ah, 02h
    mov bh, 0                     ; Page 0
    mov dh, 11                    ; Center row (0-based row 11 = 1-based row 12)
    int 10h

    ; Display converted string
    mov ah, 09h
    lea dx, buffer + 2
    int 21h

    ; Wait for key press
    mov ah, 00h
    int 16h

    ; Return to DOS
    mov ax, 4C00h
    int 21h

end start