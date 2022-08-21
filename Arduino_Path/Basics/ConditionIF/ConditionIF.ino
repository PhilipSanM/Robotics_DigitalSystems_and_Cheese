// C++ code
//
void setup()
{
  
  pinMode(A1,INPUT);
  pinMode(12,OUTPUT);
  
}

void loop()
{
  //if(condition){TRUE}else{FALSE}
  if(analogRead(A1)<511){
    digitalWrite(12,HIGH);
  }else{
    digitalWrite(12,LOW);
  }
  
}
