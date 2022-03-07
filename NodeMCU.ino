#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <Adafruit_MLX90614.h>

// Update HOST URL here

#define HOST "arjunpoudel122.com.np/"          

#define WIFI_SSID "Bodhisattva_2.4"            // WIFI SSID here                                   
#define WIFI_PASSWORD "CLB25F3B97"        // WIFI password here

// Declare global variables which will be uploaded to server

float temperture = 98.9;
int heartbeatrate = 80;
int spo2level = 98;

String sendval1, sendval2, postData;

Adafruit_MLX90614 mlx = Adafruit_MLX90614();

void setup() {     
  Serial.begin(115200); 
  Serial.println("Communication Started \n\n");  
  delay(1000);
  pinMode(LED_BUILTIN, OUTPUT);     // initialize built in led on the board

  // Wifi connection
  WiFi.mode(WIFI_STA);           
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);                                     //try to connect with wifi
  Serial.print("Connecting to ");
  Serial.print(WIFI_SSID);
  
  while (WiFi.status() != WL_CONNECTED) { 
      Serial.print(".");
      delay(500); 
  }
  
  Serial.println();
  Serial.print("Connected to ");
  Serial.println(WIFI_SSID);
  Serial.print("IP Address is : ");
  Serial.println(WiFi.localIP());    //print local IP address
  delay(1000);

  // MLX initialization
  Serial.begin("MLX90614 test");

  if(!mlx.begin()) {
    Serial.println("Error connecting to MLX sensor, check wiring");
  }
  Serial.print("Emissivity value: "); Serial.println(mlx.readEmissivity());
}


void loop() { 
  HTTPClient http;    // http object of clas HTTPClient
  float temperature = mlx.readObjectTempF();
  
  postData = "temperature=" + String(temperature) + "*F"; // + "&heartbeatrate=" + String(heartbeatrate)+"&spo2level="+String(spo2level);
  
  // We can post values to PHP files as  example.com/dbwrite.php?name1=val1&name2=val2&name3=val3
  // Hence created variable postDAta and stored our variables in it in desired format
  
  // Update Host URL here:-  
    
  http.begin("http://arjunpoudel122.com.np/insertdata.php");              // Connect to host where MySQL databse is hosted
  http.addHeader("Content-Type", "application/x-www-form-urlencoded");            //Specify content-type header 
  int httpCode = http.POST(postData);   // Send POST request to php file and store server response code in variable named httpCode
  
  // if connection eatablished then do this
  if (httpCode == 200) { Serial.println("Values uploaded successfully."); Serial.println(httpCode); 
  String webpage = http.getString();    // Get html webpage output and store it in a string
  Serial.println(webpage + "\n"); 
  }
  
  // if failed to connect then return and restart
  
  else { 
    Serial.println(httpCode); 
    Serial.println("Failed to upload values. \n"); 
    http.end(); 
    return; 
  }
  
  delay(500000); 
  digitalWrite(LED_BUILTIN, LOW);
  delay(3000);
  digitalWrite(LED_BUILTIN, HIGH);

}
