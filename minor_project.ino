#include <Arduino.h>
#include <SPI.h>
#include <Wire.h>
#include <Adafruit_MLX90614.h>
#include <Adafruit_GFX.h>
#include <Adafruit_PCD8544.h>
#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClientSecureBearSSL.h>

// Defining pins for LCD
#define SCLK D8
#define DIN D4
#define DC D5
#define CS D6
#define RST D7

// oximeter parameters
#define maxperiod_siz 80 // max number of samples in a period
#define measures 10      // number of periods stored
#define samp_siz 4       // number of samples for average
#define rise_threshold 3 // number of rising measures to determine a peak

// Define SSID and Password
#define WIFI_SSID "Bodhisattva_2.4"
#define WIFI_PASS "CLB25F3B97"

// Objects defined here
Adafruit_MLX90614 mlx = Adafruit_MLX90614();
Adafruit_PCD8544 lcd = Adafruit_PCD8544(SCLK, DIN, DC, CS, RST);
ESP8266WiFiMulti WiFiMulti;

// Parameters for temperature and data
int temp_C = 0, temp_F = 0;
String postData;
int counter = 0;

int T = 20;              // slot milliseconds to read a value from the sensor
int sensorPin = A0; 
int REDLed = D3;
int IRLed = D0;

// Fingerprint for backend server
const uint8_t fingerprint[20] = {0x93, 0x96, 0xcb, 0x76, 0xa7, 0xf0, 0xff, 0x74,0xe3, 0xc9, 0xd0, 0xaf ,0xc3 ,0x50, 0x3b, 0x6a, 0x05, 0xb4, 0x44, 0xdc};

// Wifi connection
void connectNetwork() {
  for (uint8_t t = 4; t > 0; t--) {
    Serial.printf("[SETUP] WAIT %d...\n", t);
    Serial.flush();
    delay(1000);
  }

  WiFi.mode(WIFI_STA);
  WiFiMulti.addAP(WIFI_SSID, WIFI_PASS);

  while(WiFiMulti.run() != WL_CONNECTED) {
    lcd.clearDisplay();
    lcd.setCursor(0,0);
    lcd.print("Connecting...");
    lcd.display();
    delay(1000);
  }
  
  lcd.clearDisplay();
  lcd.setCursor(0,0);
  lcd.print("Connected to");
  lcd.display();
  lcd.setCursor(0,8);
  lcd.print(WiFi.SSID());
  lcd.display();
  lcd.setCursor(0,24);
  lcd.setTextSize(1);
  lcd.print(WiFi.localIP());
  lcd.display();
  delay(10000);
  lcd.clearDisplay();
}

// Sending data to the server
void sendPostRequest(String fileName, String postData) {
  
    std::unique_ptr<BearSSL::WiFiClientSecure>client(new BearSSL::WiFiClientSecure);
    client->setFingerprint(fingerprint);
    
    HTTPClient https;

    Serial.print("[HTTPS] begin...\n");
    if (https.begin(*client, "https://arjunpoudel122.com.np/" + fileName)) {  // HTTPS

      Serial.print("[HTTPS] GET...\n");
      
      // start connection and send HTTP header
      https.addHeader("Content-Type", "application/x-www-form-urlencoded");

      int httpCode = https.POST(postData); 
      
      // httpCode will be negative on error
      if (httpCode > 0) {
        // HTTP header has been send and Server response header has been handled
        ++counter;
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

// Initializing oximeter function
void initializeOximeter() {
   pinMode(sensorPin,INPUT);
   pinMode(REDLed,OUTPUT);
   pinMode(IRLed,OUTPUT);

   // turn off leds
   digitalWrite(REDLed,LOW);
   digitalWrite(IRLed,LOW);
}

void displayTemperature(int temp_C, int temp_F) {
  
  Serial.print(temp_C); Serial.println("*C");
  Serial.print(temp_F); Serial.println("*F");

  lcd.setCursor(0,0);
  lcd.print(temp_F);
  lcd.display();
  lcd.setCursor(32,0);
  lcd.print("*F");
  lcd.setCursor(0,8);
  lcd.print(temp_C);
  lcd.display();
  lcd.setCursor(32,8);
  lcd.print("*C");
  lcd.display();
  lcd.clearDisplay();
}

void displayOximeter(int avBPM, int SpO2, int c, double avR) {
    if(c != -1) {
        if(c >=3) {
         lcd.setCursor(0,20);
         lcd.print(avBPM);
         lcd.display();
         lcd.setCursor(32,20);
         lcd.print("bpm");
         lcd.display();
         lcd.setCursor(50,20);
         lcd.print("c: ");
         lcd.display();
         lcd.setCursor(64,20);
         lcd.print(c);
         lcd.display();
      
         // SpO2 reading
         lcd.setCursor(0,36);
         lcd.print(SpO2);
         lcd.display();
         lcd.setCursor(32,36);
         lcd.print("%");
         lcd.display();
         lcd.setCursor(50,36);
         lcd.print("R: ");
         lcd.display();
         lcd.setCursor(64,36);
         lcd.print(avR);
         lcd.display(); 
      }
      else if(c >=0 && c < 3) {
         lcd.setCursor(0,20);
         lcd.print("Calculating....");
         
         lcd.display();
         lcd.setCursor(0,36);
         lcd.print("c: ");
         lcd.display();
         lcd.setCursor(32,36);
         lcd.print(c);
         lcd.display();
         lcd.setCursor(0,52);
         lcd.print("R: ");
         lcd.display();
         lcd.setCursor(32,52);
         lcd.print(avR);
         lcd.display();
      }
   }
   else {
      lcd.setCursor(0,32);
      lcd.print("FINGER OUT");
      lcd.display();
       
   }
}

// Setup starts here
void setup() {
  // put your setup code here, to run once:
   Serial.begin(9600);
   Serial.flush();

   // Initialize lcd
   lcd.begin();
   lcd.setContrast(90);
   lcd.clearDisplay();
   
   // Establish connection
   connectNetwork();

   // Initialize oximeter
   
   initializeOximeter();

   // Initializing mlx
   if(!mlx.begin()) {
      Serial.print("MLX90614 failed to initialize");
   }
   else {
      Serial.print("MLX90614 initialized successfully!");
   }
}

void loop() {
  // put your main code here, to run repeatedly:
  // Oximeter code starts here
  bool finger_status = true;
  
  float readsIR[samp_siz], sumIR,lastIR, reader, start;
  float readsRED[samp_siz], sumRED,lastRED;


  int period, samples;
  period=0; samples=0;
  int samplesCounter = 0;
  float readsIRMM[maxperiod_siz],readsREDMM[maxperiod_siz];
  int ptrMM =0;
  for (int i = 0; i < maxperiod_siz; i++) { readsIRMM[i] = 0;readsREDMM[i]=0;}
  float IRmax=0;
  float IRmin=0;
  float REDmax=0;
  float REDmin=0;
  double R=0;
  int SpO2,avBPM,avR;
  float measuresR[measures];
  int measuresPeriods[measures];
  int m = 0;
  for (int i = 0; i < measures; i++) { measuresPeriods[i]=0; measuresR[i]=0; }
   
  int ptr;

  float beforeIR;

  bool rising;
  int rise_count;
  int n,c;
  long int last_beat;
  for (int i = 0; i < samp_siz; i++) { readsIR[i] = 0; readsRED[i]=0; }
  sumIR = 0; sumRED=0; 
  ptr = 0; 
    
  
  // Data reading loop starts here
  while(1)
  {     
    // Reading body temperature
    temp_C = mlx.readObjectTempC();
    temp_F = mlx.readObjectTempF();
    displayTemperature(temp_C, temp_F);

    if(temp_F > 90 && temp_F < 110 && counter <= 2) {
        postData = "temperature=" + String(temp_F);
        sendPostRequest("inserttempr.php", postData);
        Serial.println("Function called");
        Serial.println(counter);
     }

    // Oximeter reading starts here
    // turn on IR LED
    digitalWrite(REDLed,LOW);
    digitalWrite(IRLed,HIGH);
    
    // calculate an average of the sensor
    // during a 20 ms (T) period (this will eliminate
    // the 50 Hz noise caused by electric light
    n = 0;
    start = millis();
    reader = 0.;
    do
    {
      reader += analogRead (sensorPin);
      n++;
          yield();

    }
    while (millis() < start + T);  
    reader /= n;  // we got an average
    // Add the newest measurement to an array
    // and subtract the oldest measurement from the array
    // to maintain a sum of last measurements
    sumIR -= readsIR[ptr];
    sumIR += reader;
    readsIR[ptr] = reader;
    lastIR = sumIR / samp_siz;

    
    
    

    //
    // TURN ON RED LED and do the same
    
    digitalWrite(REDLed,HIGH);
    digitalWrite(IRLed,LOW);

    n = 0;
    start = millis();
    reader = 0.;
    do
    {
      reader += analogRead (sensorPin);
      n++;
          yield();

    }
    while (millis() < start + T);  
    reader /= n;  // we got an average
    // Add the newest measurement to an array
    // and subtract the oldest measurement from the array
    // to maintain a sum of last measurements
    sumRED -= readsRED[ptr];
    sumRED += reader;
    readsRED[ptr] = reader;
    lastRED = sumRED / samp_siz;


    //                                  
    // R CALCULATION
    // save all the samples of a period both for IR and for RED
    readsIRMM[ptrMM]=lastIR;
    readsREDMM[ptrMM]=lastRED;
    ptrMM++;
    ptrMM %= maxperiod_siz;
    samplesCounter++;
    //
    // if I've saved all the samples of a period, look to find
    // max and min values and calculate R parameter
    if(samplesCounter>=samples){
      samplesCounter =0;
      IRmax = 0; IRmin=1023; REDmax = 0; REDmin=1023;
      for(int i=0;i<maxperiod_siz;i++) {
        if( readsIRMM[i]> IRmax) IRmax = readsIRMM[i];
        if( readsIRMM[i]>0 && readsIRMM[i]< IRmin ) IRmin = readsIRMM[i];
        readsIRMM[i] =0;
        if( readsREDMM[i]> REDmax) REDmax = readsREDMM[i];
        if( readsREDMM[i]>0 && readsREDMM[i]< REDmin ) REDmin = readsREDMM[i];
        readsREDMM[i] =0;
            yield();

      }
      R =  ( (REDmax-REDmin) / REDmin) / ( (IRmax-IRmin) / IRmin ) ;
    }
 

    if(lastIR>500){
           if (lastIR > beforeIR)
           {
     
             rise_count++;  // count the number of samples that are rising
             if (!rising && rise_count > rise_threshold)
             {
               //lcd.setCursor(3,0); 
               //lcd.write( 0 );       // <3
                // Ok, we have detected a rising curve, which implies a heartbeat.
                // Record the time since last beat, keep track of the 10 previous
                // peaks to get an average value.
                // The rising flag prevents us from detecting the same rise 
                // more than once. 
                rising = true;
    
                measuresR[m] = R;
                measuresPeriods[m] = millis() - last_beat;
                last_beat = millis();
                int period = 0;
                for(int i =0; i<measures; i++) period += measuresPeriods[i];
    
                // calculate average period and number of samples
                // to store to find min and max values
                period = period / measures;
                samples = period / (2*T);
                  
                 int avPeriod = 0;
    
                c = 0;
                // c stores the number of good measures (not floating more than 10%),
                // in the last 10 peaks
                for(int i =1; i<measures; i++) {
                  if ( (measuresPeriods[i] <  measuresPeriods[i-1] * 1.1)  &&  
                        (measuresPeriods[i] >  measuresPeriods[i-1] / 1.1)  ) {
                      yield();
    
                      c++;
                      avPeriod += measuresPeriods[i];
                      avR += measuresR[i];
    
                  }
                }
                  
                m++;
                m %= measures;
                
                Serial.println("c: "+String(c)+", avperiods: "+avPeriod+", lastIR: "+String(lastIR)+", lastRED: "+String(lastRED));
                if(c==0) lcd.print("    "); else lcd.print("avr: "+String(avR) + " ");
                

                // if there are at least 5 good measures...
                if(c >= 3) {
                // bpm and R shown are calculated as the
                // average of at least 5 good peaks
                avBPM = 60000 / ( avPeriod / c) ;
                avR = avR / c ;
                  //
                  // SATURTION IS A FUNCTION OF R (calibration)
                  // Y = k*x + m
                  // k and m are calculated with another oximeter
                  SpO2 = -19 * R + 100;

                   // Displaying Heart rate and SpO2
                   // Heart rate reading
                   Serial.print(String(avBPM)+" ");
                   Serial.print( " " + String(SpO2) +"% "+", R: "+avR); 

                   if((avBPM > 50 && avBPM < 220) && (SpO2 < 100 && SpO2 >= 80) && counter <= 2) {
                      postData = "temperature=" + String(mlx.readObjectTempF()) + "&heartrate=" + String(avBPM) + "&spoM2level=" + String(SpO2);
                      sendPostRequest("inserthrnspo3.php", postData);
                      Serial.println("Function called");
                      Serial.println(counter);
                   }
                }
             }
           }
           else
           {
             // Ok, the curve is falling
             rising = false;
             rise_count = 0;
             //lcd.setCursor(3,0);lcd.print(" ");
           }
           displayOximeter(avBPM, SpO2, c, R);   
    }
    else{
       Serial.println("Finger OUT");
       displayOximeter(0,0,-1,R);
    }
  
       // to compare it with the new value and find peaks
       beforeIR = lastIR;
 
   // handle the arrays      
   ptr++;
   ptr %= samp_siz;
      
  } // loop while 1
 
  lcd.clearDisplay();
}
