#include "pitches.h"

const int floorButtonsPins[] = {2, 7, 10};
byte buttonsStates[] = {HIGH, HIGH, HIGH};

const int floorLedsPins[] = {3, 8, 11};
byte floorLedsStates[] = {LOW, LOW, LOW};

const int elevatorLedStatePin = 13;
byte stateOfElevatorLedState = LOW;
const int stateLedBlinkInterval = 500;
long stateLedLastBlink = 0;

const int buzzerPin = 12;

unsigned int debounceDelay = 50;
unsigned int lastDebounceTime[] = {0, 0, 0};
byte buttonsReadings[] = {HIGH, HIGH, HIGH};
byte buttonsLastReadings[] = {HIGH, HIGH, HIGH};
long lastElevatorFloorDeparture = 0;
long lastElevatorFloorArrival = 0;

const int elevatorFloorChangeTime = 1000;
const int elevatorFloorWaitTime = 2000;
const int elevatorDoorOpenOrCloseTime = 2000;
int currentElevatorFloor = 0;
int targetElevatorFloor;
enum {
  STATIONARY, DOOR_CLOSING, DEPARTING, MOVING, ARRIVING, DOOR_OPENING
} elevatorState;
long lastElevatorStateChange = 0;

int elevatorOpeningDoorsSound = NOTE_C3;
int elevatorClosingDoorsSound = NOTE_G3;
int elevatorMovementSound = NOTE_E2;

int floorsQueue[100];
int queueStart = 0, queueEnd = -1;

void setup() {
  Serial.begin(9600);
  for (int floor = 0; floor < 3; floor++) {
    pinMode(floorButtonsPins[floor], INPUT_PULLUP);
    pinMode(floorLedsPins[floor], OUTPUT);
  }
  pinMode(buzzerPin, OUTPUT);
  pinMode(elevatorLedStatePin, OUTPUT);
}

void loop() {
  for(int floor = 0; floor < 3; floor++){
    buttonsReadings[floor] = digitalRead(floorButtonsPins[floor]);
    if (checkButtonPressed(floor)){
      addFloorToQueue(floor);
    }
  }

  if(elevatorState == STATIONARY) {
    int nextTarget = removeFloorFromQueue();
    if(nextTarget != -1) {
      targetElevatorFloor = nextTarget;
      elevatorState = DOOR_CLOSING;
      Serial.println("Change state to DOOR_CLOSING");
      lastElevatorStateChange = millis();
    } else {
      floorLedsStates[currentElevatorFloor] = HIGH;
      stateOfElevatorLedState = HIGH;
    }
  } else if(elevatorState == DOOR_CLOSING){
    tone(buzzerPin, elevatorClosingDoorsSound, elevatorDoorOpenOrCloseTime);
    if(millis() - lastElevatorStateChange > elevatorDoorOpenOrCloseTime) {
      elevatorState = DEPARTING;
      Serial.println("Change state to DEPARTING");
      lastElevatorStateChange = millis();
      lastElevatorFloorDeparture = millis();
      noTone(buzzerPin);
    }
  } else if(elevatorState == DEPARTING) {
    tone(buzzerPin, elevatorMovementSound, elevatorFloorChangeTime);
    if(millis() - stateLedLastBlink > stateLedBlinkInterval) {
      stateOfElevatorLedState = !stateOfElevatorLedState;
      stateLedLastBlink = millis();
    }
    floorLedsStates[currentElevatorFloor] = HIGH;
    if(millis() - lastElevatorFloorDeparture > elevatorFloorChangeTime) {
      lastElevatorFloorDeparture = millis();
      elevatorState = MOVING;
      Serial.println("Change state to MOVING");
      lastElevatorStateChange = millis();
    }
  } else if(elevatorState == MOVING) {
    tone(buzzerPin, elevatorMovementSound, elevatorFloorChangeTime);
    if(millis() - stateLedLastBlink > stateLedBlinkInterval) {
      stateOfElevatorLedState = !stateOfElevatorLedState;
      stateLedLastBlink = millis();
    }
    floorLedsStates[currentElevatorFloor] = LOW;
    if(currentElevatorFloor == targetElevatorFloor) {
      elevatorState = ARRIVING;
      lastElevatorFloorArrival = millis();
      lastElevatorStateChange = millis();
      noTone(buzzerPin);
      Serial.println("Change state to ARRIVING");
    } else {
      if(millis() - lastElevatorFloorDeparture > elevatorFloorChangeTime) {
        lastElevatorFloorArrival = millis();
        if(currentElevatorFloor > targetElevatorFloor) {
          currentElevatorFloor--;
          Serial.print("current floor-- ");
          Serial.println(currentElevatorFloor);
        } else {
          currentElevatorFloor++;
          Serial.print("current floor++ ");
          Serial.println(currentElevatorFloor);
        }
        elevatorState = ARRIVING;
        Serial.println("Change state to ARRIVING");
        lastElevatorFloorArrival = millis();
        lastElevatorStateChange = millis();  
      }
    }
  } else if(elevatorState == ARRIVING) {
    
    if(millis() - stateLedLastBlink > stateLedBlinkInterval) {
      stateOfElevatorLedState = !stateOfElevatorLedState;
      stateLedLastBlink = millis();
    }
    if(currentElevatorFloor == targetElevatorFloor) {
      tone(buzzerPin, elevatorMovementSound, elevatorFloorWaitTime);
      if(millis() - lastElevatorFloorArrival > elevatorFloorChangeTime) {
        lastElevatorFloorDeparture = millis();
        elevatorState = DOOR_OPENING;
        lastElevatorStateChange = millis();
        Serial.println("Change state to DOOR_OPENING");
      }
    } else {
      tone(buzzerPin, elevatorMovementSound, elevatorFloorChangeTime);
      if(millis() - lastElevatorFloorArrival > elevatorFloorChangeTime) {
        lastElevatorFloorArrival = millis();
        elevatorState = DEPARTING;
        lastElevatorStateChange = millis();
        Serial.println("Change state to DEPARTING");
      }
    }
    floorLedsStates[currentElevatorFloor] = HIGH;
    
  } else if(elevatorState == DOOR_OPENING){
    tone(buzzerPin, elevatorOpeningDoorsSound, elevatorDoorOpenOrCloseTime);
    if(millis() - lastElevatorStateChange > elevatorDoorOpenOrCloseTime) {
      elevatorState = STATIONARY;
      lastElevatorStateChange = millis();
      Serial.println("Change state to STATIONARY");
    }
  }

  digitalWrite(elevatorLedStatePin, stateOfElevatorLedState);
  for(int floor = 0; floor < 3; floor++){
    digitalWrite(floorLedsPins[floor], floorLedsStates[floor]);
  }
}

bool checkButtonPressed(int floor) {
  if (buttonsReadings[floor] != buttonsLastReadings[floor]) {
    lastDebounceTime[floor] = millis();
  }

  if (millis() - lastDebounceTime[floor] > debounceDelay) {
    if (buttonsReadings[floor] != buttonsStates[floor]) {
      buttonsStates[floor] = buttonsReadings[floor];
      if (buttonsStates[floor] == HIGH) {
        return true;
      }
    }
  }
  buttonsLastReadings[floor] = buttonsReadings[floor];
  return false;
}

void addFloorToQueue(int floor) {
  floorsQueue[++queueEnd] = floor;
}

int removeFloorFromQueue() {
  if(queueStart <= queueEnd) {
    return floorsQueue[queueStart++];
  }
  return -1;
}