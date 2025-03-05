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

    ; Convert to lowercase
    lea si, buffer + 2            ; Start of string
    mov cl, [buffer + 1]          ; String length
    mov ch, 0
    jcxz display                  ; Skip if empty string

convert_loop:
    cmp byte ptr [si], 'A'        ; Check uppercase range
    jb skip
    cmp byte ptr [si], 'Z'
    ja skip
    add byte ptr [si], 20h        ; Convert to lowercase
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

    ; Set cursor to lower-left corner (1-based: 21,10 -> 0-based: 20,9)
    mov ah, 02h
    mov bh, 0                     ; Page 0
    mov dh, 20                    ; Row 21 (0-based row 20)
    mov dl, 9                     ; Column 10 (0-based column 9)
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