//------------------------------------------------------------
//  math_arm.s — Funciones matemáticas en ensamblador ARM
//------------------------------------------------------------

    .text

    .extern pow
    .extern sqrt
    .extern sin
    .extern cos
    .extern tan
    .extern log
    .extern log10
    .extern exp
    .extern fabs

//------------------------------------------------------------
//  double realizar_suma(double a, double b)
//  Entrada: d0 = a, d1 = b
//  Salida:  d0 = a + b
//------------------------------------------------------------
    .global realizar_suma
realizar_suma:
    fadd d0, d0, d1
    ret


//------------------------------------------------------------
//  double realizar_resta(double a, double b)
//------------------------------------------------------------
    .global realizar_resta
realizar_resta:
    fsub d0, d0, d1
    ret


//------------------------------------------------------------
//  double realizar_multiplicacion(double a, double b)
//------------------------------------------------------------
    .global realizar_multiplicacion
realizar_multiplicacion:
    fmul d0, d0, d1
    ret


//------------------------------------------------------------
//  double realizar_division(double a, double b)
//  Si b == 0, regresa 0.0
//------------------------------------------------------------
    .global realizar_division
realizar_division:
    fcmp d1, #0.0
    bne 1f
    fmov d0, #0.0
    ret
1:
    fdiv d0, d0, d1
    ret


//------------------------------------------------------------
//  double realizar_potencia(double base, double exp)
//  d0 = base, d1 = exp
//------------------------------------------------------------
    .global realizar_potencia
realizar_potencia:
    // pow(base, exp)
    bl pow        // d0 = pow(d0, d1)
    ret


//------------------------------------------------------------
//  double realizar_raiz(double x)
//  d0 = x
//------------------------------------------------------------
    .global realizar_raiz
realizar_raiz:
    bl sqrt       // d0 = sqrt(d0)
    ret


//------------------------------------------------------------
//  double realizar_seno(double grados)
//  Se convierte grados → radianes y se llama sin()
//------------------------------------------------------------
    .global realizar_seno
realizar_seno:
    // rad = grados * (pi/180)
    // constante pi/180 ≈ 0.017453292519943295
    fmov d1, #0.017453292519943295
    fmul d0, d0, d1
    bl sin
    ret


//------------------------------------------------------------
//  double realizar_coseno(double grados)
//------------------------------------------------------------
    .global realizar_coseno
realizar_coseno:
    fmov d1, #0.017453292519943295
    fmul d0, d0, d1
    bl cos
    ret


//------------------------------------------------------------
//  double realizar_tangente(double grados)
//------------------------------------------------------------
    .global realizar_tangente
realizar_tangente:
    fmov d1, #0.017453292519943295
    fmul d0, d0, d1
    bl tan
    ret


//------------------------------------------------------------
//  double realizar_ln(double x)
//------------------------------------------------------------
    .global realizar_ln
realizar_ln:
    bl log
    ret


//------------------------------------------------------------
//  double realizar_log10(double x)
//------------------------------------------------------------
    .global realizar_log10
realizar_log10:
    bl log10
    ret


//------------------------------------------------------------
//  double realizar_exp(double x)
//------------------------------------------------------------
    .global realizar_exp
realizar_exp:
    bl exp
    ret


//------------------------------------------------------------
//  double realizar_inverso(double x) => 1/x
//------------------------------------------------------------
    .global realizar_inverso
realizar_inverso:
    fcmp d0, #0.0
    bne 1f
    fmov d0, #0.0
    ret
1:
    fmov d1, #1.0
    fdiv d0, d1, d0
    ret


//------------------------------------------------------------
//  double realizar_absoluto(double x)
//------------------------------------------------------------
    .global realizar_absoluto
realizar_absoluto:
    bl fabs
    ret


//------------------------------------------------------------
//  double realizar_factorial(int n)
//  Entrada: w0 = n
//  Salida:  d0 = n!  (como double)
//  Límite sugerido: n <= 20
//------------------------------------------------------------
    .global realizar_factorial
realizar_factorial:
    // Si n < 0 → 0.0
    cmp w0, #0
    bge 1f
    fmov d0, #0.0
    ret
1:
    // Si n > 20 → 0.0 (evitar overflow grande)
    cmp w0, #20
    ble 2f
    fmov d0, #0.0
    ret

2:
    // r = 1.0 (acumulador en d0)
    fmov d0, #1.0

    // i = 1 (en w1)
    mov w1, #1

3:
    cmp w1, w0
    bgt 4f

    // Convertir i (int) a double (d1)
    scvtf d1, w1
    fmul d0, d0, d1    // d0 *= i

    add w1, w1, #1
    b   3b

4:
    ret


//------------------------------------------------------------
//  double grados_a_radianes(double g)
//------------------------------------------------------------
    .global grados_a_radianes
grados_a_radianes:
    // g * pi/180
    fmov d1, #0.017453292519943295
    fmul d0, d0, d1
    ret


//------------------------------------------------------------
//  double radianes_a_grados(double r)
//------------------------------------------------------------
    .global radianes_a_grados
radianes_a_grados:
    // r * 180/pi ≈ 57.29577951308232
    fmov d1, #57.29577951308232
    fmul d0, d0, d1
    ret
