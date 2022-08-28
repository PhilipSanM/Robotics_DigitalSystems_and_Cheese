/*
subir código y visualizar en el monitor serial cual es la lectura cuando hay
presencia de gas o aliento alcoholico y apuntar los valores mínimos y máximos
*/

int gas = 0; // variable global

void setup(){
  
  Serial.begin(9600); // inicializar comunicación serial
  pinMode(A0, INPUT); // inicializar pines


}

void loop(){

  gas = analogRead(A0); //guardar lectura analogica en variable
  
  Serial.println(gas);

}
