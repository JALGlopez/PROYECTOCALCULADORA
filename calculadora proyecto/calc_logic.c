#include <stdio.h>
#include <math.h>
#include "lcd_i2c.h"

// Funciones matemáticas científicas

double realizar_suma(double a, double b) { return a + b; }
double realizar_resta(double a, double b) { return a - b; }
double realizar_multiplicacion(double a, double b) { return a * b; }
double realizar_division(double a, double b) { return (b != 0) ? a / b : 0; }
double realizar_potencia(double base, double exp) { return pow(base, exp); }
double realizar_raiz(double a) { return sqrt(a); }

double realizar_seno(double a) { return sin(a * M_PI / 180.0); }
double realizar_coseno(double a) { return cos(a * M_PI / 180.0); }
double realizar_tangente(double a) { return tan(a * M_PI / 180.0); }

double realizar_ln(double a) { return log(a); }
double realizar_log10(double a) { return log10(a); }
double realizar_exp(double a) { return exp(a); }

double realizar_inverso(double a) { return 1.0 / a; }
double realizar_absoluto(double a) { return fabs(a); }

double realizar_factorial(int n) {
    if (n < 0 || n > 20) return 0;
    double r = 1;
    for (int i = 1; i <= n; i++)
        r *= i;
    return r;
}

double grados_a_radianes(double g) { return g * M_PI / 180.0; }
double radianes_a_grados(double r) { return r * 180.0 / M_PI; }
