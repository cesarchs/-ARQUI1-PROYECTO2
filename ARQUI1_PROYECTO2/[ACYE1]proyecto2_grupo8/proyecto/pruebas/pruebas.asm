.model small
.stack 100h
.data
    
    spos db "positivo$"
    sneg db "negativo$"
    val1 dw 5000
    val2 dw 0
    retorno db 0
    fin_posi db "$"
.code

    ImprimirNumero macro registro
        push ax
        push dx

        mov dl,registro
        ;ah = 2
        add dl,48
        mov ah,02h
        int 21h

        pop dx
        pop ax
    endm

    Imprimir macro cadena
        push dx
        push ax
        mov ah, 09h
        mov dx, offset cadena
        int 21h    
        pop ax
        pop dx
    endm

    Imprimir8bits macro registro
        local cualquiera,noz
        xor ax,ax
        mov al,registro
        mov cx,10
        mov bx,3
        cualquiera:
        xor dx,dx
        div cx
        push dx
        dec bx
        jnz cualquiera
        mov bx,3
        noz:
        pop dx
        ImprimirNumero dl
        dec bx
        jnz noz
    endm


    Imprimir16bits macro registro
        local cualquiera,noz
        xor ax,ax
        mov ax,registro
        mov cx,10
        mov bx,6
        cualquiera:
        xor dx,dx
        div cx
        push dx
        dec bx
        jnz cualquiera
        mov bx,6
        noz:
        pop dx
        ImprimirNumero dl
        dec bx
        jnz noz
    endm

main proc
    mov ax,@data    
    mov ds,ax
    
    

    mov ax,5000 ; dividend, low part
    ;cwd              ; sign-extend AX into DX
    mov bx, 256      ; divisor
    idiv bx          ; quotient AX = -19, remainder DX = -136

    mov val2, ax
    Imprimir16bits val2
        
    
    mov ax, 4C00H
    int 21h
main endp
end main