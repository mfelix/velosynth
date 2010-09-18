#include "Controller.h"

#include <Wire.h>
#include "LibCompass.h"

LibCompass compass = LibCompass(0);
// degrees difference in orientation of the velosynth and bike
// from the actual direction the compass is facing inside the velosynth
#define NORTH_OFFSET 270

#define DATAOUT 11
#define DATAIN 12
#define SPICLOCK  13
#define SLAVESELECT 8

#define OFF 255
#define ON 0

#define CHANNEL_A 5
#define CHANNEL_B 4
#define CHANNEL_C 3
#define CHANNEL_D 1
#define CHANNEL_E 0
#define CHANNEL_F 2

#define FREQ 5
#define AMP 4

int blipIt = 0;

Controller controller(DATAIN, DATAOUT, SPICLOCK, SLAVESELECT, AMP, FREQ);

void setup() {
  controller.initialize();
  Serial.begin(9600);
  controller.write_pot(AMP, OFF);
  controller.write_pot(FREQ, OFF);
}

void loop() {
  int freq = map(125, 0, 100, 255, 0);
  checkNorth();
  if(blipIt){
    printHeading();
    blip(freq);
    blipIt = 0;
    delay(1000);
  }
}

void blip(int frequency) {
  controller.write_pot(FREQ, frequency);
  controller.write_pot(AMP, ON);
  for (int amp = 0; amp < 255; amp++) {
    delayMicroseconds(666);
    controller.write_pot(AMP, amp);
  }
}

void checkNorth() {
  float heading = getHeading();
  int high = 330;
  int low = 30;
  if (heading > high || heading < low) {
    blipIt = 1;
  }
}

float getHeading() {
  float heading = compass.GetHeading();
  heading = (heading + NORTH_OFFSET) % 360;
  return heading;
}

void printHeading() {
  /* Print the heading to the PC */
  Serial.print("Heading: ");

  Serial.print(getHeading());  //print the compass heading

  Serial.println(" degrees");
}
