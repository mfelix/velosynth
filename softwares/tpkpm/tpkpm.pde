/*
  ad5206-controlled / sequencer
  
*/
#include <math.h>

#define DATAOUT 11//MOSI
#define DATAIN 12//MISO - not used, but part of builtin SPI
#define SPICLOCK  13//sck
#define SLAVESELECT 10//ss

#define CHANNEL_A 5
#define CHANNEL_B 4
#define CHANNEL_C 3
#define CHANNEL_D 1
#define CHANNEL_E 0
#define CHANNEL_F 2

#define HALL_EFFECT 0


// hall effect sensor setup
const int mean = 508;  // sensor at rest (no magnet)
const int sensitivity = 40;  // sensor sensitivity

// distance and speed variables (floats are avoided because they slow the Arduino down)
unsigned long numWheelRotations = 0;  // the base from which all other data is calculated
const unsigned long wheelCircum = 2100;  // bike wheel circumference in mm (2100 = almost exact for 700-23c wheels)
 
int ledPin =  5;    // LED connected to digital pin 13
int t = 0;
int l = 0; // led toggle

// int tempo = 100; // global sequencer tempo // replaced by tempo() function
int curTempo;
byte pot=0;
byte resistance=0;


unsigned long startTime = micros();	// start time for wheel rotation in microseconds
unsigned long resetTime = 10000000;

unsigned long thisStep = millis();
unsigned long nextStep = millis() + curTempo;

int curSpeed;
const int maxSpeed =  25; //kpm
const int trackLength = 16;

int c;

int k[8] = {1, 255, 255, 255, 1, 255, 255, 255};

#define MAX 15

int trackBank[maxSpeed][trackLength];

int rhythm[16] = {
  0,  //1 
  0, 
  0, 
  0,
  0, 
  0, 
  0, 
  0,  //8
  255,  
  255,
  255,
  255,
  255,
  255,
  255,
  255,  //16
  };  

int rhythm2[16] = {
  255,  //1 
  0, 
  255, 
  0,
  255, 
  0, 
  255, 
  0,  //8
  255,  
  0,
  255,
  0,
  255,
  0,
  255,
  0,  //16
  }; 
  
int rhythm3[16] = {
  255,  //1 
  255, 
  255, 
  255,
  255, 
  255, 
  255, 
  255,  //8
  255,  
  255,
  255,
  255,
  255,
  255,
  255,
  255,  //16
  };   
  
int duration[8] = {10, 10, 10, 1, 1, 10, 10, 10};
int pattern1[8] = {5, 10, 50, 10, 5, 77, 5, 10};
int pattern2[8] = {333, 111, 444, 999, 111, 777, 333, 522};


char spi_transfer(volatile char data)
{
  SPDR = data;                    // Start the transmission
  while (!(SPSR & (1<<SPIF)))     // Wait the end of the transmission
  {
  };
  return SPDR;                    // return the received byte
}

void controller_init() {
  byte i;
  byte clr;
  pinMode(DATAOUT, OUTPUT);
  pinMode(DATAIN, INPUT);
  pinMode(SPICLOCK,OUTPUT);
  pinMode(SLAVESELECT,OUTPUT);
  digitalWrite(SLAVESELECT,HIGH); //disable device
  // SPCR = 01010000 
  //interrupt disabled,spi enabled,msb 1st,master,clk low when idle,
  //sample on leading edge of clk,system clock/4 (fastest)
  SPCR = (1<<SPE)|(1<<MSTR);
  clr=SPSR;
  clr=SPDR;
  delay(10);
  for (i=0;i<6;i++)
  {
    write_pot(i,255);
  }
}
  
void setup()   {                

  pinMode(ledPin, OUTPUT);
  controller_init();
  
  Serial.begin(9600);
  buildTrackBank();
  changeTempo();
}



void loop()                     
{

  measure_speed();  
  sequencer_step();

  write_pot(CHANNEL_A,trackBank[curSpeed - 1][t]);
  write_pot(CHANNEL_B,rhythm3[t]);
  write_pot(CHANNEL_C,rhythm3[t]);
  write_pot(CHANNEL_D,rhythm3[t]);
  
}


void measure_speed() {
  int s;
  unsigned long currentTime;
  
   if (micros() < resetTime) {
     
     // this is just to test when there is no bike
     //s = sin(micros()) * 2 * sensitivity;
     s = 508;
     //s = analogRead(HALL_EFFECT);
    
    if (s > (mean + sensitivity) || s < (mean - sensitivity)) {
      currentTime = micros();
    
      if(currentTime < startTime + 10000) {
        startTime = currentTime;
    
      } else {
        toggle_led();
        numWheelRotations++;
        calculate_speed(currentTime - startTime);
        startTime = currentTime;
      }
    }
  }
    resetTime = micros() + 1000;  
}

 
void calculate_speed(unsigned long duration){
  // calculate distance
  unsigned long distancem = numWheelRotations * wheelCircum / 1000; // distance in metres
  unsigned long distancekm = distancem / 1000; // distance in km (this truncates the number)
  unsigned long distanceRem = distancem - (distancekm * 1000); // the bit after the decimal point
  // calculate speed
  // mm / microsecond x 1000 is mm / millisecond
  // mm / millisecond is equivalent to m / sec
  // m / sec x 60 x 60 is m / hr
  // m / hr / 1000 is km / hr
  unsigned long speed100m = wheelCircum * 36000 / duration; // 100m per hour
  unsigned long speedkm = speed100m / 10; // km per hour
  unsigned long speedRem = speed100m - (speedkm * 10); // the bit after the decimal point
 
  float mph = speedkm / 1.609344;

  int s = map(mph, 1, 25, 1, 100);
  int m = map(s, 1, 100, 100, 1);
  
  Serial.print("speed km: ");
  Serial.println(speedkm);
  
  curSpeed = 3;
  // curSpeed = speedkm;
 
}

void sequencer_step() {
  int curTime = millis(); 

  if (curTime > nextStep) {
    
    if(t<MAX) {
      t+=1;
    }
    else {
      changeTempo();
      t=0;
    }
    toggle_led();
    
    nextStep = curTime + curTempo; 
  }
}

byte write_pot(int address, int value)
{
  digitalWrite(SLAVESELECT,LOW);
  //2 byte opcode
  spi_transfer(address);
  spi_transfer(value);
  digitalWrite(SLAVESELECT,HIGH); //release chip, signal end transfer
}




void toggle_led() {
     if(l==0) {
        l=1; 
       digitalWrite(ledPin, HIGH);
     }
     else
     {
       l=0;
       digitalWrite(ledPin, LOW);
     }

}

void changeTempo() {
   curTempo = map(curSpeed, 0, 33, 180, 20);

   Serial.print("\t");
   Serial.print("Current Tempo: ");
   Serial.println(curTempo);
}

void buildTrackBank() {
  for (int i; i < maxSpeed; i++){
    for (int j; j < trackLength; j++){
      trackBank[i][j] = random(0,200);
    }
  }
}
