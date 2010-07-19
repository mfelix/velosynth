#ifndef SYNTHESIZER_H
#define SYNTHESIZER_H

#include "WProgram.h"
#include "Controller.h"

class Synthesizer {
public:
  Synthesizer(Controller &controller);
  
  void playNote(int note []);
  
private:
  Controller *controller;

};


#endif
