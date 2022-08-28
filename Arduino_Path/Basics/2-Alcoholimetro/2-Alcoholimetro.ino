/*
Calcular un valor medio entre el mímino y maximo de sus lecturas
*/

int gas = 0; // variable global

void setup(){
  
  Serial.begin(9600); // inicializar comunicación serial
  pinMode(A0, INPUT); // inicializar pines
  pinMode(2, OUTPUT); // inicializar pines
  pinMode(3, OUTPUT); // inicializar pines
  pinMode(4, OUTPUT); // inicializar pines

}

void loop(){

  gas = analogRead(A0); //guardar lectura analogica en variable
  
  // valor mínimo 400  --- valor máximo 750,  valor medio =  575 

  if(gas >  575){  // Si gas es mayor a valor medio (en mi caso 575) entonces:
  
    digitalWrite(3,HIGH); //rojo
    digitalWrite(2,LOW); //verde
    
    digitalWrite(4,HIGH);  //zumbador
    delay(1000);
    digitalWrite(4,LOW);
    delay(1000);     
  }
  else{ 
  
    digitalWrite(3,LOW); 
    digitalWrite(2,HIGH);
    
    digitalWrite(4,LOW);
  
  }
  
    Serial.println(gas);

}
