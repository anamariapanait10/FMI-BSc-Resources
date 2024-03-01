#include <QTRSensors.h>

// Motor control pins
const int MOTOR1_PIN_A = 6;
const int MOTOR1_PIN_B = 7;
const int MOTOR2_PIN_A = 5;
const int MOTOR2_PIN_B = 4;

// Motor enable pins
const int MOTOR1_ENABLE = 11;
const int MOTOR2_ENABLE = 10;

// Timing and speed constants
const int MOTORS_ACTIVE_INTERVAL = 270;
const int MOTOR_INACTIVE_DELAY = 100;
const int INITIAL_MOTOR_SPEED = 150;
const int MAX_MOTOR_SPEED = 255;
const int MIN_MOTOR_SPEED = -180;
const int BASE_MOTOR_SPEED = 230;

// PID controller constants and variables
const int PID_ERROR_THRESHOLD = 18;
const int PID_ERROR_RANGE_MIN = -50;
const int PID_ERROR_RANGE_MAX = 50;
float kp = 25;
float ki = 0;
float kd = 6;
int p = 0;
int i = 0;
int d = 0;
int error = 0;
int lastError = 0;

// Line sensor constants and variables
const int SENSOR_COUNT = 6;
int sensorValues[SENSOR_COUNT];
int sensors[SENSOR_COUNT] = { 0, 0, 0, 0, 0, 0 };
const int LINE_SENSOR_RANGE_MIN = 0;
const int LINE_SENSOR_RANGE_MAX = 5000;

// Calibration constants and variables
const int CALIBRATION_ITERATIONS = 400;
unsigned long lastMotorsActivation = 0;
unsigned long lastMotorsInactivation = 0;
bool shouldResumeMotorsSpeed = true;
int currentMotorsSpeed = INITIAL_MOTOR_SPEED;
int newMotorsSpeed;
int baseSpeed = BASE_MOTOR_SPEED;

int m1Speed = 0;
int m2Speed = 0;

QTRSensors qtr;

void setup() {
  // Initialize motor control pins
  pinMode(MOTOR1_PIN_A, OUTPUT);
  pinMode(MOTOR1_PIN_B, OUTPUT);
  pinMode(MOTOR2_PIN_A, OUTPUT);
  pinMode(MOTOR2_PIN_B, OUTPUT);
  pinMode(MOTOR1_ENABLE, OUTPUT);
  pinMode(MOTOR2_ENABLE, OUTPUT);

  // Initialize sensor array
  qtr.setTypeRC();
  qtr.setSensorPins((const uint8_t[]){ A0, A1, A2, A3, A4, A5 }, SENSOR_COUNT);
  delay(500);

  pinMode(LED_BUILTIN, OUTPUT);
  // Turn on Arduino's LED to indicate we are in calibration mode
  digitalWrite(LED_BUILTIN, HIGH);  
  // Calibrate the sensor
  calibrate();
  // Turn off Arduino's LED after calibration
  digitalWrite(LED_BUILTIN, LOW);
}

void loop() {
  pidControl();
  constrainMotorSpeed();
  setMotorSpeed(m1Speed, m2Speed);
}

// Autocalibrate the line sensor by moving the robot left and right
void calibrate() {
  for (uint16_t i = 0; i < CALIBRATION_ITERATIONS; i++) {
    qtr.calibrate();
    setMotorSpeed(-currentMotorsSpeed, currentMotorsSpeed);

    if (millis() - lastMotorsActivation >= MOTORS_ACTIVE_INTERVAL) {
      lastMotorsActivation = millis();
      // Stop the motors
      currentMotorsSpeed = 0;
      // Save the following motors speed and set it after a small interval
      newMotorsSpeed = -currentMotorsSpeed;
      // Reset the variables needed to start the waiting interval before setting the new motors speed
      lastMotorsInactivation = millis();
      shouldResumeMotorsSpeed = true; 
    }

    // Wait a small interval before chaging the motors directions
    if (millis() - lastMotorsInactivation > MOTOR_INACTIVE_DELAY && shouldResumeMotorsSpeed){
      shouldResumeMotorsSpeed = false;
      currentMotorsSpeed = newMotorsSpeed;
    }
  }
}

// Calculate PID value based on error, kp, kd, ki, p, i and d
// and adjust motor speeds
void pidControl() {
  int error = -map(qtr.readLineBlack(sensorValues), LINE_SENSOR_RANGE_MIN, LINE_SENSOR_RANGE_MAX, PID_ERROR_RANGE_MIN, PID_ERROR_RANGE_MAX);
  if(abs(error) < PID_ERROR_THRESHOLD) {
    error = 0;
  }
  p = error;
  i = i + error;
  d = error - lastError;
  int motorSpeed = kp * p + ki * i + kd * d;  // = error in this case
  m1Speed = baseSpeed;
  m2Speed = baseSpeed;

  // Adjust motor speeds based on PID control
  if (error < 0) {
    m1Speed += motorSpeed;
  } else if (error > 0) {
    m2Speed -= motorSpeed;
  }
}

// Constrain motor speeds to the set limits
void constrainMotorSpeed(){
  m1Speed = constrain(m1Speed, MIN_MOTOR_SPEED, MAX_MOTOR_SPEED);
  m2Speed = constrain(m2Speed, MIN_MOTOR_SPEED, MAX_MOTOR_SPEED);
}

// Each arguments takes values between -255 and 255. The negative values represent the motor speed
void setMotorSpeed(int motor1Speed, int motor2Speed) {
  // Control motor 1
  if (motor1Speed == 0) {
    digitalWrite(MOTOR1_PIN_A, LOW);
    digitalWrite(MOTOR1_PIN_B, LOW);
  } else {
    digitalWrite(MOTOR1_PIN_A, motor1Speed > 0);
    digitalWrite(MOTOR1_PIN_B, motor1Speed < 0);
  }
  analogWrite(MOTOR1_ENABLE, abs(motor1Speed));

  // Control motor 2
  if (motor2Speed == 0) {
    digitalWrite(MOTOR2_PIN_A, LOW);
    digitalWrite(MOTOR2_PIN_B, LOW);
  } else {
    digitalWrite(MOTOR2_PIN_A, motor2Speed > 0);
    digitalWrite(MOTOR2_PIN_B, motor2Speed < 0);
  }
  analogWrite(MOTOR2_ENABLE, abs(motor2Speed));
}
