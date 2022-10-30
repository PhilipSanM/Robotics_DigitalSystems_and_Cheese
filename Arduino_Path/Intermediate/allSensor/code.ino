#include <Servo.h>

// Arduino Pins
byte pinPot = A0;
byte pinLDR = A1;
byte pinHorn = 6;
byte pinServo = 5;
byte pinLed = 4;
byte pinBottonB = 3;
byte pinBottonA = 2;


// Variables
//	Led
bool ledState = false;

bool bottonB = false;
bool bottonA = false;

//	Servo
int angle;
int lecture;

// 		Servo Object
Servo myServo;
  

// LDR
int light;

void setup(){
  // Init
  pinMode(pinPot, INPUT);
  pinMode(pinLDR, INPUT);
  pinMode(pinHorn, OUTPUT);
  pinMode(pinLed, OUTPUT);
  pinMode(pinBottonA, INPUT);
  pinMode(pinBottonB, INPUT);
  myServo.attach(pinServo);
  Serial.begin(9600);
}

void loop(){
  // Servo:
  lecture = analogRead(pinPot);
  angle = map(lecture, 0, 1023, 180, 0);
  myServo.write(angle);
  
  // Led:
  bottonB = digitalRead(pinBottonB);
  bottonA = digitalRead(pinBottonA);
  if(bottonA){
  	digitalWrite(pinLed, HIGH);
    ledState = true;
  }else if(bottonB){
    if(ledState){
      digitalWrite(pinLed, LOW);
    }
    ledState = false;
    bottonA = false;
    bottonB = false;
  }
  
  // LDR
  light = analogRead(pinLDR);
  if(light > 100){
  	digitalWrite(pinHorn,HIGH);
  }else{
 	digitalWrite(pinHorn,LOW);
  }
}

