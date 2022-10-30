
const byte rele = 2; 

const byte arriba = 4; 
const byte abajo = 7; 

bool lectura_arriba;
bool lectura_abajo;

bool activar;

void setup()
{
  pinMode(arriba, INPUT);
  pinMode(abajo, INPUT);
  pinMode(rele, OUTPUT);
  
  Serial.begin(9600);
}

void loop()
{
  lectura_arriba = digitalRead(arriba);
  lectura_abajo = digitalRead(abajo);
  
  if(lectura_arriba == 1){
    activar = 0;
  }
  
  if(lectura_abajo == 0){
    activar = 1;
  }
  
  //           pin,   estado  LOW  HIGH  = 0  1 
  digitalWrite(rele, activar);
  
  Serial.print(lectura_arriba);
  Serial.print("     ");
  Serial.print(lectura_abajo);
  Serial.print("     ");
  Serial.println(activar);
  
}







