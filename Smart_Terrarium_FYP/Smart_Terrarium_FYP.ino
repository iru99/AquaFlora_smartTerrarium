/*
  Project Title: Final Year Project 1
  Platform: ESP32
  Author: Tharindu Irushan Bandara
  Student ID: 1106202002
  
  Description:
  This code establishes a connection between an ESP32 board and both Node-RED and Firebase.
  
  References:
  - https://github.com/knolleary/pubsubclient (Pubsubclient - github)
  - https://github.com/topics/callback (Callback - github)
  
  Note: 
  1. ESP32, nodered and firebase are used for smart terrarium. Soil moisture, DHT22 and TSL2561, Ultrasonic sensor are used as sensors. Peristaltic pump, water pump, DC fan,
     LED strip and mist maker are used as actuators. All the actuators are connected to the 8 channel relay module.
*/
//-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#include <DHT.h>
#include <Wire.h>
#include <WiFi.h>
#include <PubSubClient.h>

#define DHTPIN 15           // DHT22 sensor data pin (change to your pin)
#define DHTTYPE DHT22       // DHT22 sensor type
#define BH1750_ADDR 0x23    // I2C address of BH1750
#define BH1750_ONE_TIME_H_RES_MODE 0x20   // Command for one-time high-resolution mode

const int moisturePin = 32; // GPIO pin 14 connected to the moisture sensor
int ldrPin = 32;            // A0 pin on ESP32 for LDR sensor
#define RELAY_PIN_1 25      // Relay IN1 connected to pin GPIO 25 for DC fan
#define RELAY_PIN_2 26      // Relay IN2 connected to pin GPIO 26 for LED light
#define RELAY_PIN_3 27      // Relay IN3 connected to pin GPIO 27 for peristaltic pump
#define RELAY_PIN_4 33      // Relay IN4 connected to pin GPIO 33 for humidifier

int lightThreshold = 50;          // Threshold for light
float temperatureThreshold = 31.0; // Threshold for humidity
float moistureThreshold = 60.00;   // Threshold
float humidityThreshold = 90.00;   // Threshold

bool isAutoMode = false;    // Initially set to Manual Mode
bool updateRequested = false;// Flag to indicate update request

DHT dht(DHTPIN, DHTTYPE);
WiFiClient espClient;
PubSubClient client(espClient);
//BH1750 lightMeter; // Initialize BH1750 sensor

const char* ssid = "S";      // WiFi SSID
const char* password = "Silvia0946";  // WiFi password
const char* mqtt_server = "172.20.10.4"; // MQTT broker IP address
const int mqtt_port = 1883; // MQTT broker port

// MQTT Topics
const char* mqtt_topic_auto_mode = "control/auto_mode";
const char* mqtt_topic_control_fan = "control/fan";
const char* mqtt_topic_control_light = "control/light";
const char* mqtt_topic_control_pump = "control/pump";
const char* mqtt_topic_sensor_readings = "sensor/readings";
const char* mqtt_topic_control_humidifier = "control/humidifier"; 
const char* mqtt_topic_update = "control/update";

void callback(char* topic, byte* payload, unsigned int length) {
  // Handle MQTT messages
  String message = "";
  for (int i = 0; i < length; i++) {
    message += (char)payload[i];
  }

  if (strcmp(topic, mqtt_topic_auto_mode) == 0) {
    if (message == "1") {
      isAutoMode = true;
      Serial.println("Switched to Auto Mode");
    } else if (message == "0") {
      isAutoMode = false;
      Serial.println("Switched to Manual Mode");

      // Turn off all actuators when switching to manual mode
      digitalWrite(RELAY_PIN_1, LOW); // Fan off
      digitalWrite(RELAY_PIN_2, LOW); // Light off
      digitalWrite(RELAY_PIN_3, LOW); // Pump off
      digitalWrite(RELAY_PIN_4, LOW); // MIST off
      Serial.println("All actuators turned OFF");
    }
  } else if (!isAutoMode) {
    if (strcmp(topic, mqtt_topic_control_fan) == 0) {
      // Control fan based on MQTT message
      if (message == "1") {
        digitalWrite(RELAY_PIN_1, HIGH);
        Serial.println("Fan turned ON");
      } else if (message == "0") {
        digitalWrite(RELAY_PIN_1, LOW);
        Serial.println("Fan turned OFF");
      }
    } else if (strcmp(topic, mqtt_topic_control_light) == 0) {
      // Control light based on MQTT message
      if (message == "1") {
        digitalWrite(RELAY_PIN_2, HIGH);
        Serial.println("Light turned ON");
      } else if (message == "0") {
        digitalWrite(RELAY_PIN_2, LOW);
        Serial.println("Light turned OFF");
      }
    } else if (strcmp(topic, mqtt_topic_control_pump) == 0) {
      // Control pump based on MQTT message
      if (message == "1") {
        digitalWrite(RELAY_PIN_3, HIGH);
        Serial.println("Pump turned ON");
      } else if (message == "0") {
        digitalWrite(RELAY_PIN_3, LOW);
        Serial.println("Pump turned OFF");
      }
    } else if (strcmp(topic, mqtt_topic_update) == 0) {
      // Process update request
      if (message == "1") {
        updateRequested = true;
        Serial.println("Update Requested");
      }
    }
    else if (strcmp(topic, mqtt_topic_control_humidifier) == 0) {
      // Control humidifier based on MQTT message
      if (message == "1") {
        digitalWrite(RELAY_PIN_4, HIGH);
        Serial.println("Humidifier turned ON");
      } else if (message == "0") {
        digitalWrite(RELAY_PIN_4, LOW);
        Serial.println("Humidifier turned OFF");
      }
    }
  }
}

void setup_wifi() {
  // Connect to Wi-Fi
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.println("Connecting to WiFi...");
  }
  Serial.println("Connected to WiFi");
}

void reconnect() {
  // Reconnect to MQTT broker
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
      if (client.connect("ESP32Client")) {
    Serial.println("connected");
    client.subscribe(mqtt_topic_auto_mode);
    client.subscribe(mqtt_topic_control_fan);
    client.subscribe(mqtt_topic_control_light);
    client.subscribe(mqtt_topic_control_pump);
    client.subscribe(mqtt_topic_control_humidifier); 
    client.subscribe(mqtt_topic_update);
    client.subscribe(mqtt_topic_sensor_readings);
  } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

void setup() {
  //pinMode(moisturePin, INPUT);
  pinMode(ldrPin, INPUT);
  Serial.begin(9600);
  dht.begin();
  Wire.begin();

  pinMode(RELAY_PIN_1, OUTPUT);
  pinMode(RELAY_PIN_2, OUTPUT);
  pinMode(RELAY_PIN_3, OUTPUT);
  pinMode(RELAY_PIN_4, OUTPUT);
  digitalWrite(RELAY_PIN_1, LOW);
  digitalWrite(RELAY_PIN_2, LOW);
  digitalWrite(RELAY_PIN_3, LOW);
  digitalWrite(RELAY_PIN_4, LOW);

  setup_wifi();
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
}

int readLightSensor() {
  Wire.beginTransmission(BH1750_ADDR);
  Wire.write(BH1750_ONE_TIME_H_RES_MODE); // Set one-time high-resolution mode
  Wire.endTransmission();
  delay(180); // Delay according to sensor's measurement time

  Wire.requestFrom(BH1750_ADDR, 2);
  if (Wire.available() == 2) {
    int val = Wire.read() << 8 | Wire.read();
    return val;
  }
  return -1; // Return an error value if reading failed
}

void publishSensorReadings() {
  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();
  int moistureLevel = analogRead(moisturePin);

  /// Convert analog value to percentage (adjust these values based on your sensor)
  int moisturePercentage = map(moistureLevel, 4095, 0, 75, 0); // Change the upper limit to 4095 if required

  int lightSensorValue = readLightSensor(); // Read light level from BH1750 sensor

  Serial.print("Moisture Level (%): ");
  Serial.println(moisturePercentage);
  Serial.print("Temperature (C): ");
  Serial.println(temperature);
  Serial.print("Humidity (%): ");
  Serial.println(humidity);
  Serial.print("Light value: ");
  Serial.println(lightSensorValue);

  if (updateRequested || isAutoMode) {
    if (isAutoMode) {
      // Control actions based on thresholds when in Auto Mode
      if (moisturePercentage > moistureThreshold) {
        digitalWrite(RELAY_PIN_3, HIGH);  // Turn on pump if moisture exceeds threshold
        Serial.println("Pump turned ON");
      } else {
        digitalWrite(RELAY_PIN_3, LOW);
        Serial.println("Pump turned OFF");
      }

      if (lightSensorValue < lightThreshold) {
        digitalWrite(RELAY_PIN_2, HIGH);  // Turn on LED if light is below threshold
        Serial.println("LED turned ON");
      } else {
        digitalWrite(RELAY_PIN_2, LOW);
        Serial.println("LED turned OFF");
      }

      if (temperature > temperatureThreshold) {
        digitalWrite(RELAY_PIN_1, HIGH);  // Turn on fan if temperature exceeds threshold
        Serial.println("Fan turned ON");
      } else {
        digitalWrite(RELAY_PIN_1, LOW);
        Serial.println("Fan turned OFF");
      }
      if (humidity > humidityThreshold) {
        digitalWrite(RELAY_PIN_4, HIGH); // Turn on humidifier if humidity exceeds threshold
        Serial.println("Humidifier turned ON");
      } else {
        digitalWrite(RELAY_PIN_4, LOW);
        Serial.println("Humidifier turned OFF");
      }
    }

    String sensorData = "{\"moisture\": " + String(moisturePercentage) +
                        ", \"temperature\": " + String(temperature) +
                        ", \"humidity\": " + String(humidity) +
                        ", \"light\": " + String(lightSensorValue) +
                        "}";
    client.publish(mqtt_topic_sensor_readings, sensorData.c_str());

    if (!updateRequested) {
      updateRequested = false;
    }
  }
}

void loop() {
  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  publishSensorReadings();

  delay(1000);
}
