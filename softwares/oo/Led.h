/*  Led.h
	Velosynth/Arduino LED class
	for C++/Arduino
*/

/*
This should be an easy to use class allowing access to LEDs.

Instantiate a new Led object like this, where pinNumber represents the id of the pin the LED is connected to.
	Led anLed(pinNumber);
Then, anytime you want to toggle the LED, just call your object's toggle method, like so:
	anLed.toggle();
This method returns a boolean value indicating the state of the LED after the method executes. 
*/

#ifndef LED_H
#define LED_H

#include "WProgram.h"

class Led {
public:
	Led(int pinNumber);

	boolean toggle();
	
private:
	int pinNumber;
	boolean status;
};


#endif
