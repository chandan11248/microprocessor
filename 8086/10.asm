.model small
.stack 100h

.code
start:
    ; Set video mode to 80x25 color text
    mov ax, 0003h
    int 10h

    ; Point ES to video memory
    mov ax, 0B800h
    mov es, ax

    ; Initialize character counter
    mov si, 32       ; Start with ASCII 32

    ; Draw characters in window (5,10) to (20,70)
    mov cx, 5        ; Starting row

row_loop:
    cmp cx, 20
    ja cleanup       ; Exit when rows complete

    ; Calculate row offset
    mov ax, cx
    mov bx, 160      ; Bytes per row
    mul bx
    mov di, ax
    add di, 20       ; Add column offset (10 columns * 2 bytes)

    ; Process 61 columns
    mov dx, 10       ; Starting column

col_loop:
    cmp dx, 70
    ja next_row      ; Move to next row when columns complete

    ; Write character and attribute
    mov ax, si       ; Get current ASCII character
    mov ah, 1Fh      ; White on blue attribute
    mov es:[di], ax

    ; Update character counter
    inc si
    cmp si, 127
    jbe no_reset
    mov si, 32       ; Reset to ASCII 32 after 127

no_reset:
    ; Move to next column
    add di, 2
    inc dx
    jmp col_loop

next_row:
    inc cx           ; Move to next row
    jmp row_loop

cleanup:
    ; Wait for key press
    mov ah, 0
    int 16h

    ; Restore text mode
    mov ax, 0003h
    int 10h

    ; Exit to DOS
    mov ax, 4C00h
    int 21h

end start