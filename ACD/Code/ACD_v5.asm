; INSTITUTO POLITECNICO NACIONAL.
; CECYT 9 JUAN DE DIOS BATIZ.
;
; PROYECTO AULA. 
; LA PANDILLA MANTEQUILLA.
;
; GRUPO: 6IM3.
;
; INTEGRANTES:
; ALVARADO RODRÍGUEZ FERNANDO BRYAN
; AYALA BERNAL ISRAEL
; BARRERA CASTILLO ERICK ABRAHAM
; HERNÁNDEZ CABALLERO MAURICIO
; SÁNCHEZ MARTÍNEZ FELIPE
; VILLEGAS MONROY EMILIO
;
; FECHA DE ENTREGA DEL REPORTE:
;
; EL PROGRAMA SERÁ EL MENÚ DE NUESTRO PASTILLERO, EL
; CUAL CON UN DISPOSITIVO DE SALIDA (LCD 20x4) SE PODRÁ
; VER EL MENÚ, Y CON UN DISPOSITIVO DE ENTRADA (TECLADO
; MATRICIAL 4x4) EL USUARIO PODRÁ INTERACTUAR CON
; NUESTRO SISTEMA.
;-------------------------------------------------------------------------------------------------
;
 List p=16f877A; 
 #include "c:\Program files (x86)\Microchip\Mpasm Suite\p16f877a.inc"; 
__CONFIG _CP_OFF & _WDT_OFF & _BODEN_OFF & _PWRTE_ON & _XT_OSC & _WRT_OFF & _LVP_OFF 
& _CPD_OFF;
;--------------------------------------------------------------------------------------------------
;
; Fosc = 4 MHz.
; Ciclo de trabajo del PIC = (1/fosc)*4 = 1 µs.
; T int =(256-tmr0)*(P)*((1/4000000)*4) = 1 ms. // Tiempo de interrupción.
; tmr0=131, P=8.
; frec int = 1/ t int = 1 KHz.
;----------------------------------------------------------------------------------------------------
;
;Def. de variables del programa en RAM.
resp_w 			equ 	0x20; Registro de respaldo de w.
resp_status 	equ 	0x21; Registro de respaldo del registro de las banderas de la ALU.
res_pclath 		equ 	0x22; Registro de respaldo del registro pclath.
res_fsr 		equ 	0x23; Registro de respaldo del registro fsr. 
presc_1 		equ 	0x24; Registro del prescalador 1. .001 100
10 
presc_2 		equ 	0x25; Registro del prescalador 2. t int = t intb * presc_1 * presc_2
banderas 		equ 	0x26; Registro de las banderas del PIC.
cont_milis 		equ 	0x27; Variable utilizada para el tiempo de espera de la lcd.
cta_uniseg 		equ 	0x28; Variable utilizada para contabilizar las unidades de segundo en binario.
cta_decseg 		equ 	0x29; Variable utilizada para contabilizar las decenas de segundo en binario.
cta_unimin 		equ 	0x30; Variable utilizada para contabilizar las unidades de minuto en binario.
cta_decmin 		equ 	0x31; Variable utilizada para contabilizar las decenas de minuto en binario.
cta_unihor 		equ 	0x32; Variable utilizada para contabilizar las unidades de hora en binario.
cta_dechor 		equ 	0x33; Variable utilizada para contabilizar las decenas de hora en binario.
temporal 		equ 	0x34; Registro utilizado para llevar los valores de la cuenta a la tabla de conversión a ascii.
buffer8 		equ 	0x35; Registro utilizado para mostrar el valor de cta_dechor en la lcd.
buffer7 		equ 	0x36; Registro utilizado para mostrar el valor de cta_unihor en la lcd.
buffer5 		equ 	0x38; Registro utilizado para mostrar el valor de cta_decmin en la lcd.
buffer4 		equ 	0x39; Registro utilizado para mostrar el valor de cta_unimin en la lcd.
buffer2 		equ 	0x41; Registro utilizado para mostrar el valor de cta_decseg en la lcd.
buffer1 		equ 	0x42; Registro utilizado para mostrar el valor de cta_uniseg en la lcd.
Var_teclado 	equ 	0x43; Variable utilizada para almacenar la tecla oprimida en el puerto b.
resp_uniseg 	equ 	0x44; Variables para guardar el valor de las unidades de minuto que estableció el usuario.
resp_decseg 	equ 	0x45; Variables para guardar el valor de las unidades de minuto que estableció el usuario.
resp_unimin 	equ 	0x46; Variables para guardar el valor de las unidades de minuto que estableció el usuario.
resp_decmin 	equ 	0x47; Variables para guardar el valor de las unidades de minuto que estableció el usuario.
resp_unihor 	equ 	0x48; Variables para guardar el valor de las unidades de minuto que estableció el usuario.
resp_dechor 	equ 	0x49; Variables para guardar el valor de las unidades de minuto que estableció el usuario.
cont_segundos 	equ 	0x59; Variable que cuenta segundos.
;---------------------------------------------------------------------------------------------------
;Constantes
No_haytecla equ 0xF0; Código que pertenece al no haber oprimido ninguna tecla.
Tec_7 		equ 	0xE0; Código de la tecla 1.
Tec_8 		equ 	0xD0; Código de la tecla 2.
Tec_9 		equ 	0xB0; Código de la tecla 3.
Tec_A 		equ 	0x70; Código de la tecla A.
Tec_4 		equ 	0xE0; Código de la tecla 4.
Tec_5 		equ 	0xD0; Código de la tecla 5.
Tec_6 		equ 	0xB0; Código de la tecla 6.
Tec_1 		equ 	0xE0; Código de la tecla 7.
Tec_2 		equ 	0xD0; Código de la tecla 8.
Tec_3 		equ 	0xB0; Código de la tecla 9.
Tec_0 		equ 	0xD0; Código de la tecla 0.
Tec_ON 		equ 	0xE0; Código de la tecla ON.
Tec_igual 	equ 	0xB0; Código de la tecla =.
; banderas del registro banderas.
ban_int 	equ 	.0; Bit0 de la bandera de interrupción.
sin_bd1 	equ 	.1; Bit1 de la bandera de interrupción. 
sin_bd2 	equ 	.2; Bit2 de la bandera de interrupción.
sin_bd3 	equ 	.3; Bit3 de la bandera de interrupción.
sin_bd4 	equ 	.4; Bit4 de la bandera de interrupción.
sin_bd5 	equ 	.5; Bit5 de la bandera de interrupción.
sin_bd6 	equ 	.6; Bit6 de la bandera de interrupción.
sin_bd7 	equ 	.7; Bit7 de la bandera de interrupción.
;--------------------------------------------------------------------------------------------------
; Def. de Ptos. I/0.
;
; Puerto A.
RS_LCD		equ 	.0; Bit que controla el modo de operación de la lcd.
Enable_LCD 	equ 	.1; Bit que controla el Enable de la lcd.
Sin_UsoRA2 	equ 	.2; Bit2 sin uso del puerto a.
Sin_UsoRA3 	equ 	.3; Bit3 sin uso del puerto a.
Sin_UsoRA4 	equ 	.4; Bit4 sin uso del puerto a.
Sin_UsoRA5 	equ 	.5; Bit5 sin uso del puerto a.
;
proga equ B'111100'; Definición de la configuración de los bits del puerto A.
;
;Puerto B.
Act_Ren00 	equ 	.0; Bit para la activación del renglón 0.
Act_Ren11 	equ 	.1; Bit para la activación del renglón 1.
Act_Ren22 	equ 	.2; Bit para la activación del renglón 2.
Act_Ren33 	equ 	.3; Bit para la activación del renglón 3.
Col_1 		equ 	.4; Bit de entrada para leer el c{odigo de la tecla oprimida de la columna 1.
Col_2 		equ 	.5; Bit de entrada para leer el c{odigo de la tecla oprimida de la columna 2.
Col_3 		equ 	.6; Bit de entrada para leer el c{odigo de la tecla oprimida de la columna 3.
Col_4 		equ 	.7; Bit de entrada para leer el c{odigo de la tecla oprimida de la columna 4.
;
progb equ b'11110000'; Programación inicial del puerto B.
;
;Puerto C.
D0_LCD 		equ 	.0; Bit 0 de datos o comandos para la LCD.
D1_LCD 		equ 	.1; Bit 1 de datos o comandos para la LCD.
D2_LCD 		equ 	.2; Bit 2 de datos o comandos para la LCD.
D3_LCD 		equ 	.3; Bit 3 de datos o comandos para la LCD.
D4_LCD 		equ 	.4; Bit 4 de datos o comandos para la LCD.
D5_LCD 		equ 	.5; Bit 5 de datos o comandos para la LCD.
D6_LCD 		equ	 	.6; Bit 6 de datos o comandos para la LCD.
D7_LCD 		equ 	.7; Bit 7 de datos o comandos para la LCD.
;
progc equ b'00000000'; Programación inicial del puerto C como Entrada.
;
;Puerto D.
Activador 	equ .0; Bit que activa el dispensamiento.
Sin_UsoRD1 	equ .1; Bit1 sin uso del puerto D.
Sin_UsoRD2 	equ .2; Bit2 sin uso del puerto D.
Sin_UsoRD3 	equ .3; Bit3 sin uso del puerto D.
Sin_UsoRD4 	equ .4; Bit4 sin uso del puerto D.
Sin_UsoRD5 	equ .5; Bit5 sin uso del puerto D.
Sin_UsoRD6 	equ .6; Bit6 sin uso del puerto D.
Sin_UsoRD7 	equ .7; Bit7 sin uso del puerto D.
;
progd equ b'11111110';Definición de la configuración del puerto D.
;
; Puerto E.
Sin_UsoRE0 equ .0; Bit0 sin uso del puerto E.
Sin_UsoRE1 equ .1; Bit1 sin uso del puerto E.
Sin_UsoRE2 equ .2; Bit2 sin uso del puerto E.
;
proge equ b'111'; Definición de la configuración de los bits del puerto E.
;--------------------------------------------------------------------------------------------------
 ;=================
 ;== Vector Reset =
 ;=================
				org 0000h; Ve a la página 0 de memoria.
vec_reset 		clrf pclath; Asegura la página 0 de memoria.
				goto prog_prin; Ve a prog_prin.
;-------------------------------------------------------------------------------------------------
 ;============================
 ;== Vector de interrupción ==
 ;============================
				org 0x0004; Ve a la dirección de memoria donde se encuentra el vector de interrupción.
vec_int 		movwf resp_w; Respalda el estado del registro w.
				movf status,w; Respalda el estado del registro
				movwf resp_status; de las banderas de la ALU.
				clrf status; Borra el registro status.
				movf pclath,w; Respalda el estado
				movwf res_pclath; del registro pclath.
				clrf pclath; Borra el registro pclath.
				movf fsr,w; Respalda el estado
				movwf res_fsr; del registro fsr.
				btfsc intcon,t0if; Prueba el bit t0if, del registro intcon, brinca si está en 0.
				call rutina_int; Llama a la rutina de interrupciones.
sal_int 		movlw .131; Mueve el valor 131 en binario al registro w.
				movwf tmr0; Carga el registro tmr0 con w.
				movf res_fsr,w;Restaura el contenido
				movwf fsr; del registro fsr.
				movf res_pclath,w;Restaura el contenido
				movwf pclath; del registro pclath.
				movf resp_status,w; Respalda el contenido
				movwf status; del registro status.
				movf resp_w,w; Restaura el contenido del registro w.
				retfie; Regresa de la subrutina de interrupción.
;--------------------------------------------------------------------------------------------------
 ;==================================
 ;== Subrutina de Interrupciones ==
 ;==================================
rutina_int		incf cont_milis,f; Incrementa en 1 el contenido del registro cont_milis.
				incf presc_1,f; Incrementa en 1 el contenido del registro presc_1.
				movlw .100; Mueve el valor 1oo en binario al registro w.
				xorwf presc_1,w; OR-EXCLUSIVO entre los registros w y presc_1.
				btfsc status,z; Prueba el bit z del registro status, brinca si esta en 0.
				goto sig_int; Ve a sig_int.
				goto sal_rutint; Ve a sal_rutint.
sig_int 		clrf presc_1; Borra el contenido del registro presc_1.
				incf presc_2,f; Incrementa en 1 el contenido del registro presc_2.
				movlw .10; Mueve el valor 10 en binario al registro w.
				xorwf presc_2,w; OR-EXCLUSIVO entre los registros w y presc_2.
				btfss status,z; Prueba el bit z del registro status, brinca si esta en 1.
				goto sal_rutint; Ve a sal_rutint.
				clrf presc_1; Borra el contenido del registro presc_1.
				clrf presc_2; Borra el contenido del registro presc_2.
				incf cont_segundos,f; incrementa en 1 el contenido del registro cont_segundos.
sal_rutext 		bsf banderas,ban_int; Pon a 1 el bit ban_int del registro banderas.
sal_rutint 		bcf intcon,t0if; Pon a 0 el bit t0if del registro intcont.
				return; Regresa de la subrutina.
;--------------------------------------------------------------------------------------------------
 ;=========================================
 ;== Subrutina de Ini. de Reg. del Pic ==
 ;=========================================
prog_ini 		bsf status,RP0; Ponte en el banco 1 de ram.
				movlw 0x02; Mueve el valor 82 en hexadecimal al registro w.
				movwf option_reg ^0x80; Desabilita pullups y selecciona un prescalador de 8 al TMR0.
				movlw proga;Configura los bits del puerto A RS_LCD y Enable_LCD
				movwf trisa ^0x80; como salidas, y los demás como entradas.
				movlw progb; Configura los bits del nibble alto del puerto B
				movwf trisb ^0x80; como salidas, y los del nibble bajo como entradas.
				movlw progc; Configura los bits del puerto C
				movwf trisc ^0x80; como salidas.
				movlw progd; Configura el bit Activador del puerto D
				movwf trisd ^0x80; como salida y los demás como entradas.
				movlw proge; Configura los bits del puerto E
				movwf trise ^0x80; como salida.
				movlw 0x06; Configura los bits del puerto A y E
				movwf adcon1 ^0x80; como entradas o salidas digitales.
				bcf status,RP0; Ponte en el banco 0 de ram. 
				movlw 0xa0; Habilita el sobreflujo del TMR0
				movwf intcon; y las interrupciones globales.
				movlw .131; Activa la interrupción
				movwf tmr0; cada milisegundo.
				clrf banderas; Borra el contenido del registro banderas.
				clrf portc; Limpia el bus de datos.
				movlw 0x03; Desactiva el Enable de la LCD
				movwf porta; y ponla en modo datos.
				movlw 0x0F; Deshabilita la
				movwf portb; lectura del teclado.
				clrf resp_w; Borra el contenido del registro resp_w.
				clrf resp_status; Borra el contenido del registro resp_status.
				clrf res_pclath; Borra el contenido del registro resp_pclath.
				clrf res_fsr; Borra el contenido del registro resp_fsr.
				clrf presc_1; Borra el contenido del registro presc_1.
				clrf presc_2; Borra el contenido del registro presc_2.
				clrf banderas; Borra el contenido del registro banderas.
				clrf cont_milis; Borra el contenido del registro cont_milis.
				clrf cta_uniseg; Borra el contenido del registro cta_uniseg.
				clrf cta_decseg; Borra el contenido del registro cta_decseg.
				clrf cta_unimin; Borra el contenido del registro cta_unimin.
				clrf cta_decmin; Borra el contenido del registro cta_decmin.
				clrf cta_unihor; Borra el contenido del registro cta_unihor.
				clrf cta_dechor; Borra el contenido del registro cta_dechor.
				bcf portd,Activador; Desactiva el dispensamiento.
				return; Regresa de la subrutina.
;-----------------------------------------------------------------
;==================================================
;== Subrutina que convierte de binario a ASCII ==
;==================================================
convbin_ascii 	movf temporal,w; Convierte el valor del
				call tabla_conv; registro temporal a su codigo 
				movwf temporal; equivalente en ASCII.
				goto sal_subconvascii; Ve a sal_subconvascii.
tabla_conv 		addwf pcl,f; Suma el contenido de los registros w y pcl.
				retlw '0'; Regresa con el valor 0 en ascii en w.
				retlw '1'; Regresa con el valor 1 en ascii en w.
				retlw '2'; Regresa con el valor 2 en ascii en w.
				retlw '3'; Regresa con el valor 3 en ascii en w.
				retlw '4'; Regresa con el valor 4 en ascii en w.
				retlw '5'; Regresa con el valor 5 en ascii en w.
				retlw '6'; Regresa con el valor 6 en ascii en w.
				retlw '7'; Regresa con el valor 7 en ascii en w.
				retlw '8'; Regresa con el valor 8 en ascii en w.
				retlw '9'; Regresa con el valor 9 en ascii en w.
sal_subconvascii return; Sal de la subrutina.
;------------------------------------------------------------------------------------------------------
 ;=======================
 ;== Programa principal =
 ;=======================
prog_prin 		call prog_ini; Llama a la subrutina de Inicio.
				call ini_lcd; Llama a la subrutina de inicialización de la lcd.
inicio 			bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x81; Pon al cursor de la
				movwf portc; lcd en el digito 2.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw 'C'; Manda al bus de datos el
				movwf portc; código del caracter C en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'A'; Manda al bus de datos el
				movwf portc; código del caracter A en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'P'; Manda al bus de datos el
				movwf portc; código del caracter P en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'S'; Manda al bus de datos el
				movwf portc; código del caracter S en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'U'; Manda al bus de datos el
				movwf portc; código del caracter U en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'L'; Manda al bus de datos el
				movwf portc; código del caracter L en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'E'; Manda al bus de datos el
				movwf portc; código del caracter E en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw ' '; Manda al bus de datos el
				movwf portc; código del caracter en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'A'; Manda al bus de datos el
				movwf portc; código del caracter A en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'U'; Manda al bus de datos el
				movwf portc; código del caracter U en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'T'; Manda al bus de datos el
				movwf portc; código del caracter T en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'O'; Manda al bus de datos el
				movwf portc; código del caracter O en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'M'; Manda al bus de datos el
				movwf portc; código del caracter M en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'A'; Manda al bus de datos el
				movwf portc; código del caracter A en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'T'; Manda al bus de datos el
				movwf portc; código del caracter T en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'I'; Manda al bus de datos el
				movwf portc; código del caracter I en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'C'; Manda al bus de datos el
				movwf portc; código del caracter C en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xC5; Pon al cursor de la
				movwf portc; lcd en el digito 26.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw 'D'; Manda al bus de datos el
				movwf portc; código del caracter D en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'I'; Manda al bus de datos el
				movwf portc; código del caracter I en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'S'; Manda al bus de datos el
				movwf portc; código del caracter S en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'P'; Manda al bus de datos el
				movwf portc; código del caracter P en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'E'; Manda al bus de datos el
				movwf portc; código del caracter E en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'N'; Manda al bus de datos el
				movwf portc; código del caracter N en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'S'; Manda al bus de datos el
				movwf portc; código del caracter S en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'E'; Manda al bus de datos el
				movwf portc; código del caracter E en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'R'; Manda al bus de datos el
				movwf portc; código del caracter R en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x95; Pon al cursor de la
				movwf portc; lcd en el digito 42.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw 'P'; Manda al bus de datos el
				movwf portc; código del caracter P en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'r'; Manda al bus de datos el
				movwf portc; código del caracter r en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'e'; Manda al bus de datos el
				movwf portc; código del caracter e en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 's'; Manda al bus de datos el
				movwf portc; código del caracter s en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'i'; Manda al bus de datos el
				movwf portc; código del caracter i en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'o'; Manda al bus de datos el
				movwf portc; código del caracter o en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'n'; Manda al bus de datos el
				movwf portc; código del caracter n en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'e'; Manda al bus de datos el
				movwf portc; código del caracter e en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw ' '; Manda al bus de datos el
				movwf portc; código del caracter en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'O'; Manda al bus de datos el
				movwf portc; código del caracter O en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'N'; Manda al bus de datos el
				movwf portc; código del caracter N en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw '/'; Manda al bus de datos el
				movwf portc; código del caracter / en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'C'; Manda al bus de datos el
				movwf portc; código del caracter C en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw ' '; Manda al bus de datos el
				movwf portc; código del caracter en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'p'; Manda al bus de datos el
				movwf portc; código del caracter p en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'a'; Manda al bus de datos el
				movwf portc; código del caracter a en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'r'; Manda al bus de datos el
				movwf portc; código del caracter r en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'a'; Manda al bus de datos el
				movwf portc; código del caracter a en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xD4; Pon al cursor de la
				movwf portc; lcd en el digito 61.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw 'i'; Manda al bus de datos el
				movwf portc; código del caracter i en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'n'; Manda al bus de datos el
				movwf portc; código del caracter n en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 't'; Manda al bus de datos el
				movwf portc; código del caracter t en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'r'; Manda al bus de datos el
				movwf portc; código del caracter r en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'o'; Manda al bus de datos el
				movwf portc; código del caracter o en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'd'; Manda al bus de datos el
				movwf portc; código del caracter d en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'u'; Manda al bus de datos el
				movwf portc; código del caracter u en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'c'; Manda al bus de datos el
				movwf portc; código del caracter c en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'i'; Manda al bus de datos el
				movwf portc; código del caracter i en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'r'; Manda al bus de datos el
				movwf portc; código del caracter r en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw ' '; Manda al bus de datos el
				movwf portc; código del caracter en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'u'; Manda al bus de datos el
				movwf portc; código del caracter u en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'n'; Manda al bus de datos el
				movwf portc; código del caracter n en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw ' '; Manda al bus de datos el
				movwf portc; código del caracter en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 't'; Manda al bus de datos el
				movwf portc; código del caracter t en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'i'; Manda al bus de datos el
				movwf portc; código del caracter i en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'e'; Manda al bus de datos el
				movwf portc; código del caracter e en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'm'; Manda al bus de datos el
				movwf portc; código del caracter m en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'p'; Manda al bus de datos el
				movwf portc; código del caracter p en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'o'; Manda al bus de datos el
				movwf portc; código del caracter o en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
barre_teclado1 	bsf portb,Act_Ren00; Desactiva el renglón 0.
				nop; Sin operación.
				bsf portb,Act_Ren11; Desactiva el renglón 1.
				nop; Sin operación.
				bsf portb,Act_Ren22; Desactiva el renglón 2.
				nop; Sin operación.
				bsf portb,Act_Ren33; Desactiva el renglón 3.
				nop; Sin operación.
				bcf portb,Act_Ren33; Activa el renglón 3.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0XF0; avergiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw Tec_ON; Brinca si
				subwf Var_teclado,w; la tecla ON
				btfss status,Z; fue oprimida.
				goto barre_teclado1; Ve a barre teclado1.
				call nuevo_time; Ve a nuevo_time.
cuenta_time 	movf cta_uniseg,w; Mueve el contenido del registro
				movwf temporal; cta_uniseg al registro temporal.
				call convbin_ascii; Llama a la subrutina que convierte de binario a ascii.
				movf temporal,w; Mueve el contenido del registro
				movwf buffer1; temporal al registro buffer1.
				movf cta_decseg,w; Mueve el contenido del registro
				movwf temporal; cta_decseg al registro temporal.
				call convbin_ascii; Llama a la subrutina que convierte de binario a ascii.
				movf temporal,w; Mueve el contenido del registro
				movwf buffer2; temporal al registro buffer2.
				movf cta_unimin,w; Mueve el contenido del registro
				movwf temporal; cta_unimin al registro temporal.
				call convbin_ascii; Llama a la subrutina que convierte de binario a ascii.
				movf temporal,w; Mueve el contenido del registro
				movwf buffer4; temporal al registro buffer4.
				movf cta_decmin,w; Mueve el contenido del registro
				movwf temporal; cta_decmin al registro temporal.
				call convbin_ascii; Llama a la subrutina que convierte de binario a ascii.
				movf temporal,w; Mueve el contenido del registro
				movwf buffer5; temporal al registro buffer5.
				movf cta_unihor,w; Mueve el contenido del registro
				movwf temporal; cta_unihor al registro temporal.
				call convbin_ascii; Llama a la subrutina que convierte de binario a ascii.
				movf temporal,w; Mueve el contenido del registro
				movwf buffer7; temporal al registro buffer7.
				movf cta_dechor,w; Mueve el contenido del registro
				movwf temporal; cta_dechor al registro temporal.
				call convbin_ascii; Llama a la subrutina que convierte de binario a ascii.
				movf temporal,w; Mueve el contenido del registro
				movwf buffer8; temporal al registro buffer8.
				call muestra_time; Llama a la subrutina que muestra el tiempo en la lcd.
barre_teclado2 	bsf portb,Act_Ren00; Desactiva el renglón 0.
				nop; Sin operación.
				bsf portb,Act_Ren11; Desactiva el renglón 1.
				nop; Sin operación.
				bsf portb,Act_Ren22; Desactiva el renglón 2.
				nop; Sin operación.
				bsf portb,Act_Ren33; Desactiva el renglón 3.
				nop; Sin operación.
				bcf portb,Act_Ren33; Activa el renglón 3.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0XF0; averiguar si una tecla
				andwf Var_teclado,f; fue oprimida.
				movlw Tec_igual; Brinca si
				subwf Var_teclado,w; la tecla igual
				btfsc status,Z; no fue oprimida.
				goto inicio; Ve a inicio.
				call barre_teclado; Llama a la subrutina que barre el teclado.
				decf cta_uniseg,f; Decrementa en 1 el contenido del registro cta_uniseg.
				movlw .255; Brinca si el valor
				subwf cta_uniseg,w; del registro cta_uniseg
				btfss status,Z; es 255.
				goto cuenta_time; Ve a cuenta_time.
				movlw .9; Carga la cuenta de
				movwf cta_uniseg; 9 al registro cta_uniseg.
				decf cta_decseg,f; Decrementa en 1 el contenido del registro cta_decseg.
				movlw .255; Brinca si el valor
				subwf cta_decseg,w; del registro cta_decseg
				btfss status,Z; es 255.
				goto cuenta_time; Ve a cuenta_time.
				movlw .5; Carga la cuenta de
				movwf cta_decseg; 5 al registro cta_decseg.
				movlw .9; Carga la cuenta de
				movwf cta_uniseg; 9 al registro cta_uniseg.
				decf cta_unimin,f; Incrementa en 1 el contenido del registro cta_unimin.
				movlw .255; Brinca si el valor
				subwf cta_unimin,w; del registro cta_unimin
				btfss status,Z; es 255.
				goto cuenta_time; Ve a cuenta_time.
				movlw .9; Carga la cuenta de
				movwf cta_unimin; 9 al registro cta_unimin.
				movlw .5; Carga la cuenta de
				movwf cta_decseg; 5 al registro cta_decseg.
				movlw .9; Carga la cuenta de
				movwf cta_uniseg; 9 al registro cta_uniseg.
				decf cta_decmin; Incrementa en 1 el contenido del registro cta_decmin.
				movlw .255; Brinca si el valor
				subwf cta_decmin,w; del registro cta_decmin
				btfss status,Z; es 255.
				goto cuenta_time; Ve a cuenta_time.
				movlw .5; Carga la cuenta de
				movwf cta_decmin; 5 al registro cta_decmin.
				movlw .9; Carga la cuenta de
				movwf cta_unimin; 9 al registro cta_unimin.
				movlw .5; Carga la cuenta de
				movwf cta_decseg; 5 al registro cta_decseg.
				movlw .9; Carga la cuenta de
				movwf cta_uniseg; 9 al registro cta_uniseg.
				decf cta_unihor,f; Incrementa en 1 el contenido del registro cta_unihor.
				movlw .255; Brinca si el valor
				subwf cta_unihor,w; del registro cta_unihor
				btfss status,Z; es 255.
				goto cuenta_time;
				movlw .9; Carga la cuenta de
				movwf cta_unihor; 9 al registro cta_unihor.
				movlw .5; Carga la cuenta de
				movwf cta_decmin; 5 al registro cta_decmin.
				movlw .9; Carga la cuenta de
				movwf cta_unimin; 9 al registro cta_unimin.
				movlw .5; Carga la cuenta de
				movwf cta_decseg; 5 al registro cta_decseg.
				movlw .9; Carga la cuenta de
				movwf cta_uniseg; 9 al registro cta_uniseg.
				decf cta_dechor,f; Incrementa en 1 el contenido del registro cta_dechor.
				movlw .255; Brinca si el valor
				subwf cta_dechor,w; del registro cta_dechor
				btfss status,Z; es 255.
				goto cuenta_time; Ve a cuenta_time.
				bsf portd,Activador; Activa el dispensamiento.
				call retardo_dispen; Llama a la subrutina del retardo para el dispensamiento.
				bcf portd,Activador; Desactiva el dispensamiento.
				movf resp_uniseg,w; Restaura el contenido
				movwf cta_uniseg; del registro cta_uniseg.
				movf resp_decseg,w; Restaura el contenido
				movwf cta_decseg; del registro cta_decseg.
				movf resp_unimin,w; Restaura el contenido
				movwf cta_unimin; del registro cta_unimin.
				movf resp_decmin,w; Restaura el contenido
				movwf cta_decmin; del registro cta_decmin.
				movf resp_unihor,w; Restaura el contenido
				movwf cta_unihor; del registro cta_unihor.
				movf resp_dechor,w; Restaura el contenido
				movwf cta_dechor; del registro cta_dechor.
				goto cuenta_time; Regresa de la subrutina que cuenta el tiempo.
;-----------------------------------------------------------------
;======================================
;== Subrutina que barre el teclado ==
;======================================
barre_teclado 	bsf portb,Act_Ren00; Desactiva el renglón 0.
				nop; Sin operación.
				bsf portb,Act_Ren11; Desactiva el renglón 1.
				nop; Sin operación.
				bsf portb,Act_Ren22; Desactiva el renglón 2.
				nop; Sin operación.
				bsf portb,Act_Ren33; Desactiva el renglón 3.
				nop; Sin operación.
				bcf portb,Act_Ren33; Activa el renglón 3.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0XF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida
				movlw Tec_ON; Brinca si
				subwf Var_teclado,w; la tecla ON
				btfsc status,Z; no fue oprimida.
				goto nuevo_time; Ve a nuevo_time.
				nop; Sin operacion.
				btfss banderas,ban_int; Prueba el bit ban_int del registro banderas, brinca si esta en 1.
				goto barre_teclado; Ve a barre_teclado.
				bcf banderas,ban_int; Pon a 0 el bit ban_int del registro banderas.
				return; Regresa de la subrutina.
nuevo_time 		bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x01; Borra todos los
				movwf portc; datos de la LCD.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 0x84; Pon al cursor de la
				movwf portc; lcd en el digito 5.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo datos.
				movlw 'T'; Manda al bus de datos el
				movwf portc; código del caracter T en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'i'; Manda al bus de datos el
				movwf portc; código del caracter i en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'e'; Manda al bus de datos el
				movwf portc; código del caracter e en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'm'; Manda al bus de datos el
				movwf portc; código del caracter m en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'p'; Manda al bus de datos el
				movwf portc; código del caracter p en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'o'; Manda al bus de datos el
				movwf portc; código del caracter o en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw ' '; Manda al bus de datos el
				movwf portc; código del caracter en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'N'; Manda al bus de datos el
				movwf portc; código del caracter N en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'u'; Manda al bus de datos el
				movwf portc; código del caracter u en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'e'; Manda al bus de datos el
				movwf portc; código del caracter e en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'v'; Manda al bus de datos el
				movwf portc; código del caracter v en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'o'; Manda al bus de datos el
				movwf portc; código del caracter o en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9A; Pon al cursor de la
				movwf portc; lcd en el digito 47.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '/'; Manda al bus de datos el
				movwf portc; código del caracter / en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw '/'; Manda al bus de datos el
				movwf portc; código del caracter / en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw ':'; Manda al bus de datos el
				movwf portc; código del caracter : en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw '/'; Manda al bus de datos el
				movwf portc; código del caracter / en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw '/'; Manda al bus de datos el
				movwf portc; código del caracter / en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw ':'; Manda al bus de datos el
				movwf portc; código del caracter : en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw '/'; Manda al bus de datos el
				movwf portc; código del caracter / en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw '/'; Manda al bus de datos el
				movwf portc; código del caracter / en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
dechor 			bsf portb,Act_Ren00; Desactiva el renglón 0.
				nop; Sin operación.
				bsf portb,Act_Ren11; Desactiva el renglón 1.
				nop; Sin operación.
				bsf portb,Act_Ren22; Desactiva el renglón 2.
				nop; Sin operación.
				bsf portb,Act_Ren33; Desactiva el renglón 3.
				nop; Sin operación.
				bcf portb,Act_Ren33; Activa el renglón 3.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimda
				btfsc status,Z; del renglón 3.
				goto dechor_1; Ve a dechor_1.
				movlw Tec_0; Brinca si
				subwf Var_teclado,w; la tecla 0
				btfsc status,Z; no fue oprimda.
				goto dec_hor_0; Ve a dec_hor_0.
dechor_1 		bsf portb,Act_Ren33; Desactiva el renglón 3.
				nop; Sin operación.
				bcf portb,Act_Ren22; Activa el renglón 2.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renglón 2.
				goto dechor_2; Ve a dechor_2.
				movlw Tec_1; Brinca si
				subwf Var_teclado,w; la tecla 1
				btfsc status,Z; no fue oprimida.
				goto dec_hor_1; Ve a dec_hor_1.
				movlw Tec_2; Brinca si
				subwf Var_teclado,w; la tecla 2
				btfsc status,Z; no fué oprimida.
				goto dec_hor_2; Ve a dec_hor_2.
				movlw Tec_3; Brinca si
				subwf Var_teclado,w; la tecla 3
				btfsc status,Z; no fué oprimida.
				goto dec_hor_3; Ve a dec_hor_3.
dechor_2 		bsf portb,Act_Ren22; Desactiva el renglón 2.
				nop; Sin operación.
				bcf portb,Act_Ren11; Activa el renglón 1.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; no fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renglón 1.
				goto dechor_3; Ve a dechor_3.
				movlw Tec_4; Brinca si
				subwf Var_teclado,w; la tecla 4
				btfsc status,Z; no fué oprimda.
				goto dec_hor_4; Ve a dec_hor_4.
				movlw Tec_5; Brinca si
				subwf Var_teclado,w; la tecla 5
				btfsc status,Z; no fué oprimida.
				goto dec_hor_5; Ve a dec_hor_5.
				movlw Tec_6; Brinca si
				subwf Var_teclado,w; la tecla 6
				btfsc status,Z; no fué oprimida.
				goto dec_hor_6; Ve a dec_hor_6.
dechor_3 		bsf portb,Act_Ren11; Desactiva el renglón 1.
				nop; Sin operación.
				bcf portb,Act_Ren00; Activa el renglón 0.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renglón 0.
				goto dechor; Ve a dechor.
				movlw Tec_7; Brinca si
				subwf Var_teclado,w; la tecla 7
				btfsc status,Z; no fué oprimida.
				goto dec_hor_7; Ve a dec_hor_7.
				movlw Tec_8; Brinca si
				subwf Var_teclado,w; la tecla 8
				btfsc status,Z; no fué oprimida.
				goto dec_hor_8; Ve a dec_hor_8.
				movlw Tec_9; Brinca si
				subwf Var_teclado,w; la tecla 9
				btfsc status,Z; no fué oprimida.
				goto dec_hor_9; Ve a dec_hor_9.
				goto dechor; Ve a dechor;
dec_hor_0 		movlw .0; Carga 0 al
				movwf cta_dechor; registro cta_dechor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9A; Pon al cursor de la lcd
				movwf portc; en el digito 7 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '0'; Manda el código del caracter 0
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto unihor; Ve a unihor.
dec_hor_1 		movlw .1; Carga 1 al
				movwf cta_dechor; registro cta_dechor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9A; Pon al cursor de la lcd
				movwf portc; en el digito 7 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '1'; Manda el código del caracter 1
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto unihor; Ve a unihor.
dec_hor_2 		movlw .2; Carga 2 al
				movwf cta_dechor; registro cta_dechor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9A; Pon al cursor de la lcd
				movwf portc; en el digito 7 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '2'; Manda el código del caracter 2
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto unihor; Ve a unihor.
dec_hor_3 		movlw .3; Carga 3 al
				movwf cta_dechor; registro cta_dechor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9A; Pon al cursor de la lcd
				movwf portc; en el digito 7 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '3'; Manda el código del caracter 3
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto unihor; Ve a unihor.
dec_hor_4 		movlw .4; Carga 4 al
				movwf cta_dechor; registro cta_dechor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9A; Pon al cursor de la lcd
				movwf portc; en el digito 7 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '4'; Manda el código del caracter 4
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto unihor; Ve a unihor.
dec_hor_5 		movlw .5; Carga 5 al
				movwf cta_dechor; registro cta_dechor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9A; Pon al cursor de la lcd
				movwf portc; en el digito 7 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '5'; Manda el código del caracter 5
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto unihor; Ve a unihor.
dec_hor_6 		movlw .6; Carga 6 al
				movwf cta_dechor; registro cta_dechor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9A; Pon al cursor de la lcd
				movwf portc; en el digito 7 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '6'; Manda el código del caracter 6
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto unihor; Ve a unihor.
dec_hor_7 		movlw .7; Carga 7 al
				movwf cta_dechor; registro cta_dechor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9A; Pon al cursor de la lcd
				movwf portc; en el digito 7 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '7'; Manda el código del caracter 7
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto unihor; Ve a unihor.
dec_hor_8 		movlw .8; Carga 8 al
				movwf cta_dechor; registro cta_dechor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9A; Pon al cursor de la lcd
				movwf portc; en el digito 7 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '8'; Manda el código del caracter 8
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto unihor; Ve a unihor.
dec_hor_9 		movlw .9; Carga 9 al
				movwf cta_dechor; registro cta_dechor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9A; Pon al cursor de la lcd
				movwf portc; en el digito 7 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '9'; Manda el código del caracter 9
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto unihor; Ve a unihor.
unihor 			call esp_int; Llama a la subrutina que espera la interrupción.
				call esp_int; Llama a la subrutina que espera la interrupción.
unihor_0 		bsf portb,Act_Ren00; Desactiva el renglón 0.
				nop; Sin operación.
				bsf portb,Act_Ren11; Desactiva el renglón 0.
				nop; Sin operación.
				bsf portb,Act_Ren22; Desactiva el renglón 2.
				nop; Sin operación.
				bsf portb,Act_Ren33; Desactiva el renglón 3.
				nop; Sin operación.
				bcf portb,Act_Ren33; Activa el renglón 3.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renglón 3.
				goto unihor_1; Ve a unihor_1.
				movlw Tec_0; Brinca si
				subwf Var_teclado,w; la tecla 0
				btfsc status,Z; no fué oprimida.
				goto uni_hor_0; Ve a uni_hor_0.
unihor_1 		bsf portb,Act_Ren33; Desactiva el renglón 3.
				nop; Sin operación.
				bcf portb,Act_Ren22; Activa el renglón 2.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renglón 2.
				goto unihor_2; Ve a dechor_2.
				movlw Tec_1; Brinca si
				subwf Var_teclado,w; la tecla 1.
				btfsc status,Z; no fué oprimida.
				goto uni_hor_1; Ve a uni_hor_1.
				movlw Tec_2; Brinca si
				subwf Var_teclado,w; la tecla 2.
				btfsc status,Z; no fué oprimida.
				goto uni_hor_2; Ve a uni_hor_2.
				movlw Tec_3; Brinca si
				subwf Var_teclado,w; la tecla 3.
				btfsc status,Z; no fué oprimida.
				goto uni_hor_3; Ve a uni_hor_3.
unihor_2 		bsf portb,Act_Ren22; Desactiva el renglón 2.
				nop; Sin operación.
				bcf portb,Act_Ren11; Activa el renglón 1.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; en el renglón 1.
				goto unihor_3; Ve a unihor_3.
				movlw Tec_4; Brinca si
				subwf Var_teclado,w; la tecla 4
				btfsc status,Z; no fué oprimida.
				goto uni_hor_4; Ve a uni_hor_4.
				movlw Tec_5; Brinca si
				subwf Var_teclado,w; la tecla 5
				btfsc status,Z; no fué oprimida.
				goto uni_hor_5; Ve a uni_hor_5.
				movlw Tec_6; Brinca si
				subwf Var_teclado,w; la tecla 6
				btfsc status,Z; no fué oprimida.
				goto uni_hor_6; Ve a uni_hor_6.
unihor_3 		bsf portb,Act_Ren11; Desactiva el renglón 1.
				nop; Sin operación.
				bcf portb,Act_Ren00; Activa el renglón 0.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; en el renglón 0.
				goto unihor_0; Ve a unihor_0.
				movlw Tec_7; Brinca si
				subwf Var_teclado,w; la tecla 7
				btfsc status,Z; no fué oprimida.
				goto uni_hor_7; Ve a uni_hor_7.
				movlw Tec_8; Brinca si
				subwf Var_teclado,w; la tecla 9
				btfsc status,Z; no fué oprimida.
				goto uni_hor_8; Ve a uni_hor_8.
				movlw Tec_9; Brinca si
				subwf Var_teclado,w; la tecla 9
				btfsc status,Z; no fué oprimida.
				goto uni_hor_9; Ve a uni_hor_9.
				goto unihor_0; Ve a unihor_0.
uni_hor_0 		movlw .0; Carga 0 al
				movwf cta_unihor; registro cta_unihor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9B; Pon al cursor de la lcd
				movwf portc; en el digito 8 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '0'; Manda el código del caracter 0
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto decmin; Ve a decmin.
uni_hor_1 		movlw .1; Carga 1 al
				movwf cta_unihor; registro cta_unihor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9B; Pon al cursor de la lcd
				movwf portc; en el digito 8 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '1'; Manda el código del caracter 1
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto decmin; Ve a decmin.
uni_hor_2	 	movlw .2; Carga 2 al
				movwf cta_unihor; registro cta_unihor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9B; Pon al cursor de la lcd
				movwf portc; en el digito 8 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '2'; Manda el código del caracter 2
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto decmin; Ve a decmin.
uni_hor_3 		movlw .3; Carga 3 al
				movwf cta_unihor; registro cta_unihor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9B; Pon al cursor de la lcd
				movwf portc; en el digito 8 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '3'; Manda el código del caracter 3
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto decmin; Ve a decmin.
uni_hor_4 		movlw .4; Carga 4 al
				movwf cta_unihor; registro cta_unihor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9B; Pon al cursor de la lcd
				movwf portc; en el digito 8 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '4'; Manda el código del caracter 4
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto decmin; Ve a decmin.
uni_hor_5 		movlw .5; Carga 5 al
				movwf cta_unihor; registro cta_unihor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9B; Pon al cursor de la lcd
				movwf portc; en el digito 8 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '5'; Mueve el valor de 0 en ascii al registro w.
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto decmin; Ve a decmin.
uni_hor_6 		movlw .6; Carga 6 al
				movwf cta_unihor; registro cta_unihor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9B; Pon al cursor de la lcd
				movwf portc; en el digito 8 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '6'; Manda el código del caracter 6
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto decmin; Ve a decmin.
uni_hor_7 		movlw .7; Carga 7 al
				movwf cta_unihor; registro cta_unihor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9B; Pon al cursor de la lcd
				movwf portc; en el digito 8 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '7'; Manda el código del caracter 7
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto decmin; Ve a decmin.
uni_hor_8 		movlw .8; Carga 8 al
				movwf cta_unihor; registro cta_unihor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9B; Pon al cursor de la lcd
				movwf portc; en el digito 8 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '8'; Manda el código del caracter 8
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto decmin; Ve a decmin.
uni_hor_9 		movlw .9; Carga 9 al
				movwf cta_unihor; registro cta_unihor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9B; Pon al cursor de la lcd
				movwf portc; en el digito 8 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '9'; Manda el código del caracter 9
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto decmin; Ve a decmin.
decmin 			call esp_int; Llama a la subrutina que espera la interrupción.
				call esp_int; Llama a la subrutina que espera la interrupción.
decmin_0 		bsf portb,Act_Ren00; Desactiva el renglón 0.
				nop; Sin operación.
				bsf portb,Act_Ren11; Desactiva el renglón 1.
				nop; Sin operación.
				bsf portb,Act_Ren22; Desactiva el renglón 2.
				nop; Sin operación.
				bsf portb,Act_Ren33; Desactiva el renglón 3.
				nop; Sin operación.
				bcf portb,Act_Ren33; Activa el renglón 3.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renglón 3.
				goto decmin_1; Ve a decmin_1.
				movlw Tec_0; Brinca si
				subwf Var_teclado,w; la tecla 0
				btfsc status,Z; no fué oprimida.
				goto dec_min_0; Ve a dec_min_0.
decmin_1 		bsf portb,Act_Ren33; Desactiva el renglón 3.
				nop; Sin operación.
				bcf portb,Act_Ren22; Activa el renglón 2.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renglón 2.
				goto decmin_2; Ve a decmin_2.
				movlw Tec_1; Brinca si
				subwf Var_teclado,w; la tecla 1
				btfsc status,Z; no fué oprimida.
				goto dec_min_1; Ve a dec_min_1.
				movlw Tec_2; Brinca si
				subwf Var_teclado,w; la tecla 2
				btfsc status,Z; no fué oprimida.
				goto dec_min_2; Ve a dec_min_2.
				movlw Tec_3; Brinca si
				subwf Var_teclado,w; la tecla 3
				btfsc status,Z; no fué oprimida.
				goto dec_min_3; Ve a dec_min_3.
decmin_2 		bsf portb,Act_Ren22; Desactiva el renglón 2.
				nop; Sin operación.
				bcf portb,Act_Ren11; Activa el renglón 1.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renglón 1.
				goto decmin_3; Ve a decmin_3.
				movlw Tec_4; Brinca si
				subwf Var_teclado,w; la tecla 4
				btfsc status,Z; no fué oprimida.
				goto dec_min_4; Ve a dec_min_4.
				movlw Tec_5; Brinca si
				subwf Var_teclado,w; la tecla 5
				btfsc status,Z; no fué oprimida.
				goto dec_min_5; Ve a dec_min_5.
				movlw Tec_6; Brinca si
				subwf Var_teclado,w; la tecla 6
				btfsc status,Z; no fué oprimida.
				goto dec_min_6; Ve a dec_min_6.
decmin_3 		bsf portb,Act_Ren11; Desactiva el renglón 1.
				nop; Sin operación.
				bcf portb,Act_Ren00; Activa el renglón 0.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renglón 0.
				goto decmin_0; Ve a decmin_0.
				movlw Tec_7; Brinca si
				subwf Var_teclado,w; la tecla 7
				btfsc status,Z; no fué oprimida.
				goto dec_min_7; Ve a dec_min_7.
				movlw Tec_8; Brinca si
				subwf Var_teclado,w; la tecla 8
				btfsc status,Z; no fué oprimida.
				goto dec_min_8; Ve a dec_min_8.
				movlw Tec_9; Brinca si
				subwf Var_teclado,w; la tecla 9
				btfsc status,Z; no fué oprimida.
				goto dec_min_9; Ve a dec_min_9.
				goto decmin_0; Ve a decmin_0.
dec_min_0		movlw .0; Carga 0 al
				movwf cta_decmin; registro cta_decmin.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9D; Mueve el valor 9D en hexadecimal al registro w.
				movwf portc; Pon al cursor de la lcd en el digito 10 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '0'; Manda el código del caracter 0
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto unimin; Ve a unimin.
dec_min_1 		movlw .1; Carga 1 al
				movwf cta_decmin; registro cta_decmin.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9D; Pon al cursor de la lcd
				movwf portc; en el digito 10 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '1'; Manda el código del caracter 1
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto unimin; Ve a unimin.
dec_min_2 		movlw .2; Carga 2 al
				movwf cta_decmin; registro cta_decmin.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9D; Pon al cursor de la lcd
				movwf portc; en el digito 10 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '2'; Manda el código del caracter 2
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto unimin; Ve a unimin.
dec_min_3 		movlw .3; Carga 3 al
				movwf cta_decmin; registro cta_decmin.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9D; Pon al cursor de la lcd
				movwf portc; en el digito 10 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '3'; Manda el código del caracter 3
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto unimin; Ve a unimin.
dec_min_4 		movlw .4; Carga 4 al
				movwf cta_decmin; registro cta_decmin.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9D; Pon al cursor de la lcd
				movwf portc; en el digito 10 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '4'; Manda el código del caracter 4
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto unimin; Ve a unimin.
dec_min_5 		movlw .5; Carga 5 al
				movwf cta_decmin; registro cta_decmin.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9D; Pon al cursor de la lcd
				movwf portc; en el digito 10 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '5'; Manda el código del caracter 5
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto unimin; Ve a unimin.
dec_min_6 		movlw .6; Carga 6 al
				movwf cta_decmin; registro cta_decmin.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9D; Pon al cursor de la lcd
				movwf portc; en el digito 10 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '6'; Manda el código del caracter 6
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto unimin; Ve a unimin.
dec_min_7 		movlw .7; Carga 7 al
				movwf cta_decmin; registro cta_decmin.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9D; Pon al cursor de la lcd
				movwf portc; en el digito 10 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '7'; Manda el código del caracter 7
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto unimin; Ve a unimin.
dec_min_8 		movlw .8; Carga 8 al
				movwf cta_decmin; registro cta_decmin.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9D; Pon al cursor de la lcd
				movwf portc; en el digito 10 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '8'; Manda el código del caracter 8
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto unimin; Ve a unimin.
dec_min_9 		movlw .9; Carga 9 al
				movwf cta_decmin; registro cta_decmin.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9D; Pon al cursor de la lcd
				movwf portc; en el digito 10 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '9'; Manda el código del caracter 9
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto unimin; Ve a unimin.
unimin 			call esp_int; Llama a la subrutina que espera a la interrupción.
				call esp_int; Llama a la subrutina que espera a la interrupción.
unimin_0		bsf portb,Act_Ren00; Desactiva el renglón 0.
				nop; Sin operación.
				bsf portb,Act_Ren11; Desactiva el renglón 1.
				nop; Sin operación.
				bsf portb,Act_Ren22; Desactiva el renglón 2.
				nop; Sin operación.
				bsf portb,Act_Ren33; Desactiva el renglón 3.
				nop; Sin operación.
				bcf portb,Act_Ren33; Activa el renglón 3.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renglón 3.
				goto unimin_1; Ve a unimin_1.
				movlw Tec_0; Brinca si
				subwf Var_teclado,w; la tecla 0
				btfsc status,Z; no fué oprimida.
				goto uni_min_0; Ve a uni_min_0.
unimin_1 		bsf portb,Act_Ren33; Desactiva el renglón 3.
				nop; Sin operación.
				bcf portb,Act_Ren22; Activa el renglón 2.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renglón 2.
				goto unimin_2; Ve a unimin_2.
				movlw Tec_1; Brinca si
				subwf Var_teclado,w; la tecla 1
				btfsc status,Z; no fué oprimida.
				goto uni_min_1; Ve a uni_min_1.
				movlw Tec_2; Brinca si
				subwf Var_teclado,w; la tecla 2
				btfsc status,Z; no fué oprimida.
				goto uni_min_2; Ve a uni_min_2.
				movlw Tec_3; Brinca si
				subwf Var_teclado,w; la tecla 3.
				btfsc status,Z; no fué oprimida.
				goto uni_min_3; Ve a uni_min_3.
unimin_2 		bsf portb,Act_Ren22; Desactiva el renglón 2.
				nop; Sin operación.
				bcf portb,Act_Ren11; Activa el renglón 1.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renglón 1.
				goto unimin_3; Ve a unimin_3.
				movlw Tec_4; Brinca si
				subwf Var_teclado,w; la tecla 4
				btfsc status,Z; no fué oprimida.
				goto uni_min_4; Ve a uni_min_4.
				movlw Tec_5; Brinca si
				subwf Var_teclado,w; la tecla 5
				btfsc status,Z; no fué oprimida.
				goto uni_min_5; Ve a uni_min_5.
				movlw Tec_6; Brinca si
				subwf Var_teclado,w; la tecla 6
				btfsc status,Z; no fué oprimida.
				goto uni_min_6; Ve a uni_min_6.
unimin_3 		bsf portb,Act_Ren11; Desactiva el renglón 1.
				nop; Sin operación.
				bcf portb,Act_Ren00; Activa el renglón 0.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renglón 0.
				goto unimin_0; Ve a unimin.
				movlw Tec_7; Brinca si
				subwf Var_teclado,w; la tecla 7
				btfsc status,Z; no fué oprimida.
				goto uni_min_7; Ve a uni_min_7.
				movlw Tec_8; Brinca si
				subwf Var_teclado,w; la tecla 8
				btfsc status,Z; no fué oprimida.
				goto uni_min_8; Ve a uni_min_8.
				movlw Tec_9; Brinca si
				subwf Var_teclado,w; la tecla 9
				btfsc status,Z; no fué oprimida.
				goto uni_min_9; Ve a uni_min_9.
				goto unimin_0;
uni_min_0 		movlw .0; Carga 0 al
				movwf cta_unimin; registro cta_unimin.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9E; Pon al cursor de la lcd
				movwf portc; en el digito 11 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '0'; Manda el código del caracter 0
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto decseg; Ve a decseg.
uni_min_1		movlw .1; Carga 1 al
				movwf cta_unimin; registro cta_unimin.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9E; Pon al cursor de la lcd
				movwf portc; en el digito 11 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '1'; Manda el código del caracter 1
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto decseg; Ve a decseg.
uni_min_2 		movlw .2; Carga 2 al
				movwf cta_unimin; registro cta_unimin.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9E; Pon al cursor de la lcd
				movwf portc; en el digito 11 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '2'; Manda el código del caracter 2
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto decseg; Ve a decseg.
uni_min_3 		movlw .3; Carga 3 al
				movwf cta_unimin; registro cta_unimin.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9E; Pon al cursor de la lcd
				movwf portc; en el digito 11 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '3'; Manda el código del caracter 3
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto decseg; Ve a decseg.
uni_min_4 		movlw .4; Carga 4 al
				movwf cta_unimin; registro cta_unimin.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9E; Pon al cursor de la lcd
				movwf portc; en el digito 11 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '4'; Manda el código del caracter 4
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto decseg; Ve a decseg.
uni_min_5 		movlw .5; Carga 5 al
				movwf cta_unimin; registro cta_unimin.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9E; Pon al cursor de la lcd
				movwf portc; en el digito 11 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '5'; Manda el código del caracter 5
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto decseg; Ve a decseg.
uni_min_6 		movlw .6; Carga 6 al
				movwf cta_unimin; registro cta_unimin.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9E; Pon al cursor de la lcd
				movwf portc; en el digito 11 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '6'; Manda el código del caracter 6
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto decseg; Ve a decseg.
uni_min_7 		movlw .7; Carga 7 al
				movwf cta_unimin; registro cta_unimin.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9E; Pon al cursor de la lcd
				movwf portc; en el digito 11 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '7'; Manda el código del caracter 7
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto decseg; Ve a decseg.
uni_min_8 		movlw .8; Carga 8 al
				movwf cta_unimin; registro cta_unimin.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9E; Pon al cursor de la lcd
				movwf portc; en el digito 11 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '8'; Manda el código del caracter 8
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto decseg; Ve a decseg.
uni_min_9 		movlw .9; Carga 9 al
				movwf cta_unimin; registro cta_unimin.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9E; Pon al cursor de la lcd
				movwf portc; en el digito 11 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '9'; Manda el código del caracter 9
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto decseg; Ve a decseg.
decseg 			call esp_int; Llama a la subrutina que espera la interrupción.
				call esp_int; Llama a la subrutina que espera la interrupción.
decseg_0 		bsf portb,Act_Ren00; Desactiva el renglón 0.
				nop; Sin operación.
				bsf portb,Act_Ren11; Desactiva el renglón 1.
				nop; Sin operación.
				bsf portb,Act_Ren22; Desactiva el renglón 2.
				nop; Sin operación.
				bsf portb,Act_Ren33; Desactiva el renglón 3.
				nop; Sin operación.
				bcf portb,Act_Ren33; Activa el renglón 3.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renlgón 3.
				goto decseg_1; Ve a decseg_1.
				movlw Tec_0; Brinca si
				subwf Var_teclado,w; la telca 0
				btfsc status,Z; no fué oprimida.
				goto dec_seg_0; Ve a dec_seg_0.
decseg_1 		bsf portb,Act_Ren33; Desactiva el renglón 3.
				nop; Sin operación.
				bcf portb,Act_Ren22; Activa el renglón 2.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renglón 2.
				goto decseg_2; Ve a decseg_2.
				movlw Tec_1; Brinca si
				subwf Var_teclado,w; la tecla 1
				btfsc status,Z; no fué oprimida.
				goto dec_seg_1; Ve a dec_seg_1.
				movlw Tec_2; Brinca si
				subwf Var_teclado,w; la tecla 2
				btfsc status,Z; no fué oprimida.
				goto dec_seg_2; Ve a dec_seg_2.
				movlw Tec_3; Brinca si
				subwf Var_teclado,w; la tecla 3
				btfsc status,Z; no fué oprimida.
				goto dec_seg_3; Ve a dec_seg_3.
decseg_2		bsf portb,Act_Ren22; Desactiva el renglón 2.
				nop; Sin operación.
				bcf portb,Act_Ren11; Activa el renglón 1.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renglón 1.
				goto decseg_3; Ve a decseg_3.
				movlw Tec_4; Brinca si
				subwf Var_teclado,w; la tecla 4
				btfsc status,Z; no fué oprimida.
				goto dec_seg_4; Ve a dec_seg_4.
				movlw Tec_5; Brinca si
				subwf Var_teclado,w; la tecla 5
				btfsc status,Z; no fué oprimida.
				goto dec_seg_5; Ve a dec_seg_5.
				movlw Tec_6; Brinca si
				subwf Var_teclado,w; la tecla 6
				btfsc status,Z; no fué oprimida.
				goto dec_seg_6; Ve a dec_seg_6.
decseg_3 		bsf portb,Act_Ren11; Desactiva el renglón 1.
				nop; Sin operación.
				bcf portb,Act_Ren00; Activa el renglón 0.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renglón 0.
				goto decseg_0; Ve a decseg.
				movlw Tec_7; Brinca si
				subwf Var_teclado,w; la tecla 7
				btfsc status,Z; no fué oprimida.
				goto dec_seg_7; Ve a dec_seg_7.
				movlw Tec_8; Brinca si
				subwf Var_teclado,w; la tecl 8
				btfsc status,Z; no fué oprimida.
				goto dec_seg_8; Ve a dec_seg_8.
				movlw Tec_9; Brinca si
				subwf Var_teclado,w; la tecla 9
				btfsc status,Z; no fué oprimida.
				goto dec_seg_9; Ve a dec_seg_9.
				goto decseg_0; Ve a decseg_0.
dec_seg_0 		movlw .0; Carga 0 al
				movwf cta_decseg; registro cta_decseg.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xA0; Pon al cursor de la lcd
				movwf portc; en el digito 13 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '0'; Manda el código del caracter 0
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto uniseg; Ve a uniseg.
dec_seg_1 		movlw .1; Carga 1 al
				movwf cta_decseg; registro cta_decseg.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xA0; Pon al cursor de la lcd
				movwf portc; en el digito 13 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '1'; Manda el código del caracter 1
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto uniseg; Ve a uniseg.
dec_seg_2 		movlw .2; Carga 2 al
				movwf cta_decseg; registro cta_decseg.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xA0; Pon al cursor de la lcd
				movwf portc; en el digito 13 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '2'; Manda el código del caracter 2
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto uniseg; Ve a uniseg.
dec_seg_3 		movlw .3; Carga 3 al
				movwf cta_decseg; registro cta_decseg.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xA0; Pon al cursor de la lcd
				movwf portc; en el digito 13 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '3'; Manda el código del caracter 3
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto uniseg; Ve a uniseg.
dec_seg_4 		movlw .4; Carga 4 al
				movwf cta_decseg; registro cta_decseg.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xA0; Pon al cursor de la lcd
				movwf portc; en el digito 13 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '4'; Manda el código del caracter 4
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto uniseg; Ve a uniseg.
dec_seg_5	 	movlw .5; Carga 5 al
				movwf cta_decseg; registro cta_decseg.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xA0; Pon al cursor de la lcd
				movwf portc; en el digito 13 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '5'; Manda el código del caracter 5
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto uniseg; Ve a uniseg.
dec_seg_6 		movlw .6; Carga 6 al
				movwf cta_decseg; registro cta_decseg.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xA0; Pon al cursor de la lcd
				movwf portc; en el digito 13 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '6'; Manda el código del caracter 6
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto uniseg; Ve a uniseg.
dec_seg_7 		movlw .7; Carga 7 al
				movwf cta_decseg; registro cta_decseg.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xA0; Pon al cursor de la lcd
				movwf portc; en el digito 13 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '7'; Manda el código del caracter 7
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto uniseg; Ve a uniseg.
dec_seg_8 		movlw .8; Carga 8 al
				movwf cta_decseg; registro cta_decseg.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xA0; Pon al cursor de la lcd
				movwf portc; en el digito 13 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '8'; Manda el código del caracter 8
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto uniseg; Ve a uniseg.
dec_seg_9 		movlw .9; Carga 9 al
				movwf cta_decseg; registro cta_decseg.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xA0; Pon al cursor de la lcd
				movwf portc; en el digito 13 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '9'; Manda el código del caracter 9
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto uniseg; Ve a uniseg.
uniseg 			call esp_int; Llama a la subrutina que espera la interrupción.
				call esp_int; Llama a la subrutina que espera la interrupción.
uniseg_0		bsf portb,Act_Ren00; Desactiva el renglón 0.
				nop; Sin operación.
				bsf portb,Act_Ren11; Desactiva el renglón 1.
				nop; Sin operación.
				bsf portb,Act_Ren22; Desactiva el renglón 2.
				nop; Sin operación.
				bsf portb,Act_Ren33; Desactiva el renglón 3.
				nop; Sin operación.
				bcf portb,Act_Ren33; Activa el renglón 3.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renglón 3.
				goto uniseg_1; Ve a uniseg_1.
				movlw Tec_0; Brinca si
				subwf Var_teclado,w; la tecla 0
				btfsc status,Z; no fué oprimida.
				goto uni_seg_0; Ve a uni_seg_0.
uniseg_1 		bsf portb,Act_Ren33; Desactiva el renglón 3.
				nop; Sin operación.
				bcf portb,Act_Ren22; Activa el renglón 2.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renglón 2.
				goto uniseg_2; Ve a uniseg_2.
				movlw Tec_1; Brinca si
				subwf Var_teclado,w; la tecla 1
				btfsc status,Z; no fué oprimida.
				goto uni_seg_1; Ve a uni_seg_1.
				movlw Tec_2; Brinca si
				subwf Var_teclado,w; la tecla 2
				btfsc status,Z; no fué oprimida.
				goto uni_seg_2; Ve a uni_seg_2.
				movlw Tec_3; Brinca si
				subwf Var_teclado,w; la tecla 3
				btfsc status,Z; no fué oprimida.
				goto uni_seg_3; Ve a uni_seg_3.
uniseg_2 		bsf portb,Act_Ren22; Desactiva el renglón 2.
				nop; Sin operación.
				bcf portb,Act_Ren11; Activa el renglón 1.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renglón 1.
				goto uniseg_3; Ve a uniseg_3.
				movlw Tec_4; Brinca si
				subwf Var_teclado,w; la tecla 4
				btfsc status,Z; no fué oprimida.
				goto uni_seg_4; Ve a uni_seg_4.
				movlw Tec_5; Brinca si
				subwf Var_teclado,w; la tecla 5
				btfsc status,Z; no fué oprimida.
				goto uni_seg_5; Ve a uni_seg_5.
				movlw Tec_6; Brinca si
				subwf Var_teclado,w; la tecla 6
				btfsc status,Z; no fué oprimida.
				goto uni_seg_6; Ve a uni_seg_6.
uniseg_3 		bsf portb,Act_Ren11; Desactiva el renglón 1.
				nop; Sin operación.
				bcf portb,Act_Ren00; Activa el renglón 0.
				movf portb,w; Lee el teclado
				movwf Var_teclado; matricial para
				movlw 0xF0; averiguar si una tecla
				andwf Var_teclado,f; fué oprimida.
				movlw No_haytecla; Brinca si hay
				subwf Var_teclado,w; alguna tecla oprimida
				btfsc status,Z; del renglón 0.
				goto uniseg_0; Ve a uniseg.
				movlw Tec_7; Brinca si
				subwf Var_teclado,w; la tecla 7
				btfsc status,Z; no fué oprimida.
				goto uni_seg_7; Ve a uni_seg_7.
				movlw Tec_8; Brinca si
				subwf Var_teclado,w; la tecla 8
				btfsc status,Z; no fué oprimida.
				goto uni_seg_8; Ve a uni_seg_8.
				movlw Tec_9; Brinca si
				subwf Var_teclado,w; la tecla 9
				btfsc status,Z; no fué oprimida.
				goto uni_seg_9; Ve a uni_seg_9.
				goto uniseg_0; Ve a unidseg_0.
uni_seg_0 		movlw .0; Carga 0 al
				movwf cta_uniseg; registro cta_uniseg.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xA1; Pon al cursor de la lcd
				movwf portc; en el digito 14 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '0'; Manda el código del caracter 0
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto regresa; Ve a regresa.
uni_seg_1 		movlw .1; Carga 1 al
				movwf cta_uniseg; registro cta_uniseg.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xA1; Pon al cursor de la lcd
				movwf portc; en el digito 14 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '1'; Manda el código del caracter 1
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto regresa; Ve a regresa.
uni_seg_2 		movlw .2; Carga 2 al
				movwf cta_uniseg; registro cta_uniseg.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xA1; Pon al cursor de la lcd
				movwf portc; en el digito 14 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '2'; Manda el código del caracter 2
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto regresa; Ve a regresa.
uni_seg_3 		movlw .3; Carga 3 al
				movwf cta_uniseg; registro cta_uniseg.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xA1; Pon al cursor de la lcd
				movwf portc; en el digito 14 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '3'; Manda el código del caracter 3
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto regresa; Ve a regresa.
uni_seg_4 		movlw .4; Carga 4 al
				movwf cta_uniseg; registro cta_uniseg.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xA1; Pon al cursor de la lcd
				movwf portc; en el digito 14 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '4'; Manda el código del caracter 4
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto regresa; Ve a regresa.
uni_seg_5 		movlw .5; Carga 5 al
				movwf cta_uniseg; registro cta_uniseg.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xA1; Pon al cursor de la lcd
				movwf portc; en el digito 14 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '5'; Manda el código del caracter 5
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto regresa; Ve a regresa.
uni_seg_6 		movlw .6; Carga 6 al
				movwf cta_uniseg; registro cta_uniseg.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xA1; Pon al cursor de la lcd
				movwf portc; en el digito 14 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '6'; Manda el código del caracter 6
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto regresa; Ve a regresa.
uni_seg_7 		movlw .7; Carga 7 al
				movwf cta_uniseg; registro cta_uniseg.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xA1; Pon al cursor de la lcd
				movwf portc; en el digito 14 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '7'; Manda el código del caracter 7
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto regresa; Ve a regresa.
uni_seg_8 		movlw .8; Carga 8 al
				movwf cta_uniseg; registro cta_uniseg.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xA1; Pon al cursor de la lcd
				movwf portc; en el digito 14 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '8'; Manda el código del caracter 8
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto regresa; Ve a regresa.
uni_seg_9 		movlw .9; Carga 9 al
				movwf cta_uniseg; registro cta_uniseg.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0xA1; Pon al cursor de la lcd
				movwf portc; en el digito 14 del 3er renglón.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw '9'; Manda el código del caracter 9
				movwf portc; en ASCII al puerto C.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				goto regresa; Ve a regresa.
regresa 		movf cta_uniseg,w; Respalda el contenido
				movwf resp_uniseg; del registro cta_uniseg.
				movf cta_decseg,w; Respalda el contenido
				movwf resp_decseg; del registro cta_decseg.
				movf cta_unimin,w; Respalda el contenido
				movwf resp_unimin; del registro cta_unimin.
				movf cta_decmin,w; Respalda el contenido
				movwf resp_decmin; del registro cta_decmin.
				movf cta_unihor,w; Respalda el contenido
				movwf resp_unihor; del registro cta_unihor.
				movf cta_dechor,w; Respalda el contenido
				movwf resp_dechor; del registro cta_dechor.
				bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x01; Borra todos los
				movwf portc; datos de la LCD.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 0x82; Pon al cursor de la
				movwf portc; lcd en el digito 3.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movlw 'T'; Manda al bus de datos el
				movwf portc; código del caracter T en ASCII
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'i'; Manda al bus de datos el
				movwf portc; código del caracter i en ASCII
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'e'; Manda al bus de datos el
				movwf portc; código del caracter e en ASCII
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'm'; Manda al bus de datos el
				movwf portc; código del caracter m en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'p'; Manda al bus de datos el
				movwf portc; código del caracter o en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'o'; Manda al bus de datos el
				movwf portc; código del caracter o en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw ' '; Manda al bus de datos el
				movwf portc; código del caracter en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'e'; Manda al bus de datos el
				movwf portc; código del caracter e en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'n'; Manda al bus de datos el
				movwf portc; código del caracter n en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw ' '; Manda al bus de datos el
				movwf portc; código del caracter en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'C'; Manda al bus de datos el
				movwf portc; código del caracter C en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'u'; Manda al bus de datos el
				movwf portc; código del caracter u en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'r'; Manda al bus de datos el
				movwf portc; código del caracter r en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 's'; Manda al bus de datos el
				movwf portc; código del caracter s en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 'o'; Manda al bus de datos el
				movwf portc; código del caracter o en ASCII.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				return; Regresa de la subrutina.
;-----------------------------------------------------------------
;=================================================
;== Subrutina que muestra el tiempo en la lcd ==
;=================================================
muestra_time 	bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x9A; Mueve el valor 84 en hexadecimal al registro w.
				movwf portc; Pon al cursor de la lcd en el digito 5.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				movf buffer8,w; Manda al bus de datos el
				movwf portc; contenido del registro buffer 8.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movf buffer7,w; Manda al bus de datos el
				movwf portc; contenido del registro buffer 7.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw ':'; Manda al bus de datos el
				movwf portc; código en ASCII de :.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movf buffer5,w; Manda al bus de datos el
				movwf portc; contenido del registro buffer 5.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movf buffer4,w; Manda al bus de datos el
				movwf portc; contenido del registro buffer 4.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw ':'; Manda al bus de datos el
				movwf portc; código en ASCII de :.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movf buffer2,w; Manda al bus de datos el
				movwf portc; contenido del registro buffer 2.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movf buffer1,w; Manda al bus de datos el
				movwf portc; contenido del registro buffer 1.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				return; Regresa de la subrutina.
;--------------------------------------------------------------------------------------------------
 ;============================================
 ;== Subrutina de inicialización de la LCD ==
 ;============================================
ini_lcd 		bcf porta,RS_LCD; Pon a la lcd en modo comando.
				movlw 0x38; Enciende la pantalla
				movwf portc; y el cursor.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 0x0c; Establece las operaciones de 8 bits, y selecciona un
				movwf portc; display de 2 lìneas y fuente de 5 x 7 caracteres de puntos.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 0x01; Borra los caracteres que aparecen
				movwf portc; en la LCD y pon el cursor en el dígito 1.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 0x06; Establece el modo para incrementar la dirección en uno y para mover
				movwf portc; el cursor a la derecha a la hora de escribir en el 00/CG RAM.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				movlw 0x80; Coloca el cursor de la LCD
				movwf portc; en la posición del dígito 1.
				call pulso_enable; Llama a la subrutina que ingresa el dato/comando a la lcd.
				bsf porta,RS_LCD; Pon a la lcd en modo operacion.
				return; Regresa de la subrutina.
;--------------------------------------------------------------------------------------------------
 ;====================================================
 ;== Subrutina que ingresa el comando/dato a la LCD ==
 ;====================================================
pulso_enable 	bcf porta,Enable_LCD; Pon a 1 el bit Enable_LCD del registro porta.
				call retardo_1ms; Llama a la subrutina de retardo de 1ms.
				bsf porta,Enable_LCD; Pon a 0 el bit Enable_LCD del registro porta.
				call ret_40ms; Llama a la subrutina de retardo de 40ms.
				return; Regresa de la subrutina.
;--------------------------------------------------------------------------------------------------
 ;================================
 ;== Subrutina de retardo de 1ms =
 ;================================
retardo_1ms 	clrf cont_milis; Borra el contenido del registro cont_milis.
esp_int1ms 		movlw .1; Mueve el valor 1 en decimal al registro w.
				subwf cont_milis,w; Resta el contenido del registro w al contenido del registro cont_milis, y guarda el resultado en w.
				btfss status,Z; Prueba el bit z del registro status, brinca si esta en 1.
				goto esp_int1ms; Ve a esp_int1ms.
				return; Regresa de la interrupcion.
;--------------------------------------------------------------------------------------------------
 ;================================
 ;== Subrutina de retardo de 40ms =
 ;================================
ret_40ms 		clrf cont_milis; Borra el contenido del registro cont_milis.
esp_int40ms 	movlw .40; Mueve el valor 40 en decimal al registro w.
				subwf cont_milis,w; Resta el contenido del registro w al contenido del registro cont_milis, y guarda el resultado en w.
				btfss status,Z; Prueba el bit z del registro status, brinca si esta en 1.
				goto esp_int40ms; Ve a esp_int40ms.
				return; Regresa de la subrutina.
;--------------------------------------------------------------------------------------------------
 ;=================================================
 ;== Subrutina de espera de int. de 1 segundo ==
 ;=================================================
esp_int 	nop; Sin operacion.
			btfss banderas,ban_int; Prueba el bit ban_int del registro banderas, brinca si esta en 1.
			goto esp_int; Ve a esp_int.
			bcf banderas,ban_int; Pon a 0 el bit ban_int del registro banderas.
			return; Regresa de la interrupcion.
;--------------------------------------------------------------------------------------------------
 ;============================================
 ;== Subrutina de retardo de dispensamiento ==
 ;============================================
retardo_dispen 	clrf cont_segundos; Borra el contenido del registro cont_milis.
esp_ret 		movlw .3; Mueve el valor 3 en decimal al registro w.
				subwf cont_segundos,w; Resta el contenido del registro w al contenido del registro cont_milis, y guarda el resultado en w.
				btfss status,Z; Prueba el bit z del registro status, brinca si esta en 1.
				goto esp_ret; Ve a esp_ret.
				return; Regresa de la interrupcion.
;--------------------------------------------------------------------------------------------------
end; Termina el progra
