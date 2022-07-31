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
}
