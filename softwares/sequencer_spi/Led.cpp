/*  Led.cpp
	Velosynth/Arduino LED class
	for C++/Arduino
*/

#include "Led.h"

Led::Led(pinNumber) {
	this.pinNumber = pinNumber;
	status = 0;
	
}

Led::toggle() {
	if(status == 0) {
		digitalWrite(pinNumber, HIGH);
		status = 1;
	}
	else {
		digitalWrite(pinNumber, LOW);
		status == 0;
	}
	
}
