    .text
    .global main

main:
    bl lcd_init          // inicializa LCD
    bl menu_operaciones  // llama el menú principal
    mov x0, #0
    ret
