#include <Servo.h>

byte pinPot = A0;
byte led = 3;

int lectura;

int brillo;
int angulo;

Servo miServo;
  
void setup()
{
  pinMode(pinPot, INPUT);
  pinMode(led, OUTPUT);
  miServo.attach(7);
  Serial.begin(9600);
}

void loop()
{
  lectura = analogRead(pinPot);
  brillo = map(lectura, 0, 1023, 0, 255);
  angulo = map(lectura, 0, 1023, 180, 0);
  
  miServo.write(angulo);
  analogWrite(led, brillo);
  
  Serial.println(brillo);
}



