#include "Speedometer.h"
#include "Controller.h"

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

// bike wheel circumference in mm (2100 = almost exact for 700-23c wheels)
const unsigned int WHEEL_CIRCUM = 2100;

int rpm;
int blipIt = 0;

// make a speedometer object!
Speedometer speedometer(WHEEL_CIRCUM, 1);
Controller controller(DATAIN, DATAOUT, SPICLOCK, SLAVESELECT, AMP, FREQ);

void setup() {
  controller.initialize();
  // Serial.begin(9600);
  attachInterrupt(1, sensorTripped, RISING);
  controller.write_pot(AMP, OFF);
  controller.write_pot(FREQ, OFF);
}

void loop() {
  rpm = speedometer.checkRPM();
  int freq = map(rpm, 0, 100, 255, 0);
  if(blipIt){
    blip(freq);
    blipIt = 0;
  }
}

void sensorTripped() {
  speedometer.sensorTripped();
  blipIt = 1;
}

void blip(int frequency) {
  controller.write_pot(FREQ, frequency);
  controller.write_pot(AMP, ON);
  for (int amp = 0; amp < 255; amp++) {
    delayMicroseconds(666);
    controller.write_pot(AMP, amp);
  }
}