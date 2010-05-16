/*  Led.cpp
	Velosynth/Arduino LED class
	for C++/Arduino
*/

#include "Led.h"

Led::Led(pinNumber) {
	pinMode(pinNumber, OUTPUT);
	this.pinNumber = pinNumber;
	status = FALSE;
	
}

boolean Led::toggle() {
	if(status == FALSE) {
		digitalWrite(pinNumber, HIGH);
		status = TRUE;
	}
	else {
		digitalWrite(pinNumber, LOW);
		status == FALSE;
	}
	
	return status;
}
