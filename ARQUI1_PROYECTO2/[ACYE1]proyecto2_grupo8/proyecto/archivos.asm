;============= Abrir archivo===========================
OpenFile macro buffer,handler
    local erro,fini
    push ax
    push dx    
    
    mov AX,@data
    mov DS,AX
    mov ah,3dh
    mov al,02h
    lea dx,buffer
    int 21h
    ;jc Erro ; db con mensaje que debe existir en doc maestro
    mov handler,ax
    mov ax,0
    ;jmp fini
    erro:
    ;Print TItuloErrorArchivo
    mov ax,1
    fini:
    pop dx
    pop ax
endm
;============== MACRO CERRAR ARCHIVO==============
CloseFile macro handler
    push ax
    push bx
    push dx    
;mov checkopenfile,1
    mov AX,@data
    mov DS,AX
    mov ah,3eh
    mov bx,handler
    int 21h
    ;jc Error2 ; db con mensaje que debe existir en doc maestro
    pop dx
    pop bx
    pop ax
endm

;=========== MACRO LEER ARCHIVO===========
ReadFile macro handler,buffer,numbytes
    push ax
    push bx
    push cx
    push dx
    
    mov AX,@data
    mov DS,AX
    mov ah,3fh
    mov bx,handler
    mov cx,numbytes ; numero maximo de bytes a leer(para proyectos hacerlo gigante) 
    lea dx,buffer
    int 21h
    ;jc Error4 ; db con mensaje que debe existir en doc maestro

    pop dx
    pop cx
    pop bx
    pop ax
endm

; pendiente el de crear escribir
;======================== MACRO CREAR ARCHIVO (any extension) ===================
CreateFile macro buffer,handler
    push ax
    push bx
    push cx
    push dx

    mov AX,@data
    mov DS,AX
    mov ah,3ch
    mov cx,00h
    lea dx,buffer
    int 21h
    ;jc Error4
    mov bx,ax
    mov ah,3eh
    int 21h
    
    pop dx
    pop cx
    pop bx
    pop ax
endm
; ========================= MACRO ESCRIBIR EN ARCHIVO YA CREADO =================

WriteFile macro handler,buffer,numbytes
    push ax
    push bx
    push cx
    push dx

    mov AX,@data
    mov DS,AX
    mov ah,40h
    mov bx,handler
    mov cx,numbytes
    lea dx, buffer
    int 21h
    
    pop dx
    pop cx
    pop bx
    pop ax
endm