#include "DHT.h"
#include "PubSubClient.h" 

#define DHTPIN 4 

#define DHTTYPE DHT22 
DHT dht(DHTPIN, DHTTYPE);

// WiFi
const char* ssid = "TP_LINK-804";                 
const char* wifi_password = "senha_do_wifi"

// MQTT
const char* mqtt_server = "192.168.0.106";  // IP MQTT server
const char* humidity_topic = "Humidade: ";
const char* temperature_topic = "Temperatura: ";
const char* mqtt_username = "erick"; // MQTT username
const char* mqtt_password = "123"; // MQTT password
const char* clientID = "client_livingroom"; // MQTT client ID

// Inicializa WiFi e MQTT Client
WiFiClient wifiClient;

// escuta pela porta 1883
PubSubClient client(mqtt_server, 1883, wifiClient);

void connect_MQTT(){
  Serial.print("Connecting to ");
  Serial.println(ssid);

  // Conectado no WiFi
  WiFi.begin(ssid, wifi_password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
 
  Serial.println("WiFi conectado");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());

  if (client.connect(clientID, mqtt_username, mqtt_password)) {
    Serial.println("Connectado ao MQTT!");
  }
  else {
    Serial.println("Falha ao conectar no MQTT...");
  }
}


void setup() {
  Serial.begin(9600);
  dht.begin();
}

void loop() {
  connect_MQTT();
  Serial.setTimeout(2000);

  float h = dht.readHumidity();
  float t = dht.readTemperature();

  Serial.print("Umidade: ");
  Serial.print(h);
  Serial.println(" %");
  Serial.print("Temperatura: ");
  Serial.print(t);
  Serial.println(" *C");

  String hs="Umidade: "+String((float)h)+" % ";
  String ts="Temperatura: "+String((float)t)+" C ";

  if (client.publish(temperature_topic, String(t).c_str())) {
    Serial.println("Temperatura enviada!");
  }
  else {
    Serial.println("Falha ao enviar Temperatura. Reconectando ao MQTT Broker e tentando novamente");
    client.connect(clientID, mqtt_username, mqtt_password);
    delay(10); 
    client.publish(temperature_topic, String(t).c_str());
  }

  
  if (client.publish(humidity_topic, String(h).c_str())) {
    Serial.println("Umidade enviada!");
  }
  
  else {
    Serial.println("Falha ao enviar Humidade. Reconectando ao MQTT Broker e tentando novamente");
    client.connect(clientID, mqtt_username, mqtt_password);
    delay(10); 
    client.publish(humidity_topic, String(h).c_str());
  }
  client.disconnect(); 
  delay(100);  
}
