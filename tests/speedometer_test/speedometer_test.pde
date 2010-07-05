// speedometer test
//
// adapted from: http://www.arduino.cc/playground/Main/ReadingRPM

volatile byte revs = 0;
unsigned int rpm = 0;
unsigned long timeold = 0;
int resolution = 2; // decrease for faster update
 
void setup() {
  Serial.begin(9600);
  attachInterrupt(1, sensorTripped, RISING);
}

void loop()
{

}

void sensorTripped() {
  Serial.print("+");
  revs++;
}

void checkRPM() {
  if (revs >= resolution) { 
    rpm = 30*1000/(millis() - timeold)*revs;
    timeold = millis();
    revs = 0;
    Serial.print(" ");
    Serial.println(rpm,DEC);
  }
}
