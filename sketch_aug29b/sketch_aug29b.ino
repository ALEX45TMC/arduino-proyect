#include <DHT.h>

#define DHTPIN 2        // Pin de datos del DHT11
#define DHTTYPE DHT11   // Tipo de sensor

DHT dht(DHTPIN, DHTTYPE);

void setup() {
  Serial.begin(9600);
  dht.begin(); // Inicializa el sensor
  delay(200); // Espera para estabilizar
}

void loop() {
  float temp = dht.readTemperature();
  float hum = dht.readHumidity();

  // Si falla la lectura, envía valores por defecto
  if (isnan(temp) || isnan(hum)) {
    temp = -99.9;
    hum = -99.9;
  }

  // Formato: "T25.3,H60.5." → fácil de parsear en Processing
  Serial.print("T");
  Serial.print(temp, 1); // 1 decimal
  Serial.print(",H");
  Serial.print(hum, 1);
  Serial.println(".");

  delay(200); // Espera 2 segundos entre lecturas (DHT11 es lento)
}
