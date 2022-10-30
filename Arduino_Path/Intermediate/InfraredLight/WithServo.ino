
// LIBRARIES:
#include <Servo.h>

// Servo it's an Object of OOP
Servo myServo;

// Const for pin
const byte pinPIR = 2;

//Variables
int angle;
int lectur;
bool presence;

void setup()
{
  //Init
  myServo.attach(3);
  pinMode(pinPIR, INPUT);
  Serial.begin(9600);
}

void loop()
{
  //Read of Sensor
  presence = digitalRead(pinPIR);
 
  
  if(presence == true ){
    angle = 90;
    myServo.write(angle);
  }else{
    angle = 0;
    myServo.write(angle);
  }
  
  //imprimir variables
  Serial.print(presence);
  Serial.print("     ");
  Serial.println(angle);
}











