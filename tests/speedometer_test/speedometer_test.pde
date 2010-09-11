#include "Speedometer.h"

// bike wheel circumference in mm (2100 = almost exact for 700-23c wheels)
const unsigned int WHEEL_CIRCUM = 2100;

int rpm;
int last_rpm;

// make a speedometer object!
Speedometer speedometer(WHEEL_CIRCUM, 1);


void setup() {
  Serial.begin(9600);  
  attachInterrupt(1, sensorTripped, RISING);
}

void loop() {
  rpm = speedometer.checkRPM();
  if (last_rpm != rpm) {
    Serial.println(rpm);
  }
  last_rpm = rpm;
}

void sensorTripped() {
  speedometer.sensorTripped();
  Serial.println("!");
}
