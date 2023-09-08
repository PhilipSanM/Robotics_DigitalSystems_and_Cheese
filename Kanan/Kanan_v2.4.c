/*      =======================================================================
        =================== K A N A N =========================================
        =======================================================================
>>date of last modification: 09/07/23
Mexico is one of the most insecure countries, in addition to having a large number of missing persons... 
Have you ever felt in danger? 
(This is a project carried out during my confinement due to the covid-19 pandemic)
:3


* @copyright Copyright (c) 2023
Contributos:
 - PhilipSanM
 - Maurichio Hernandez

*/


#include <16F873A.h> //MICROCONTROLLER PIC16F873A

//Init of the Microcontroller and the SIM 800L and Neo GPS
#device PASS_STRINGS = IN_RAM
#fuses NOWDT,NOPROTECT,NOLVP
#fuses XT,PUT
#use delay(clock = 4000000)
#use RS232(UART1, BAUD = 9600, ERRORS)   // UART configuration & initialization

#use standard_io(B)// trisB
#use standard_io(A)//trisA

#define ledFunction   PIN_A0 // LED that turns on when you press the botton 3 times
#define ledLectureOK PIN_A1 //LED of lecture
#define ledSendMessage PIN_A2 //LED that turns on when the message has send

#define GGO  PIN_B1 //This is the botton of the main function
#include <GPS_Lib.c> //Library of the GPS

void main(){
  set_tris_b(0b00000011);//RB0 and RB1 are intput and the rest output
  //variables
  int j=0;
  int s=0;
  int g=0;
  do{
    //The botton when you push it 
    if(input(GGO)==0){
    g++;  //increments a varaible
    delay_ms(500);
    }
    
    //when the botton has been pushed 3 times
    if(g==3){
      delay_ms(1000);
      output_high(ledFunction);
      while(j<16) {
        //This read the GPS 
        //Its 16 times because it takes time to read the localization when the 
        // Kanan is turned on in the moment of use.
        if(kbhit()) {
          if(GPSRead()) {
            // Latitude
            printf("Latitude  :  %.6f\r\n", Latitude());
            // Longitude
            printf("Longitude :  %.6f\r\n", Longitude());
            j++;
          } else 
            output_high(ledLectureOK);
        }                   
      }
      //Now that the information of the GPS is OK
      //It's time to send the message with AT COMMANDS
      output_low(ledLectureOK);

      delay_ms(1000);

      printf("AT\n\r");
      delay_ms(2000);
      printf("AT+CMGF=1\n\r"); //Mode text if the sim 
      delay_ms(2000);
      //===========================
      //THIS IS MY PHONE NUMBER :3=
      //===========================
      printf("AT+CMGS=\"+525611107896\"\n\r");//Insert the phone number in the SIM
      delay_ms(2000);
      printf(" Me ha surgido un inprevisto, podrias tratar de contactarme? :((\n\r"); //This is the message
      printf("https://www.google.com/maps/place/%.6f,%.6f\r\n", Latitude(),Longitude()); //And U print it like a google maps link
      putc(26);// Thisis ctrl+Z to send the message
      delay_ms(1000);

      printf("AT\n\r");
      delay_ms(2000);
      printf("AT+CMGF=1\n\r"); //Mode text if the sim 
      delay_ms(2000);
      printf("AT+CMGS=\"+525611107896\"\n\r");//Insert the Celphone number
      delay_ms(2000);
      printf(" Me ha surgido un inprevisto, podrias tratar de contactarme? :((\n\r"); //This is the message
      printf("https://www.google.com/maps/place/%.6f,%.6f\r\n", Latitude(),Longitude()); //And U print it like a google maps link
      putc(26);// Thisis ctrl+Z to send the message
      delay_ms(1000);

      printf("AT\n\r");
      delay_ms(2000);
      printf("AT+CMGF=1\n\r"); //Mode text if the sim 
      delay_ms(2000);
      printf("AT+CMGS=\"+525611107896\"\n\r");//Insert the Celphone number
      delay_ms(2000);
      printf(" Me ha surgido un inprevisto, podrias tratar de contactarme? :((\n\r"); //This is the message
      printf("https://www.google.com/maps/place/%.6f,%.6f\r\n", Latitude(),Longitude()); //And U print it like a google maps link
      putc(26);// Thisis ctrl+Z to send the message
      delay_ms(1000);

      printf("AT\n\r");
      delay_ms(2000);
      printf("AT+CMGF=1\n\r"); //Mode text if the sim 
      delay_ms(2000);
      printf("AT+CMGS=\"+525611107896\"\n\r");//Insert the Celphone number
      delay_ms(2000);
      printf(" Me ha surgido un inprevisto, podrias tratar de contactarme? :((\n\r"); //This is the message
      printf("https://www.google.com/maps/place/%.6f,%.6f\r\n", Latitude(),Longitude()); //And U print it like a google maps link
      putc(26);// Thisis ctrl+Z to send the message

      output_high(ledSendMessage); //This LED is on when the message has already send
      delay_ms(50000);
      output_low(ledFunction);// Turns of the main LED
      output_low(ledSendMessage); // Turns on the Led of the message
      s++;
    }
  }while(true);
}
