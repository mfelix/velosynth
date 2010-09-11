#include "Speedometer.h"

// bike wheel circumference in mm (2100 = almost exact for 700-23c wheels)
const unsigned int WHEEL_CIRCUM = 2100;

int rpm;

// make a speedometer object!
Speedometer speedometer(WHEEL_CIRCUM, 1);


void setup() {
  Serial.begin(9600);  
  attachInterrupt(1, sensorTripped, RISING);
}

void loop() {
  rpm = speedometer.checkRPM();
  

}

void sensorTripped() {
  speedometer.sensorTripped();
  Serial.println("!");
}
