// C++ code
//
void setup()
{
  pinMode(13, OUTPUT); //GREEN
  pinMode(12, OUTPUT); // YELLOW
  pinMode(7, OUTPUT); // RED
  
  
}

void loop()
{
  digitalWrite(13,HIGH);
  delay(3000);
  digitalWrite(13,LOW);
  
  digitalWrite(12,HIGH);
  delay(500);
  digitalWrite(12,LOW);
  delay(500);
  digitalWrite(12,HIGH);
  delay(500);
  digitalWrite(12,LOW);
  delay(500);
  
  digitalWrite(7,HIGH);
  delay(3000);
  digitalWrite(7,LOW);
 
}
