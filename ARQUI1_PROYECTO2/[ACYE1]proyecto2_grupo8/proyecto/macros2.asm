print macro cadena ;imprimir cadenas
    push ax
    push dx
    mov ax,@data
    mov ds,ax
    mov ah,09h ;Numero de funcion para imprimir cadena en pantalla
	mov dx,offset cadena ;especificamos el largo de la cadena, con la instrucción offset
	int 21h  ;ejecutamos la interrupción
    pop dx 
    pop ax      
endm 

close macro  ;cerrar el programa
    mov ah, 4ch ;Numero de función que finaliza el programa
    int 21h
endm

getChar macro ;obtener caracter
    mov ah,01h ;se guarda en al en código hexadecimal del caracter leído 
    int 21h
endm


ModoVideo macro 
	;resolucion de 320x180
	mov ah, 00h
	mov al, 13h 
	int 10h   
	mov ax, 0A000h
	mov ds, ax  ; DS = A000h (memoria de graficos).
endm 


ModoTexto macro  
	mov ah, 00h 
	mov al, 03h 
	int 10h 
endm 



PintarMargen macro color
LOCAL primera, segunda, tercera, cuarta, x, y

mov dl, color

; barra horizontal superior
; pixel (x,y) = (20,0) = 20 x 320 + 10 = 6400
 mov di, 6410
primera:
	mov [di],dl
	inc di ; para que pinte a la derecha
	cmp di, 6709 ; 20 x 320 + 319
	jne primera

 ;barra horizontal inferior
 ; (180,0) = 180*320 = 57600
 mov di, 57610
segunda:
	mov [di],dl
	inc di ; para que pinte a la derecha
	cmp di, 57909 ; 180 x 320 + 319
	jne segunda

; barra vertical izquierda
mov di , 6410 
tercera:
	mov [di],dl
	add di, 320
	cmp di, 57610
	jne tercera

; barra vertical derecha
mov di , 6709 
cuarta:

	mov [di],dl
	add di, 320
	cmp di, 57909
	jne cuarta


mov di , 32010 
x:
	mov [di],dl
	inc di 
	cmp di, 32309 
	jne x


mov di , 6560 
y:
	mov [di],dl
	add di, 320
	cmp di, 57760
	jne y


endm 

posicionarCursor macro x,y
    mov ah,02h
    mov dh,x
    mov dl,y
    mov bh,0
    int 10h
endm

imprimirVideo macro caracter, color
    mov ah, 09h
    mov al, caracter ;al guarda el valor que vamos a escribir
    mov bh, 0
    mov bl, color
    mov cx,1
    int 10h
endm

enviar macro caracter  
    mov dx, 3F8h  ;copiamos a dx el numero del puerto com1 
    mov al, caracter ;copiamos a al el caracter a mandar por el puerto 
    out dx, al ;escribimos un byte en el puerto 3f8h
endm 