.MOdel small
.stack 100h
.data
msg db "Enter a text: $"
max_len db 100
str_len db ?
string db 100 DUP('$')
row db 3
col db 10
.code
main proc far
mov ax , @data
mov ds , ax 

;clear screen
mov ax , 0600h
mov bx , 0700h
mov cx , 0000h
mov dx , 184fh
int 10h

;display msg
lea dx , msg
mov ah , 09h
int 21h

;asked input
lea dx , max_len
mov ah , 0Ah
int 21h

;made the blue rectangle(window)
mov ax , 0600h ; scrollup
mov bx , 1700h ; blue bg 
mov cx , 0310h ; from 03,10
mov dx , 1420h ; to 14 , 20  remember max is : 184F
int 10h

; set cursor to the buttom left
mov ah , 02h
mov bh , 00h ; page number 
mov dx, 1410h ; set cursor to 14 , 10 (position)
int 10h

; print at the cursor
lea dx , string
mov ah , 09h
int 21h

mov ah , 4ch
int 21h

main endp
end main