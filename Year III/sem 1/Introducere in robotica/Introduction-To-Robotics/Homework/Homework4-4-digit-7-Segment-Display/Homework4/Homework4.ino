const byte latchPin = 11;  // STCP to 12 on Shift Register
const byte clockPin = 10;  // SHCP to 11 on Shift Register
const byte dataPin = 12;   // DS to 14 on Shift Register

// Pin assignments for controlling the common cathode pins of the 7-segment digits
const byte segD1 = 4;
const byte segD2 = 5;
const byte segD3 = 6;
const byte segD4 = 7;

// Size of the register in bits
const byte regSize = 8;

// Array to keep track of the digit control pins
byte displayDigits[] = {
  segD1, segD2, segD3, segD4
};

const byte displayCount = 4;  // Number of digits in the display
// Array representing the state of each bit in the shift register
byte registers[regSize];

const int encodingsNumber = 10;
byte encodingArray[encodingsNumber][regSize] = {
  // A B C D E F G DP
  { 1, 1, 1, 1, 1, 1, 0, 0 },  // 0
  { 0, 1, 1, 0, 0, 0, 0, 0 },  // 1
  { 1, 1, 0, 1, 1, 0, 1, 0 },  // 2
  { 1, 1, 1, 1, 0, 0, 1, 0 },  // 3
  { 0, 1, 1, 0, 0, 1, 1, 0 },  // 4
  { 1, 0, 1, 1, 0, 1, 1, 0 },  // 5
  { 1, 0, 1, 1, 1, 1, 1, 0 },  // 6
  { 1, 1, 1, 0, 0, 0, 0, 0 },  // 7
  { 1, 1, 1, 1, 1, 1, 1, 0 },  // 8
  { 1, 1, 1, 1, 0, 1, 1, 0 },  // 9
};

// Enumeration defining different states of the timer
enum {
  COUNTING,
  PAUSE,
  RESET,
  LAP_VIEWING
} timerMode;


// Buttons indices from array 
#define START_PAUSE_BUTTON 0
#define RESET_BUTTON 1
#define LAP_BUTTON 2

const int numberButtons = 3;
const int buttonsPins[] = { A3, A4, A5 };
byte buttonsStates[] = { LOW, LOW, LOW };
byte buttonsReadings[] = { HIGH, HIGH, HIGH };
byte buttonsLastReadings[] = { HIGH, HIGH, HIGH };
unsigned long buttonsLastDebounceTime[] = { 0, 0, 0 };
unsigned int debounceDelay = 50;

unsigned long currentTime = 0;
long lastIncrementTime = 0;
const int timeIncrementDelay = 100;
const int maxTimerValue = 1000000;

int lapIndex = 0;
const int numberLaps = 4;
unsigned long laps[numberLaps] = { 0, 0, 0, 0 };

// Array representing the 'off' state for the 7-segment display
byte zero[] = { 0, 0, 0, 0, 0, 0, 0, 0 };

const int digitWithDP = 2;

void setup() {
  // Initialize the digital pins connected to the shift register as outputs
  pinMode(latchPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, OUTPUT);
  // Initialize the digit control pins as outputs and turn them off
  for (byte i = 0; i < displayCount; i++) {
    pinMode(displayDigits[i], OUTPUT);
    digitalWrite(displayDigits[i], LOW);
  }

  for (byte btn = 0; btn < numberButtons; btn++) {
    pinMode(buttonsPins[btn], INPUT_PULLUP);
  }

  timerMode = PAUSE;
}

void loop() {
  // // Implement debounce on all buttons
  for (int button = 0; button < numberButtons; button++) {
    buttonsReadings[button] = digitalRead(buttonsPins[button]);

    if (buttonsReadings[button] != buttonsLastReadings[button]) {
      buttonsLastDebounceTime[button] = millis();
    }

    if (millis() - buttonsLastDebounceTime[button] > debounceDelay) {
      if (buttonsReadings[button] != buttonsStates[button]) {
        buttonsStates[button] = buttonsReadings[button];
        if (buttonsStates[button] == LOW) {
          handleButtonPress(button);
        }
      }
    }
    buttonsLastReadings[button] = buttonsReadings[button];
  }

  if (timerMode == COUNTING) {
    if (millis() - lastIncrementTime > timeIncrementDelay) {
      currentTime += timeIncrementDelay;
      lastIncrementTime = millis();
    }
    if (currentTime > maxTimerValue) {
      currentTime = 0;
    }
    displayTime(currentTime);
  } else if (timerMode == PAUSE || timerMode == RESET) {
    displayTime(currentTime);
  } else if (LAP_VIEWING) {
    displayTime(laps[lapIndex]);
  }
}
void handleButtonPress(int button) {
  if (button == START_PAUSE_BUTTON) {  // Start/pause button
    if (timerMode == COUNTING) {
      timerMode = PAUSE;
    } else {
      timerMode = COUNTING;
    }
  } else if (button == RESET_BUTTON) {  // Reset button
    if (timerMode == PAUSE) {
      currentTime = 0;
      timerMode = RESET;
    } else if (timerMode == LAP_VIEWING) {
      lapIndex = 0;
      for (int lap = 0; lap < numberLaps; lap++) {
        laps[lap] = 0;
      }
      timerMode = PAUSE;
    }
  } else if (button == LAP_BUTTON) {  // Save lap button
    if (timerMode == COUNTING) {
      lapIndex = (lapIndex + 1) % numberLaps;
      laps[lapIndex] = currentTime;
    } else if (timerMode == RESET) {
      timerMode = LAP_VIEWING;
    } else if (timerMode == LAP_VIEWING) {
      lapIndex = (lapIndex + 1) % numberLaps;
    }
  }
}

// Function to write the contents of the 'encoding' array to the shift register
void writeReg(byte encoding[]) {
  digitalWrite(latchPin, LOW);           // Begin sending data to the shift register
  for (int i = 0; i < regSize; i++) {    // Loop over each bit
    digitalWrite(clockPin, LOW);         // Prepare to send the bit
    digitalWrite(dataPin, encoding[i]);  // Send the bit
    digitalWrite(clockPin, HIGH);        // Clock in the bit
  }
  digitalWrite(latchPin, HIGH);  // Latch the data, updating the output of the shift register
}

void displayTime(unsigned long time) {
  // Calculate the time into seconds and tenths of a second
  unsigned int seconds = time / 1000;
  unsigned int tenths = (time / 100) % 10;

  byte digit = 0;

  // Display the hundreds place of seconds
  displayDigit(digit++, seconds / 100);
  writeReg(zero); // Turn off the segments for this digit

  // Display the tens place of seconds
  displayDigit(digit++, seconds / 10 % 10);
  writeReg(zero);

  // Display the ones place of seconds
  displayDigit(digit++, seconds % 10);
  writeReg(zero);

  // Display the tenths of a second
  displayDigit(digit, tenths);
  writeReg(zero);
}

void displayDigit(int digit, int value) {
  // Turn off all digits
  for (int i = 0; i < displayCount; i++) {
    digitalWrite(displayDigits[i], HIGH);
  }

  // Activate the specific digit
  digitalWrite(displayDigits[digit], LOW);

  if (digit == digitWithDP) {
    encodingArray[value][7] = 1;
  }
  writeReg(encodingArray[value]);
  if (digit == digitWithDP) {
    encodingArray[value][7] = 0;
  }
}