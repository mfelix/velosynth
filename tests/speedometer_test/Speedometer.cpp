/*  Speedometer.cpp
	Velosynth/Arduino Speedometer class
	for C++/Arduino
*/

#include "Speedometer.h"

Speedometer::Speedometer(int wheelCircumference, int resolution) {
  this->wheelCircumference = wheelCircumference;
  this->revs = 0;
  this->oldTime = millis();
  this->resolution = resolution;
  
  // 1,000,000 mm = 1 km
  speedCalcCoefficient = this->wheelCircumference / 1000000;
}

int Speedometer::checkRPM() {
  measure();
  return 30000 / revDur;
}

int Speedometer::checkKmph() {
  measure();
  return speedCalcCoefficient * revDur;
}

void Speedometer::sensorTripped() {
  revs++;
}

// Private
void Speedometer::measure() {
  if (revs >= resolution) { 
    unsigned long curTime = millis();
    revDur = (curTime - oldTime) / revs;
    oldTime = curTime;
    revs = 0;
  }
}


