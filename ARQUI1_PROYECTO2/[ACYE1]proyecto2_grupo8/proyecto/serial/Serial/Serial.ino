void setup() {
  Serial.begin(9600);  //iniciamos comunicación de la terminal 1
  Serial1.begin(9600); //iniciamos comunicación de la terminal 2
  pinMode(7, OUTPUT);  //pin de salida para el led 
  pinMode(8, OUTPUT);  //pin de salida para el led 
  DDRF = B11111111;   //declaramos los pines del puerto F del arduino mega como salida 
}

char str[100];
char letra = '\0';
int pos=0;

void loop() {
  if(Serial.available() >0){
    letra = Serial.read();
    str[pos]=letra;
    pos++;
  }

  if(letra=='\r') {
    Serial1.print("Procesando : ");
    Serial1.print(str);

    procesarStr();
    pos =0;
    letra = '\0';
    
  }
}


void procesarStr(){
 if(str[0]=='l') {
  //led1e = encienda led 1
  //led1a = apaga led 1
  //led2e = encienda led 2
  //led2a = apaga led 2

  if(str[3]=='1' && str[4]=='e' ){ digitalWrite(8,HIGH); Serial.write("Arduino: Led 1 encendido-"); return; }
  if(str[3]=='1' && str[4]=='a' ){ digitalWrite(8,LOW); Serial.write("Arduino: Led 1 apagado-"); return; }
  if(str[3]=='2' && str[4]=='e' ){ digitalWrite(7,HIGH); Serial.write("Arduino: Led 2 encendido-"); return; }
  if(str[3]=='2' && str[4]=='a' ){ digitalWrite(7,LOW); Serial.write("Arduino: Led 2 apagado-"); return; }
 } else if (str[0]=='d') {
  //encender display con el numero indicado 
  int val = String(str[1]).toInt(); 
  PORTF = getBytes(val); 
  Serial.write("DISPLAY ENCENDIDO-"); 
  return;
 } else if(str[0]=='\r'){
  Serial.write("-"); //indicamos que  deje de escuchar
  return;
 }
  Serial.write("No se reconoce el comando");
  Serial.write(str);
  
}


void limpiarStr(){
  for(int i = 0; i<100; i++) {
    str[i]='\0';
  }
}

byte getBytes(int val) {
  if(val==0) return B1111110;
  if(val==1) return B0110000;
  if(val==2) return B1101101;
  if(val==3) return B1111001;
  if(val==4) return B0110011;
  if(val==5) return B1011011;
  if(val==6) return B1011111;
  if(val==7) return B1110000;
  if(val==8) return B1111111;
  if(val==9) return B1110011; 

}
