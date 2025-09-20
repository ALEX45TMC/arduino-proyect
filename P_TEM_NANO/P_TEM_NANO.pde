import processing.serial.*;

Serial myPort;

// Array para guardar las últimas 10 lecturas
String[] temperaturas = new String[10];
String[] humedades = new String[10];
String[] timestamps = new String[10];

int lecturaActual = 0; // Índice de la lectura más reciente

void setup() {
  size(800, 600);
  background(30);
  
  // Configura puerto serial — ¡CAMBIA "COM3" POR TU PUERTO!
  String portName = "COM3"; // <-- CAMBIA ESTO
  myPort = new Serial(this, portName, 9600);
  myPort.bufferUntil('.');

  // Inicializa arrays con "-"
  for (int i = 0; i < 10; i++) {
    temperaturas[i] = "-";
    humedades[i] = "-";
    timestamps[i] = "-";
  }
}

void draw() {
  background(30);
  drawTable();
}

void serialEvent(Serial port) {
  String input = port.readStringUntil('.');
  if (input == null) return;
  input = input.trim();

  if (input.startsWith("T")) {
    try {
      // Extrae temperatura y humedad
      int hIndex = input.indexOf(",H");
      if (hIndex != -1) {
        String tempStr = input.substring(1, hIndex);      // "25.3"
        String humStr = input.substring(hIndex + 2);      // "60.5"

        float temp = Float.parseFloat(tempStr);
        float hum = Float.parseFloat(humStr);

        // Guarda en el array circular
        int index = lecturaActual % 10;
        temperaturas[index] = (temp == -99.9) ? "Error" : tempStr + " °C";
        humedades[index] = (hum == -99.9) ? "Error" : humStr + " %";
        timestamps[index] = hour() + ":" + nf(minute(), 2) + ":" + nf(second(), 2);

        lecturaActual++;
      }
    } catch (Exception e) {
      println("Error parsing: " + input);
    }
  }
}

void drawTable() {
  fill(255);
  textSize(24);
  textAlign(CENTER);
  text("📊 ÚLTIMAS 10 LECTURAS DEL DHT11", width/2, 50);

  // Encabezados
  fill(200, 255, 200);
  textSize(18);
  text("N°", 80, 100);
  text("Temperatura", 250, 100);
  text("Humedad", 450, 100);
  text("Hora", 650, 100);

  // Línea separadora
  stroke(100);
  line(50, 110, 750, 110);

  // Mostrar las últimas 10 lecturas (las más recientes arriba)
  fill(255);
  textSize(16);
  textAlign(LEFT);

  for (int i = 0; i < 10; i++) {
    int index = (lecturaActual - 1 - i + 10) % 10; // Última lectura primero
    int y = 140 + i * 40;

    if (i < lecturaActual) { // Solo muestra lecturas válidas
      text((i+1) + ".", 80, y);
      text(temperaturas[index], 200, y);
      text(humedades[index], 400, y);
      text(timestamps[index], 580, y);
    }
  }

  // Leyenda
  textSize(14);
  fill(255, 200, 100);
  text("Actualizando cada 2 segundos...", 50, 570);
}
