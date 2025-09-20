// ================================
// ARDUINO NANO - HC-SR04 SENSOR
// Puerto: COM3
// Envía: distancia en cm + "."
// ================================

const int trigPin = 9;
const int echoPin = 10;

void setup() {
  Serial.begin(9600);
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
}

void loop() {
  long duration;
  int distance;

  // Limpia el pin de trigger
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  // Lee el eco
  duration = pulseIn(echoPin, HIGH);
  distance = duration * 0.034 / 2; // Velocidad del sonido: 340 m/s → 0.034 cm/µs

  // Filtra lecturas no válidas
  if (distance <= 0 || distance > 40) {
    distance = 40; // "Out of range" → máximo del radar
  }

  // ENVÍA DISTANCIA + DELIMITADOR
  Serial.print(distance);
  Serial.println(".");

  delay(50); // Ajusta según velocidad del servo (en el UNO)
}