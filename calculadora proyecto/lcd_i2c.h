#ifndef LCD_I2C_H
#define LCD_I2C_H

void lcd_init();
void lcd_clear();
void lcd_print(const char *s);
void lcd_set_line2();
void double_to_str(double val, char *buf);

#endif
