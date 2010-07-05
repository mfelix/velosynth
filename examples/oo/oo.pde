/*
  ad5206-controlled / sequencer
  
*/
#include "Led.h"
#include "Speedometer.h"
#include "Envelope.h"
#include "Controller.h"

#define DATAOUT 11
#define DATAIN 12
#define SPICLOCK  13
#define SLAVESELECT 8

#define CHANNEL_A 5
#define CHANNEL_B 4
#define CHANNEL_C 3
#define CHANNEL_D 1
#define CHANNEL_E 0
#define CHANNEL_F 2

// Pin bindings
const int LEDPIN = 5;
const int HALL_EFFECT_PIN = 0;
const int MEAN = 508;  // sensor at rest (no magnet)
const int SENSITIVITY = 40;  // sensor sensitivity
const unsigned long POLLING_INTERVAL = 1000;

// Other environmental constants
const unsigned int WHEEL_CIRCUM = 2100; // bike wheel circumference in mm (2100 = almost exact for 700-23c wheels)
// Initialize I/O Objects
Led led(LEDPIN);
Speedometer speedometer(WHEEL_CIRCUM, 1);

const int ENVELOPE_LENGTH = 800;

Controller controller(DATAIN, DATAOUT, SPICLOCK, SLAVESELECT);
Envelope envelope(ENVELOPE_LENGTH, 0, 255);

int t = 0;

// int tempo = 100; // global sequencer tempo // replaced by tempo() function
int curTempo;

unsigned long thisStep = millis();
unsigned long nextStep = millis() + curTempo;

int curSpeed;
const int maxSpeed = 25; //kpm
const int trackLength = 16;

int c;

int k[8] = {1, 255, 255, 255, 1, 255, 255, 255};

#define MAX 16

int trackBank[maxSpeed][trackLength];

int halfSteps[16] = {
  235,
222,
209,
198,
186,
176,
166,
157,
148,
140,
132,
125,
  0,
  0,
  0,
  0
  };  

int majorScale[16] = {
  235,

209,

186,
176,

157,

140,

125,
  118, //octave
  235,

209,

186,
176,

157,

140,

125,
  118 //octave
 
  };  

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

void setup()   {                
  
  // Serial.begin(9600);  
  controller.initialize();
  speedometer.initialize();
//  Serial.print("Note Generated!");
  attachInterrupt(1, sensorTripped, RISING);
  select_note(0);
  controller.write_pot(CHANNEL_D, 0); // amplitude full
}

void loop()                     
{ 
  int rpm = speedometer.checkRPM();
  if (rpm > -1) {
    select_note(rpm);    
  }
  play_note(); 
}

void sensorTripped() {
  speedometer.sensorTripped();
}

int note0[] = {180, 170, 160, 190, 200, 220, 230, 235 };
int note1[] = {120, 120, 130, 140, 150, 130, 140, 120 };
int note2[] = {60,  40,  80,  90,  120, 110, 70,  50 };

int *notes[] = {note0, note1, note2};
int *note;
int silent[] = {255, 255, 255, 255, 255, 255, 255, 255 }; // mostly silent frequency values

void select_note(int rpm) {  
  int beat = map(rpm, 0, 150, 5000, 1); // number of milliseconds between beat changes
  long selection = (millis() / beat) % 3;
  if ( t % 8) {
    note = notes[selection];
  } else {
    note = silent;
  }
  sequencer_step(); // update step
}

void play_note() {
  //sequencer_step();
  long last, now;
  int waitForIt = 300;
  for(int i = 0; i < 8; i++) {
    now = micros();
    if (now - last < waitForIt) {
      i--;
    } else {
      controller.write_pot(CHANNEL_D, ( now / 1500 ) % 255); // amplitude?
      controller.write_pot(CHANNEL_C, *(note + i));         // frequency
      last = now;
    }
  }
}

void sequencer_step() {
  if(t<MAX) {
    t+=1;
  }
  else {
    t=0;
  }
  led.toggle();
}

