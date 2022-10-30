
const byte pinPIR = 2;
const byte rele = 4;
const byte LDR = A0;     //light dependent resistor
//                  resistencia dependiente de luz
 
bool presencia;
int luz;

void setup()
{
  pinMode(LDR, INPUT);  
  pinMode(rele, OUTPUT);
  pinMode(pinPIR, INPUT);
  Serial.begin(9600);
}

void loop()
{
  //obtener lectura
  presencia = digitalRead(pinPIR);
  luz = analogRead(LDR);
  
  
  //realizar una tarea
  //  luz < 400 --- noche
  
  if(presencia == 1 && luz < 400){
    digitalWrite(rele, HIGH);
  }else{
    digitalWrite(rele, LOW);
  }
  
  //imprimir variables
  Serial.print(presencia);
  Serial.print("     ");
  Serial.println(luz);
}









