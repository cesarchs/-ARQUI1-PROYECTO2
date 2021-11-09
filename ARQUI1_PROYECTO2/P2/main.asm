.model small
.stack 100h
.data

    msg1 db 13,10, '| CESAR LEONEL CHAMALE SICAN - 201700634 - HT2  |$'
    msg2 db 13,10, '| - DIVISIBLE                                   |$'
    msg3 db 13,10, '| - NO DIVISIBLE                                |$'
    msg4 db 13,10, '|-----------------------------------------------|$'

    saltoLinea db 13,10, "$";coloca 0A porq es el codigo ascci de salto linea y 0D porq retorna el carro
    
    array1 dw 112   ; arrays para la lista de numeros 
    array2 dw 10,5,2,5,7,63,11,21,50,60

.code      
;----------------------------------------------
	imprimir macro param	;imprimir cadenas
        push dx ;bkup de dx	
		mov ah, 09h  
	    mov dx, offset param   ;muevo a dx la etiqueta o string
	    int 21h
        call XOR_REG    ;reset de registros a,b,c,d
        pop dx ;bkup de dx	
	endm

;----------------------------------------------

    imprimir_reg macro reg	;imprimir registros	
        push dx ;bkup de dx	
		mov ah, 02h  
	    mov dx, reg   ;asigno a dx el reg 16 bits 
        ;add dx,30h  ;sumamos para q salga el numero tal cual porq en consola +-30h
	    int 21h
        call XOR_REG    ;reset de registros a,b,c,d
        pop dx ;bkup de dx	
	endm

;----------------------------------------------
    COMPARAR_ARRAYS proc   ;metodo o proc estos necesitan ret sino F          
        mov di,0; pongo 0 como contador di=0
        call XOR_REG; limpio los registros antes de operar
    
        CUERPO: ;aqui todos mis registros estan como nuevos

            imprimir_reg array1[di]

            mov Ax,array1[di] ; MOV hacia el segmento Ax 
            mov Bx,array2[di] ; MOV hacia el segmento Bx
                              ; de la posicion que toque del array segun el contador
            DIV Bx            ; hacemos el div

            cmp dl,0    ;comparo el residuo q se guarda en dl con 0
            je SON_DIVISIBLES; si si es igual a cero salta a etiqueta

            jmp NO_DIVISIBLES


            CONTINUACION:

                inc di  ;incremento di++  
                inc di  ;incremento di++   se aumenta 2 posiciones por que
			            ;el array es de una palabra (16 bits), por lo mismo
			  	        ;tiene ambas posiciones del segmento.

                ;if si en di<=20d
                cmp di,20d; di==14h
                jbe CUERPO;  di<14h

        ret
    COMPARAR_ARRAYS endp
;----------------------------------------------
    XOR_REG proc
		xor ax, ax
		xor bx, bx
		xor cx, cx
		xor dx, dx
		ret
	XOR_REG endp

SON_DIVISIBLES:
    imprimir msg2
    ;imprimir saltoLinea
    call XOR_REG
    jmp CONTINUACION
    ;ret

NO_DIVISIBLES:
    imprimir msg3
    ;imprimir saltoLinea
    call XOR_REG
    jmp CONTINUACION
    ;ret

main proc
    mov ax,@data    
    mov ds,ax

    imprimir msg4
    
    imprimir msg1
                   
    call XOR_REG 
    
    imprimir msg4

    call COMPARAR_ARRAYS

    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h

    mov ah,4ch
    int 21h

main endp
end main