/*  Speedometer.h
	Velosynth/Arduino Speedometer class
	for C++/Arduino
*/

/*
Use this class to keep track of a bicycle's speed using a digital Hall Effect sensor.

Because we're using a digital sensor with an interrput, this library takes two steps to configure.
1.  Instantiate a new Speedometer object like so:
      Speedometer speedomerName(2100, 2);
    The parameters, in order, are:
	    int wheelCircumference: circumference of the bike wheel and tire, in mm
	    int resolution: the number of wheel revolutions that must occur for RPM to be recalculated.
2.  Register an interrupt in your main sketch.
    First, in your setup() function, call the attachInterrupt function like so:
        attachInterrupt(1, interruptHandler, RISING); // replace 1 with the correct interrupt
    Then, write a function to handle the interrupt. This function must call the speedometerName.sensorTripped function.
      void interruptHandler() {
        speedometerName.sensorTripped();
      }

To get the current speed in RPMs, call speedometerName.checkRPM(). The function will return the current speed ff the resolution tolerance has been met, or the most recently calculated speed if not. 

To get the current speed in km/hour, call speedometerName.checkKmph(). The function will return the current speed ff the resolution tolerance has been met, or the most recently calculated speed if not. 

*/

#ifndef SPEEDOMETER_H
#define SPEEDOMETER_H

#include "WProgram.h"

class Speedometer {
public:
	Speedometer(int wheelCircumference, int resolution);

  int checkRPM();
  int checkKmph();

  void sensorTripped();
private:
  void measure();

  int wheelCircumference;
	volatile byte revs;
  unsigned int rawRevs;
  unsigned long oldTime;
  int resolution;
  unsigned long speedCalcCoefficient;
};


#endif
