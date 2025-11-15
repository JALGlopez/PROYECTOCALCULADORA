#include <stdio.h>
#include <unistd.h>
#include "lcd_i2c.h"

extern int i2c_init(int);
extern void i2c_write_byte(unsigned char);

#define LCD_ADDR 0x27
#define LCD_BACKLIGHT 0x08
#define ENABLE 0x04

void lcd_pulse(unsigned char data) {
    i2c_write_byte(data | ENABLE | LCD_BACKLIGHT);
    usleep(500);
    i2c_write_byte((data & ~ENABLE) | LCD_BACKLIGHT);
    usleep(500);
}

void lcd_write4(unsigned char data) {
    i2c_write_byte(data | LCD_BACKLIGHT);
    lcd_pulse(data);
}

void lcd_cmd(unsigned char cmd) {
    lcd_write4(cmd & 0xF0);
    lcd_write4((cmd << 4) & 0xF0);
}

void lcd_print(const char *s) {
    while (*s) {
        unsigned char c = *s++;
        lcd_write4((c & 0xF0) | 1);
        lcd_pulse((c << 4) | 1);
    }
}

void lcd_clear() {
    lcd_cmd(0x01);
    usleep(2000);
}

void lcd_set_line2() {
    lcd_cmd(0xC0);
}

void lcd_init() {
    i2c_init(LCD_ADDR);

    lcd_write4(0x30); usleep(5000);
    lcd_write4(0x30); usleep(200);
    lcd_write4(0x30);
    lcd_write4(0x20);

    lcd_cmd(0x28);
    lcd_cmd(0x0C);
    lcd_cmd(0x06);
    lcd_clear();
}

void double_to_str(double val, char *buf) {
    sprintf(buf, "%.6f", val);
}
