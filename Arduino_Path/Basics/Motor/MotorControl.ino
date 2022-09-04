// C++ code
//
void setup()
{
  pinMode(9, OUTPUT);
  pinMode(10,OUTPUT);
}

void loop()
{
  digitalWrite(10, HIGH);
  digitalWrite(9, LOW);
  delay(1000);

  digitalWrite(10, LOW); // This for stopping correctly the motor
  digitalWrite(9, LOW);
  delay(1000);
  
  digitalWrite(9, HIGH);
  digitalWrite(10, LOW);
  delay(1000);
  

  digitalWrite(10, LOW); // This for stopping correctly the motor
  digitalWrite(9, LOW);
  delay(1000);
  
  
  
}
