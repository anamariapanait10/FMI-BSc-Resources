#include <EEPROM.h>

#define SENSOR_SETTINGS 1
#define RESET_LOGGER_DATA 2
#define SYSTEM_STATUS 3
#define RGB_LED_CONTROL 4

#define SENSOR_SAMPLING_INTERVAL 1
#define ULTRASONIC_ALERT_THRESHOLD 2
#define LDR_ALERT_THRESHOLD 3
#define SENSOR_SETTINGS_BACK 4

#define YES 1
#define NO 2

#define CURRENT_SENSORS_READINGS 1
#define CURRENT_SENSOR_SETTINGS 2
#define DISPLAY_LOGGED_DATA 3
#define SYSTEM_STATUS_BACK 4

#define MANUAL_COLOR_CONTROL 1
#define LED_AUTOMATIC_TOGGLE 2
#define RGB_LED_CONTROL_BACK 3

const int trigPin = 2;
const int echoPin = 3;
long duration = 0;
int distance = 0;

const int photocellPin = A0;
int photocellValue;

const int redLEDPin = 11;
const int greenLEDPin = 10;
const int blueLEDPin = 9;
int redLEDValue = -1;
int greenLEDValue = -1;
int blueLEDValue = -1;

// Settings variables
unsigned int sensorsSamplingInterval = 2;
int ultrasonicThreshold = 15;
int ldrThreshold = 500;
bool automaticLEDMode = false;

int eepromAddress = 0;
const int eepromSavedDataSize = 40;

long lastSensorsSampleTime = 0;
int lastUltrasonicValue = -1;
int lastLdrValue = -1;

int submenuCurrentOption = -1;
int subSubmenuCurrentOption = -1;

bool printCurrentSensorsReadings = false;

const float SOUND_SPEED = 0.034;
const int TWO_BYTES_SIZE = 2;
const int FOUR_BYTES_SIZE = 4;
const int TRIG_PIN_SEND_DELAY = 2;
const int TRIG_PIN_WAIT_DELAY = 2;


void setup() {
  Serial.begin(9600);
  pinMode(photocellPin, INPUT);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
  pinMode(redLEDPin, OUTPUT);
  pinMode(greenLEDPin, OUTPUT);
  pinMode(blueLEDPin, OUTPUT);
  printMenu();
}

void loop() {
  // Continuously checks for incoming serial data
  if (Serial.available()) {
    // Reads an integer value from the serial buffer (user's menu choice)
    int choice = Serial.parseInt();

    if (submenuCurrentOption == -1) {
      printSubmenu(choice);
    } else if (subSubmenuCurrentOption == -1) {
      handleSubmenuChoice(submenuCurrentOption, choice);
    } else {
      handleSubSubmenuChoice(submenuCurrentOption, subSubmenuCurrentOption, choice);
    }
  }
  checkSensors();
  updateLEDColor();
}

void printMenu() {
  Serial.println("\nMain Menu:");
  Serial.println("1. Sensor Settings");
  Serial.println("2. Reset Logger Data");
  Serial.println("3. System Status");
  Serial.println("4. RGB LED Control");
  Serial.println("------------------------");
}

void printSubmenu(int option) {
  submenuCurrentOption = option;
  switch (option) {
    case SENSOR_SETTINGS:
      Serial.println("1. Sensor Settings:");
      Serial.println("\t1. Sensors Sampling Interval");
      Serial.println("\t2. Ultrasonic Alert Threshold");
      Serial.println("\t3. LDR Alert Threshold");
      Serial.println("\t4. Back");
      break;
    case RESET_LOGGER_DATA:
      Serial.println("2. Reset logger data?");
      Serial.println("\t1. Yes");
      Serial.println("\t2. No");
      break;
    case SYSTEM_STATUS:
      Serial.println("3. System Status:");
      Serial.println("\t1. Current Sensor Readings");
      Serial.println("\t2. Current Sensor Settings");
      Serial.println("\t3. Display Logged Data");
      Serial.println("\t4. Back");
      break;
    case RGB_LED_CONTROL:
      Serial.println("4. RGB LED Control:");
      Serial.println("\t1. Manual Color Control");
      Serial.println("\t2. LED: Toggle Automatic ON/OFF");
      Serial.println("\t3. Back");
      break;
    default:
      submenuCurrentOption = -1;
      Serial.println("Invalid option!");
  }
  if (submenuCurrentOption != -1) {
    Serial.println("------------------------");
  }
}

void handleSubmenuChoice(int submenu, int option) {
  // Handles the choice based on the submenu context
  // Uses nested switch cases to respond to the user's selection
  switch (submenu) {
    case SENSOR_SETTINGS:
      subSubmenuCurrentOption = option;
      switch (option) {
        case SENSOR_SAMPLING_INTERVAL:
          Serial.println("Input Sensors Sampling Interval (1s - 10s).");
          break;
        case ULTRASONIC_ALERT_THRESHOLD:
          Serial.println("Input Ultrasonic Sensor Alert Threshold.");
          break;
        case LDR_ALERT_THRESHOLD:
          Serial.println("Input LDR Alert Threshold.");
          break;
        case SENSOR_SETTINGS_BACK:  // Back to Main Menu
          submenuCurrentOption = -1;
          subSubmenuCurrentOption = -1;
          printMenu();
          break;
        default:
          subSubmenuCurrentOption = -1;
          Serial.println("Invalid option!");
      }
      break;
    case RESET_LOGGER_DATA:
      switch (option) {
        case YES:
          Serial.println("Logged data was reset.");
          resetLoggerData();
          submenuCurrentOption = -1;
          printMenu();
          break;
        case NO:
          Serial.println("Logged data reset canceled.");
          submenuCurrentOption = -1;
          printMenu();
          break;
        default:
          Serial.println("Invalid option!\n");
      }
      break;
    case SYSTEM_STATUS:
      subSubmenuCurrentOption = option;
      switch (option) {
        case CURRENT_SENSORS_READINGS:
          Serial.println("Current Sensor Readings selected. To exit press 1.");
          printCurrentSensorsReadings = true;
          break;
        case CURRENT_SENSOR_SETTINGS:  // Display Sensor Settings
          Serial.print("Sensors Sampling Rate: ");
          Serial.print(sensorsSamplingInterval);
          Serial.print(" seconds\nUltrasonic Threshold: ");
          Serial.println(ultrasonicThreshold);
          Serial.print("LDR Threshold: ");
          Serial.println(ldrThreshold);
          Serial.println("------------------------");

          printSubmenu(submenuCurrentOption);
          subSubmenuCurrentOption = -1;
          break;
        case DISPLAY_LOGGED_DATA:
          displayLoggedData();
          subSubmenuCurrentOption = -1;
          printSubmenu(submenuCurrentOption);
          break;
        case SYSTEM_STATUS_BACK:  // Back to Main Menu
          submenuCurrentOption = -1;
          subSubmenuCurrentOption = -1;
          printMenu();
          break;
        default:
          subSubmenuCurrentOption = -1;
          Serial.println("Invalid option!");
      }
      break;
    case RGB_LED_CONTROL:
      subSubmenuCurrentOption = option;
      switch (option) {
        case MANUAL_COLOR_CONTROL:
          if (!automaticLEDMode) {
            redLEDValue = -1;
            greenLEDValue = -1;
            blueLEDValue = -1;
            Serial.println("Manual Color Control selected. Input red LED value (0 - 255)");
          } else {
            Serial.println("Automatic LED Mode is set to ON. Disable it first!");
            subSubmenuCurrentOption = -1;
            printSubmenu(submenuCurrentOption);
          }
          break;
        case LED_AUTOMATIC_TOGGLE:
          Serial.println("LED: Toggle Automatic ON/OFF selected");
          if (automaticLEDMode) {
            automaticLEDMode = false;
            if (redLEDValue != -1 && greenLEDValue != -1 && blueLEDValue != -1) {
              setLEDColor(redLEDValue, greenLEDValue, blueLEDValue);
            } else {
              setLEDColor(0, 0, 0);
            }
            Serial.println("Automatic LED mode is set to OFF");
          } else {
            automaticLEDMode = true;
            updateLEDColor();
            Serial.println("Automatic LED mode is set to ON");
          }
          subSubmenuCurrentOption = -1;
          printSubmenu(submenuCurrentOption);
          break;
        case RGB_LED_CONTROL_BACK:  // Back to Main Menu
          submenuCurrentOption = -1;
          subSubmenuCurrentOption = -1;
          printMenu();
          break;
        default:
          subSubmenuCurrentOption = -1;
          Serial.println("Invalid option!");
      }
      break;
    default:
      // Handles any choices outside the defined options
      Serial.println("Invalid option!");
  }
}

void handleSubSubmenuChoice(int submenu, int subSubmenu, int option) {
  // Function to handle the user's subsubmenu choice
  // Similar to handleSubmenuChoice but for a deeper submenu level
  switch (submenu) {
    case SENSOR_SETTINGS:
      switch (subSubmenu) {
        case 1:
          if (option >= 1 && option <= 10) {
            sensorsSamplingInterval = option;
            Serial.print("Sensors Sampling Interval changed to ");
            Serial.print(option);
            Serial.println(" seconds.");
            subSubmenuCurrentOption = -1;
            printSubmenu(submenuCurrentOption);
          } else {
            Serial.println("Invalid Sensors Sampling Interval (1 - 10)");
          }
          break;
        case 2:
          ultrasonicThreshold = option;
          if (option >= 0) {
            Serial.print("Ultrasonic Threshold changed to ");
            Serial.println(option);
            subSubmenuCurrentOption = -1;
            printSubmenu(submenuCurrentOption);
          } else {
            Serial.println("Invalid Ultrasonic Threshold. Must be a positive integer.");
          }
          break;
        case 3:
          ldrThreshold = option;
          if (option >= 0) {
            Serial.print("LDR Threshold changed to ");
            Serial.println(option);
            subSubmenuCurrentOption = -1;
            printSubmenu(submenuCurrentOption);
          } else {
            Serial.println("Invalid LDR Threshold. Must be a positive integer.");
          }
          break;
        default:
          subSubmenuCurrentOption = -1;
          Serial.println("The selected option is outside the scope of the menu.");
      }
      break;
    case SYSTEM_STATUS:
      switch (subSubmenu) {
        case 1:
          if (option == 1) {
            printCurrentSensorsReadings = false;
            subSubmenuCurrentOption = -1;
            printSubmenu(submenuCurrentOption);
          }
          break;
        case 3:
          Serial.println("Display Logged Data selected");
          break;
      }
      break;
    case RGB_LED_CONTROL:
      switch (subSubmenu) {
        case 1:
          if (redLEDValue == -1) {
            redLEDValue = option;
            Serial.println("Input a value for the green LED");
          } else if (greenLEDValue == -1) {
            greenLEDValue = option;
            Serial.println("Input a value for the blue LED");
          } else if (blueLEDValue == -1) {
            blueLEDValue = option;
            subSubmenuCurrentOption = -1;
            setLEDColor(redLEDValue, greenLEDValue, blueLEDValue);
            printSubmenu(submenuCurrentOption);
          }
          break;
      }
      break;
    default:
      subSubmenuCurrentOption = -1;
      Serial.println("Invalid option\n");
  }
}

void setLEDColor(int redValue, int greenValue, int blueValue) {
  analogWrite(redLEDPin, redValue);
  analogWrite(greenLEDPin, greenValue);
  analogWrite(blueLEDPin, blueValue);
}

void checkSensors() {
  // Function to read the sensor values at the defined interval
  if (millis() - lastSensorsSampleTime >= sensorsSamplingInterval * 1000) {
    lastSensorsSampleTime = millis();
    readSensors();
  }
}

void readSensors() {
  digitalWrite(trigPin, LOW);
  delayMicroseconds(TRIG_PIN_SEND_DELAY);
  // Sets the trigPin on HIGH state for 10 micro seconds
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(TRIG_PIN_WAIT_DELAY);
  digitalWrite(trigPin, LOW);
  duration = pulseIn(echoPin, HIGH);
  // Sound wave reflects from the obstacle, so to calculate the distance we
  // consider half of the distance traveled.
  distance = duration * SOUND_SPEED / 2;
  // Prints the distance on the Serial
  int ultrasonicValue = distance;
  int ldrValue = analogRead(photocellPin);

  if (printCurrentSensorsReadings) {
    Serial.print("Log Sensor Data - ultrasonic: ");
    Serial.print(ultrasonicValue);
    Serial.print(", LDR value: ");
    Serial.println(ldrValue);
  }

  lastUltrasonicValue = ultrasonicValue;
  lastLdrValue = ldrValue;
  logSensorData(ultrasonicValue, ldrValue);
}

void updateLEDColor() {
  // Function to update the LED color based on sensor values
  if (automaticLEDMode) {
    if (lastUltrasonicValue < ultrasonicThreshold || lastLdrValue < ldrThreshold) {
      setLEDColor(255, 0, 0);  // Red for alert
    } else {
      setLEDColor(0, 255, 0);  // Green for no alert
    }
  }
}

void logSensorData(int ultrasonicValue, int ldrValue) {
  // Function to log sensor data to EEPROM
  
  // Avoiding EEPROM wear, only log if values have changed
  EEPROM.put(eepromAddress, ultrasonicValue);
  eepromAddress += TWO_BYTES_SIZE;
  EEPROM.put(eepromAddress, ldrValue);
  eepromAddress += TWO_BYTES_SIZE;

  // Reset EEPROM address if we reach the end of
  // memory where the data was saved
  if (eepromAddress >= eepromSavedDataSize) {
    eepromAddress = 0;
  }
}

void displayLoggedData() {
  // Function to display logged sensor data from the EEPROM
  Serial.println("Logged data for the ultrasonic sensor:");
  int address = 0;
  int sensorValue = 0;
  while (address < eepromSavedDataSize) {
    EEPROM.get(address, sensorValue);
    Serial.print(sensorValue);
    Serial.print(" ");
    address += FOUR_BYTES_SIZE;
  }
  Serial.println("\nLogged data for the LDR sensor:");
  address = TWO_BYTES_SIZE;
  while (address < eepromSavedDataSize) {
    EEPROM.get(address, sensorValue);
    Serial.print(sensorValue);
    Serial.print(" ");
    address += FOUR_BYTES_SIZE;
  }
  Serial.println();
}

void resetLoggerData() {
  // Function to reset the data logged in EEPROM
  for (int addr = 0; addr < eepromSavedDataSize; addr++) {
    EEPROM.update(addr, 0);
  }
}