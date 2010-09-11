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
  this->rpm = 0;
  // 1,000,000 mm = 1 km
  speedCalcCoefficient = this->wheelCircumference / 1000000;
}

int Speedometer::checkRPM() {
  measure();
  return rpm;
}

int Speedometer::checkKmph() {
  measure();
  return rpm * wheelCircumference * 3600;
}

void Speedometer::sensorTripped() {
    revs++;
}

// Private
void Speedometer::measure() {
  if (revs >= resolution) { 
    curTime = millis();
    revDur = (curTime - oldTime)/revs;
    rpm = 30000/revDur;
    oldTime = millis();
    revs = 0;
  }
}


