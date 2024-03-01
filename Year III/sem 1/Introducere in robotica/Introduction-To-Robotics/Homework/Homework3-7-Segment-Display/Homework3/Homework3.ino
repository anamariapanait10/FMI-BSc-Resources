const int pinA = 6;
const int pinB = 4;
const int pinC = 12;
const int pinD = 11;
const int pinE = 10;
const int pinF = 5;
const int pinG = 7;
const int pinDP = 13;
const int pinX = A0;
const int pinY = A1;
const int pinButton = 2;
const int segSize = 8;

const int noAction = -1;
const int numberOfDirections = 4;
const int upDirection = 0;
const int downDirection = 1;
const int leftDirection = 2;
const int rightDirection = 3;
const int segmentsNextStatePins[segSize][numberOfDirections] = {
  { noAction, pinG, pinF, pinB },
  { pinA, pinG, pinF, noAction },
  { pinG, pinD, pinE, pinDP },
  { pinG, noAction, pinE, pinC },
  { pinG, pinD, noAction, pinC },
  { pinA, pinG, noAction, pinB },
  { pinA, pinD, noAction, noAction },
  { noAction, noAction, pinC, noAction }
};

const unsigned long buttonDebounceDelay = 100;
const unsigned long buttonLongPressDuration = 2000;
const int segmentBlinkTime = 300;

int segmentsPins[segSize] = { pinA, pinB, pinC, pinD, pinE, pinF, pinG, pinDP };
byte segmentsStates[segSize];

// The biggest Arduino pin to use it for the mapping below.
const int maxArduinoPin = 13; 
// This mapping corelates the digital pins from the Arduino board (the index of the vector represents the pin number) 
// to the index from the segmentsPins vector that corresponds to the segment from the 7-segment display that is
// controlled by that Arduino pin. The -1 value means that the pin is not used.
const int arduinoPinTo7SegmentDisplayPinMapping[maxArduinoPin + 1] = {-1, -1, -1, -1, 1, 5, 0, 6, -1, -1, 4, 3, 2, 7};

int currentSegmentIndex = 7;

byte buttonState = HIGH;
unsigned long buttonPressStartTime = 0;
byte buttonReading = HIGH;


int xValue = 0;
int yValue = 0;

bool joyMovedX = false;
bool joyMovedY = false;
int minThreshold = 400;
int maxThreshold = 600;

long lastSegmentBlink = 0;

byte blinkState = LOW;

void setup() {
  Serial.begin(9600);
  pinMode(pinButton, INPUT_PULLUP);
  pinMode(pinX, INPUT);
  pinMode(pinY, INPUT);
  for (int i = 0; i < segSize; i++) {
    pinMode(segmentsPins[i], OUTPUT);
  }
}

void loop() {
  xValue = analogRead(pinX);
  yValue = analogRead(pinY);
 
  if(millis() - lastSegmentBlink > segmentBlinkTime){
    blinkState = !blinkState;
    lastSegmentBlink = millis();
  }

  buttonReading = digitalRead(pinButton);
  if (buttonReading == LOW && buttonState == HIGH) {
    buttonPressStartTime = millis();
    buttonState = LOW;
  }

  if (buttonReading == HIGH && buttonState == LOW) {
    if (millis() - buttonPressStartTime > buttonDebounceDelay && millis() - buttonPressStartTime < buttonLongPressDuration) {
      segmentsStates[currentSegmentIndex] = !segmentsStates[currentSegmentIndex];
    } else {
      resetDisplaySegments();
    }
    buttonState = HIGH;
  }

  if (xValue < minThreshold && joyMovedX == false) {
    int nextSegmentPin = segmentsNextStatePins[currentSegmentIndex][leftDirection];
    if(nextSegmentPin != -1){
      currentSegmentIndex = arduinoPinTo7SegmentDisplayPinMapping[nextSegmentPin];
    }
    joyMovedX = true;
  }
  if (xValue > maxThreshold && joyMovedX == false) {
    int nextSegmentPin = segmentsNextStatePins[currentSegmentIndex][rightDirection];
    if(nextSegmentPin != -1){
      currentSegmentIndex = arduinoPinTo7SegmentDisplayPinMapping[nextSegmentPin];
    }
    joyMovedX = true;
  }
  if (xValue >= minThreshold && xValue <= maxThreshold) {
    joyMovedX = false;
  }

  if (yValue < minThreshold && joyMovedY == false) {
    int nextSegmentPin = segmentsNextStatePins[currentSegmentIndex][downDirection];
    if(nextSegmentPin != -1){
      currentSegmentIndex = arduinoPinTo7SegmentDisplayPinMapping[nextSegmentPin];
    }
    joyMovedY = true;
  }
  if (yValue > maxThreshold && joyMovedY == false) {
    int nextSegmentPin = segmentsNextStatePins[currentSegmentIndex][upDirection];
    if(nextSegmentPin != -1){
      currentSegmentIndex = arduinoPinTo7SegmentDisplayPinMapping[nextSegmentPin];
    }
    joyMovedY = true;
  }
  if (yValue >= minThreshold && yValue <= maxThreshold) {
    joyMovedY = false;
  }

  for(int segment = 0; segment < segSize; segment++){
    if(segment != currentSegmentIndex){
      digitalWrite(segmentsPins[segment], segmentsStates[segment]);
    } else {
      digitalWrite(segmentsPins[segment], blinkState);
    }
  }
}

void resetDisplaySegments() {
  for(int segment = 0; segment < segSize; segment++) {
    segmentsStates[segment] = LOW;
  }
  // Change current segment to be DP
  currentSegmentIndex = 7;
}
