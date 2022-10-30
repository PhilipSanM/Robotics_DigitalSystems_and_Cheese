# Abstract:
---
## Useful commands:🔥❤️‍🔥
## Map:

```CPP
  //   map(variable, min, max, nuevoMin, nuevoMax)
  velocidad = map(lectura, 0, 1023, 0, 255);
```

## While Loop:

```CPP
/* while(Condition){
    Code
  }
*/
  while(presence == 1){
    Serial.println("Inside While");
  // Also you can use:
  // break;
  // To get aoutside a loop
  }
  Serial.println("Outside While");

```

## For Loop:

```CPP
/* for(Initialization;Condition;Increment){
    Code
  }
*/
  for (int i = 0; i <= 180; i++) {
    analogWrite(ledPin, i);
    miServo.write(i);
    Serial.println(i);
    delay(300);
  }

```

## Delay microseconds:

```CPP
/* 
  delayMicroseconds(Integer);
  Just another delay but, for microseconds
*/
 delayMicroseconds(10);

```



