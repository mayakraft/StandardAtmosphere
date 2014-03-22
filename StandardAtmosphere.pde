float NUMBER_E = 2.718281828;
// 2008
// display
color skyColor, spaceColor;
int fontSize = 12;

int screenAltitude = 20000;

//// Standard Atmosphere Modeling ////
//
// air is assumed to be devoid of dust, moisture, water vapor
//  and to be at rest with the Earth (no wind)
//

float a, a0 = 340.294;  // speed of sound, m/sec
float g, g0 = 9.80665;  // acceleration of gravity m/sec^2
int h = 0;  // altitude, m or ft
float p, p0 = 1013.25;  // pressure, (101325 N/m^2) or (1013.25 hPa)
float T, T0 = 15;  // C (288.15 in K)  // K or C
float density, density0 = 1.225;  // density, kg/m^3
float R = 287.04;  // real gas constant for air, m^2/Ksec^2

void setMeanSeaLevelConditions(){
  p = p0;
  T = T0;
  a = a0;
  g = g0;
  density = density0;
}

void setup(){
  size(800,600);
  skyColor = color(10, 10, 20);
  spaceColor = color(0, 102, 153);
  
  setMeanSeaLevelConditions();
}

void updateDataForAltitude(int altitude){
  h = altitude;
  if(h < 11000){ // meters, (36,089 ft)
    T = T0 - 6.5 * (float)h / 1000.0;
//  T = T0 - 1.98 * float(h) / 1000.0;  // in ft
    p = p0 * pow(1 - (0.0065 * h / (T0+273.15)), 5.2561 );
  }
  else{  // above the troposphere
    T = -56.5;  // C, or 216.65 K
    p = 226.32 * pow(NUMBER_E, -g*(h-11000)/(R*216.65));
  }
  density = p/(R*(T+273.15));
}

void update(){
  updateDataForAltitude(h);  
}

void draw() {
  update();
  clear();
  noFill();
  for (int i = 0; i <= height; i++) {
    float inter = map(i, 0, height, 0, 1);
    color c = lerpColor(skyColor, spaceColor, inter);
    stroke(c);
    line(0, i, width, i);
  } 
  printStats();
}

void printStats(){
  text("speed of sound: " + a + " m/sec", 10, 1*fontSize);
  text("gravity: " + g + " m/sec^2", 10, 2*fontSize);
  text("altitude: " + h + " m", 10, 3*fontSize);
  text("pressure: " + p + " N/m^2, or hPa", 10, 4*fontSize);
  text("real gas constant: " + R + " m^2/Ksec^2", 10, 5*fontSize);
  text("temperature: " + T + " C", 10, 6*fontSize);
  text("density: " + density + " ??? kg/m^3", 10, 7*fontSize);
}
void mousePressed(){
  h = int(screenAltitude * (1.0-(float)mouseY/height));
}
void mouseDragged(){
  h = int(screenAltitude * (1.0-(float)mouseY/height));
}
