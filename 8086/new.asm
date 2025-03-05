.MODEL SMALL
.STACK 100H
.DATA
   
.CODE
main PROC
    ; Initialize data segment
    mov ax, @data
    mov ds, ax

   mov ax , 0005h
   
   mov cx , 0
   loop_1:
   mov dx , 0
   mov bl , 10h
   mov bh , 00h
   div Bx
   add dl , '0'
   push dx 
   inc cx 
   cmp ax , 0
    jne loop_1

loop_2:
    pop dx 
    cmp dx , '0'
    jb skip
    cmp dx , '9'
    ja skip
    mov ah , 02h
    int 21h
    jmp Exit
    Skip:
    add dx , 07H
    mov ah , 02h
    int 21h
    loop loop_2


   Exit: ; Exit program
    mov ah, 4Ch
    int 21h

main ENDP
END main