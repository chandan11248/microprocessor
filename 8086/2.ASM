.model SMALL
.STACK 100H
.data 
MSG1 db 'sum of numbers between 30 and 100 :$'  
sum dw 0
count dw 10
table db 45,60,75,155,130,90,200,120,50,150
.code 
main proc
mov ax,@data    
mov ds,ax
lea si,table
mov cx,count
mov ax,0000h
sum_loop:
mov bl,[si]
cmp bl,30
jbe skip 
cmp bl,100
jae skip
add al,bl
adc ah,0
mov sum,ax
skip:
inc si
loop sum_loop   
 mov ah,02h
mov dl,sum
int 21h
mov ah,4ch
int 21h
main endp
end main



