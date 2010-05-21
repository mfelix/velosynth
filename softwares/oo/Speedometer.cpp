/*  Speedometer.cpp
	Velosynth/Arduino Speedometer class
	for C++/Arduino
*/

#include "Speedometer.h"

Speedometer::Speedometer(int sensorPin, int wheelCircumference, int mean, int sensitivity) {
	this->sensorPin = sensorPin;
	this->wheelCircumference = wheelCircumference;
	this->mean = mean;
	this->sensitivity = sensitivity;

	startTime = micros();	// start time for wheel rotation in microseconds
	resetTime = 10000000;

	currentSpeed = 0;
	wheelRotations = 0;
}

unsigned long Speedometer::getSpeed() {
	return measureSpeed();
}

float Speedometer::getSpeedMph() {
	float mph = measureSpeed() / 1.609344;	
	return mph;
}

// PRIVATE
//
unsigned long Speedometer::measureSpeed() {
  	int sensorReading;
  	unsigned long currentTime;
	
	
   	if (micros() < resetTime) {
     	sensorReading = analogRead(sensorPin);
    
    	if (sensorReading > (mean + sensitivity) || sensorReading < (mean - sensitivity)) {
      		currentTime = micros();
			
      		if(currentTime < startTime + 10000) {
        		startTime = currentTime;
      		} else {
        		wheelRotations++;
        		currentSpeed = calculateSpeed(currentTime - startTime);
        		startTime = currentTime;
      		}
    	}
  	}
    
	resetTime = micros() + 1000;  
	return currentSpeed;
}

unsigned long Speedometer::calculateSpeed(unsigned long duration){
	// Calculate distance
	// Integer operations are significantly faster on the Arduino
	unsigned long distancem = wheelRotations * wheelCircumference / 1000; // distance in metres
	unsigned long distancekm = distancem / 1000; // distance in km (this truncates the number)
	unsigned long distanceRem = distancem - (distancekm * 1000); // the bit after the decimal point

	// calculate speed
	// mm / microsecond x 1000 is mm / millisecond
	// mm / millisecond is equivalent to m / sec
	// m / sec x 60 x 60 is m / hr
	// m / hr / 1000 is km / hr
	unsigned long speed100m = wheelCircumference * 36000 / duration; // 100m per hour
	unsigned long speedkm = speed100m / 10; // km per hour
	unsigned long speedRem = speed100m - (speedkm * 10); // the bit after the decimal point

	return speedkm;
}
