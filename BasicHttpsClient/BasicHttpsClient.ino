/**
   BasicHTTPSClient.ino
    Created on: 20.08.2018

*/

#include <Arduino.h>

#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>

#include <ESP8266HTTPClient.h>

#include <WiFiClientSecureBearSSL.h>

#define WIFI_SSID "Bodhisattva_2.4"
#define WIFI_PASS "CLB25F3B97"

// Fingerprint for demo URL, expires on June 2, 2021, needs to be updated well before this date
const uint8_t fingerprint[20] = {0x93, 0x96, 0xcb, 0x76, 0xa7, 0xf0, 0xff, 0x74,0xe3, 0xc9, 0xd0, 0xaf ,0xc3 ,0x50, 0x3b, 0x6a, 0x05, 0xb4, 0x44, 0xdc};

ESP8266WiFiMulti WiFiMulti;

int temp_F, heartRate, spo2;

void setup() {

  Serial.begin(9600);
  // Serial.setDebugOutput(true);

  Serial.println();
  Serial.println();
  Serial.println();

  for (uint8_t t = 4; t > 0; t--) {
    Serial.printf("[SETUP] WAIT %d...\n", t);
    Serial.flush();
    delay(1000);
  }

  WiFi.mode(WIFI_STA);
  WiFiMulti.addAP(WIFI_SSID, WIFI_PASS);
}

void loop() {
  
  // wait for WiFi connection
  if ((WiFiMulti.run() == WL_CONNECTED)) {

    std::unique_ptr<BearSSL::WiFiClientSecure>client(new BearSSL::WiFiClientSecure);

    client->setFingerprint(fingerprint);
    // Or, if you happy to ignore the SSL certificate, then use the following line instead:
    // client->setInsecure();

    HTTPClient https;

    Serial.print("[HTTPS] begin...\n");
    if (https.begin(*client, "https://arjunpoudel122.com.np/inserthrnspo3.php")) {  // HTTPS

      Serial.print("[HTTPS] GET...\n");

      String postData = "temperature=" + String(temp_F) + "&heartrate=" + String(heartRate) + "&spo02level=" + String(spo2);
      
      // start connection and send HTTP header
    https.addHeader("Content-Type", "application/x-www-form-urlencoded");

      int httpCode = https.POST("temperature=45&heartrate=455&spo2level=34"); //POST(postData);

      // httpCode will be negative on error
      if (httpCode > 0) {
        // HTTP header has been send and Server response header has been handled
        Serial.printf("[HTTPS] GET... code: %d\n", httpCode);

        // file found at server
        if (httpCode == HTTP_CODE_OK || httpCode == HTTP_CODE_MOVED_PERMANENTLY) {
          String payload = https.getString();
          Serial.println(payload);
        }
      } else {
        Serial.printf("[HTTPS] GET... failed, error: %s\n", https.errorToString(httpCode).c_str());
      }

      https.end();
    } else {
      Serial.printf("[HTTPS] Unable to connect\n");
    }
  }

  //Serial.println("Wait 10s before next round...");
  //delay(1000000);
}
