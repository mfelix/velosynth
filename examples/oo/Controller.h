/*  Controller.h
	Velosynth/Arduino Controller wrapper
	for C++/Arduino
*/

#ifndef CONTROLLER_H
#define CONTROLLER_H

#include "WProgram.h"

class Controller {
public:
  Controller(byte dataIn, byte dataOut, byte spiClock, byte slaveSelect);
  void initialize();
  byte write_pot(int address, int value);  

private:
  char spi_transfer(volatile char data);

  
  byte dataIn;
  byte dataOut;
  byte spiClock;
  byte slaveSelect;
};


#endif
