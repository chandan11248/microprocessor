TITLE MUL_TABLE(EXE) display multiplicaiton table
.model small 
.stack 32
.data
nl db 0dh,0ah,"$"
num dw 0
multx db " x ","$"
multe db " = ","$"
.code
main proc far
mov ax,@DATA
mov ds,ax
;-----------------------------

call cinx

mov dx,offset nl
mov ax,0900H
int 21H

mov cx,10
mov bx,1
l1:
mov ax,num
call coutx

mov ax,0900H
mov dx,offset multx
int 21H

mov ax,bx
call coutx

mov ax,0900H
mov dx,offset multe
int 21H

mov ax,num
mul bl
call coutx
mov ax,0900H
mov dx,offset nl
int 21H
inc bx
cmp bx,11
jne l1


;-------------------------------
mov ax,4C00H
int 21H
main endp

cinx proc
xor bx,bx
xor cx,cx
mov dl,10
cinxloop:
mov ax,0100h
int 21H
cmp al,0dh
je retcinx
sub al,30H
mov cl,al
mov ax,bx
mul dl
mov bx,ax
add bx,cx
jmp cinxloop
retcinx:
mov num,bx
RET
cinx endp


coutx proc
mov dx,0
div cx
add dx,30H
push dx
cmp ax,0
JE retcoutx
call coutx
retcoutx:
pop dx
mov ax,0200h
int 21H
RET
coutx endp

end main