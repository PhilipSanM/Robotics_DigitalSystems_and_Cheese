// C++ code
//
void setup()
{
  pinMode(9, OUTPUT); // G
  pinMode(8, OUTPUT); // F
  pinMode(7, OUTPUT); // A
  pinMode(6, OUTPUT); // B
  pinMode(5, OUTPUT); // .
  pinMode(4, OUTPUT); // C
  pinMode(3, OUTPUT); // D
  pinMode(2, OUTPUT); // E
}

void loop()
{
  //INIT
  digitalWrite(9, LOW);
  digitalWrite(8, LOW);
  digitalWrite(7, LOW);
  digitalWrite(6, LOW);
  digitalWrite(5, HIGH);
  digitalWrite(4, LOW);
  digitalWrite(3, LOW);
  digitalWrite(2, LOW);
  //START
  digitalWrite(9, HIGH); // 0
  delay(1000);
  
  digitalWrite(8,HIGH);
  digitalWrite(7,HIGH); //1
  digitalWrite(5,HIGH);
  digitalWrite(3,HIGH);
  digitalWrite(2,HIGH);
  delay(1000);
  
  digitalWrite(4,HIGH);
  digitalWrite(7,LOW); //2
  digitalWrite(9,LOW);
  digitalWrite(3,LOW);
  digitalWrite(2,LOW);
  delay(1000);
  
  digitalWrite(4,LOW); //3
  digitalWrite(2,HIGH);
  delay(1000);
  
  digitalWrite(3,HIGH);
  digitalWrite(7,HIGH); //4
  digitalWrite(8,LOW);
  delay(1000);
  
  digitalWrite(6, HIGH);
  digitalWrite(3, LOW);//5
  digitalWrite(7, LOW);
  delay(1000);
  
  
  digitalWrite(2, LOW);//6
  delay(1000);
  
  digitalWrite(8,HIGH); //7
  digitalWrite(9,HIGH);
  digitalWrite(3,HIGH);
  digitalWrite(2,HIGH);
  digitalWrite(6,LOW);
  delay(1000);
  
  digitalWrite(8,LOW); 
  digitalWrite(9,LOW);
  digitalWrite(7,LOW);
  digitalWrite(6,LOW);//LOW
  digitalWrite(4,LOW);
  digitalWrite(3,LOW);
  digitalWrite(2,LOW);
  delay(1000);
  
  digitalWrite(3,HIGH);
  digitalWrite(2,HIGH);
  delay(1000);
  
  
}