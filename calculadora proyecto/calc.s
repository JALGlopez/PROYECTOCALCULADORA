//------------------------------------------------------------
//  calc.s  —  Núcleo del programa en ENSAMBLADOR ARM
//  Proyecto: Calculadora Científica con Raspberry Pi + LCD I2C
//------------------------------------------------------------

    .data                       // Sección de datos en memoria RAM

menu_txt:
    .asciz "\n=== CALCULADORA CIENTIFICA ===\n"

menu_ops:
    .asciz "1) Suma\n2) Resta\n3) Multiplicacion\n4) Division\n5) Potencia\n6) Raiz\n7) Seno\n8) Coseno\n9) Tangente\n10) Salir\nOpcion: "

ask1:
    .asciz "Ingrese el primer numero: "

ask2:
    .asciz "Ingrese el segundo numero: "

ask_single:
    .asciz "Ingrese un numero: "

ask_angle:
    .asciz "Ingrese un angulo (grados): "

fmt_in:
    .asciz "%lf"

fmt_out:
    .asciz "Resultado: %.6f\n"

buffer:
    .space 32                  // Espacio para almacenar lectura de scanf()



//------------------------------------------------------------
//               SECCIÓN DE CÓDIGO (Ensamblador)
//------------------------------------------------------------
    .text
    .global main



//------------------------------------------------------------
//  main()
//  Punto de entrada del programa (ARM Assembly)
//------------------------------------------------------------
main:
    bl lcd_init                // Inicializa el LCD (función escrita en C)
    b menu_loop                // Salta al menú principal



//------------------------------------------------------------
//  MENU PRINCIPAL — TODO EN ENSAMBLADOR ARM
//------------------------------------------------------------
menu_loop:

    //--------------------------------------------------------
    // Imprime título del menú
    //--------------------------------------------------------
    adrp x0, menu_txt
    add  x0, x0, :lo12:menu_txt
    bl printf

    //--------------------------------------------------------
    // Imprime lista de operaciones
    //--------------------------------------------------------
    adrp x0, menu_ops
    add  x0, x0, :lo12:menu_ops
    bl printf

    //--------------------------------------------------------
    // Lee la opción del usuario — scanf("%lf", buffer)
    //--------------------------------------------------------
    adrp x0, fmt_in
    add  x0, x0, :lo12:fmt_in

    adrp x1, buffer
    add  x1, x1, :lo12:buffer

    bl scanf
    ldr d0, [x1]               // d0 = opción ingresada



//------------------------------------------------------------
//  VALIDAR SI EL USUARIO QUIERE SALIR
//------------------------------------------------------------
    fmov d1, #10.0
    fcmp d0, d1
    beq end_program            // Si opción = 10 → salir



//------------------------------------------------------------
//  COMPARACIÓN PARA ELEGIR OPERACIONES
//------------------------------------------------------------
    // == 1) SUMA ==
    fmov d1, #1.0
    fcmp d0, d1
    beq op_suma

    // == 2) RESTA ==
    fmov d1, #2.0
    fcmp d0, d1
    beq op_resta

    // == 3) MULTIPLICACIÓN ==
    fmov d1, #3.0
    fcmp d0, d1
    beq op_mult

    // == 4) DIVISIÓN ==
    fmov d1, #4.0
    fcmp d0, d1
    beq op_div

    // == 5) POTENCIA ==
    fmov d1, #5.0
    fcmp d0, d1
    beq op_pow

    // == 6) RAÍZ ==
    fmov d1, #6.0
    fcmp d0, d1
    beq op_sqrt

    // == 7) SENO ==
    fmov d1, #7.0
    fcmp d0, d1
    beq op_sin

    // == 8) COSENO ==
    fmov d1, #8.0
    fcmp d0, d1
    beq op_cos

    // == 9) TANGENTE ==
    fmov d1, #9.0
    fcmp d0, d1
    beq op_tan



//------------------------------------------------------------
//       RUTINAS DE OPERACIONES — TODAS EN ENSAMBLADOR
//------------------------------------------------------------

//------------------------------------------------------------
//  SUMA
//------------------------------------------------------------
op_suma:
    bl read_two_values         // Lee d2 y d3
    fadd d4, d2, d3            // d4 = d2 + d3
    b print_result             // Imprimir resultado


//------------------------------------------------------------
//  RESTA
//------------------------------------------------------------
op_resta:
    bl read_two_values
    fsub d4, d2, d3
    b print_result


//------------------------------------------------------------
//  MULTIPLICACIÓN
//------------------------------------------------------------
op_mult:
    bl read_two_values
    fmul d4, d2, d3
    b print_result


//------------------------------------------------------------
//  DIVISIÓN
//------------------------------------------------------------
op_div:
    bl read_two_values
    fdiv d4, d2, d3
    b print_result


//------------------------------------------------------------
//  POTENCIA — usa pow() en C pero llamada en ensamblador
//------------------------------------------------------------
op_pow:
    bl read_two_values
    fmov x0, d2                // base
    fmov x1, d3                // exponente
    bl realizar_potencia       // función C → retorna d0
    fmov d4, d0
    b print_result


//------------------------------------------------------------
//  RAÍZ — sqrt(x)
//------------------------------------------------------------
op_sqrt:
    bl read_one_value
    bl realizar_raiz
    fmov d4, d0
    b print_result


//------------------------------------------------------------
//  SENO — sin(grados)
//------------------------------------------------------------
op_sin:
    bl read_one_value
    bl realizar_seno
    fmov d4, d0
    b print_result


//------------------------------------------------------------
//  COSENO
//------------------------------------------------------------
op_cos:
    bl read_one_value
    bl realizar_coseno
    fmov d4, d0
    b print_result


//------------------------------------------------------------
//  TANGENTE
//------------------------------------------------------------
op_tan:
    bl read_one_value
    bl realizar_tangente
    fmov d4, d0
    b print_result



//------------------------------------------------------------
//      LECTURA DE VALORES — USANDO scanf EN ENSAMBLADOR
//------------------------------------------------------------

//------------------------------------------------------------
//  LEE 1 VALOR → retorna en d2
//------------------------------------------------------------
read_one_value:

    adrp x0, ask_single
    add  x0, x0, :lo12:ask_single
    bl printf                   // imprimir texto

    adrp x0, fmt_in
    add  x0, x0, :lo12:fmt_in

    adrp x1, buffer
    add  x1, x1, :lo12:buffer

    bl scanf
    ldr d2, [x1]                // d2 = valor ingresado
    ret



//------------------------------------------------------------
//  LEE 2 VALORES → retorna d2 y d3
//------------------------------------------------------------
read_two_values:

    // Primer número
    adrp x0, ask1
    add  x0, x0, :lo12:ask1
    bl printf

    adrp x0, fmt_in
    add  x0, x0, :lo12:fmt_in

    adrp x1, buffer
    add  x1, x1, :lo12:buffer
    bl scanf
    ldr d2, [x1]

    // Segundo número
    adrp x0, ask2
    add  x0, x0, :lo12:ask2
    bl printf

    adrp x0, fmt_in
    add  x0, x0, :lo12:fmt_in

    adrp x1, buffer
    add  x1, x1, :lo12:buffer
    bl scanf
    ldr d3, [x1]

    ret



//------------------------------------------------------------
//  IMPRIMIR RESULTADO EN TERMINAL Y LCD
//------------------------------------------------------------
print_result:

    //--------------------------------------------------------
    // Mostrar en terminal
    //--------------------------------------------------------
    adrp x0, fmt_out
    add  x0, x0, :lo12:fmt_out
    fmov x1, d4
    bl printf

    //--------------------------------------------------------
    // Mostrar en LCD
    //--------------------------------------------------------
    bl lcd_clear

    adrp x0, buffer
    add  x0, x0, :lo12:buffer

    fmov x1, d4
    bl double_to_str            // Convierte double → texto

    adrp x0, buffer
    add  x0, x0, :lo12:buffer
    bl lcd_print

    b menu_loop                 // Regresa al menú



//------------------------------------------------------------
//               FIN DEL PROGRAMA
//------------------------------------------------------------
end_program:
    bl lcd_clear
    mov x0, #0
    ret
