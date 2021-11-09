include macros2.asm

.model small
;----------------SEGMENTO DE PILA---------------------

.stack
;----------------SEGMENTO DE DATO---------------------

.data
salt db 0ah,0dh, ' ' , '$'
enc1 db 0ah,0dh, '1.) Video' ,  0ah,0dh,'2.) Salir' , '$'

var_funcion db 30 dup ('$')
var db 'x^2-3x+2' , '$'
;----------------SEGMENTO DE CODIGO---------------------

.code

IMPRIMIR_FUNCION proc 
push ax
push si
    xor ax,ax
    xor si,si

    ModoVideo
	PintarMargen 7
	;IMPRIMIR ECUACION 
	posicionarCursor 0,0 ;(y,x)
    imprimirVideo 70, 1111b     ;F 
    posicionarCursor 0,1 ;(y,x)
    imprimirVideo 85, 1111b     ;U
    posicionarCursor 0,2 ;(y,x)
    imprimirVideo 78, 1111b     ;N
    posicionarCursor 0,3 ;(y,x)
    imprimirVideo 67, 1111b     ;C
    posicionarCursor 0,4 ;(y,x)
    imprimirVideo 73, 1111b     ;I
    posicionarCursor 0,5 ;(y,x)
    imprimirVideo 79, 1111b     ;O
    posicionarCursor 0,6 ;(y,x)
    imprimirVideo 78, 1111b     ;N
    

    cicloFuncion:
    mov al,var[si]
    posicionarCursor 1,1 ;(y,x)
    cmp al,36 ; 
    je terminioFunicion
    imprimirVideo al, 1111b
    inc si
    jmp cicloFuncion
    
	getChar
	ModoTexto
    terminioFunicion:
pop si
pop ax
ret
IMPRIMIR_FUNCION endp

main proc 
	MenuPrincipal:
		print enc1
		print salt
		getChar
		cmp al, '1'
		je Video
		cmp al, '2'
		je Salir
		jmp MenuPrincipal

	Video:
        call IMPRIMIR_FUNCION
		jmp MenuPrincipal
	Salir:
		close



main endp
end main