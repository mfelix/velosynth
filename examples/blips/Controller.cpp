/*  Controller.cpp
	Velosynth/Arduino controller class
	for C++/Arduino
*/

#include "Controller.h"

Controller::Controller(byte dataIn, byte dataOut, byte spiClock, byte slaveSelect, int amp, int freq) {
  this->dataIn = dataIn;
  this->dataOut = dataOut;
  this->spiClock = spiClock;
  this->slaveSelect = slaveSelect;
  ampAddress = amp;
  freqAddress = freq;
}

void Controller::initialize() {
  byte i;
  byte clr;
  pinMode(dataOut, OUTPUT);
  pinMode(dataIn, INPUT);
  pinMode(spiClock,OUTPUT);
  pinMode(slaveSelect,OUTPUT);
  pinMode(10, OUTPUT); // pin 10 must have its pullup resistor enabled for SPI to work
  digitalWrite(slaveSelect,HIGH); //disable device
  // SPCR = 01010000 
  //interrupt disabled,spi enabled,msb 1st,master,clk low when idle,
  //sample on leading edge of clk,system clock/4 (fastest)
  SPCR = (1<<SPE)|(1<<MSTR);
  clr=SPSR;
  clr=SPDR;
  delay(10);
  // set all pots to 255 (off)
  for (i=0;i<6;i++)
  {
    write_pot(i,255);
  }
  
}

char Controller::spi_transfer(volatile char data) {
  SPDR = data;                    // Start the transmission
  while (!(SPSR & (1<<SPIF)))     // Wait the end of the transmission
  {
  };
  return SPDR;                    // return the received byte
}

byte Controller::write_pot(int address, int value)
{
  digitalWrite(slaveSelect,LOW);
  //2 byte opcode
  spi_transfer(address);
  spi_transfer(value);
  digitalWrite(slaveSelect,HIGH); //release chip, signal end transfer
}

void Controller::writeAmplitude(int value) {
  write_pot(ampAddress, value);
}

void Controller::writeFrequency(int value) {
  write_pot(freqAddress, value);
}