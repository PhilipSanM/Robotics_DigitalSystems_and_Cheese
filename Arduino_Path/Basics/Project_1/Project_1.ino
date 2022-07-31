void setup() {
  // put your setup code here, to run once:
//  Serial.begin(); // This command is the init of serial
                  // comunication betwen Arduino and a PC
                  // We will use it always we want to show
                  // a message on ur PC
  Serial.begin(9600); // With this command we init the serial
                        // Comunication at 9600 bits/sec.
}

void loop() {
  // put your main code here, to run repeatedly:
//Serial.println(); // Command used for print a line.
                  // it shows you a text line on ur screen.
                  // The argument will be the message

  Serial.println("Hello from an Arduino"); // Prints--> "Hello from an Arduino"
  //Now let's add a delay in order to see the simulation more slowly
  // a pause of 1 sec ----  delay(1000);
  // a pause of 1/2 sec ----  delay(500);
  // a pause of 9 sec ----  delay(9000);
  delay(4000);
}
