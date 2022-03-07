#include <Wire.h>
#include <Adafruit_MLX90614.h>
#include "MAX30100_PulseOximeter.h"

#define REPORTING_PERIOD_MS 1000
// Variables defined here
Adafruit_MLX90614 mlx = Adafruit_MLX90614();
PulseOximeter pox;
uint32_t tsLastReport = 0;
float heartRate, temp_C, temp_F;
int spO2;

void onBeatDetected() {
  Serial.println("Beat!");
}

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  while(!Serial);

  // Initializing oximeter
  if(!pox.begin()) {
    Serial.println("Failed to initialize MAX30100");
  }
  else {
    Serial.println("MAX30100 initialized successfully");
  }

  // Initializing thermometer
  if(!mlx.begin()) {
    Serial.println("Failed to initialize MLX90614");
  }
  else {
    Serial.println("MLX90614 initialized successfully");
    Serial.print("Emissivity: "); Serial.println(mlx.readEmissivity());
  }

  pox.setOnBeatDetectedCallback(onBeatDetected);
}

void loop() {
  // put your main code here, to run repeatedly:

  // Oximeter reading
  pox.update();

  // Asynchronously dump heart rate and oxidation levels to the serial
  // For both, a value of 0 means "invalid"
  if (millis() - tsLastReport > REPORTING_PERIOD_MS) {
      heartRate = pox.getHeartRate();
      spO2 = pox.getSpO2();

      tsLastReport = millis();
  }

  // Reading from thermometer
  temp_C = mlx.readObjectTempC();
  temp_F = mlx.readObjectTempF();

  // Printing data to serial monitor
  Serial.print("Heart rate: "); Serial.print(heartRate); Serial.print("\tSpO2: "); Serial.println(spO2);
  Serial.print("Temperature: "); Serial.print(temp_C); Serial.print("*C\t"); Serial.print(temp_F); Serial.println("*F"); 

  delay(1000);
}
