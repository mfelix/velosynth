/*  Speedometer.cpp
	Velosynth/Arduino Speedometer class
	for C++/Arduino
*/

#include "Speedometer.h"

Speedometer::Speedometer(int sensorPin, int wheelCircumference, unsigned int mean, unsigned int sensitivity, unsigned long pollingInterval) {
	this->sensorPin = sensorPin;
	this->wheelCircumference = wheelCircumference;
	this->mean = mean;
	this->sensitivity = sensitivity;
	this->pollingInterval = pollingInterval;

	startTime = micros(); // start time for wheel rotation in microseconds

	currentSpeed = 0; // This is a guess: assuming that 
	resetTime = 0; // Ensures that resetTime is properly initalized below
	wheelRotations = 0; // Accumulator, current unused but could be used for distance measurements 

	// The number '3600' is a conversion from mm/microsecond to km/hr
	// We need to cast 3600 as an unsigned long for the computation to be correct.
	speedCalcCoefficient = this->wheelCircumference * (unsigned long)3600;
}

unsigned long Speedometer::getSpeedKmph() {
	return measureSpeed();
}

float Speedometer::getSpeedMph() {
	// Float arithmetic is inefficient and should be avoided when necessary.
	float mph = measureSpeed() / 1.609344;	
	return mph;
}

// PRIVATE
//
// Speed is returned in km/hr
unsigned long Speedometer::measureSpeed() {
  	int sensorReading;
  	unsigned long currentTime;

	// Check to see if resetTime has been initialized OR if it is time to gather a new sensor reading
	if ((resetTime == 0) || (micros() > resetTime)) {
			sensorReading = analogRead(sensorPin);

			// Check to see if sensor data is within appropriate range; discard all data points that are not relevant
			if (sensorReading > (mean + sensitivity) || sensorReading < (mean - sensitivity)) {
				currentTime = micros();

			    // Debounce: ensure that invalid data are not taken into account
			    // This assumes that the bike is traveling less than ~756 km/hr
				if(currentTime < startTime + 10000) {
					startTime = currentTime;
				} else {
					wheelRotations++;
					currentSpeed = speedCalcCoefficient / (currentTime - startTime);
					startTime = currentTime;
      		}
    	}
		// resetTime is the earliest we will collect data to find a new speed.
		resetTime = micros() + pollingInterval;
  	}

	// Return calculated OR cached speed.
	return currentSpeed;
}
