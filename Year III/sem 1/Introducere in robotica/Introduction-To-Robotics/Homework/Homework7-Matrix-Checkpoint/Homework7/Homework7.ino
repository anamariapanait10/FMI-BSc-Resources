#include "pitches.h"
#include <LedControl.h>
#include <LiquidCrystal.h>
#include <EEPROM.h>

// Pin definitions
const int joyXPin = A1;
const int joyYPin = A0;
const int buttonPin = 2;
const int buzzerPin = 13;
const int potentiometerPin = A3;
int potentiometerValue = 0;

// LCD variables
const byte rs = 9;
const byte en = 8;
const byte d4 = 7;
const byte d5 = 6;
const byte d6 = 5;
const byte d7 = 4;
const int LCDLedPin = 3;
int LCDBrightness = 5;
int LCDprogressBar = 0;
const int LCDNumOfColumns = 16;
const int LCDNumOfRows = 2;
bool increaseLCDBrightness = false;
bool decreaseLCDBrightness = false;
const int oneLCDColumn = 1;
const int twoLCDColumns = 2;
const int analogWriteMinValue = 0;
const int analogWriteMaxValue = 255;
const int LCDFirstRow = 0;
const int LCDSecondRow = 1;
const int LCD0Col = 0;
const int LCDS1stCol = 1;
const int LCD2ndCol = 2;
const int LCD3rdCol = 3;
const int LCD4thCol = 4;
const int LCD5thCol = 5;
const int LCD6thCol = 6;
const int LCD12thCol = 12;
const int LCD13thCol = 13;
const int LCD14thCol = 14;
const int LCDLastCol = 15;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);

// Constants for LED matrix
const int dataInPin = 12;
const int clockPin = 11;
const int loadPin = 10;
const int driverNumInUse = 1;  // Only using one MAX7219
const int matrixSize = 8;
byte matrixBrightness = 5;
const int minBrightness = 0;
const int maxBrightness = 15;
bool matrixChanged = false;
bool decreaseMatrixBrightness;
bool increaseMatrixBrightness;
int matrixDisplayOffsetX = 0;
int matrixDisplayOffsetY = 0;
const int initialOffset = 0;
const int matrixIntensityMinValue = 0;
const int matrixIntensityMaxValue = 15;
LedControl lc = LedControl(dataInPin, clockPin, loadPin, driverNumInUse);

// EEPROM addresses
int matrixBrightnessEepromAddress = 0;
int LCDBrightnessEepromAddress = 1;
int gameDifficultyEepromAddress = 2;
int soundsEnabledEepromAddress = 3;
int firstPlaceTimeBeginAddress = 4;
int firstPlaceUsernameBeginAddress = 8;
int secondPlaceTimeBeginAddress = 23;
int secondPlaceUsernameBeginAddress = 27;
int thirdPlaceTimeBeginAddress = 40;
int thirdPlaceUsernameBeginAddress = 44;
int gameSoundsEepromAddress = 45;

// Highscore variables
byte firstPlaceTime = 0;
byte secondPlaceTime = 0;
byte thirdPlaceTime = 0;
const int maxTime = 255;
char firstPlaceUsername[11];
char secondPlaceUsername[11];
char thirdPlaceUsername[11];
const int firstPlace = 1;
const int secondPlace = 2;
const int thirdPlace = 3;
const int noUserLength = 8;

// Game constants and variables
long gameStartTime = 0;
const int mapWidth = 16;
const int mapHeight = 16;
const int halfMatrixSize = matrixSize / 2;
const int quaterMatrixSize = matrixSize / 4;
const int yMatrixOffset = 5;
int gameMap[mapWidth][mapHeight] = {};

byte playerLEDState = HIGH;
unsigned long lastPlayerBlink = 0;
const int playerBlinkInterval = 500;
unsigned long lastFoodBlink = 0;
const int foodBlinkInterval = 1000;

long lastBulletMovement = 0;
int bulletMovementDelay = 700;
int enemyShootingInterval = 2000;
long lastBulletSpawn = 0;
long lastEnemyBlink = 0;
long enemyBlinkDelay = 80;
byte enemyState = LOW;

const int shortToneDuration = 50;
const int longToneDuration = 100;
const int gameOverToneDuration = 400;

int userTime = 0;  // the time taken for the user to finish the level
const int millisToSecond = 1000;

const int playerStartX = 4;
const int playerStartY = 4;
int playerX = playerStartX;  // player's current X position
int playerY = playerStartY;  // player's current Y position

int numOfWalls;
int lastNumOfWalls;

const int initialNumberOfLives = 3;
int numberOfLives = initialNumberOfLives;
const int numberOfFoodToWin = 15;
const int mediumMaxFood = numberOfFoodToWin + 5;
const int numberOfLevels = 3;
const int initalNumberOfFoodEaten = 0;
int numberOfFoodEaten = initalNumberOfFoodEaten;
bool gameVariablesChanged = false;
const int noLeaderBoardPosition = -1;
int leaderBoardPosition = noLeaderBoardPosition;

enum {
  EASY,
  MEDIUM,
  HARD
} gameDifficulty,
  settingsGameDifficulty;

// Variables for generating the map
int gameMapFoodRatio = 20;
const int easyFoodRatio = 50;
int gameMapEnemyRatio = 5;
const int easyEnemyRatio = 3;
const int hardEnemyRatio = 5;
const int gameMapWallRatio = 5;
const int gameMapTotalRatio = 100;
const int noMaxFoodLimit = -1;
int spawnDistance = 2;
const int easySpawnDistance = 2;
const int hardSpawnDistance = 3;

// Varibles for the button
unsigned int debounceDelay = 60;
unsigned int lastDebounceTime = 0;
byte buttonReading = HIGH;
byte buttonLastReading = HIGH;
byte buttonState = HIGH;

// Variables for the joystick
bool joyMovedX = false;
bool joyMovedY = false;
const int minThreshold = 300;
const int maxThreshold = 600;
const int joyMinValue = 80;
const int joyMaxValue = 900;

const int introMessageDuration = 2000;
int lastIntroMessage = 0;

// Menu variables
#define MENU_START_GAME 0
#define MENU_HIGHSCORE 1
#define MENU_RESET_HIGHSCORE 2
#define MENU_LCD_BRIGHTNESS 3
#define MENU_MATRIX_BRIGHTNESS 4
#define MENU_CHANGE_DIFFICULTY 5
#define MENU_HOW_TO_PLAY 6
#define MENU_ABOUT 7
#define MENU_ENTER_NAME 8
#define MENU_SOUNDS 9

enum {
  INTRO_MESSAGE,
  MENU,
  START_GAME,
  IN_GAME,
  END_GAME_SCREEN_1,
  END_GAME_SCREEN_2
} gameState;

int showMenuOption;
const int noSubMenuOption = -1;
int subMenuOption = noSubMenuOption;

enum {
  LEVEL0,
  LEVEL1,
  LEVEL2,
  LEVEL3
} gameLevel;

// Variables for scrolling text
const int initialScollingTextPos = 0;
int scrollingTextPos = initialScollingTextPos;
const int ScrollingDelay = 500;
unsigned long lastScrollingChange = 0;

// Variables for map generation
struct matrixCoordinates {
  int x;
  int y;
};
const int numberOfDirections = 5;
const matrixCoordinates matrixDirections[numberOfDirections] = {
  { -1, 0 }, { 0, 1 }, { 1, 0 }, { 0, -1 }, { 0, 0 }
};
const int up = 0;
const int right = 1;
const int down = 2;
const int left = 3;
const int stay = 4;

const int numberOfCornerWalls = 8;
const int numberOfCornerWallLEDs = 3;
const matrixCoordinates directionMatrixWallCorners[numberOfCornerWalls][numberOfCornerWallLEDs] = {
  { matrixDirections[stay], matrixDirections[up], matrixDirections[right] },
  { matrixDirections[stay], matrixDirections[up], matrixDirections[left] },
  { matrixDirections[stay], matrixDirections[right], matrixDirections[up] },
  { matrixDirections[stay], matrixDirections[right], matrixDirections[down] },
  { matrixDirections[stay], matrixDirections[down], matrixDirections[right] },
  { matrixDirections[stay], matrixDirections[down], matrixDirections[left] },
  { matrixDirections[stay], matrixDirections[left], matrixDirections[down] },
  { matrixDirections[stay], matrixDirections[left], matrixDirections[up] }
};

const int mapEmptySpace = 0;
const int mapWall = 1;
const int mapEnemyShowing = 2;
const int mapEnemyNotShowing = 3;
const int mapFood = 4;
const int mapBulletUp = 5;
const int mapBulletRight = 6;
const int mapBulletDown = 7;
const int mapBulletLeft = 8;
const byte mapBulletUpMoved = 9;
const byte mapBulletRightMoved = 10;
const byte mapBulletDownMoved = 11;
const byte mapBulletLeftMoved = 12;
byte foodState = LOW;

// Variables for username
char firstAlphabetChar = 'a';
char lastAlphabetChar = 'z';
char currentUsernameChar = firstAlphabetChar;
byte currentUsernamePosition = 0;
const int usernameLength = 10;
const int oneChar = 1;
String userName = "";

// Variables for game sounds
enum {
  ON,
  OFF
} gameSounds,
  settings ;

// Icons for the LCD and Matrix

// progress bar character for brightness
byte progressBarCharacter[matrixSize] = {
  0b11111,
  0b11111,
  0b11111,
  0b11111,
  0b11111,
  0b11111,
  0b11111,
  0b11111
};
const int progressBarCharacterIndex = 0;

byte customHeart[matrixSize] = {
  0b00000,
  0b01010,
  0b11111,
  0b11111,
  0b01110,
  0b00100,
  0b00000,
  0b00000
};
const int customHeartIndex = 1;

byte customArrow[matrixSize] = {
  0b00100,
  0b01110,
  0b10101,
  0b00100,
  0b00100,
  0b10101,
  0b01110,
  0b00100
};
const int customArrowIndex = 2;

byte customSlashFirstRow[matrixSize] = {
  0b00000,
  0b00000,
  0b00000,
  0b00001,
  0b00010,
  0b00100,
  0b01000,
  0b10000
};
const int customSlashFirstRowIndex = 3;

byte customSlashSecondRow[matrixSize] = {
  0b00001,
  0b00010,
  0b00100,
  0b01000,
  0b10000,
  0b00000,
  0b00000,
  0b00000
};
const int customSlashSecondRowIndex = 4;

byte customBackslashFirstRow[matrixSize] = {
  0b00000,
  0b00000,
  0b00000,
  0b10000,
  0b01000,
  0b00100,
  0b00010,
  0b00001
};
const int customBackslashFirstRowIndex = 5;

byte customBackslashSecondRow[matrixSize] = {
  0b10000,
  0b01000,
  0b00100,
  0b00010,
  0b00001,
  0b00000,
  0b00000,
  0b00000
};
const int customBackslashSecondRowIndex = 6;

byte playIcon[matrixSize] = {
  B00100000,
  B00110000,
  B00111000,
  B00111100,
  B00111000,
  B00110000,
  B00100000,
  B00000000
};

byte aboutIcon[matrixSize] = {
  B00000000,
  B00011000,
  B00011000,
  B00000000,
  B00011000,
  B00011000,
  B00011000,
  B00000000
};

byte gameSoundsIcon[matrixSize] = {
  B00000000,
  B00010000,
  B00111000,
  B00111110,
  B00111110,
  B00111000,
  B00010000,
  B00000000
};

byte lcdIcon[matrixSize] = {
  B00000000,
  B00011000,
  B00111100,
  B00111100,
  B00111100,
  B00011000,
  B00011000,
  B00000000
};
byte difficultyIcon[matrixSize] = {
  B00000000,
  B00100010,
  B00011100,
  B00111110,
  B00011100,
  B00100010,
  B00000000,
  B00000000
};

byte matrixIcon[matrixSize] = {
  B00000000,
  B00111100,
  B01111110,
  B01111110,
  B01111110,
  B01111110,
  B00111100,
  B00000000
};

byte questionMarkIcon[matrixSize] = {
  B00000000,
  B00111000,
  B01111100,
  B00011100,
  B00111000,
  B00000000,
  B00111000,
  B00111000
};

byte resetScoreIcon[matrixSize] = {
  B00000000,
  B00111100,
  B01000010,
  B10000001,
  B10000101,
  B10000110,
  B01000000,
  B00111100
};

byte leaderboardIcon[matrixSize] = {
  B00000000,
  B01111110,
  B01000010,
  B01011010,
  B01011010,
  B01011010,
  B01111110,
  B00000000
};

void setup() {
  pinMode(joyXPin, INPUT);
  pinMode(joyYPin, INPUT);
  pinMode(buttonPin, INPUT_PULLUP);
  pinMode(buzzerPin, OUTPUT);
  pinMode(LCDLedPin, OUTPUT);

  // set up the LCD's number of columns and rows
  lcd.begin(LCDNumOfColumns, LCDNumOfRows);
  lcd.clear();

  // create the custom characters
  lcd.createChar(progressBarCharacterIndex, progressBarCharacter);
  lcd.createChar(customHeartIndex, customHeart);
  lcd.createChar(customArrowIndex, customArrow);
  lcd.createChar(customBackslashFirstRowIndex, customBackslashFirstRow);
  lcd.createChar(customBackslashSecondRowIndex, customBackslashSecondRow);
  lcd.createChar(customSlashFirstRowIndex, customSlashFirstRow);
  lcd.createChar(customSlashSecondRowIndex, customSlashSecondRow);

  // set up the LED matrix
  lc.shutdown(0, false);
  lc.setIntensity(0, matrixBrightness);
  lc.clearDisplay(LCDFirstRow);

  // print welcome message
  lcd.setCursor(LCD4thCol, LCDFirstRow);
  lcd.print("Welcome!");

  // read game settings from EEPROM and set first menu option
  readGameVariablesFromEEPROM();
  gameState = INTRO_MESSAGE;
  showMenuOption = MENU_START_GAME;

  randomSeed(analogRead(A4));
}

void loop() {
  switch (gameState) {
    case INTRO_MESSAGE:
      checkDisplayIntroMessage();
      break;
    case MENU:
      displayMenuOptions();
      readJoysticValues();
      checkButtonPressed();
      break;
    case START_GAME:
      generateGameMap();
      gameState = IN_GAME;
      gameVariablesChanged = true;
      break;
    case IN_GAME:
      blinkGameObjects();
      readJoysticValues();
      checkEnemyNearbyAndSpawnBullets();
      moveBullets();
      if (matrixChanged) {
        displayMap();
      }
      if (gameVariablesChanged) {
        displayGameVariablesOnLCD();
      }
      checkGameFinished();
      break;
    case END_GAME_SCREEN_1:
      if (numberOfLives == initialNumberOfLives) {
        displayEndGameMessageLose();
      } else if (numberOfFoodEaten >= numberOfFoodToWin) {
        displayEndGameMessageWin();
      }
      checkButtonPressed();
      break;
    case END_GAME_SCREEN_2:
      displayEndGameStats();
      checkButtonPressed();
      break;
  }
}

void displayMap() {
  for (int row = 0; row < matrixSize; row++) {
    for (int col = 0; col < matrixSize; col++) {
      if (row + matrixDisplayOffsetX == playerX && col + matrixDisplayOffsetY == playerY) {
        lc.setLed(0, row, col, playerLEDState);
      } else if (gameMap[row + matrixDisplayOffsetX][col + matrixDisplayOffsetY] < mapEnemyShowing) {
        lc.setLed(0, row, col, gameMap[row + matrixDisplayOffsetX][col + matrixDisplayOffsetY]);
      } else if (gameMap[row + matrixDisplayOffsetX][col + matrixDisplayOffsetY] < mapFood) {
        lc.setLed(0, row, col, mapEnemyNotShowing - gameMap[row + matrixDisplayOffsetX][col + matrixDisplayOffsetY]);
      } else if (gameMap[row + matrixDisplayOffsetX][col + matrixDisplayOffsetY] == mapFood) {
        lc.setLed(0, row, col, foodState);
      } else if (gameMap[row + matrixDisplayOffsetX][col + matrixDisplayOffsetY] > mapFood) {
        lc.setLed(0, row, col, HIGH);
      }
    }
  }
  matrixChanged = false;
}

void blinkGameObjects() {
  // blink enemys
  if (millis() - lastEnemyBlink > enemyBlinkDelay) {
    for (int row = matrixDisplayOffsetX; row < matrixDisplayOffsetX + matrixSize; row++) {
      for (int col = matrixDisplayOffsetY; col < matrixDisplayOffsetY + matrixSize; col++) {
        if (gameMap[row][col] == mapEnemyShowing + enemyState) {  // it is an enemy
          gameMap[row][col] = mapEnemyNotShowing - enemyState;
        }
      }
    }
    enemyState = !enemyState;
    lastEnemyBlink = millis();
    matrixChanged = true;
  }
  // blink player
  if (millis() - lastPlayerBlink > playerBlinkInterval) {
    playerLEDState = !playerLEDState;
    lastPlayerBlink = millis();
    matrixChanged = true;
  }
  // blink food
  if (millis() - lastFoodBlink > foodBlinkInterval) {
    foodState = !foodState;
    lastFoodBlink = millis();
    matrixChanged = true;
  }
}

void displayMenuOptions() {
  switch (subMenuOption) {
    case noSubMenuOption:
      displayNoSubMenuOptions();
      break;
    case MENU_ENTER_NAME:
      enterUsername();
      break;
    case MENU_LCD_BRIGHTNESS:
      adjustLCDBrightness();
      break;
    case MENU_MATRIX_BRIGHTNESS:
      adjustMatrixBrightness();
      break;
    case MENU_HOW_TO_PLAY:
      lcd.setCursor(LCD2ndCol, LCDFirstRow);
      lcd.print("How to Play?");
      displayScrollingText(F("  Help Bob eat food while avoiding bullets from the enemies  "));
      break;
    case MENU_ABOUT:
      lcd.setCursor(LCD2ndCol, LCDFirstRow);
      lcd.print(" About game ");
      displayScrollingText(F("  Game: Hungry Bob, Author: Ana Maria Panait, Github user: anamariapanait10   "));
      break;
    case MENU_CHANGE_DIFFICULTY:
      displayChangeDifficulty();
      break;
    case MENU_SOUNDS:
      displaySoundsOption();
      break;
    case MENU_HIGHSCORE:
      lcd.setCursor(LCDS1stCol, LCDFirstRow);
      lcd.print(" Leaderboard ");
      displayHighscore();
      break;
    case MENU_RESET_HIGHSCORE:
      lcd.setCursor(LCD0Col, LCDFirstRow);
      lcd.print("Scores reseted! ");
      break;
  }
}

void displayNoSubMenuOptions() {
  lcd.setCursor(LCD0Col, LCDFirstRow);
  lcd.write((byte)customSlashFirstRowIndex);
  lcd.print("     MENU     ");
  lcd.setCursor(LCDLastCol, LCDFirstRow);
  lcd.write((byte)customBackslashFirstRowIndex);
  lcd.setCursor(LCD0Col, LCDSecondRow);
  lcd.write((byte)customBackslashSecondRowIndex);
  switch (showMenuOption) {
    case MENU_START_GAME:
      lcd.print("  Start game  ");
      lcd.setCursor(LCDLastCol, LCDSecondRow);
      lcd.write((byte)customSlashSecondRowIndex);
      displayIcon(playIcon);
      break;
    case MENU_HIGHSCORE:
      lcd.print(" Leaderboard  ");
      lcd.setCursor(LCDLastCol, LCDSecondRow);
      displayIcon(leaderboardIcon);
      lcd.write((byte)customSlashSecondRowIndex);
      break;
    case MENU_RESET_HIGHSCORE:
      lcd.print(" Reset Scores ");
      displayIcon(resetScoreIcon);
      lcd.setCursor(LCDLastCol, LCDSecondRow);
      lcd.write((byte)customSlashSecondRowIndex);
      break;
    case MENU_LCD_BRIGHTNESS:
      lcd.print("     LCD      ");
      lcd.setCursor(LCDLastCol, LCDSecondRow);
      lcd.write((byte)customSlashSecondRowIndex);
      displayIcon(lcdIcon);
      break;
    case MENU_MATRIX_BRIGHTNESS:
      lcd.setCursor(LCD5thCol, LCDSecondRow);
      lcd.print("Matrix");
      lcd.setCursor(LCDLastCol, LCDSecondRow);
      lcd.write((byte)customSlashSecondRowIndex);
      displayIcon(matrixIcon);
      break;
    case MENU_CHANGE_DIFFICULTY:
      lcd.print("  Difficulty  ");
      lcd.setCursor(LCDLastCol, LCDSecondRow);
      lcd.write((byte)customSlashSecondRowIndex);
      displayIcon(difficultyIcon);
      break;
    case MENU_SOUNDS:
      lcd.print("  Game sounds  ");
      lcd.setCursor(LCDLastCol, LCDSecondRow);
      lcd.write((byte)customSlashSecondRowIndex);
      displayIcon(gameSoundsIcon);
      break;
    case MENU_HOW_TO_PLAY:
      lcd.print(" How to Play? ");
      displayIcon(questionMarkIcon);
      lcd.setCursor(LCDLastCol, LCDSecondRow);
      lcd.write((byte)customSlashSecondRowIndex);
      break;
    case MENU_ABOUT:
      lcd.print("  About game  ");
      displayIcon(aboutIcon);
      lcd.setCursor(LCDLastCol, LCDSecondRow);
      lcd.write((byte)customSlashSecondRowIndex);
      break;
  }
}

void displayChangeDifficulty() {
  lcd.setCursor(LCD2ndCol, LCDFirstRow);
  lcd.print(" Difficulty ");
  switch (settingsGameDifficulty) {
    case EASY:
      lcd.setCursor(LCD3rdCol, LCDSecondRow);
      lcd.print("   EASY   ");
      break;
    case MEDIUM:
      lcd.setCursor(LCD4thCol, LCDSecondRow);
      lcd.print(" MEDIUM ");
      break;
    case HARD:
      lcd.setCursor(LCD3rdCol, LCDSecondRow);
      lcd.print("   HARD   ");
      break;
  }
  lcd.setCursor(LCDLastCol, LCDSecondRow);
  lcd.write((byte)customArrowIndex);
}

void displaySoundsOption() {
  lcd.setCursor(LCDS1stCol, LCDFirstRow);
  lcd.print(" Game Sounds ");
  switch (settingsGameSounds) {
    case ON:
      lcd.setCursor(LCD3rdCol, LCDSecondRow);
      lcd.print("    ON   ");
      break;
    case OFF:
      lcd.setCursor(LCD3rdCol, LCDSecondRow);
      lcd.print("    OFF   ");
      break;
  }
  lcd.setCursor(LCDLastCol, LCDSecondRow);
  lcd.write((byte)customArrowIndex);
}

void readJoysticValues() {
  int joyXVal = analogRead(joyXPin);
  if (joyXVal < minThreshold && joyMovedX == false) {
    joyMovedX = true;
    if (gameState == MENU) {
      changeMenuOptionLeft();
    } else if (gameState == IN_GAME) {
      movePlayerToLeft();
    }
  }
  if (joyXVal > maxThreshold && joyMovedX == false) {
    joyMovedX = true;
    if (gameState == MENU) {
      changeMenuOptionRight();
    } else if (gameState == IN_GAME) {
      movePlayerToRight();
    }
  }
  if (joyXVal >= minThreshold && joyXVal <= maxThreshold) {
    joyMovedX = false;
    if (gameState == MENU) {
      switch (subMenuOption) {
        case MENU_LCD_BRIGHTNESS:
          setBrightness();
          break;
        case MENU_MATRIX_BRIGHTNESS:
          setMatrixBrightness();
          break;
      }
    }
  }

  if (gameState == IN_GAME || subMenuOption == MENU_ENTER_NAME || subMenuOption == MENU_CHANGE_DIFFICULTY || subMenuOption == MENU_SOUNDS) {
    int joyYVal = analogRead(joyYPin);
    if (joyYVal < minThreshold && joyMovedY == false) {
      joyMovedY = true;
      if (gameState == IN_GAME) {
        movePlayerUp();
      } else if (subMenuOption == MENU_ENTER_NAME) {
        changeCharUp();
      } else if (subMenuOption == MENU_CHANGE_DIFFICULTY) {
        changeDifficultyUp();
      } else if (subMenuOption == MENU_SOUNDS) {
        changeSounds();
      }
      matrixChanged = true;
    }

    if (joyYVal > maxThreshold && joyMovedY == false) {
      joyMovedY = true;
      if (gameState == IN_GAME) {
        movePlayerDown();
      } else if (subMenuOption == MENU_ENTER_NAME) {
        changeCharDown();
      } else if (subMenuOption == MENU_CHANGE_DIFFICULTY) {
        changeDifficultyDown();
      } else if (subMenuOption == MENU_SOUNDS) {
        changeSounds();
      }
      matrixChanged = true;
    }
    if (joyYVal >= minThreshold && joyYVal <= maxThreshold) {
      joyMovedY = false;
    }
  }
}

void changeMenuOptionLeft() {
  if (gameSounds == ON) {
    tone(buzzerPin, NOTE_A6, shortToneDuration);
  }
  switch (subMenuOption) {
    case noSubMenuOption:
      switch (showMenuOption) {
        case MENU_START_GAME:
          showMenuOption = MENU_ABOUT;
          break;
        case MENU_HIGHSCORE:
          showMenuOption = MENU_START_GAME;
          break;
        case MENU_RESET_HIGHSCORE:
          showMenuOption = MENU_HIGHSCORE;
          break;
        case MENU_LCD_BRIGHTNESS:
          showMenuOption = MENU_RESET_HIGHSCORE;
          break;
        case MENU_MATRIX_BRIGHTNESS:
          showMenuOption = MENU_LCD_BRIGHTNESS;
          lcd.clear();
          break;
        case MENU_CHANGE_DIFFICULTY:
          showMenuOption = MENU_MATRIX_BRIGHTNESS;
          lcd.clear();
          break;
        case MENU_SOUNDS:
          showMenuOption = MENU_CHANGE_DIFFICULTY;
          lcd.clear();
          break;
        case MENU_HOW_TO_PLAY:
          showMenuOption = MENU_SOUNDS;
          lcd.clear();
          break;
        case MENU_ABOUT:
          showMenuOption = MENU_HOW_TO_PLAY;
          lcd.clear();
          break;
      }
    case MENU_LCD_BRIGHTNESS:
      decreaseLCDBrightness = true;
      break;
    case MENU_MATRIX_BRIGHTNESS:
      decreaseMatrixBrightness = true;
      break;
  }
}

void changeMenuOptionRight() {
  if (gameSounds == ON) {
    tone(buzzerPin, NOTE_A6, shortToneDuration);
  }
  switch (subMenuOption) {
    case noSubMenuOption:
      switch (showMenuOption) {
        case MENU_START_GAME:
          showMenuOption = MENU_HIGHSCORE;
          lcd.clear();
          break;
        case MENU_HIGHSCORE:
          showMenuOption = MENU_RESET_HIGHSCORE;
          break;
        case MENU_RESET_HIGHSCORE:
          showMenuOption = MENU_LCD_BRIGHTNESS;
          break;
        case MENU_LCD_BRIGHTNESS:
          showMenuOption = MENU_MATRIX_BRIGHTNESS;
          lcd.clear();
          break;
        case MENU_MATRIX_BRIGHTNESS:
          showMenuOption = MENU_CHANGE_DIFFICULTY;
          break;
        case MENU_CHANGE_DIFFICULTY:
          showMenuOption = MENU_SOUNDS;
          break;
        case MENU_SOUNDS:
          showMenuOption = MENU_HOW_TO_PLAY;
          break;
        case MENU_HOW_TO_PLAY:
          showMenuOption = MENU_ABOUT;
          break;
        case MENU_ABOUT:
          showMenuOption = MENU_START_GAME;
          break;
      }
    case MENU_START_GAME:
      break;
    case MENU_LCD_BRIGHTNESS:
      increaseLCDBrightness = true;
      break;
    case MENU_MATRIX_BRIGHTNESS:
      increaseMatrixBrightness = true;
      break;
    case MENU_ENTER_NAME:
      userName.concat(currentUsernameChar);
      currentUsernamePosition++;
      currentUsernameChar = firstAlphabetChar;
      break;
    case MENU_ABOUT:
      break;
  }
}

void movePlayerToLeft() {
  int newPlayerY = playerY + matrixDirections[left].y;
  if (gameMap[playerX][newPlayerY] == mapEmptySpace || gameMap[playerX][newPlayerY] == mapFood) {
    if (gameMap[playerX][newPlayerY] == mapFood) {
      numberOfFoodEaten++;
      updateGameLevel();
      if (gameSounds == ON) {
        tone(buzzerPin, NOTE_A6, shortToneDuration);
      }
      gameVariablesChanged = true;
      gameMap[playerX][newPlayerY] = mapEmptySpace;
    }
    playerY = newPlayerY;
    if (playerY < mapFood) {
      matrixDisplayOffsetY = initialOffset;
    } else if (playerY > mapWidth - halfMatrixSize) {
      matrixDisplayOffsetY = mapWidth - matrixSize;
    } else if (playerY - matrixDisplayOffsetY < quaterMatrixSize) {
      matrixDisplayOffsetY--;
    }
    matrixChanged = true;
  }
}

void movePlayerToRight() {
  int newPlayerY = playerY + matrixDirections[right].y;
  if (gameMap[playerX][newPlayerY] == mapEmptySpace || gameMap[playerX][newPlayerY] == mapFood) {
    if (gameMap[playerX][newPlayerY] == mapFood) {
      numberOfFoodEaten++;
      if (gameSounds == ON) {
        tone(buzzerPin, NOTE_A6, shortToneDuration);
      }
      updateGameLevel();
      gameVariablesChanged = true;
      gameMap[playerX][newPlayerY] = mapEmptySpace;
    }
    playerY = newPlayerY;
    if (playerY < mapFood) {
      matrixDisplayOffsetY = initialOffset;
    } else if (playerY > mapWidth - halfMatrixSize) {
      matrixDisplayOffsetY = mapWidth - matrixSize;
    } else if (playerY - matrixDisplayOffsetY > yMatrixOffset) {
      matrixDisplayOffsetY++;
    }
    matrixChanged = true;
  }
}

void movePlayerUp() {
  int newPlayerX = playerX + matrixDirections[up].x;
  if (gameMap[newPlayerX][playerY] == mapEmptySpace || gameMap[newPlayerX][playerY] == mapFood) {
    if (gameMap[newPlayerX][playerY] == mapFood) {
      numberOfFoodEaten++;
      if (gameSounds == ON) {
        tone(buzzerPin, NOTE_A6, shortToneDuration);
      }
      updateGameLevel();
      gameVariablesChanged = true;
      gameMap[newPlayerX][playerY] = mapEmptySpace;
    }
    playerX = newPlayerX;
    if (playerX < mapFood) {
      matrixDisplayOffsetX = initialOffset;
    } else if (playerX > mapHeight - halfMatrixSize) {
      matrixDisplayOffsetX = mapHeight - matrixSize;
    } else if (playerX - matrixDisplayOffsetX < quaterMatrixSize) {
      matrixDisplayOffsetX--;
    }
  }
}

void movePlayerDown() {
  int newPlayerX = playerX + matrixDirections[down].x;
  if (gameMap[newPlayerX][playerY] == mapEmptySpace || gameMap[newPlayerX][playerY] == mapFood) {
    if (gameMap[newPlayerX][playerY] == mapFood) {
      numberOfFoodEaten++;
      if (gameSounds == ON) {
        tone(buzzerPin, NOTE_A6, shortToneDuration);
      }
      updateGameLevel();
      gameVariablesChanged = true;
      gameMap[newPlayerX][playerY] = mapEmptySpace;
    }
    playerX = newPlayerX;
    if (playerX < mapFood) {
      matrixDisplayOffsetX = initialOffset;
    } else if (playerX > mapHeight - halfMatrixSize) {
      matrixDisplayOffsetX = mapHeight - matrixChanged;
    } else if (playerX - matrixDisplayOffsetX > yMatrixOffset) {
      matrixDisplayOffsetX++;
    }
  }
}

void changeCharUp() {
  if (gameSounds == ON) {
    tone(buzzerPin, NOTE_A6, shortToneDuration);
  }
  if (currentUsernameChar == firstAlphabetChar) {
    currentUsernameChar = lastAlphabetChar;
  } else {
    currentUsernameChar--;
  }
}

void changeDifficultyUp() {
  if (gameSounds == ON) {
    tone(buzzerPin, NOTE_A6, shortToneDuration);
  }
  switch (settingsGameDifficulty) {
    case EASY:
      settingsGameDifficulty = HARD;
      break;
    case MEDIUM:
      settingsGameDifficulty = EASY;
      break;
    case HARD:
      settingsGameDifficulty = MEDIUM;
      break;
  }
}

void changeSounds() {
  if (gameSounds == ON) {
    tone(buzzerPin, NOTE_A6, shortToneDuration);
  }
  switch (settingsGameSounds) {
    case ON:
      settingsGameSounds = OFF;
      break;
    case OFF:
      settingsGameSounds = ON;
      break;
  }
}

void changeCharDown() {
  if (gameSounds == ON) {
    tone(buzzerPin, NOTE_A6, shortToneDuration);
  }
  if (currentUsernameChar == lastAlphabetChar) {
    currentUsernameChar = firstAlphabetChar;
  } else {
    currentUsernameChar++;
  }
}

void changeDifficultyDown() {
  if (gameSounds == ON) {
    tone(buzzerPin, NOTE_A6, shortToneDuration);
  }
  switch (settingsGameDifficulty) {
    case EASY:
      settingsGameDifficulty = MEDIUM;
      break;
    case MEDIUM:
      settingsGameDifficulty = HARD;
      break;
    case HARD:
      settingsGameDifficulty = EASY;
      break;
  }
}

void updateGameLevel() {
  if (numberOfFoodEaten < numberOfFoodToWin / numberOfLevels) {
    gameLevel = LEVEL1;
  } else if (numberOfFoodEaten < LEVEL2 * numberOfFoodToWin / numberOfLevels) {
    gameLevel = LEVEL2;
  } else {
    gameLevel = LEVEL3;
  }
}

void moveBullets() {
  if (millis() - lastBulletMovement > bulletMovementDelay) {
    for (int i = 0; i < mapHeight; i++) {
      for (int j = 0; j < mapWidth; j++) {
        int x = i, y = j;
        switch (gameMap[i][j]) {
          case mapBulletUp:
            x--;
            break;
          case mapBulletRight:
            y++;
            break;
          case mapBulletDown:
            x++;
            break;
          case mapBulletLeft:
            y--;
            break;
        }

        switch (gameMap[i][j]) {
          case mapBulletUp:
          case mapBulletRight:
          case mapBulletDown:
          case mapBulletLeft:
            gameMap[i][j] = mapEmptySpace;
            if (x == playerX && y == playerY) {
              numberOfLives--;
              if (gameSounds == ON) {
                tone(buzzerPin, NOTE_A3, longToneDuration);
              }
              gameVariablesChanged = true;
            } else if (gameMap[x][y] == mapEmptySpace || gameMap[x][y] == mapFood) {
              switch (gameMap[i][j]) {
                case mapBulletUp:
                  gameMap[x][y] = mapBulletUpMoved;
                  break;
                case mapBulletRight:
                  gameMap[x][y] = mapBulletRightMoved;
                  break;
                case mapBulletDown:
                  gameMap[x][y] = mapBulletDownMoved;
                  break;
                case mapBulletLeft:
                  gameMap[x][y] = mapBulletLeftMoved;
                  break;
              }
            }
            break;
        }
      }
    }

    for (int i = 0; i < mapHeight; i++) {  // change moved bullets to unmoved for next update
      for (int j = 0; j < mapWidth; j++) {
        switch (gameMap[i][j]) {
          case mapBulletUpMoved:
            gameMap[i][j] = mapBulletUp;
            break;
          case mapBulletRightMoved:
            gameMap[i][j] = mapBulletRight;
            break;
          case mapBulletDownMoved:
            gameMap[i][j] = mapBulletDown;
            break;
          case mapBulletLeftMoved:
            gameMap[i][j] = mapBulletLeft;
            break;
        }
      }
    }

    lastBulletMovement = millis();
    matrixChanged = true;
  }
}

void checkEnemyNearbyAndSpawnBullets() {
  if (millis() - lastBulletSpawn > enemyShootingInterval) {
    int x, y;
    for (int direction = 0; direction < numberOfDirections - 1; direction++) {
      x = playerX + matrixDirections[direction].x;
      y = playerY + matrixDirections[direction].y;
      for (int i = 0; i < spawnDistance; i++) {
        if (gameMap[x][y] == mapEnemyNotShowing || gameMap[x][y] == mapEnemyShowing) {
          switch (direction) {
            case up:
            case right:
            case down:
            case left:
              if (playerX == x - matrixDirections[direction].x && playerY == y - matrixDirections[direction].y) {
                numberOfLives--;
                if (gameSounds == ON) {
                  tone(buzzerPin, NOTE_A3, longToneDuration);
                }
                gameVariablesChanged = true;
              } else {
                switch (direction) {
                  case up:
                    gameMap[x - matrixDirections[direction].x][y - matrixDirections[direction].y] = mapBulletDown;
                    break;
                  case right:
                    gameMap[x - matrixDirections[direction].x][y - matrixDirections[direction].y] = mapBulletLeft;
                    break;
                  case down:
                    gameMap[x - matrixDirections[direction].x][y - matrixDirections[direction].y] = mapBulletUp;
                    break;
                  case left:
                    gameMap[x - matrixDirections[direction].x][y - matrixDirections[direction].y] = mapBulletRight;
                    break;
                }
              }
              lastBulletSpawn = millis();
              lastBulletMovement = millis();
              break;
          }
        }
        x = x + matrixDirections[direction].x;
        y = y + matrixDirections[direction].y;
      }
    }
    matrixChanged = true;
  }
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
        if (gameSounds == ON) {
          tone(buzzerPin, NOTE_A6, shortToneDuration);
        }
        if (gameState == MENU) {
          switch (subMenuOption) {
            case noSubMenuOption:
              handleNoSubMenuOptionPress();
              break;
            case MENU_LCD_BRIGHTNESS:
              EEPROM.update(LCDBrightnessEepromAddress, LCDBrightness);
              subMenuOption = noSubMenuOption;
              lcd.clear();
              break;
            case MENU_ENTER_NAME:
              handleUsernameSubmenuPress();
              break;
            case MENU_MATRIX_BRIGHTNESS:
              EEPROM.update(matrixBrightnessEepromAddress, matrixBrightness);
              lc.clearDisplay(0);
              lcd.clear();
              subMenuOption = noSubMenuOption;
              break;
            case MENU_CHANGE_DIFFICULTY:
              gameDifficulty = settingsGameDifficulty;
              writeDifficultyToEeprom();
              subMenuOption = noSubMenuOption;
              break;
            case MENU_SOUNDS:
              gameSounds = settingsGameSounds;
              writeGameSoundsToEeprom();
              subMenuOption = noSubMenuOption;
              break;
            default:
              subMenuOption = noSubMenuOption;
              break;
          }
        } else if (gameState == END_GAME_SCREEN_1) {
          gameState = END_GAME_SCREEN_2;
          lcd.clear();
        } else if (gameState == END_GAME_SCREEN_2) {
          if (leaderBoardPosition != noLeaderBoardPosition) {
            subMenuOption = MENU_ENTER_NAME;
            gameState = MENU;
          } else {
            gameState = MENU;
            subMenuOption = noSubMenuOption;
            showMenuOption = MENU_START_GAME;
          }
          lcd.clear();
        }
      }
    }
  }
  buttonLastReading = buttonReading;
}

void handleNoSubMenuOptionPress() {
  switch (showMenuOption) {
    case MENU_START_GAME:
      gameState = START_GAME;
      restartGame();
      break;
    case MENU_HIGHSCORE:
      subMenuOption = MENU_HIGHSCORE;
      scrollingTextPos = initialScollingTextPos;
      lcd.clear();
      break;
    case MENU_RESET_HIGHSCORE:
      subMenuOption = MENU_RESET_HIGHSCORE;
      lcd.clear();
      resetHighscores();
      break;
    case MENU_LCD_BRIGHTNESS:
      subMenuOption = MENU_LCD_BRIGHTNESS;
      lcd.clear();
      break;
    case MENU_MATRIX_BRIGHTNESS:
      subMenuOption = MENU_MATRIX_BRIGHTNESS;
      lcd.clear();
      break;
    case MENU_HOW_TO_PLAY:
      subMenuOption = MENU_HOW_TO_PLAY;
      scrollingTextPos = initialScollingTextPos;
      lcd.clear();
      break;
    case MENU_ABOUT:
      subMenuOption = MENU_ABOUT;
      scrollingTextPos = initialScollingTextPos;
      lcd.clear();
      break;
    case MENU_CHANGE_DIFFICULTY:
      subMenuOption = MENU_CHANGE_DIFFICULTY;
      readGameDifficultyFromEEPROM();
      settingsGameDifficulty = gameDifficulty;
      lcd.clear();
      break;
    case MENU_SOUNDS:
      subMenuOption = MENU_SOUNDS;
      readGameSoundsFromEEPROM();
      Serial.println(gameSounds);
      settingsGameSounds = gameSounds;
      lcd.clear();
      break;
    default:
      subMenuOption = noSubMenuOption;
      break;
  }
}

void handleUsernameSubmenuPress() {
  subMenuOption = noSubMenuOption;
  showMenuOption = START_GAME;
  lcd.clear();
  userName.concat(currentUsernameChar);
  writeScoreToEeprom();
  readGameVariablesFromEEPROM();
  currentUsernamePosition = initialScollingTextPos;
  userName = "";
}

void writeScoreToEeprom() {
  switch (leaderBoardPosition) {
    case thirdPlace:
      EEPROM.put(thirdPlaceTimeBeginAddress, userTime);
      for (int i = 0; i <= usernameLength; i++) {
        EEPROM.put(thirdPlaceUsernameBeginAddress + i, userName[i]);
        thirdPlaceUsername[i] = userName[i];
      }
      thirdPlaceTime = userTime;
      break;
    case secondPlace:
      EEPROM.put(thirdPlaceTimeBeginAddress, secondPlaceTime);
      for (int i = 0; i <= usernameLength; i++) {
        EEPROM.put(thirdPlaceUsernameBeginAddress + i, secondPlaceUsername[i]);
        thirdPlaceUsername[i] = secondPlaceUsername[i];
      }
      thirdPlaceTime = secondPlaceTime;
      EEPROM.put(secondPlaceTimeBeginAddress, userTime);
      for (int i = 0; i <= usernameLength; i++) {
        EEPROM.put(secondPlaceUsernameBeginAddress + i, userName[i]);
        secondPlaceUsername[i] = userName[i];
      }
      secondPlaceTime = userTime;
      break;
    case firstPlace:
      EEPROM.put(thirdPlaceTimeBeginAddress, secondPlaceTime);
      for (int i = 0; i <= usernameLength; i++) {
        EEPROM.put(thirdPlaceUsernameBeginAddress + i, secondPlaceUsername[i]);
        thirdPlaceUsername[i] = secondPlaceUsername[i];
      }
      thirdPlaceUsername[usernameLength] = '\0';
      thirdPlaceTime = secondPlaceTime;
      EEPROM.put(secondPlaceTimeBeginAddress, firstPlaceTime);
      for (int i = 0; i <= usernameLength; i++) {
        EEPROM.put(secondPlaceUsernameBeginAddress + i, firstPlaceUsername[i]);
        secondPlaceUsername[i] = firstPlaceUsername[i];
      }
      secondPlaceUsername[usernameLength] = '\0';
      secondPlaceTime = firstPlaceTime;
      EEPROM.put(firstPlaceTimeBeginAddress, userTime);
      for (int i = 0; i <= usernameLength; i++) {
        EEPROM.put(firstPlaceUsernameBeginAddress + i, userName[i]);
        firstPlaceUsername[i] = firstPlaceUsername[i];
      }
      firstPlaceUsername[usernameLength] = '\0';
      firstPlaceTime = userTime;
      break;
  }
}

void checkDisplayIntroMessage() {
  if (millis() - lastIntroMessage >= introMessageDuration) {
    lastIntroMessage = millis();
    gameState = MENU;
    lcd.clear();
  }
}

void setBrightness() {
  if (increaseLCDBrightness && LCDBrightness < LCDNumOfColumns) {
    LCDBrightness++;
    increaseLCDBrightness = false;
  }
  if (decreaseLCDBrightness && LCDBrightness > oneLCDColumn) {
    LCDBrightness--;
    decreaseLCDBrightness = false;
  }

  analogWrite(LCDLedPin, map(LCDBrightness, oneLCDColumn, LCDNumOfColumns, analogWriteMinValue, analogWriteMaxValue));
  for (int i = 0; i < LCDBrightness; i++) {
    lcd.setCursor(i, oneLCDColumn);
    lcd.write((byte)progressBarCharacterIndex);
  }
  for (int i = LCDBrightness; i < LCDNumOfColumns; i++) {
    lcd.setCursor(i, oneLCDColumn);
    lcd.print(" ");
  }
}

void setMatrixBrightness() {
  if (increaseMatrixBrightness && matrixBrightness < LCDNumOfColumns) {
    matrixBrightness++;
    increaseMatrixBrightness = false;
  }
  if (decreaseMatrixBrightness && matrixBrightness > 1) {
    matrixBrightness--;
    decreaseMatrixBrightness = false;
  }
  lc.setIntensity(0, map(matrixBrightness, oneLCDColumn, LCDNumOfColumns, matrixIntensityMinValue, matrixIntensityMaxValue));
  for (int i = 0; i < matrixBrightness; i++) {
    lcd.setCursor(i, LCDSecondRow);
    lcd.write((byte)progressBarCharacterIndex);
  }
  for (int i = matrixBrightness; i < matrixIntensityMaxValue; i++) {
    lcd.setCursor(i, LCDSecondRow);
    lcd.print(" ");
  }
}

void adjustLCDBrightness() {
  lcd.setCursor(LCD0Col, LCDFirstRow);
  lcd.print(" LCD Brightness");
  lcd.setCursor(LCD0Col, LCDSecondRow);  // bottom left
  readJoysticValues();
}

void adjustMatrixBrightness() {
  for (int row = 0; row < matrixSize; row++) {
    for (int col = 0; col < matrixSize; col++) {
      lc.setLed(0, row, col, true);
    }
  }

  lcd.setCursor(LCD0Col, LCDFirstRow);
  lcd.print("Matrix Brightness");
  lcd.setCursor(LCD0Col, LCDSecondRow);
  readJoysticValues();
}

void displayScrollingText(String text) {
  if (millis() - lastScrollingChange > ScrollingDelay) {
    lcd.setCursor(LCDS1stCol, LCDSecondRow);
    lcd.print(text.substring(scrollingTextPos, min(scrollingTextPos + LCDNumOfColumns - twoLCDColumns, text.length() - oneChar)));
    scrollingTextPos++;
    if (scrollingTextPos == text.length() - oneChar) {
      scrollingTextPos = initialScollingTextPos;
    }
    lastScrollingChange = millis();
  }
}

void checkGameFinished() {
  if (numberOfLives <= initialNumberOfLives || numberOfFoodEaten >= numberOfFoodToWin) {
    gameState = END_GAME_SCREEN_1;
    if (gameSounds == ON) {
      tone(buzzerPin, NOTE_C2, gameOverToneDuration);
    }
    userTime = (millis() - gameStartTime) / millisToSecond;
    lcd.clear();
    scrollingTextPos = initialScollingTextPos;
  }
}

void displayEndGameMessageLose() {
  lcd.setCursor(LCD0Col, LCDFirstRow);
  lcd.print(F("   Game over!"));
  String message = "";
  message.concat(F(" Level "));
  message.concat(gameLevel);
  message.concat(F(", score "));
  message.concat(numberOfFoodEaten);
  message.concat("  ");
  displayScrollingText(message);
}

void displayEndGameMessageWin() {
  lcd.setCursor(LCD0Col, LCDFirstRow);
  lcd.print(F("   You won!"));
  String message = "Congrats! You are now #";

  if (userTime < thirdPlaceTime) {
    if (userTime < secondPlaceTime) {
      if (userTime < firstPlaceTime) {
        message.concat(F("1"));
        leaderBoardPosition = firstPlace;
      } else {
        message.concat(F("2"));
        leaderBoardPosition = secondPlace;
      }
    } else {
      message.concat(F("3"));
      leaderBoardPosition = thirdPlace;
    }
    message.concat(F(", time "));
    message.concat(userTime);
    message.concat(F("s!         "));
  } else {
    message = "  You needed to be ";
    message.concat(userTime - thirdPlaceTime);
    message.concat(F("s quicker to beat #3! "));
    leaderBoardPosition = noLeaderBoardPosition;
  }
  displayScrollingText(message);
}

void displayEndGameStats() {
  lcd.setCursor(LCD0Col, LCDFirstRow);
  lcd.print("Score: ");
  lcd.print(numberOfFoodEaten);
  lcd.setCursor(LCD14thCol, LCDFirstRow);
  lcd.print(numberOfLives);
  lcd.setCursor(LCDLastCol, LCDFirstRow);
  lcd.print(" ");
  lcd.setCursor(LCDLastCol, LCDFirstRow);
  lcd.write((byte)customHeartIndex);
  lcd.setCursor(LCD0Col, LCDSecondRow);
  lcd.print("Time: ");
  lcd.print(userTime);
  lcd.print("s ");
  lcd.setCursor(LCD12thCol, LCDSecondRow);
  lcd.print("Lev");
  lcd.print(gameLevel);
}

void displayFinishedGame() {
  lcd.clear();
  lcd.setCursor(LCD3rdCol, LCDFirstRow);
  lcd.print("You won!");
  lcd.setCursor(LCD2ndCol, LCDSecondRow);
  lcd.print("Press button for Menu");
}

void displayGameOver() {
  lcd.clear();
  lcd.setCursor(LCD2ndCol, LCDFirstRow);
  lcd.print("Game over");
  lcd.setCursor(LCD2ndCol, LCDSecondRow);
  lcd.print("Press button for Menu");
}

void restartGame() {
  playerX = playerStartX;
  playerY = playerStartY;
  matrixDisplayOffsetX = initialOffset;
  matrixDisplayOffsetY = initialOffset;
  generateGameMap();
  numberOfFoodEaten = initalNumberOfFoodEaten;
  numberOfLives = initialNumberOfLives;
  gameStartTime = millis();
  leaderBoardPosition = noLeaderBoardPosition;
  userName = "";
}

void tryGeneratingWalls(int startRow, int startCol) {
  bool canGenerateWall = false;
  for (int wall = 0; wall < numberOfCornerWalls && !canGenerateWall; wall++) {
    canGenerateWall = true;
    for (int direction = 0; direction < numberOfCornerWallLEDs && canGenerateWall; direction++) {
      bool notOutOfBoundsX = startRow + directionMatrixWallCorners[wall][direction].x > 0 && startRow + directionMatrixWallCorners[wall][direction].x < mapWidth;
      bool notOutOfBoundsY = startCol + directionMatrixWallCorners[wall][direction].y > 0 && startRow + directionMatrixWallCorners[wall][direction].y < mapHeight;
      if (!notOutOfBoundsX || !notOutOfBoundsY) {
        canGenerateWall = false;
      }
    }
    if (canGenerateWall) {
      for (int direction = 0; direction < numberOfCornerWallLEDs && canGenerateWall; direction++) {
        gameMap[startRow + directionMatrixWallCorners[wall][direction].x][startCol + directionMatrixWallCorners[wall][direction].y] = mapWall;
        matrixChanged = true;
      }
    }
  }
}

void generateGameMap() {
  readGameDifficultyFromEEPROM();
  int maxNumberOfFood = noMaxFoodLimit, numberOfFood = 0;
  switch (gameDifficulty) {
    case EASY:
      maxNumberOfFood = noMaxFoodLimit;  // no limit
      gameMapEnemyRatio = easyEnemyRatio;
      spawnDistance = easySpawnDistance;
      break;
    case MEDIUM:
      maxNumberOfFood = mediumMaxFood;
      gameMapEnemyRatio = easyEnemyRatio;
      gameMapFoodRatio = easyFoodRatio;
      spawnDistance = hardSpawnDistance;
      break;
    case HARD:
      maxNumberOfFood = numberOfFoodToWin;
      gameMapEnemyRatio = hardEnemyRatio;
      gameMapFoodRatio = easyFoodRatio;
      spawnDistance = hardSpawnDistance;
      break;
  }
  for (int i = 0; i < mapHeight; i++) {
    for (int j = 0; j < mapWidth; j++) {
      if (i == 0 || j == 0 || i == mapHeight - 1 || j == mapWidth - 1) {  // border the matrix with walls
        gameMap[i][j] = mapWall;
      } else {
        // put empty space near the player (up, right, left, down)
        bool putEmptySpace = false;
        for (int direction = 0; direction < numberOfDirections && !putEmptySpace; direction++) {
          if (playerStartX + matrixDirections[direction].x == i && playerStartY + matrixDirections[direction].y == j) {
            putEmptySpace = true;
          }
        }
        if (putEmptySpace) {
          gameMap[i][j] = mapEmptySpace;
        } else {
          gameMap[i][j] = random(gameMapTotalRatio) < gameMapEnemyRatio ? mapEnemyShowing : mapEmptySpace;
          if (gameMap[i][j] == mapEmptySpace) {
            if (random(gameMapTotalRatio) < gameMapWallRatio) {
              tryGeneratingWalls(i, j);
            } else if (random(gameMapTotalRatio) < gameMapFoodRatio && (numberOfFood < maxNumberOfFood || maxNumberOfFood == noMaxFoodLimit)) {
              gameMap[i][j] = mapFood;
              numberOfFood++;
            }
          }
        }
      }
    }
  }
}


void displayGameVariablesOnLCD() {
  lcd.clear();
  lcd.setCursor(LCD0Col, LCDFirstRow);
  lcd.print(F("Food:"));
  lcd.setCursor(LCD6thCol, LCDFirstRow);
  lcd.print(numberOfFoodEaten);
  lcd.setCursor(LCD14thCol, LCDFirstRow);
  lcd.print(numberOfLives);
  lcd.write((byte)customHeartIndex);

  lcd.setCursor(LCD0Col, LCDSecondRow);
  lcd.print(F("Difficulty: "));
  lcd.setCursor(LCD12thCol, LCDSecondRow);
  switch (gameDifficulty) {
    case EASY:
      lcd.print(F("EASY"));
      break;
    case MEDIUM:
      lcd.print(F("MED"));
      break;
    case HARD:
      lcd.print(F("HARD"));
      break;
  }
  gameVariablesChanged = false;
}

void displayIcon(byte icon[]) {
  for (int row = 0; row < matrixSize; row++) {
    lc.setRow(0, row, icon[row]);
  }
}

void enterUsername() {
  lcd.setCursor(LCD2ndCol, LCDFirstRow);
  lcd.print(F("Username"));
  lcd.setCursor(LCD13thCol, LCDFirstRow);
  lcd.write((byte)customArrowIndex);
  lcd.setCursor(LCDS1stCol, LCDSecondRow);
  lcd.print(userName);
  lcd.setCursor(userName.length() + 1, LCDSecondRow);
  lcd.print(currentUsernameChar);
}


void readGameVariablesFromEEPROM() {
  EEPROM.get(matrixBrightnessEepromAddress, matrixBrightness);
  lc.setIntensity(0, map(matrixBrightness, oneLCDColumn, LCDNumOfColumns, matrixIntensityMinValue, matrixIntensityMaxValue));
  EEPROM.get(LCDBrightnessEepromAddress, LCDBrightness);
  analogWrite(LCDLedPin, map(LCDBrightness, oneLCDColumn, LCDNumOfColumns, analogWriteMinValue, analogWriteMaxValue));
  EEPROM.get(gameSoundsEepromAddress, gameSounds);
  EEPROM.get(gameDifficultyEepromAddress, gameDifficulty);
  EEPROM.get(firstPlaceTimeBeginAddress, firstPlaceTime);
  EEPROM.get(secondPlaceTimeBeginAddress, secondPlaceTime);
  EEPROM.get(thirdPlaceTimeBeginAddress, thirdPlaceTime);
  for (int i = 0; i <= usernameLength; i++) {
    firstPlaceUsername[i] = EEPROM.read(firstPlaceUsernameBeginAddress + i);
    secondPlaceUsername[i] = EEPROM.read(secondPlaceUsernameBeginAddress + i);
    thirdPlaceUsername[i] = EEPROM.read(thirdPlaceUsernameBeginAddress + i);
  }
}

void displayHighscore() {
  char noUser[noUserLength] = "No user\0";
  bool noUserYet = true;
  for (int i = 0; i < noUserLength; i++) {
    if (firstPlaceUsername[i] != noUser[i]) {
      noUserYet = false;
    }
  }
  if (noUserYet) {
    displayScrollingText(F("  No users yet   "));
  } else {
    String message = "1. ";
    message.concat(firstPlaceUsername);
    message.concat(F(" T: "));
    message.concat(firstPlaceTime);
    message.concat(F(" 2. "));
    message.concat(secondPlaceUsername);
    message.concat(F(" T: "));
    message.concat(secondPlaceTime);
    message.concat(F(" 3. "));
    message.concat(thirdPlaceUsername);
    message.concat(F(" T: "));
    message.concat(thirdPlaceTime);
    message.concat(F("  "));
    displayScrollingText(message);
  }
}

void resetHighscores() {
  EEPROM.put(firstPlaceTimeBeginAddress, maxTime);
  EEPROM.put(secondPlaceTimeBeginAddress, maxTime);
  EEPROM.put(thirdPlaceTimeBeginAddress, maxTime);
  firstPlaceTime = maxTime;
  secondPlaceTime = maxTime;
  thirdPlaceTime = maxTime;

  char noUser[noUserLength] = "No user\0";
  for (int i = 0; i < noUserLength; i++) {
    firstPlaceUsername[i] = noUser[i];
    secondPlaceUsername[i] = noUser[i];
    thirdPlaceUsername[i] = noUser[i];
  }
  for (int i = 0; i < noUserLength; i++) {
    EEPROM.put(firstPlaceUsernameBeginAddress + i, noUser[i]);
    EEPROM.put(secondPlaceUsernameBeginAddress + i, noUser[i]);
    EEPROM.put(thirdPlaceUsernameBeginAddress + i, noUser[i]);
  }
}

void readGameDifficultyFromEEPROM() {
  EEPROM.get(gameDifficultyEepromAddress, gameDifficulty);
}

void readGameSoundsFromEEPROM() {
  EEPROM.get(gameSoundsEepromAddress, gameSounds);
}

void writeDifficultyToEeprom() {
  EEPROM.put(gameDifficultyEepromAddress, gameDifficulty);
}

void writeGameSoundsToEeprom() {
  EEPROM.put(gameSoundsEepromAddress, gameSounds);
}
