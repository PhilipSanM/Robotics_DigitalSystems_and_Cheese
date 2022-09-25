# ABSTRACT

---
## Useful commands:🔥❤️‍🔥
### Digital Write:
```CPP
digitallWrite(pin, State);
    // It sends 0V or 5V through an OUTPUT pin
  // Arguments:  (PIN, STATE);
  // STATE: 5V --> HIGH
  //       0V --> LOW
  // Ex:  digitalWrite(7,HIGH);
  // Ex:  digitalWrite(7,LOW);
```
### Pin Mode:
```CPP
  pinMode(pin, OUTPUT/INPUT);
  // This declare a "control pin", it means that
  // we say to ARDUINO that we are goin to use
  // this pin, fot input or output
  // Arguments: (PIN,MODE);
  //  MODE: OUTPUT  <-->  INPUT
  //  PIN: The pin ur going to use.
  //  Ex:  pinMode(7,OUTPUT);
```
### Digital Read:
```CPP
digitalRead(pin);
  //This read 0 or 1, just a bit
```
### Analog Write:
```CPP
analogWrite(pin,"bits");
  // It sends the Voltage analogically
  // Arguments (PIN, BITS);
  // Remember that it can supply 5V so:
  // 5Volts = 255 bits
  // 0 V   =  0 bits
  //Ex: (7,200);
```
### Analog Read:
```CPP
analogRead(pin);
  //This command reads the analog voltage from an input
  // (pinA0,A1,...)
  // Argument: (pin);
  // Note: The voltage will be in bits
  //     0v -> 0 bits
  //   5v -> 255 bits
  //  This command returns a numeric value. 0 - 1023
  // Ex:    analogRead(A1);
 // Serial.println(analogRead(A1));
```
### Setup and Setloop:
```CPP
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
```
### If Conditional:
```CPP
  //if(condition){TRUE}else{FALSE}
  if(analogRead(A1)<511){
    digitalWrite(12,HIGH);
  }else{
    digitalWrite(12,LOW);
  }
```
### Remember to use variables if you need 😀
### Arduino on Tinkercad:
![Resume](https://user-images.githubusercontent.com/99928036/192148771-1da617d8-c196-4273-bf48-0380f59da390.png)
