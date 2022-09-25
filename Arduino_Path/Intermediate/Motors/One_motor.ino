//creación variables para pines 
byte pinM1A = 3;
byte pinM1B = 5;
byte pinPot = A0;

byte pinM2A = 9;
byte pinM2B = 10;

//variable para sensores
int lectura;
int velocidad;


void setup()
{
  Serial.begin(9600);
  pinMode(pinM1A, OUTPUT); // actuador
  pinMode(pinM1B, OUTPUT);
  
  pinMode(pinPot, INPUT);  // sensores
}

void loop()
{
  lectura = analogRead(pinPot); // 0 - 1023
  
  //   map(variable, min, max, nuevoMin, nuevoMax)
  velocidad = map(lectura, 0, 1023, 0, 255);
 
  analogWrite(pinM1B, velocidad);   //0-255
  analogWrite(pinM1A, 0);            // 0-255
 
  
  Serial.print(lectura);
  Serial.print("    ");
  Serial.println(velocidad);
  
}
