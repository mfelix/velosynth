#include "Controller.h"

// gravity plug
#include <Ports.h>
#include <RF12.h> // needed to avoid a linker error :(
PortI2C myBus (2);
GravityPlug sensor (myBus);

// defines for jeenode pins
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

#define FREQ1 5
#define FREQ2 3
#define AMP 4

Controller controller(DATAIN, DATAOUT, SPICLOCK, SLAVESELECT, AMP, FREQ1);

void setup() {
  controller.initialize();
  controller.write_pot(AMP, OFF);
  controller.write_pot(FREQ1, OFF);
  controller.write_pot(FREQ2, OFF);
}

void loop() {
  const int* p = sensor.getAxes();
  int f1V = abs(p[0]); // x
  int aV = abs(p[1]); // y
  int f2V = abs(p[2]); // z
  
  int sensitivity = 250; // higher is less sensitive
  int freq1 = map(f1V, 0, sensitivity, 230, 30);
  int freq2 = map(f2V, 0, sensitivity, 30, 230);
  int amp   = map(aV, 0, sensitivity, ON, OFF);
  wiggleBuzz(freq1, freq2, amp);
}

void wiggleBuzz(int freq1, int freq2, int amp) {
  controller.write_pot(FREQ1, freq1);
  controller.write_pot(FREQ2, freq2);  
  controller.write_pot(AMP, amp);
}