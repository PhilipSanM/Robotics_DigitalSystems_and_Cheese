
// const = solo lectura "constante"


const byte trigger = 7; // const = solo lectura ("constante")
const byte echo = 5;

float litros;
float altura;
float distancia;
int tiempo; 

const float pi = 3.1416;  
const float radio = 75;
const float h = 150;

const byte led1 = 13;
const byte rele = 2;


void setup()
{
  Serial.begin(9600);
  pinMode(trigger, OUTPUT); // sensor
  pinMode(echo, INPUT);     // de ultrasonido
  
  pinMode(rele, OUTPUT); // actuadores
  pinMode(led1, OUTPUT); // actuador
  
  
}

void loop()
{
  
  // código para sensor de ultrasonido
  digitalWrite(trigger, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigger, LOW);
  delayMicroseconds(10);
  tiempo = pulseIn(echo, HIGH);
  distancia = 0.01715 * tiempo;
  
  
  //---calculando la altura y los litros---------------------------------
  altura = h - distancia;
    
  litros = pi * (radio * radio) * altura * 0.001 ; //cm3 a litros 
  
  //            (pow(radio, 2))
  //----------------------------

  
  if (litros < 500){
   digitalWrite(led1, HIGH);
   digitalWrite(rele, HIGH);  
  }
  if (litros > 2300){
   digitalWrite(led1, LOW);
   digitalWrite(rele, LOW);
  }
  
   // 2700

  //Serial.println(distancia);

  Serial.println(litros);

}

