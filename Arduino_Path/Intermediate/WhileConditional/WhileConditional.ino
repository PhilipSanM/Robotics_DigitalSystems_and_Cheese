
byte led = 13;
byte pinPot = A0;
byte pinB = 2;
byte pinZ = 4;
byte pinPIR = 7;

int lectura;
bool estadoB;
bool presencia;
  
void setup()
{
  pinMode(led, OUTPUT);
  pinMode(pinZ, OUTPUT);
  pinMode(pinPot, INPUT);
  pinMode(pinB, INPUT);
  pinMode(pinPIR, INPUT);
  
  Serial.begin(9600);
}

void loop()
{
  lectura = analogRead(pinPot);
  estadoB = digitalRead(pinB);
  presencia = digitalRead(pinPIR);

  while(presencia == 1){
    Serial.println("dentro del while");
    digitalWrite(pinZ, HIGH);
    digitalWrite(led, HIGH);
    estadoB = digitalRead(pinB);
    
    if(estadoB == 1){
       break;
    }
  }
  
  digitalWrite(led, LOW);
  digitalWrite(pinZ, LOW);
  Serial.println("afuera del while");
  
}



