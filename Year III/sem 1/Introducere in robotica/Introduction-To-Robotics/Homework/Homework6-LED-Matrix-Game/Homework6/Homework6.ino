#include "pitches.h"
#include <LedControl.h>
#include <EEPROM.h>

const int joyXPin = A1;
const int joyYPin = A0;
const int photoresistorPin = A2;
const int buttonPin = 2;  // Button for bomb placement
const int buzzerPin = 13;

// Constants for LED matrix
const int dataInPin = 12;
const int clockPin = 11;
const int loadPin = 10;
const int driverNumInUse = 1;  // Only using one MAX7219
const int matrixSize = 8;
byte matrixBrightness = 2;
const int minBrightness = 0;
const int maxBrightness = 15;
LedControl lc = LedControl(dataInPin, clockPin, loadPin, driverNumInUse);

// Game constants and variables
const int mapWidth = 8;
const int mapHeight = 8;
int gameMap[mapWidth][mapHeight] = {};

byte playerLEDState = HIGH;
unsigned long lastPlayerBlink = 0;
const int playerBlinkInterval = 500;
byte bombState = LOW;
unsigned long lastBombBlink = 0;
const int bombBlinkInterval = 250;

const int playerStartX = 4;
const int playerStartY = 4;
int playerX = playerStartX;  // Player's current X position
int playerY = playerStartY;  // Player's current Y position
int lastPlayerXPos;
int lastPlayerYPos;

bool matrixChanged = false;
int numOfWalls;
int lastNumOfWalls;
const int gameMapWallRatio = 50;
const int gameMapTotalRatio = 100;

unsigned int debounceDelay = 60;
unsigned int lastDebounceTime = 0;
byte buttonReading = HIGH;
byte buttonLastReading = HIGH;
byte buttonState = HIGH;

bool joyMovedX = false;
bool joyMovedY = false;
const int minThreshold = 300;
const int maxThreshold = 700;
const int joyMinValue = 80;
const int joyMaxValue = 900;

long bombPlacementTime = 0;
long bombTimeUntilExplosion = 1000;
long bombExplosionTime = 200;
int bombX = -1;
int bombY = -1;

const int animationDelayBetweenSteps = 100;
const int animationDelayUntilGameStart = 500;
const int animationFlowerSize = 3;

void setup() {
  Serial.begin(9600);

  pinMode(joyXPin, INPUT);
  pinMode(joyYPin, INPUT);
  pinMode(buttonPin, INPUT_PULLUP);
  pinMode(buzzerPin, OUTPUT);
  pinMode(photoresistorPin, INPUT);

  // Initialize the LED matrix
  lc.shutdown(0, false);                 // Wake up displays
  lc.setIntensity(0, matrixBrightness);  // Set brightness level (0 is min, 15 is max)
  lc.clearDisplay(0);                    // Clear display register

  // Start game with startup animation
  restartGame();
}

void loop() {
  checkButtonPressed();

  updateGameState();

  blinkPlayerLED();

  blinkBombLED();

  checkBombExplodes();

  updateDisplay();

  if (gameEnded()) {
    restartGame();
  }

  adjustMatrixBrightness();
  updateScore();
}

bool checkButtonPressed() {
  buttonReading = digitalRead(buttonPin);
  if (buttonReading != buttonLastReading) {
    lastDebounceTime = millis();
  }
  if ((millis() - lastDebounceTime) > debounceDelay) {
    if (buttonReading != buttonState) {
      buttonState = buttonReading;
      if (buttonState == LOW) {
        placeBomb();
      }
    }
  }
  buttonLastReading = buttonReading;
}

void updateGameState() {
  // Read the joystick values
  int joyXVal = analogRead(joyXPin);
  int joyYVal = analogRead(joyYPin);

  lastPlayerXPos = playerX;
  lastPlayerYPos = playerY;

  if (joyXVal < minThreshold && joyMovedX == false) {
    joyMovedX = true;
    if (playerY > 0 && gameMap[playerX][playerY - 1] == 0) {
      playerY = playerY - 1;
    }
  }
  if (joyXVal > maxThreshold && joyMovedX == false) {
    joyMovedX = true;
    if (playerY < matrixSize - 1 && gameMap[playerX][playerY + 1] == 0) {
      playerY = playerY + 1;
    }
  }
  if (joyXVal >= minThreshold && joyXVal <= maxThreshold) {
    joyMovedX = false;
  }
  if (joyYVal < minThreshold && joyMovedY == false) {
    joyMovedY = true;
    if (playerX > 0 && gameMap[playerX - 1][playerY] == 0) {
      playerX = playerX - 1;
    }
  }
  if (joyYVal > maxThreshold && joyMovedY == false) {
    joyMovedY = true;
    if (playerX < matrixSize - 1 && gameMap[playerX + 1][playerY] == 0) {
      playerX = playerX + 1;
    }
  }
  if (joyYVal >= minThreshold && joyYVal <= maxThreshold) {
    joyMovedY = false;
  }

  if (playerX != lastPlayerXPos || playerY != lastPlayerYPos) {
    gameMap[lastPlayerXPos][lastPlayerYPos] = 0;
    gameMap[playerX][playerY] = 1;
    matrixChanged = true;
  }
}

void updateDisplay() {
  if (matrixChanged) {
    updateMatrix();
    matrixChanged = false;
  }
}

void placeBomb() {
  tone(buzzerPin, NOTE_A6, bombTimeUntilExplosion);
  // Turn on the bomb LED and set a timer for the explosion
  bombX = playerX;
  bombY = playerY;
  bombState = HIGH;
  gameMap[bombX][bombY] = bombState;
  matrixChanged = true;
  bombPlacementTime = millis();
}

void explodeBomb() {
  tone(buzzerPin, NOTE_C7, bombExplosionTime);
  for (int y = bombY - 2; y <= bombY + 2; y++) {
    if (y >= 0 && y < mapHeight && (bombX != playerX || y != playerY)) {
      if (gameMap[bombX][y] == 1) {
        gameMap[bombX][y] = 0;  // Remove the wall
        numOfWalls--;
        matrixChanged = true;
      }
    }
  }
  for (int x = bombX - 2; x <= bombX + 2; x++) {
    if (x >= 0 && x < mapWidth && (x != playerX || bombY != playerY)) {
      if (gameMap[x][bombY] == 1) {
        gameMap[x][bombY] = 0;  // Remove the wall
        matrixChanged = true;
        numOfWalls--;
      }
    }
  }
  bombX = -1;
  bombY = -1;
}

void checkBombExplodes() {
  if (bombX != -1 && bombY != -1 && millis() - bombPlacementTime >= bombTimeUntilExplosion) {
    explodeBomb();
  }
}

void blinkPlayerLED() {
  if (millis() - lastPlayerBlink >= playerBlinkInterval) {
    lastPlayerBlink = millis();
    playerLEDState = !playerLEDState;
    gameMap[playerX][playerY] = playerLEDState;
    matrixChanged = true;
  }
}

void blinkBombLED() {
  if (bombX != -1 && bombY != -1 && (bombX != playerX || bombY != playerY) && millis() - lastBombBlink >= bombBlinkInterval) {
    lastBombBlink = millis();
    bombState = !bombState;
    gameMap[bombX][bombY] = bombState;
    matrixChanged = true;
  }
}

bool gameEnded() {
  // Check for game end condition
  return numOfWalls == 0;
}

void adjustMatrixBrightness() {
  // Adjust the brightness based on the photoresistor
  int sensorValue = analogRead(photoresistorPin);
  int brightness = map(sensorValue, joyMinValue, joyMaxValue, minBrightness, maxBrightness);
  lc.setIntensity(0, brightness);
}

void updateScore() {
  static int score = 0;
  if (numOfWalls != lastNumOfWalls) {
    score++;
    Serial.println("-------- Score -------");
    Serial.println(score);
    lastNumOfWalls = numOfWalls;
  }
}

void updateMatrix() {
  for (int row = 0; row < matrixSize; row++) {
    for (int col = 0; col < matrixSize; col++) {
      lc.setLed(0, row, col, gameMap[row][col]);  // Update each LED state
    }
  }
}

void generateGameMap() {
  for (int x = 0; x < mapHeight; x++) {
    for (int y = 0; y < mapWidth; y++) {
      // Ensure the player's starting position is not a wall
      if (x == playerStartX && y == playerStartY) {
        gameMap[x][y] = 0;
      } else {
        // Randomly place walls; ratio can be adjusted as needed
        if (random(gameMapTotalRatio) < gameMapWallRatio) {
          gameMap[x][y] = 1;
          numOfWalls++;
        } else {
          gameMap[x][y] = 0;
        }
      }
    }
  }
  for (int i = playerX - 3; i < playerX; i++) {
    numOfWalls -= gameMap[i][playerY];
    gameMap[i][playerY] = 0;
  }

  matrixChanged = true;
}

void restartGame() {
  randomSeed(analogRead(A3));
  playerX = playerStartX;
  playerY = playerStartY;
  generateGameMap();
  animation();
}

void animation() {
  lc.clearDisplay(0);
  for (int row = animationFlowerSize; row >= 1; row--) {
    for (int col = animationFlowerSize; col >= 1; col--) {
      if ((row + col) != animationFlowerSize + 1) {
        lc.setLed(0, row, col, true);
        delay(animationDelayBetweenSteps);
        lc.setLed(0, matrixSize - row - 1, matrixSize - col - 1, true);
        delay(animationDelayBetweenSteps);
        lc.setLed(0, matrixSize - row - 1, col, true);
        delay(animationDelayBetweenSteps);
        lc.setLed(0, row, matrixSize - col - 1, true);
        delay(animationDelayBetweenSteps);
      }
    }
  }
  delay(animationDelayUntilGameStart);
}