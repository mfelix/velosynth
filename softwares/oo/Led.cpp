/*  Led.cpp
	Velosynth/Arduino LED class
	for C++/Arduino
*/

#include "Led.h"

Led::Led(int pinNumber) {
	pinMode(pinNumber, OUTPUT);
	this->pinNumber = pinNumber;
	status = 0;
}

boolean Led::toggle() {
	if(0 == status) {
    _on();
	}
	else {
    _off();
	}
	return status;
}

void Led::on() {
  if(0 == status) {
    _on();
  }
}

void Led::off() {
  if(1 == status) {
    _off();
  }
}

void Led::_on() {
    digitalWrite(pinNumber, HIGH);
    status = 1;
}

void Led::_off() {
    digitalWrite(pinNumber, LOW);
    status = 0;
}
