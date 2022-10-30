// relevador, reles, relays


byte pinRele = 2;

char orden;

void setup()
{
  pinMode(pinRele, OUTPUT);
  Serial.begin(9600);
}

void loop()
{
  
  if(Serial.available() > 0){
     orden = Serial.read();
  }
      
    if(orden == 'A'){
    digitalWrite(pinRele, HIGH);
  }
  
  if(orden == 'B'){
    digitalWrite(pinRele, LOW);
  }
  
  Serial.println(orden);          
                
}



