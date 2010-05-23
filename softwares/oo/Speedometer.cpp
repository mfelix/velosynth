/*  Speedometer.cpp
	Velosynth/Arduino Speedometer class
	for C++/Arduino
*/

#include "Speedometer.h"

Speedometer::Speedometer(int sensorPin, int wheelCircumference, unsigned int mean, unsigned int sensitivity, unsigned int pollingInterval) {
	this->sensorPin = sensorPin;
	this->wheelCircumference = wheelCircumference;
	this->mean = mean;
	this->sensitivity = sensitivity;
  this->pollingInterval = pollingInterval;

	startTime = micros();	// start time for wheel rotation in microseconds

	currentSpeed = 0; //This is a guess.
	wheelRotations = 0;
	
  speedCalcCoefficient = wheelCircumference * 3600;
}

unsigned long Speedometer::getSpeedKmph() {
	return measureSpeed();
}

float Speedometer::getSpeedMph() {
	float mph = measureSpeed() / 1.609344;	
	return mph;
}

// PRIVATE
//
// Speed is returned in km/hr
unsigned long Speedometer::measureSpeed() {
  	int sensorReading;
  	unsigned long currentTime;
	
	  // Unsure if this if statement is necessary, should test to see what it does exactly.
   	if (!resetTime || micros() < resetTime) {
     	sensorReading = analogRead(sensorPin);
    
    	if (sensorReading > (mean + sensitivity) || sensorReading < (mean - sensitivity)) {
      		currentTime = micros();
			    
			    // debounce
			    // This assumes that the bike is traveling ~< 756 kph
      		if(currentTime < startTime + 10000) {
        		startTime = currentTime;
      		} else {
        		wheelRotations++;
            currentSpeed = speedCalcCoefficient / (currentTime - startTime);
        		startTime = currentTime;
      		}
    	}
  	}
    
	resetTime = micros() + pollingInterval;  
	return currentSpeed;
}
