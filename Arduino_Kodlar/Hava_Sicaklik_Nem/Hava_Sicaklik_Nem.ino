#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>
#include <DHT.h>
#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include <ArduinoJson.h>

const char* ssid = "internet";
const char* password = "12345678";

ESP8266WebServer server(80);

#define Ekran_genislik 128
#define Ekran_yukseklik 64
#define OLED_RESET -1
const int OLED_I2C_ADDRESS = 0x3C;
Adafruit_SSD1306 display(Ekran_genislik, Ekran_yukseklik, &Wire, OLED_RESET);

#define DHTPIN 13
#define DHTTYPE DHT11

DHT dht(DHTPIN, DHTTYPE);

float currentHumidity = 0.0;
float currentTemperature = 0.0;
bool sensorReadSuccess = false;

void handleGetData() {
  StaticJsonDocument<200> doc;
  server.sendHeader("Access-Control-Allow-Origin", "*");
  server.sendHeader("Access-Control-Allow-Methods", "GET,OPTIONS");
  if (sensorReadSuccess) {
    doc["temperature"] = currentTemperature;
    doc["humidity"] = currentHumidity;
    doc["status"] = "ok";
    String jsonResponse;
    serializeJson(doc, jsonResponse);
    server.send(200, "application/json", jsonResponse);
  } else {
    doc["status"] = "error";
    doc["message"] = "Sensor okuma hatasi";
    String jsonResponse;
    serializeJson(doc, jsonResponse);
    server.send(503, "application/json", jsonResponse);
  }
}

void handleRoot() {
  String html = "<html><body><h1>ESP8266 Sensor Verileri</h1>";
  html += "<p>Status: ";
  if (sensorReadSuccess) {
    html += "OK</p>";
    html += "<p>Sicaklik: " + String(currentTemperature) + "&deg;C</p>";
    html += "<p>Nem: " + String(currentHumidity) + "%</p>";
  } else {
    html += "Sensor Hatasi veya henuz okunmadi</p>";
  }
  html += "<p><a href='/data'>JSON Verisini Goster</a></p>";
  html += "</body></html>";
  server.send(200, "text/html", html);
}

void setup() {
  Serial.begin(115200);
  WiFi.disconnect();
  delay(1000);

  Serial.println();
  Serial.print("Aga baglaniliyor: ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.println("Baglanti Bekleniyor...");
    Serial.print(".");
    Serial.println(WiFi.status());
  }

  Serial.println();
  Serial.println("WiFi baglandi!");
  Serial.print("ESP IP Adresi: ");
  Serial.println(WiFi.localIP());

  server.on("/", handleRoot);
  server.on("/data", handleGetData);
  server.begin();
  Serial.println("HTTP sunucusu baslatildi.");

  Wire.begin();
  if (!display.begin(SSD1306_SWITCHCAPVCC, OLED_I2C_ADDRESS)) {
    Serial.print(F("SSD1306 tahsis basarisiz. Adresi ("));
    Serial.print(OLED_I2C_ADDRESS, HEX);
    Serial.println(F(") ve baglantilari kontrol edin."));
    for (;;);
  }

  display.display();
  delay(1000);
  display.clearDisplay();
  display.display();

  dht.begin();
  Serial.println("DHT ve OLED baslatildi!");
}

void loop() {
  delay(2000);

  float h = dht.readHumidity();
  float t = dht.readTemperature();

  if (isnan(h) || isnan(t)) {
    Serial.println(F("DHT okuma hatasi!"));
    sensorReadSuccess = false;
    display.clearDisplay();
    display.setCursor(0, 0);
    display.setTextColor(SSD1306_WHITE);
    display.setTextSize(1);
    display.println("Sensor Hatasi!");
    display.display();
  } else {
    sensorReadSuccess = true;
    currentHumidity = h;
    currentTemperature = t;

    Serial.print(F("Nem: "));
    Serial.print(currentHumidity);
    Serial.print(F("%  Sicaklik: "));
    Serial.print(currentTemperature);
    Serial.println(F("°C"));
    Serial.println(WiFi.localIP());

    display.clearDisplay();
    display.setTextSize(1);
    display.setTextColor(SSD1306_WHITE);
    display.setCursor(0, 0);
    display.print("Sicaklik: ");
    display.print(currentTemperature);
    display.println(" C");
    display.print("Nem: ");
    display.print(currentHumidity);
    display.println(" %");
    display.display();
  }

  server.handleClient();
}
