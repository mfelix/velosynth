/*  Speedometer.cpp
	Velosynth/Arduino Speedometer class
	for C++/Arduino
*/

#include "Speedometer.h"

Speedometer::Speedometer(int wheelCircumference, int resolution) {
  this->wheelCircumference = wheelCircumference;
  this->revs = 0;
  this->rpm = 0;
  this->oldTime = 0;
  this->resolution = resolution;
}

void Speedometer::initialize() {
//  attachInterrupt(1, this->sensorTripped(), RISING);
}

int Speedometer::checkRPM() {
  if (revs >= resolution) { 
    unsigned long curTime = millis();
    rpm = 60000 * revs / (curTime - oldTime);
    oldTime = curTime;
    revs = 0;
    return rpm;
  }
  return -1;
}

void Speedometer::sensorTripped() {
  revs++;
}


