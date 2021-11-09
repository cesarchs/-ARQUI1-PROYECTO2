getChar macro ;obtener caracter
    mov ah,01h ;se guarda en al en código hexadecimal del caracter leído 
    int 21h
endm

imprimir macro param 
		mov ah, 09
		lea dx, param
		int 21h
endm

enviar macro caracter  
    mov dx, 3F8h  ;copiamos a dx el numero del puerto com1 
    mov al, caracter ;copiamos a al el caracter a mandar por el puerto 
    out dx, al ;escribimos un byte en el puerto 3f8h
endm 

.model small 

.stack 

.data 
    saltoLinea db 0Ah, 0Dh, "$"
    recibidoB db "recibido display", 0Ah, 0Dh, "$"
    letraRecibida db 2 dup ('$')

.code   

;description: procedimiento para escuchar en el puerto com1
ESCUCHAR PROC
    recibir: 
    mov dx, 3FDh ; se verifica el estado del puerto 
    in al, dx ; lee el byte 
    test al, 00000001b ; validamos que existan datos en al,
    jz  noHayDatos  ;saltamos si ZF está activada después de la operación test

    mov dx, 3F8h ; copiamos la direccion en la cual está el dato, en el com1
    in al, dx ;leemos el byte
    cmp al, '-' ;salimos 
    je fin 
    mov letraRecibida, al ; sino es guion guardamos el caracter recibido 
    imprimir letraRecibida

    noHayDatos: 
    jmp recibir 

    fin:
    imprimir saltoLinea

ESCUCHAR ENDP

main proc far 

    push ds  
    mov ax, 0
    push ax             
    mov ax, @data 
    mov ds, ax   

    menu:   
        xor ax, ax                
        xor bx, bx 
        xor dx, dx                   
        xor cx, cx               

        pedirLetra:
            getChar 
            enviar al                    
            cmp al, 0Dh ;compara con enter 
            je respuesta 

            jmp pedirLetra

        respuesta:
            call ESCUCHAR   

        jmp menu

    ret 

    main endp        
end main 