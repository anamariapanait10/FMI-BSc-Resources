/*
This Arduino program reads values from three potentiometers, each controlling a
color channel (Red, Green, Blue) of an RGB LED. It then maps these values to the
corresponding LED pins to control color intensity.
*/
const int redLedPin = 11;
const int greenLedPin = 10;
const int blueLedPin = 9;

const int redLedPotentiometerPin = A0;
const int greenLedPotentiometerPin = A1;
const int blueLedPotentiometerPin = A2;

const int minAnalogReadValue = 0;
const int maxAnalogReadValue = 1023;
const int minLedValue = 0;
const int maxLedValue = 255;

int redPotentiometerValue = 0;
int greenPotentiometerValue = 0;
int bluePotentiometerValue = 0;

int redLedBrightness = 0;
int greenLedBrightness = 0;
int blueLedBrightness = 0;

void setup() {
  pinMode(redLedPotentiometerPin, INPUT);
  pinMode(greenLedPotentiometerPin, INPUT);
  pinMode(blueLedPotentiometerPin, INPUT);

  pinMode(redLedPin, OUTPUT);
  pinMode(greenLedPin, OUTPUT);
  pinMode(blueLedPin, OUTPUT);
}

void loop() {
  readPotentiometersValues();
  mapPotentiometerValuesToLedValues();
  setLedColor();
  delay(1);
}

void readPotentiometersValues(){
  redPotentiometerValue = analogRead(redLedPotentiometerPin);
  greenPotentiometerValue = analogRead(greenLedPotentiometerPin);
  bluePotentiometerValue = analogRead(blueLedPotentiometerPin);
}

void mapPotentiometerValuesToLedValues(){
  redLedBrightness = map(redPotentiometerValue, minAnalogReadValue, maxAnalogReadValue, minLedValue, maxLedValue);
  greenLedBrightness = map(greenPotentiometerValue, minAnalogReadValue, maxAnalogReadValue, minLedValue, maxLedValue);
  blueLedBrightness = map(bluePotentiometerValue, minAnalogReadValue, maxAnalogReadValue, minLedValue, maxLedValue);
}

void setLedColor(){
  analogWrite(redLedPin, redLedBrightness);
  analogWrite(greenLedPin, greenLedBrightness);
  analogWrite(blueLedPin, blueLedBrightness);
}
