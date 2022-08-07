#include <16f877a.h>
#fuses hs, nowdt
# use delay (clock=4M)
/*
# define lcd_rs_pin pin_b0 // esto es en caso de que yo quiero especificar los pines que yo quiero 
utilizar
# define lcd_rw_pin pin_b1
# define lcd_enable_pin pin_b2
# define lcd_data4 pin_b4
# define lcd_data5 pin_b5
# define lcd_data6 pin_b6
# define lcd_data7 pin_b7
*/
# include <lcd.c>
void main (){
    set_tris_d(0); // esto es si en caso que yo qiero po ner solo ines D COMO saida
    lcd_init();
    while (true){
        lcd_gotoxy (1,1); //Uvicamos la palabra en la primera fila y la primera columna
        printf(lcd_putc, "AutomaticCapsule"); // manifestamos la palabra en nuestro lcd
        lcd_gotoxy (1,2); //Uvicamos la palabra en la segunda fila y la primera columna
        printf(lcd_putc, "Dispenser");
        delay_ms(8000); // Le damos un retardo de 500 ms
        lcd_putc("\f"); // borramos la palabra para entrar a otra instruccion
        for (int car = 0;car<=16;car++){ 
            lcd_gotoxy(car,1);
            printf(lcd_putc, "PANDILLA");
            delay_ms(500);
            lcd_putc("\f");
        }
        for (car=16;car>=1;Car--){
            lcd_gotoxy(car,1);
            printf(lcd_putc, "PANDILLA");
            delay_ms(500);
            lcd_putc("\f");
        }
    }
}
