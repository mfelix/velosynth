/*  Speedometer.h
	Velosynth/Arduino Speedometer class
	for C++/Arduino
*/

/*
Use this class to keep track of a bicycle's speed using a Hall Effect sensor. 

Instantiate a new Speedometer object like this:
	Speedometer speedomerName(0, 2100, 508, 40, 1000);
The parameters, in order, are:
	int sensorPin: the pin the Hall Effect sensor is connected to
	int wheelCircumference: circumferences of the bike wheel and tire, in mm
	int mean: the mean ("rest") value of the Hall Effect Sensor
	int sensitivity: the sensitivity variable for the sensor
	int pollingInterval: length of time (in microseconds) between each time the software checks the sensor.

To get the current speed, call speedometerName.getSpeed(). Speed, in Km/h is returned as an unsigned long.
To get the current speed in miles/hour, call speedometerName.getSpeedMph(). Speed is returned as a float.

Will need to add logic to change the speed update interval; currently, if the interval has not passed, the getSpeed() methods
return cached speed.
*/

#ifndef SPEEDOMETER_H
#define SPEEDOMETER_H

#include "WProgram.h"

class Speedometer {
public:
	Speedometer(int wheelCircumference, int resolution);
  void initialize();
  int checkRPM();
  void sensorTripped();
	
private:

  
  int wheelCircumference;
	volatile byte revs;
  unsigned int rpm;
  unsigned long oldTime;
  int resolution;
};

#endif
