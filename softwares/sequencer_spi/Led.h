/*  Led.h
	Velosynth/Arduino LED class
	for C++/Arduino
*/

/*
This should be an easy to use class allowing access to LEDs.

Instantiate a new Led object like this, where pinNumber represents the id of the pin the LED is connected to.
	anLed = Led.new(pinNumber);
Then, anytime you want to toggle the LED, just call your object's toggle method, like so:
	anLed.toggle();
*/

#ifndef LED_H
#define LED_H

#include "WProgram.h"

class Led {
	Led(pinNumber);
	
	boolean toggle();
	
private:
	int pinNumber;
	boolean status;
}


#endif