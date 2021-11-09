;-----------------------------------------------------------------------------------------------------------------------------
;   IMPRIMIR CADENA
;-----------------------------------------------------------------------------------------------------------------------------    
Imprimir macro cadena
    push dx
    push ax
    mov ah, 09h
    mov dx, offset cadena
    int 21h    
    pop ax
    pop dx
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   IMPRIMIR NÚMERO
;-----------------------------------------------------------------------------------------------------------------------------    
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


;-----------------------------------------------------------------------------------------------------------------------------
;   IMPRIMIR 8 BITS
;-----------------------------------------------------------------------------------------------------------------------------    
Imprimir8bits macro registro
    local cualquiera,noz,dig2,dig22
    push ax
    push bx
    push cx

    xor ax,ax
    mov al,registro
    mov cx,10
    
    cmp registro,10
    jae dig2
    mov bx,1
    jmp cualquiera
    dig2:    
    mov bx,2

    cualquiera:
    xor dx,dx
    div cx
    push dx
    dec bx
    jnz cualquiera

    cmp registro,10
    jae dig22
    mov bx,1
    jmp noz
    dig22:        
    mov bx,2    

    noz:
    pop dx
    ImprimirNumero dl
    dec bx
    jnz noz

    pop cx
    pop bx
    pop ax
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   IMPRIMIR 16 BITS
;-----------------------------------------------------------------------------------------------------------------------------    
Imprimir16bits macro registro
    local cualquiera,noz,dig2,dig3,dig5,dig22,dig23,dig25
    xor ax,ax
    mov ax,registro
    mov cx,10

    cmp registro,10
    jae dig2
    mov bx,1
    jmp cualquiera
    dig2:
    cmp registro,100
    jae dig3
    mov bx,2
    jmp cualquiera
    dig3:
    cmp registro,1000
    jae dig5
    mov bx,3
    jmp cualquiera
    dig5:
    mov bx,5
    cualquiera:
    xor dx,dx
    div cx
    push dx
    dec bx
    jnz cualquiera
    
    cmp registro,10
    jae dig22
    mov bx,1
    jmp noz
    dig22:
    cmp registro,100
    jae dig23
    mov bx,2
    jmp noz
    dig23:
    cmp registro,1000
    jae dig25
    mov bx,3
    jmp noz
    dig25:
    mov bx,5

    noz:
    pop dx
    ImprimirNumero dl
    dec bx
    jnz noz
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   IMPRIMIR CON SIGNO
;----------------------------------------------------------------------------------------------------------------------------- 
Imprimir16ConSigno macro valor
    local negat, pos, irse    
        
    cmp valor,32768
    jnc negat
    jmp pos

    negat:
        Imprimir menos
        neg valor
        Imprimir16bits valor
        jmp irse
    pos:        
        Imprimir16bits valor
    irse:
endm



;-----------------------------------------------------------------------------------------------------------------------------
;   IMPRIMIR CON MENOS Y MÁS
;----------------------------------------------------------------------------------------------------------------------------- 
Imprimir16ConMasyMenos macro valor
    local negat, pos, irse    
        
    cmp valor,32768
    jnc negat
    jmp pos

    negat:
        Imprimir menos
        neg valor
        Imprimir16bits valor
        jmp irse
    pos:
        Imprimir mas        
        Imprimir16bits valor
    irse:        
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   IMPRIMIR 8 BITS CON MENOS Y MÁS
;----------------------------------------------------------------------------------------------------------------------------- 
Imprimir8ConMasyMenos macro valor
    local negat, pos, irse    
        
    cmp valor,128
    jnc negat
    jmp pos

    negat:
        Imprimir menos
        neg valor
        Imprimir8bits valor
        jmp irse
    pos:
        Imprimir mas        
        Imprimir8bits valor
    irse:        
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   PARSE DE 8 A 16 BITS
;-----------------------------------------------------------------------------------------------------------------------------
Parse8a16 macro valor, variable
    local negat,pos,irse,ciclo,aumentar,negar,irse2
    push ax
    push bx

    mov ax,0
    mov bl,0
    mov flag_negativo,0

    cmp valor,127
    jnc negat
    jmp pos

    negat:
        mov flag_negativo,1
        neg valor
    pos:
        ciclo:
            cmp valor,bl
            jne aumentar
            jmp irse
        aumentar:
            inc ax
            inc bl
            jmp ciclo
    irse:
        mov variable,ax
        cmp flag_negativo,1
        je negar
        jmp irse2
    negar:
        neg variable
    irse2:
    pop bx
    pop ax
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   LIMPIAR VARIABLE
;-----------------------------------------------------------------------------------------------------------------------------    
LimpiarVariable macro array
    local ciclo
    push si
    mov si,0
    ciclo:
        mov array[si],'$'
        inc si
        cmp array[si],'$'
        jne ciclo
    pop si
endm



;-----------------------------------------------------------------------------------------------------------------------------
;   ES NUMERO UN CHAR?
;-----------------------------------------------------------------------------------------------------------------------------    
EsNumero macro char
    local y, es_num, no_num, fin
    mov flag_numero,0
    ;si char >= '0' and char <= '9'
    cmp char, '0'
    jae y
    jmp no_num
    y:
        cmp char, '9'
        jbe es_num
        jmp no_num

    es_num:
        mov flag_numero,1
        jmp fin
    no_num:
        mov flag_numero,0        
    fin:
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   ES UN EXPONENTE EL CHAR?
;-----------------------------------------------------------------------------------------------------------------------------    
EsExponente macro char
    local y, es_num, no_num, fin
    mov flag_exp,0
    ;if char >= '0' and char <= '9'
    cmp char, '1'
    jae y
    jmp no_num
    y:
        cmp char, '4'
        jbe es_num
        jmp no_num
    es_num:
        mov flag_exp,1
        jmp fin
    no_num:
        mov flag_exp,0        
    fin:
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   AGREGAR 00H
;-----------------------------------------------------------------------------------------------------------------------------    
Agregar00H macro str
    local ciclo
    push si
    mov si,0
    ciclo:
        inc si
        cmp str[si],'$'
        jne ciclo
    mov str[si],00h
    pop si
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   CARGAR ARCHIVO
;-----------------------------------------------------------------------------------------------------------------------------    
CargarArchivo macro ruta, handle, contenedor, cantidad
    LimpiarVariable contenedor
    Agregar00H ruta
    OpenFile ruta,handle
    ReadFile handle,contenedor,cantidad
    CloseFile handle
    SepararFunciones contenedor
    Imprimir msg_archivo_bien
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   COMPROBAR TÉRMINO
;-----------------------------------------------------------------------------------------------------------------------------    
ComprobarTermino macro termino
    local negativo,variable, numero, numero2, seguir2, exponente, error,bien, fin_ct, fin_cadena
    push si

    mov error_termino,0
    mov si,0    

    cmp termino[si],'-'
    je negativo
    cmp termino[si],'x'
    je variable
    EsNumero termino[si]
    cmp flag_numero,1
    je numero
    jmp error

    negativo:
        inc si
        cmp termino[si],'x'
        je variable
        EsNumero termino[si]
        cmp flag_numero,1
        je numero
        jmp error
    variable:
        inc si
        cmp termino[si],'^'
        je exponente
        jmp fin_ct
    exponente:
        inc si
        EsExponente termino[si]
        cmp flag_exp,1
        je fin_cadena
        jmp error
    fin_cadena:
        inc si
        cmp termino[si],'$'
        je fin_ct
        jmp error
    numero:
        inc si
        cmp termino[si],'x'
        je variable
        EsNumero termino[si]
        cmp flag_numero,1
        je numero2
        jmp fin_cadena
    numero2:
        inc si
        cmp termino[si],'x'
        je variable
        jmp fin_cadena
    error:        
        mov error_termino,1
    fin_ct:
        pop si
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   SEPARAR FUNCIÓN POR TÉRMINOS
;-----------------------------------------------------------------------------------------------------------------------------    
SepararTerminos macro funcion
    local ciclo, seguir,seguir2, negativo, termino, errorxd,finxd
    push si
    push di
    push ax

    mov si,0
    mov di,0    
    ciclo:
        cmp funcion[si],'-'
        je negativo
        cmp funcion[si],'+'
        je termino
    seguir:
        mov al,funcion[si]
        mov var_termino[di],al ;GLOBAL
        inc di
        inc si
        cmp funcion[si],'$'
        jne ciclo
        jmp termino
    negativo:
        cmp var_termino[0],'$'
        je seguir
        dec si
    termino:        
        ComprobarTermino var_termino
        cmp error_termino,0
        je seguir2
        mov error_funcion,1 ;global
    seguir2:
        LimpiarVariable var_termino
        mov di,0
        inc si       
        cmp funcion[si],'$'
        jne ciclo
    finxd:
        pop ax
        pop di
        pop si
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   SEPARAR FUNCIONES POR ';'
;-----------------------------------------------------------------------------------------------------------------------------
SepararFunciones macro texto
    local ciclo, seguir,seguir2,seguir3,funcion
    push si
    push di
    push ax

    mov si,0
    mov di,0
    ciclo:  
        mov error_funcion,0
        ;IGNORAR \n y \r
        cmp texto[si],10 ; '\n'
        je seguir
        cmp texto[si],13 ; '\r'
        je seguir
                
        cmp texto[si],59 ; ';'
        je funcion

        mov al,texto[si]
        mov var_funcion[di],al
        inc di
    seguir:
        inc si                
        cmp texto[si],'$'
        jne ciclo
    funcion:        
        SepararTerminos var_funcion
        cmp error_funcion,1
        je seguir2
        GuardarFuncion var_funcion
    seguir2:
        LimpiarVariable var_funcion
        mov di,0
        inc si
        cmp texto[si],'$'
        jne ciclo
    pop ax
    pop di
    pop si
endm

;-----------------------------------------------------------------------------------------------------------------------------
;   GUARDAR FUNCIÓN
;-----------------------------------------------------------------------------------------------------------------------------
GuardarFuncion macro funcion    
    local s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,nohay,exit
    cmp func_1[0],'$'
    jne s2
    Copiar func_1,funcion
    jmp exit
    s2:
        cmp func_2[0],'$'
        jne s3
        Copiar func_2,funcion
        jmp exit
    s3:
        cmp func_3[0],'$'
        jne s4
        Copiar func_3,funcion
        jmp exit
    s4:
        cmp func_4[0],'$'
        jne s5
        Copiar func_4,funcion
        jmp exit
    s5:
        cmp func_5[0],'$'
        jne s6
        Copiar func_5,funcion
        jmp exit
    s6:
        cmp func_6[0],'$'
        jne s7
        Copiar func_6,funcion
        jmp exit
    s7:
        cmp func_7[0],'$'
        jne s8
        Copiar func_7,funcion
        jmp exit
    s8:
        cmp func_8[0],'$'
        jne s9
        Copiar func_8,funcion
        jmp exit
    s9:
        cmp func_9[0],'$'
        jne s10
        Copiar func_9,funcion
        jmp exit
    s10:
        cmp func10[0],'$'
        jne s11
        Copiar func10,funcion
        jmp exit
    s11:
        cmp func11[0],'$'
        jne s12
        Copiar func11,funcion
        jmp exit
    s12:
        cmp func12[0],'$'
        jne s13
        Copiar func12,funcion
        jmp exit
    s13:
        cmp func13[0],'$'
        jne s14
        Copiar func13,funcion
        jmp exit
    s14:
        cmp func14[0],'$'
        jne s15
        Copiar func14,funcion
        jmp exit
    s15:
        cmp func15[0],'$'
        jne s16
        Copiar func15,funcion
        jmp exit
    s16:
        cmp func16[0],'$'
        jne s17
        Copiar func16,funcion
        jmp exit
    s17:
        cmp func17[0],'$'
        jne s18
        Copiar func17,funcion
        jmp exit
    s18:
        cmp func18[0],'$'
        jne s19
        Copiar func18,funcion
        jmp exit
    s19:
        cmp func19[0],'$'
        jne s20
        Copiar func19,funcion
        jmp exit
    s20:
        cmp func20[0],'$'
        jne nohay
        Copiar func20,funcion
        jmp exit
    nohay:
        Imprimir msg_nohay
    exit:    
endm

;-----------------------------------------------------------------------------------------------------------------------------
;   COPIAR FUNCIÓN
;-----------------------------------------------------------------------------------------------------------------------------
Copiar macro var1, var2
    local More
    push si
    push di
    push ax
    mov di, 0
    mov si, 0
    More:
        mov al, var2[di]
        mov var1[si], al
        inc si
        inc di
        cmp var2[di], "$"
        jne More
    pop ax    
    pop di
    pop si    
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   IMPRIMIR FUNCIÓN
;-----------------------------------------------------------------------------------------------------------------------------
ImprimirFunc macro funcion
    local vacio, exit
    cmp funcion[0],'$'
    je vacio
    Imprimir funcion
    jmp exit
    vacio:
    Imprimir msg_vacio
    exit:
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   AGREGAR A LISTA
;-----------------------------------------------------------------------------------------------------------------------------    
AgregarLista macro array, valor
    local ciclo, compar
    push si
    push cx
    mov si,0
    jmp compar
    ciclo:
        inc si
    compar:
        cmp array[si],'$'
        jne ciclo
    
    mov cl,valor
    mov array[si],cl

    pop cx
    pop si
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   COMPROBAR TÉRMINO
;-----------------------------------------------------------------------------------------------------------------------------    
LeerTermino macro termino
    local negativo,variable, numero, numero2, seguir2, exponente, error,bien, fin_ct, fin_cadena,seg_var,finalizar
    push si
    push ax
    push bx

    mov flag_negativo,0
    mov error_termino,0
    mov si,0    

    mov var_coef,0
    mov var_exp,0

    cmp termino[si],'-'
    je negativo
    cmp termino[si],'x'
    je variable
    EsNumero termino[si]
    cmp flag_numero,1
    je numero
    jmp error

    negativo:
        mov flag_negativo,1
        inc si
        cmp termino[si],'x'
        je variable
        EsNumero termino[si]
        cmp flag_numero,1
        je numero
        jmp error
    variable:
        cmp var_coef,0
        jne seg_var
        mov var_coef,1
    seg_var:
        inc si
        cmp termino[si],'^'
        je exponente
        
        cmp var_exp,0
        jne fin_ct
        mov var_exp,1    
        jmp fin_ct
    exponente:
        inc si
        mov al, termino[si]
        sub al, 48
        add var_exp,al
        EsExponente termino[si]
        cmp flag_exp,1
        je fin_cadena
        jmp error
    fin_cadena:
        inc si
        cmp termino[si],'$'
        je fin_ct
        jmp error
    numero:
        mov al, termino[si]
        sub al, 48
        mov var_coef,al
        inc si
        cmp termino[si],'x'
        je variable
        EsNumero termino[si]
        cmp flag_numero,1
        je numero2    
        jmp fin_cadena
    numero2:        
        ;MULTIPLICAR *10 EL NÚMERO ANTERIOR
        mov al, var_coef
        mov bl, 10d
        mul bl
        mov var_coef, al
        ;SUMARLE EL NUEVO NUMERO
        mov al, termino[si]
        sub al, 48
        add var_coef,al

        inc si
        cmp termino[si],'x'
        je variable
        cmp termino[si],'$'
        je fin_ct    
    error:        
        mov error_termino,1
    fin_ct:               
        cmp flag_negativo,1
        jne finalizar
        neg var_coef
    finalizar:            
        AgregarLista arr_exponentes, var_exp
        AgregarLista arr_coeficientes, var_coef
        pop bx
        pop ax
        pop si
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   SEPARAR FUNCIÓN POR TÉRMINOS PARA LECTURA
;-----------------------------------------------------------------------------------------------------------------------------    
SepararTerminos2 macro funcion
    local ciclo, seguir,seguir2, negativo, st_termino, errorxd,finxd,limpiarxd
    push si
    push di
    push ax

    mov si,0
    mov di,0    
    ciclo:
        cmp funcion[si],'-'
        je negativo
        cmp funcion[si],'+'
        je st_termino
    seguir:
        mov al,funcion[si]
        mov var_termino[di],al ;GLOBAL
        inc di
        inc si
        cmp funcion[si],'$'
        jne ciclo
        jmp st_termino
    negativo:
        cmp var_termino[0],'$'
        je seguir
        dec si
    st_termino:        
        cmp var_termino[0],'0'
        je limpiarxd
        LeerTermino var_termino
    limpiarxd:
        LimpiarVariable var_termino
        mov di,0
        inc si       
        cmp funcion[si],'$'
        jne ciclo
    finxd:
        pop ax
        pop di
        pop si
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   SELECCIONAR FUNCIÓN 
;-----------------------------------------------------------------------------------------------------------------------------
SeleccionarFuncion macro id
    local s2,s3,s4,s5,s6,s7,s8,s9,s10,s11,s12,s13,s14,s15,s16,s17,s18,s19,s20,nohay,exit
    push si
    mov si,0
    cmp id[si], 'A'
    jne s2
    Copiar var_funcion, func_1
    jmp exit
    s2:
        cmp id[si], 'B'
        jne s3
        Copiar var_funcion, func_2
        jmp exit
    s3:
        cmp id[si], 'C'
        jne s4
        Copiar var_funcion, func_3
        jmp exit
    s4:
        cmp id[si], 'D'
        jne s5
        Copiar var_funcion, func_4
        jmp exit
    s5:
        cmp id[si], 'E'
        jne s6
        Copiar var_funcion, func_5
        jmp exit
    s6:
        cmp id[si], 'F'
        jne s7
        Copiar var_funcion, func_6
        jmp exit
    s7:
        cmp id[si], 'G'
        jne s8
        Copiar var_funcion, func_7
        jmp exit
    s8:
        cmp id[si], 'H'
        jne s9
        Copiar var_funcion, func_8
        jmp exit
    s9:
        cmp id[si], 'I'
        jne s10
        Copiar var_funcion, func_9
        jmp exit
    s10:
        cmp id[si], 'J'
        jne s11
        Copiar var_funcion, func10
        jmp exit
    s11:
        cmp id[si], 'K'
        jne s12
        Copiar var_funcion, func11
        jmp exit
    s12:
        cmp id[si], 'L'
        jne s13
        Copiar var_funcion, func12
        jmp exit
    s13:
        cmp id[si], 'M'
        jne s14
        Copiar var_funcion, func13
        jmp exit
    s14:
        cmp id[si], 'N'
        jne s15
        Copiar var_funcion, func14
        jmp exit
    s15:
        cmp id[si], 'O'
        jne s16
        Copiar var_funcion, func15
        jmp exit
    s16:
        cmp id[si], 'P'
        jne s17
        Copiar var_funcion, func16
        jmp exit
    s17:
        cmp id[si], 'Q'
        jne s18
        Copiar var_funcion, func17
        jmp exit
    s18:
        cmp id[si], 'R'
        jne s19
        Copiar var_funcion, func18
        jmp exit
    s19:
        cmp id[si], 'S'
        jne s20
        Copiar var_funcion, func19
        jmp exit
    s20:
        cmp id[si], 'T'
        jne nohay
        Copiar var_funcion, func20
        jmp exit
    nohay:
        Imprimir msg_id_mal
    exit:
        pop si
endm



;-----------------------------------------------------------------------------------------------------------------------------
;   DERIVAR FUNCIÓN
;-----------------------------------------------------------------------------------------------------------------------------
Derivar macro coeficientes, exponentes    
    local ciclo,continuar_ciclo
    push si    
    push ax
    push bx
    mov si,0    
    ciclo:        
        cmp exponentes[si],0 ; IGNORAR CONSTANTES
        je continuar_ciclo
        ;MULTIPLICAR EXP * COEF
        mov al,coeficientes[si]
        mov bl,exponentes[si]
        imul bl        
        mov var16_coef, ax
        ;RESTAR EXP-1
        mov al,exponentes[si]
        sub al,1
        mov var_exp,al        
        Imprimir16ConMasyMenos var16_coef
        cmp var_exp,0
        je continuar_ciclo
        Imprimir equis
        Imprimir circunflejo        
        Imprimir8bits var_exp
    continuar_ciclo:        
        inc si
        cmp coeficientes[si],'$'
        jne ciclo
    pop bx
    pop ax
    pop si
endm



;-----------------------------------------------------------------------------------------------------------------------------
;   INTEGRAR FUNCIÓN
;-----------------------------------------------------------------------------------------------------------------------------
Integrar macro coeficientes, exponentes
    local ciclo,continuar_ciclo
    push si    
    push ax
    push bx
    mov si,0    
    ciclo:
        ;SUMAR 1 AL exp
        mov al,exponentes[si]
        add al,1
        mov var_exp,al        
        ;DIVIDIR COEF/(EXP+1)
        mov al,coeficientes[si]
        cbw
        mov bl,var_exp
        idiv bl
        mov var_coef, al
        Imprimir8ConMasyMenos var_coef
        Imprimir equis
        Imprimir circunflejo
        Imprimir8bits var_exp
    continuar_ciclo:
        inc si
        cmp coeficientes[si],'$'
        jne ciclo
        Imprimir mas_c
    pop bx
    pop ax
    pop si
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   SQRT 
;-----------------------------------------------------------------------------------------------------------------------------
Sqrt macro valor
    local calcular, menor, salirMayor, igual
    push ax
    push bx
    push cx    
    mov bx, valor
    xor cx, cx

    calcular:        
        mul cx
        mov ax, cx
        cmp ax, bx
        ja salirMayor
        jb menor
        jc igual 
    menor:
        inc cx
        mov ax, cx
        mul cx
        cmp ax, bx
        ja salirMayor
        je igual
        jb menor
    salirMayor:
        dec cx
        jmp igual
        
    igual: ;Resultado queda en CX :D        
        hlt
        mov var16_coef,cx
    pop cx
    pop bx
    pop ax
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   RESOLVER FUNCIÓN - LINEAL
;-----------------------------------------------------------------------------------------------------------------------------
ResolverLineal macro coeficientes   
    push si
    push ax
    push bx        
    mov var_a,0
    mov var_b,0    
    mov si,0
    
    mov al,coeficientes[si]
    mov var_a,al
    inc si
    mov al,coeficientes[si]
    mov var_b,al
    neg var_b
    ;DIVISIÓN -B/A
    mov al,var_b    
    cbw
    mov bl,var_a
    idiv bl
    mov var_coef,al
    Imprimir msg_resultado
    Imprimir8ConMasyMenos var_coef
    pop bx
    pop ax
    pop si
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   RESOLVER FUNCIÓN - CUADRÁTICA 1
;-----------------------------------------------------------------------------------------------------------------------------
ResolverCadratica1 macro coeficientes
    push si
    push ax
    push bx
    mov var_a,0
    mov var_b,0    
    mov si,0
    
    mov al,coeficientes[si]
    mov var_a,al
    inc si
    mov al,coeficientes[si]
    mov var_b,al
    neg var_b
    ;DIVISIÓN -B/A
    mov al,var_b    
    cbw
    mov bl,var_a
    idiv bl
    mov var_coef,al
    mov bl,1
    imul bl
    mov var16_coef, ax

    Sqrt var16_coef
    Imprimir msg_resultado
    Imprimir16ConMasyMenos var16_coef

    pop bx
    pop ax
    pop si
endm


;-----------------------------------------------------------------------------------------------------------------------------
;   RESOLVER FUNCIÓN - CUADRÁTICA 2
;-----------------------------------------------------------------------------------------------------------------------------
ResolverCadratica2 macro funcion
    Imprimir funcion
endm










