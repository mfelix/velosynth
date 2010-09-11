#include "Ports.h"
#include "RF12.h"
//#include "Speedometer.h"


const unsigned int WHEEL_CIRCUM = 2100; // bike wheel circumference in mm
volatile int revs = 0;
  unsigned long zoom;
  unsigned int rpm;
  unsigned int revDur;
  unsigned long curTime;
  unsigned long oldTime;
  int resolution = 1;
  
MilliTimer speedometer;


void setup() {
  Serial.begin(9600);  
  attachInterrupt(1, sensorTripped, RISING);
  oldTime = millis();
}

void loop() {
  
  checkSpeed();


  
}

void checkSpeed() {
  if (revs >= resolution) { 
    curTime = millis();
    revDur = (curTime - oldTime)/revs;
    rpm = 30000/revDur;
    zoom = rpm * 2100;
    Serial.println(rpm);
    Serial.println(zoom);
    Serial.println(revDur);
    Serial.println("-");
    
    oldTime = millis();
    revs = 0;
  }
}

void sensorTripped() {
  revs++;
}
