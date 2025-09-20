// ================================
// ARDUINO UNO - SERVOMOTOR
// Puerto: COM5
// Envía: ángulo + "."
// ================================

#include <Servo.h>  // ✅ Librería obligatoria

Servo miServo;
int angulo = 0;
int direccion = 1; // 1 = sube, -1 = baja

void setup() {
  Serial.begin(9600);
  miServo.attach(9); // Pin PWM (9, 10, 11 en UNO)
}

void loop() {
  miServo.write(angulo); // Mueve el servo

  // ENVÍA ÁNGULO + DELIMITADOR
  Serial.print(angulo);
  Serial.println(".");

  // Cambia dirección en los extremos
  if (angulo >= 180) direccion = -1;
  if (angulo <= 0) direccion = 1;

  angulo += direccion; // Avanza 1 grado

  delay(15); // Velocidad de barrido → ajusta si necesitas más precisión
}