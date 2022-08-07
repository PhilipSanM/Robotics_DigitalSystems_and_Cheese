// C++ code
//
void setup()
{
  pinMode(7, OUTPUT);
  // This declare a "control pin", it means that
  // we say to ARDUINO that we are goin to use
  // this pin, fot input or output
  // Arguments: (PIN,MODE);
  //  MODE: OUTPUT  <-->  INPUT
  //  PIN: The pin ur going to use.
  //  Ex:  pinMode(7,OUTPUT);
  
}

void loop()
{
  digitalWrite(7,HIGH);
    // It sends 0V or 5V through an OUTPUT pin
  // Arguments:  (PIN, STATE);
  // STATE: 5V --> HIGH
  //       0V --> LOW
  // Ex:  digitalWrite(7,HIGH);
  // Ex:  digitalWrite(7,LOW);
  delay(1000);
  digitalWrite(7,LOW);
  delay(1000);
}
