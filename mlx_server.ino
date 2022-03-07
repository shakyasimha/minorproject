#include <Adafruit_MLX90614.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>

#define HOST "arjunpoudel122.com.np/"
#define WIFI_SSID "Bodhisattva_2.4"
#define WIFI_PASS "CLB25F3B97"

// Variables defined here
Adafruit_MLX90614 mlx = Adafruit_MLX90614();
HTTPClient http;
float temp_C, temp_F, heart_rate;
int spo2_level;
int httpCode;
String postData, webpage;

// Setup function set up here
void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);
  Serial.println("Serial communication started");

  // Establishing wifi connection
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASS);

  Serial.print("Connecting to ");
  Serial.println(WIFI_SSID);

  while(WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }

  if(WiFi.status() != WL_CONNECTED) {
    Serial.print("Failed to connect to");
    Serial.println(WIFI_SSID);
  }
  else {
    Serial.print("Successfully connected to ");
    Serial.println(WIFI_SSID);
    Serial.print("IP Address is ");
    Serial.println(WiFi.localIP());
    Serial.println();
    delay(100);
  }

  // Initializing mlx90614
  if(!mlx.begin()) {
    Serial.println("Error initializing MLX90614, check wiring");
    delay(100);  
  }
  else {
    Serial.println("Successfully initialized MLX90614");
    delay(100);
  }
}

// Loop function starts here
void loop() {  
  temp_C = mlx.readObjectTempC();
  temp_F = mlx.readObjectTempF();
  postData = "temperature=" + String(temp_F) + "&heartbeatrate=" + String(heart_rate)+"&spo2level="+String(spo2_level);
  
  Serial.print("Body temperature: "); Serial.print(temp_C); Serial.print("*C, "); Serial.print(temp_F); Serial.println("*F");

  // Starting HTTP POST
  http.begin("http://arjunpoudel122.com.np/insertdata.php");
  http.addHeader("Content-Type", "application/x-www-form-urlencoded");
  httpCode = http.POST(postData);

  if(httpCode = 200) {
    Serial.println("Values uploaded successfully");
    Serial.println(httpCode);
    webpage = http.getString();     // Gets html webpage output and stores it in string
    Serial.println(webpage + "\n");
  }
  else {
    Serial.println(httpCode);
    Serial.println("Failed to send data");
    http.end();
    return;
  }

  delay(2000);
}
