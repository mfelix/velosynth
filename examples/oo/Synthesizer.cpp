#include "Synthesizer.h"

Synthesizer::Synthesizer(Controller& controller) {
  this->controller = &controller;
}

void Synthesizer::playNote(int note []) {
  //sequencer_step();
  long last, now;
  int waitForIt = 300;
  for(int i = 0; i < 8; i++) {
    now = micros();
    if (now - last < waitForIt) {
      i--;
    } else {
      controller->writeAmplitude(( now / 1500 ) % 255); // amplitude?
      controller->writeFrequency(note[i]);         // frequency
      last = now;
    }
  }
}
