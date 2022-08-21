// C++ code
//
void setup()
{
  Serial.begin(9600);
  pinMode(A1,INPUT);
  pinMode(6,OUTPUT);
}

void loop()
{
 // analogRead(A1);
  //This command reads the analog voltage from an input
  // (pinA0,A1,...)
  // Argument: (pin);
  // Note: The voltage will be in bits
  //     0v -> 0 bits
  //   5v -> 255 bits
  //  This command returns a numeric value. 0 - 1023
  // Ex:    analogRead(A1);
 // Serial.println(analogRead(A1));
  analogWrite(6,analogRead(A1)/4);
  
}
