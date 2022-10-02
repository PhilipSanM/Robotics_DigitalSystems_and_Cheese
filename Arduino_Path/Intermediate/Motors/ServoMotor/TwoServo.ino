

// LIBRARIES:
#include <Servo.h>

// Servo it's an Object of OOP
Servo miServoA;
Servo miServoB;


// Def. of program variables
int lecturaA;
int anguloA;

int lecturaB;
int anguloB;

// Def. of Arduino pins
byte pinPotA = A0;
byte pinPotB = A1;


void setup()
{  
  //           pin
  // Init of the servo pin
  miServoA.attach(2);
  miServoB.attach(4);
  pinMode(pinPotA, INPUT);
  pinMode(pinPotB, INPUT);
  Serial.begin(9600);
  
}

void loop()
{
  // READ
  lecturaA = analogRead(pinPotA);
  // Map for the angle betwen 0 and 180 degrees
  anguloA = map(lecturaA, 0, 1023, 180, 0);
  lecturaB = analogRead(pinPotB);
  anguloB = map(lecturaB, 0, 1023, 180, 0);
  
  
  // WRITE
  //             angle
  miServoA.write(anguloA);  // 0 - 180
  //              angle
  miServoB.write(anguloB);  // 0 - 180
  
  
  Serial.print("Servo A: ");
  Serial.print(anguloA);
  Serial.print(" - ");
  Serial.print("Servo B: ");
  Serial.println(anguloB);
  
}



