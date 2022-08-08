// C++ code
//
void setup()
{
  pinMode(7, OUTPUT); // RED
}

void loop()
{
 analogWrite(7, 255);
  // It sends the Voltage analogically
  // Arguments (PIN, BITS);
  // Remember that it can supply 5V so:
  // 5Volts = 255 bits
  // 0 V   =  0 bits
  //Ex: (7,200);
  delay(1000);
  analogWrite(7, 150);
  delay(1000);
  analogWrite(7, 0);
  delay(1000);
}
