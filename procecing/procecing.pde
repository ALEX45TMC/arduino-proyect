// ================================
// RADAR ULTRASÓNICO - DUAL ARDUINO
// Autor: FABRI creator
// Recibe ángulo de Arduino UNO (COM5) y distancia de Arduino NANO (COM3)
// ================================

import processing.serial.*; // Librería para comunicación serial

Serial myPort;   // COM3 → Arduino NANO → DISTANCIA
Serial myPort1;  // COM5 → Arduino UNO  → ÁNGULO

int iDistance = 40; // Valor por defecto: fuera de rango
int iAngle = 0;     // Valor por defecto: 0 grados

float pixsDistance; // Distancia convertida a píxeles

void setup() {
  size(1200, 700); // Ajusta según tu resolución
  smooth();        // Suaviza los gráficos
  
  // Inicializa puerto del NANO (sensor ultrasónico)
  myPort = new Serial(this, "COM3", 9600);
  myPort.bufferUntil('.');
  
  // Inicializa puerto del UNO (servomotor)
  myPort1 = new Serial(this, "COM5", 9600);
  myPort1.bufferUntil('.');
  
  // Opcional: fondo inicial
  background(0);
}

void draw() {
  // Efecto de desvanecimiento (simula persistencia de radar)
  fill(0, 4);
  noStroke();
  rect(0, 0, width, height - height * 0.065);
  
  // Dibuja los elementos del radar
  drawRadar();
  drawLine();
  drawObject();
  drawText();
}

// ✅ ÚNICA FUNCIÓN serialEvent — maneja ambos puertos sin conflicto
void serialEvent(Serial port) {
  String input = port.readStringUntil('.');
  if (input == null) return; // Si no hay datos, salir
  input = input.trim();      // Elimina espacios o saltos de línea

  try {
    if (port == myPort) {
      // Datos de COM3 → DISTANCIA (desde Arduino NANO)
      iDistance = Integer.parseInt(input);
      // Limita rango para evitar errores visuales
      if (iDistance < 0 || iDistance > 40) iDistance = 40;
    } 
    else if (port == myPort1) {
      // Datos de COM5 → ÁNGULO (desde Arduino UNO)
      iAngle = Integer.parseInt(input);
      // Asegura rango válido 0-180
      if (iAngle < 0) iAngle = 0;
      if (iAngle > 180) iAngle = 180;
    }
  } 
  catch (Exception e) {
    // Manejo de errores: si falla la conversión, ignora y usa valor anterior
    println("⚠️ Error al parsear: " + input);
  }
}

// --- FUNCIONES DE DIBUJO ---

void drawRadar() {
  pushMatrix();
  translate(width/2, height - height*0.074); // Mueve origen al centro inferior
  noFill();
  strokeWeight(2);
  stroke(98, 245, 31); // Color verde radar

  // Dibuja círculos de rango (10cm, 20cm, 30cm, 40cm)
  float w = width;
  arc(0, 0, w - w*0.0625, w - w*0.0625, PI, TWO_PI);
  arc(0, 0, w - w*0.27,   w - w*0.27,   PI, TWO_PI);
  arc(0, 0, w - w*0.479,  w - w*0.479,  PI, TWO_PI);
  arc(0, 0, w - w*0.687,  w - w*0.687,  PI, TWO_PI);

  // Dibuja líneas de ángulo (0° a 180°)
  strokeWeight(1);
  line(-w/2, 0, w/2, 0); // Línea horizontal (0° y 180°)
  line(0, 0, (-w/2)*cos(radians(30)), (-w/2)*sin(radians(30)));
  line(0, 0, (-w/2)*cos(radians(60)), (-w/2)*sin(radians(60)));
  line(0, 0, (-w/2)*cos(radians(90)), (-w/2)*sin(radians(90)));
  line(0, 0, (-w/2)*cos(radians(120)), (-w/2)*sin(radians(120)));
  line(0, 0, (-w/2)*cos(radians(150)), (-w/2)*sin(radians(150)));
  popMatrix();
}

void drawLine() {
  pushMatrix();
  translate(width/2, height - height*0.074);
  strokeWeight(9);
  stroke(30, 250, 60); // Verde brillante
  float len = height - height*0.12;
  // Dibuja línea giratoria según ángulo recibido
  line(0, 0, len * cos(radians(iAngle)), -len * sin(radians(iAngle)));
  popMatrix();
}

void drawObject() {
  if (iDistance < 40) { // Solo si está dentro del rango visible
    pushMatrix();
    translate(width/2, height - height*0.074);
    strokeWeight(9);
    stroke(255, 10, 10); // Rojo para objeto detectado
    pixsDistance = iDistance * ((height - height*0.1666) * 0.025);
    float endLen = (width - width*0.505);
    // Dibuja segmento desde el centro hasta la distancia detectada
    line(
      pixsDistance * cos(radians(iAngle)), -pixsDistance * sin(radians(iAngle)),
      endLen * cos(radians(iAngle)), -endLen * sin(radians(iAngle))
    );
    popMatrix();
  }
}

void drawText() {
  pushMatrix();
  // Dibuja barra inferior negra
  fill(0);
  noStroke();
  rect(0, height - height*0.0648, width, height);

  // Texto en verde
  fill(98, 245, 31);
  textSize(25);
  text("10cm", width - width*0.3854, height - height*0.0833);
  text("20cm", width - width*0.281,  height - height*0.0833);
  text("30cm", width - width*0.177,  height - height*0.0833);
  text("40cm", width - width*0.0729, height - height*0.0833);

  textSize(40);
  text("FABRI creator", width - width*0.875, height - height*0.0277);
  text("Ángulo: " + iAngle + " °", width - width*0.48, height - height*0.0277);
  text("Dist: " + iDistance + " cm", width - width*0.26, height - height*0.0277);
  popMatrix();
}
