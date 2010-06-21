/*  Envelope.h
	Velosynth/Arduino Envelope generator
	for C++/Arduino
*/

#ifndef ENVELOPE_H
#define ENVELOPE_H

#include "WProgram.h"

class Envelope {
public:
  Envelope(unsigned int length, int sampleMin, int sampleMax);
	
  void generateNote(unsigned char note[]);
private:
  unsigned int length;
  int sampleMin;
  int sampleMax;
  
  short int note[100];
};


#endif
