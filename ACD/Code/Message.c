#include <16f877a.h>
#fuses hs, nowdt
# use delay (clock=4M)
# include <lcd.c>

int A=1;
void main()
{
    lcd_init();
    set_tris_A(0x00);
    set_tris_B(0xFF);
    set_tris_C(0x00);
    output_A(0x00);
    output_C(0x00);
    set_tris_d(0);
    lcd_gotoxy (1,1); 
    printf(lcd_putc, "AutomaticCapsule"); 
    lcd_gotoxy (1,2); 
    printf(lcd_putc, "Dispenser");
    delay_ms(4000); 
    printf(lcd_putc,"\f"); 
    do{
        if(!input(pin_B0)==1){
            A--;
            delay_ms(10);
        }
        if(!input(pin_B1)==1){
            A++;
            delay_ms(10);
        }

        if(A>3 && A==0)
            A=1;
        if(A==1){
            printf(lcd_putc,"\f");
            lcd_gotoxy (1,1);
            printf(lcd_putc,"Cual activar");
            lcd_gotoxy (1,2);
            printf(lcd_putc,"1.A*");
            lcd_gotoxy (6,2);
            printf(lcd_putc,"2.B");
            lcd_gotoxy (11,2);
            printf(lcd_putc,"3.C");
            delay_ms(500);
 
        if(!input(pin_B2)==1)
            output_high(pin_A0);
        
        if(!input(pin_B3)==1)
            output_low(pin_A0);
        }
        if(A==2){
            printf(lcd_putc,"\f");
            lcd_gotoxy (1,1);
            printf(lcd_putc,"Cual activar");
            lcd_gotoxy (1,2);
            printf(lcd_putc,"1.A");
            lcd_gotoxy (6,2);
            printf(lcd_putc,"2.B*");
            lcd_gotoxy (11,2);
            printf(lcd_putc,"3.C");
            delay_ms(500);
            if(!input(pin_B2)==1)
                output_high(pin_A1);
            
            if(!input(pin_B3)==1)
                output_low(pin_A1);
            
        }

        if(A==3){
            printf(lcd_putc,"\f");
            lcd_gotoxy (1,1);
            printf(lcd_putc,"Cual activar");
            lcd_gotoxy (1,2);
            printf(lcd_putc,"1.A");
            lcd_gotoxy (6,2);
            printf(lcd_putc,"2.B");
            lcd_gotoxy (11,2);
            printf(lcd_putc,"3.C*");
            delay_ms(500);

            if(!input(pin_B2)==1)
                output_high(pin_A2);
            
            if(!input(pin_B2)==1)
                output_low(pin_A2);
 
        }
        do{
            output_high(pin_A3);
        }while(!input(pin_B4)==1);
 
        do{
            output_high(pin_A4);
            }while (!input(pin_B5)==1);
        do{
            output_high(pin_A5);
        }while(!input(pin_B6)==1); 
 
    }while(true);
 }