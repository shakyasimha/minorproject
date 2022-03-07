#include <SPI.h>
#include <Adafruit_PCD8544.h>
#include <Adafruit_GFX.h>
#include <Adafruit_MLX90614.h>

// Using hardware SPI
// MOSI = DIN (D7 on ESP8266) 
// CLK  = CLK (D5 on ESP8266)
// Rest of the pins are as follows
// RST = D3 = 0
// CE  = D8 = 5
// DC  = D4 = 2
// Adafruit_PCD8544(DC, CE, RST)
Adafruit_PCD8544 display = Adafruit_PCD8544(D4, D8, D3);

// MLX sensor
Adafruit_MLX90614 mlx = Adafruit_MLX90614();

// Initializing variables
float temp_C = 0, temp_F = 0;
String error_msg = "MLX90614 failed to initialize";
String success_msg = "MLX90614 initialized successfully";

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);

  display.begin(); // Initializing display
  display.setContrast(50);

  //display.display();  // Shows splashscreen
  //delay(2000);
  //display.clearDisplay();

  display.setTextSize(1);
  display.setTextColor(BLACK);
  display.setCursor(0,0);
  display.print("Initializing MLX90614");
  display.display();

  display.setCursor(1,0);
  while(1) {
    display.print(".");
    display.display();
    delay(1000);
    display.clearScreen();
    
    if(!mlx.begin()) {
      display.clearScreen();
      Serial.println(error_msg);
      display.print(error_msg);
      display.display();
      delay(2000);
      display.clearScreen();
      break;
    }
    else {
      display.clearScreen();
      Serial.println(success_msg);
      display.print(success_msg);
      display.display();
      delay(2000);
      display.clearScreen();
    }
  }

  display.setTextSize(1);
  display.setTextColor(BLACK, WHITE);
  display.setCursor(0,0);
  display.print("Temperature");
  display.display();
}

void loop() {
  // put your main code here, to run repeatedly:
  temp_C = mlx.readObjectTempC();
  temp_F = mlx.readObjectTempF();

  display.setCursor(1,0);
  Serial.print(temp_C); Serial.println("*C");
  display.println(temp_C + "*C");
  display.display();
  Serial.print(temp_F); Serial.println("*F");
  display.println(temp_F + "*F");
  display.display();

  delay(5000);
}
