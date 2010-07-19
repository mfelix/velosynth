#include "Instrument.h"

Instrument::Instrument() {
  
}

void Instrument::generateNote(unsigned int frequency, int note []) {
  //note = {180, 170, 160, 190, 200, 220, 230, 235 };
  for(int i = 0; i < 8; i++) {
    if (i < 4) {
      note[i] = frequency + (i * 10);
    } else {
      note[i] = frequency + 40 - ((i - 4) * 10);
    }
  }
}
