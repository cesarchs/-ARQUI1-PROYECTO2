include archivos.asm
include  macros.asm
include  macros2.asm
.model small
.stack 100h
.data
    
    ;MENSAJES----------------------------------------------------------------------------------------------------------    
    msg_menu  db 13,10, '____________________Men',163,' Principal____________________'
    msg_menu1 db 13,10, '1. Ingresar Funci',162,'n'
    msg_menu2 db 13,10, '2. Cargar Archivo'
    msg_menu3 db 13,10, '3. Imprimir Funciones Ingresadas'
    msg_menu4 db 13,10, '4. Derivar Funci',162,'n'
    msg_menu5 db 13,10, '5. Integrar Funci',162,'n'
    msg_menu6 db 13,10, '6. Resolver Funci',162,'n'
    msg_menu7 db 13,10, '7. Graficar Funci',162,'n'
    msg_menu8 db 13,10, '8. Eviar a Arduino'
    msg_menu9 db 13,10, '9. Salir'
    msg_men10 db 13,10, '___________________________________________________________'
    msg_men11 db 13,10, 'Ingrese opci',162,'n: $'
    
    ln db 13,10,'$'
    menos db '-$'
    mas db '+$'
    equis db 'x$'    
    circunflejo db '^$'
    mas_c db '+C$'
    msg_escribe db 13,10, 'Escribe la funci',162,'n: $'
    msg_func_mala db 13,10, 'La funci',162,'n mal escrita.$'
    msg_func_bien db 13,10, 'La funci',162,'n ha sido guardada. :)$'
    msg_archivo_bien db 13,10, 'Archivo subido!$'
    msg_seguir db 13,10, 'Presiona enter para continuar.$'
    msg_archivo db 13,10, 'Ruta de Archivo: $'
    msg_nohay db 13,10, 'No hay espacio para la funci',162,'n$'
    msg_id_mal db 13,10, 'Id incorrecto$'
    msg_ingrese_id db 13,10, 'Ingrese id de funcion(A-T): $'
    msg_funcion_select db 13,10, 'Funcion seleccionada: $'
    msg_id db 13,10,'0: $'    
    msg_error db 'Valor ingresado err',162,'neo >:v$'
    msg_bien db 'Expresion correcta$'
    msg_error2 db 13,10,'Error en la funci',162,'n: $'
    msg_vacio db 'Espacio Libre $'
    msg_temps db 'llego:$'
    msg_derivida db 13,10,'Derivada de funci',162,'n: $'
    msg_integral db 13,10,'Integral de funci',162,'n: $'
    msg_resultado db 13,10, 'Resultado: $'
    msg_nose db 13,10,'No se hizo xd$' 
    msg_submenu0 db 13,10, 'Escojer forma de ecuaci',162,'n:'
    msg_submenu1 db 13,10, '1: ax o ax^2'
    msg_submenu2 db 13,10, '2: ax+b'
    msg_submenu3 db 13,10, '3: ax^2+b'
    msg_submenu4 db 13,10, '4: ax^2+bx+c$'
    msg_ceroxd db '00$'
    ;################################################# video ################################
    msg_noFun db 'NO EXISTE FUNCION EN MEMORIA' , '$'

    recibidoB db "recibido display", 0Ah, 0Dh, "$"
    letraRecibida db 2 dup ('$')

    ;FUNCIONES----------------------------------------------------------------------------------------------------------        
    func_1 db 30 dup('$')
    func_2 db 30 dup('$')
    func_3 db 30 dup('$')
    func_4 db 30 dup('$')
    func_5 db 30 dup('$')
    func_6 db 30 dup('$')
    func_7 db 30 dup('$')
    func_8 db 30 dup('$')
    func_9 db 30 dup('$')
    func10 db 30 dup('$')
    func11 db 30 dup('$')
    func12 db 30 dup('$')
    func13 db 30 dup('$')
    func14 db 30 dup('$')
    func15 db 30 dup('$')
    func16 db 30 dup('$')
    func17 db 30 dup('$')
    func18 db 30 dup('$')
    func19 db 30 dup('$')
    func20 db 30 dup('$')
    

    ;VARIABLES-----------------------------------------------------------------------------------------------    
    var_funcion db 30 dup('$') ; ALMACENA LA FUNCION QUE SE ESTÁ TRABANDO
    var_termino db 10 dup('$') ; ALMACENA LA TÉRMINO QUE SE ESTÁ TRABANDO
    var_bandera db 0

    vreak db '_exp$'
    var_exp db 0
    var16_exp dw 0    
    var_coef db 0    
    var16_coef dw 0
    var16_result dw 0
    var_digitos dw 0
    arr_exponentes db 15 dup('$')      ;LIMITADO A 15 TÉRMINOS
    arr_coeficientes db 15 dup('$')     ;LIMITADO A 15 TÉRMINOS
    
    var_a db 0
    var_b db 0
    var_c db 0

    ;BANDERAS BOOL-----------------------------------------------------------------------------------------------    
    error_termino db 0      ; BANDERA PARA SABER SI EL TERMINO ESTÁ CORRECTO
    error_funcion db 0      ; BANDERA PARA SABER SI LA FUNCIÓN ESTÁ CORRECTA
    flag_numero db 0        ; BANDERA PARA SABER SI UN CARACTER ES NÚMERO 
    flag_exp db 0           ; BANDERA PARA SAVER SI UN CARACTER ES EXPONENTE
    flag_funcion db 0       ; BANDERA PARA VER SI ESTÁ BIEN ESCRITA LA FUNCIÓN
    flag_negativo db 0
    
    ;ARCHIVO----------------------------------------------------------------------------------------------------------    
    var_texto_archivo db 500 dup('$')
    var_handle dw ?

    ;INPUT USUARIO----------------------------------------------------------------------------------------------------
    var_input db 30 dup('$')
    var_cmp_str db 0

.code
;-----------------------------------------------------------------------------------------------------------------------------
;                                              LIMPIAR REGISTROS
;-----------------------------------------------------------------------------------------------------------------------------
    Limpiar proc
		xor ax,ax
		xor bx,bx
		xor cx,cx
		xor dx,dx
		ret
	Limpiar endp


;-----------------------------------------------------------------------------------------------------------------------------
;                                           LIMPIAR ENTRADAS
;-----------------------------------------------------------------------------------------------------------------------------  
    LimpiarEntradas proc        
        mov si,0
        nciclo:
            mov var_input[si],'$'
            inc si
            cmp var_input[si],'$'
            jne nciclo
        mov si,0        
        ret
    LimpiarEntradas endp


;-----------------------------------------------------------------------------------------------------------------------------
;                                           IMPRIMIR FUNCIONES
;-----------------------------------------------------------------------------------------------------------------------------  
    ImprimirFunciones proc        
        mov msg_id[2],'A'
        Imprimir msg_id
        ImprimirFunc func_1

        mov msg_id[2],'B'
        Imprimir msg_id  
        ImprimirFunc func_2

        mov msg_id[2],'C'
        Imprimir msg_id
        ImprimirFunc func_3

        mov msg_id[2],'D'
        Imprimir msg_id
        ImprimirFunc func_4

        mov msg_id[2],'E'
        Imprimir msg_id
        ImprimirFunc func_5
        
        mov msg_id[2],'F'
        Imprimir msg_id
        ImprimirFunc func_6

        mov msg_id[2],'G'
        Imprimir msg_id
        ImprimirFunc func_7

        mov msg_id[2],'H'
        Imprimir msg_id
        ImprimirFunc func_8

        mov msg_id[2],'I'
        Imprimir msg_id
        ImprimirFunc func_9

        mov msg_id[2],'J'
        Imprimir msg_id
        ImprimirFunc func10

        mov msg_id[2],'K'
        Imprimir msg_id
        ImprimirFunc func11

        mov msg_id[2],'L'
        Imprimir msg_id
        ImprimirFunc func12

        mov msg_id[2],'M'
        Imprimir msg_id
        ImprimirFunc func13

        mov msg_id[2],'N'
        Imprimir msg_id
        ImprimirFunc func14

        mov msg_id[2],'O'
        Imprimir msg_id
        ImprimirFunc func15

        mov msg_id[2],'P'
        Imprimir msg_id
        ImprimirFunc func16

        mov msg_id[2],'Q'
        Imprimir msg_id
        ImprimirFunc func17

        mov msg_id[2],'R'
        Imprimir msg_id
        ImprimirFunc func18

        mov msg_id[2],'S'
        Imprimir msg_id
        ImprimirFunc func19

        mov msg_id[2],'T'
        Imprimir msg_id
        ImprimirFunc func20
        ret
    ImprimirFunciones endp

;-----------------------------------------------------------------------------------------------------------------------------
;                                              LEER LA LINEA DE ENTRDA
;-----------------------------------------------------------------------------------------------------------------------------
    LeerLinea proc        
        mov si, offset var_input
        loop_input:
            mov ah,1    ;LEER CARACTER
            int 21h
            cmp al,13   ;COMPARAR CON \n
            je concat_input
            mov [si],al ;AGREGAR A MEMORIA SI NO CUMPLE
            inc si      ;PASAR A LA SIGUIENTE CELDA
            jmp loop_input ;FIN DEL LOOP
        concat_input:
            mov di,offset var_input
        ret
    LeerLinea endp


;-----------------------------------------------------------------------------------------------------------------------------
;                                              COMANDO SALIR
;-----------------------------------------------------------------------------------------------------------------------------
    Salir proc
        mov ax, 4C00H
        int 21h
    Salir endp


;-----------------------------------------------------------------------------------------------------------------------------
;                                              INGRESAR ARCHIVO
;-----------------------------------------------------------------------------------------------------------------------------
    SubirArchivo proc
        Imprimir msg_archivo
        call LeerLinea     
        CargarArchivo var_input, var_handle, var_texto_archivo, 500
        ret
    SubirArchivo endp


;-----------------------------------------------------------------------------------------------------------------------------
;                                              INGRESAR FUNCION
;-----------------------------------------------------------------------------------------------------------------------------
    IngresarFuncion proc
        mov error_funcion,0
        Imprimir msg_escribe
        call LeerLinea
        SepararTerminos var_input
        cmp error_funcion,1
        je mostrar_error
        GuardarFuncion var_input
        Imprimir msg_func_bien
        jmp if_salir
        mostrar_error:
            Imprimir msg_func_mala
        if_salir:
            LimpiarVariable var_input
        ret
    IngresarFuncion endp


;-----------------------------------------------------------------------------------------------------------------------------
;                                              DERIVAR FUNCION
;-----------------------------------------------------------------------------------------------------------------------------
    DerivarFuncion proc        
        Imprimir msg_ingrese_id
        call LeerLinea        
        LimpiarVariable var_funcion
        SeleccionarFuncion var_input
        Imprimir msg_funcion_select
        Imprimir var_funcion

        LimpiarVariable arr_exponentes
        LimpiarVariable arr_coeficientes
        SepararTerminos2 var_funcion
        Imprimir msg_derivida
        Derivar arr_coeficientes, arr_exponentes
        ret
    DerivarFuncion endp


;-----------------------------------------------------------------------------------------------------------------------------
;                                              INTEGRAR FUNCION
;-----------------------------------------------------------------------------------------------------------------------------
    IntegrarFuncion proc        
        Imprimir msg_ingrese_id
        call LeerLinea     
        LimpiarVariable var_funcion
        SeleccionarFuncion var_input
        Imprimir msg_funcion_select
        Imprimir var_funcion

        LimpiarVariable arr_exponentes
        LimpiarVariable arr_coeficientes
        SepararTerminos2 var_funcion
        Imprimir msg_integral
        Integrar arr_coeficientes, arr_exponentes
        ret
    IntegrarFuncion endp


;-----------------------------------------------------------------------------------------------------------------------------
;                                              RESOLVER FUNCIÓN
;-----------------------------------------------------------------------------------------------------------------------------
    ResolverFuncion proc        
        Imprimir msg_ingrese_id
        call LeerLinea     
        LimpiarVariable var_funcion
        SeleccionarFuncion var_input
        Imprimir msg_funcion_select
        Imprimir var_funcion
        ;PREGUNTAR QUE TIPO DE FUNCIÓN ES
        LimpiarVariable var_input
        LimpiarVariable arr_exponentes
        LimpiarVariable arr_coeficientes
        SepararTerminos2 var_funcion 
        Imprimir msg_submenu0
        Imprimir msg_men11        
        call LeerLinea

        cmp var_input[0], '1'   ; Ax = 0 y Ax^2 = 0
        jne resfunc2
        Imprimir msg_resultado
        Imprimir msg_ceroxd
        jmp res_func_salir
        resfunc2:
            cmp var_input[0], '2' ; Ax + B = 0
            jne resfunc3
            ResolverLineal arr_coeficientes
            jmp res_func_salir
        resfunc3:
            cmp var_input[0], '3' ; Ax^2 + B = 0
            jne resfunc4
            ResolverCadratica1 arr_coeficientes
            jmp res_func_salir
        resfunc4:
            cmp var_input[0], '4' ; Ax^2 + Bx + C = 0
            jne res_func_salir
            ResolverCadratica2 arr_coeficientes
            jmp res_func_salir
        LimpiarVariable var_funcion
        
        res_func_salir:
        ret 
    ResolverFuncion endp

;-----------------------------------------------------------------------------------------------------------------------------
;                                              IMPRIMIR FUNCIÓN
;-----------------------------------------------------------------------------------------------------------------------------


    FIN_VIDEO proc 
        mov ax, 0003h
        int 10h
        mov ax,@data
        mov ds,ax
        ret
    FIN_VIDEO endp

    IMPRIMIR_FUNCION proc 
    push ax
    push bx
    push si
        xor ax,ax
        xor si,si

        Imprimir msg_ingrese_id
        call LeerLinea        
        LimpiarVariable var_funcion
        SeleccionarFuncion var_input
        Imprimir msg_funcion_select
        Imprimir var_funcion
        ;comparamos para que ya no se vaya a modo video
        mov bl, var_funcion[0]
        cmp bl, 36
        JE finGraf
        getChar

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
        

       ; cicloFuncion:
        ;mov al,var[si]
        ;posicionarCursor 1,1 ;(y,x)
        ;cmp al,36 ; 
       ;je terminioFunicion
        ;imprimirVideo al, 1111b
       ; inc si
       ; jmp cicloFuncion
        
        getChar

        call FIN_VIDEO
        ModoTexto
        jmp finfin
        finGraf:
        call FIN_VIDEO
        ModoTexto
        print msg_noFun
       ; terminioFunicion:

       finfin:
    pop si
    pop bx
    pop ax
    ret
    IMPRIMIR_FUNCION endp

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
        imprimir ln

    ESCUCHAR ENDP

;-----------------------------------------------------------------------------------------------------------------------------
;                                                   MAIN 
;-----------------------------------------------------------------------------------------------------------------------------
main proc
    mov ax,@data
    mov ds,ax

    ciclo_principal:        
        Imprimir msg_menu
        call LeerLinea
        call Limpiar

        cmp var_input[0], '1' ; INGRESAR FUNCIÓN
        jne sig2
        call IngresarFuncion
    sig2:
        cmp var_input[0], '2' ; CARGAR ARCHIVO
        jne sig3
        call SubirArchivo
    sig3:
        cmp var_input[0], '3' ; IMPRIMIR FUNCIONES GUARDADAS
        jne sig4
        call ImprimirFunciones
    sig4:
        cmp var_input[0], '4' ; DERIVAR FUNCIÓN
        jne sig5
        call DerivarFuncion
    sig5:
        cmp var_input[0], '5' ; INTEGRAR FUNCIÓN
        jne sig6
        call IntegrarFuncion
    sig6:
        cmp var_input[0], '6' ; RESOLVER FUNCIÓN
        jne sig7
        call ResolverFuncion
    sig7:
        cmp var_input[0], '7' ; GRAFICAR FUNCIÓN
        jne sig8
        ;Imprimir msg_bien
        call IMPRIMIR_FUNCION
    sig8:
        cmp var_input[0], '8' ; ENVIAR ARDUINO
        jne sig9
        Imprimir msg_nose
    sig9:
        cmp var_input[0], '9' ; SALIR XD
        jne fin_ciclo_principal
        call Salir

    fin_ciclo_principal:
        Imprimir msg_seguir    
        call LeerLinea
        call LimpiarEntradas
        jmp ciclo_principal    
main endp
end main