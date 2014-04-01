//// Standard Atmosphere Modeling ////
// http://fisicaatmo.at.fcen.uba.ar/practicas/ISAweb.pdf
//
// air is assumed to be devoid of dust, moisture, water vapor
//  and to be at rest with the Earth (no wind)
//
// speed of sound respect to temperature, not density, but that may not matter:
// http://en.wikipedia.org/wiki/File:Comparison_US_standard_atmosphere_1962.svg
//
// gravity disregards latitude
// http://en.wikipedia.org/wiki/Gravity_of_Earth
//
// robby kraft

class StandardData{  
public
  float a;  // speed of sound, m/sec
  float g;  // acceleration of gravity m/sec^2
  int h = 0;  // altitude, m or ft
  float p;  // pressure, (101325 N/m^2) or (1013.25 hPa)
  float T;  // C (288.15 in K)  // K or C
  float density; // density, kg/m^3
  float R = 287.04;  // real gas constant for air, m^2/Ksec^2
  StandardData(){
    setMeanSeaLevelConditions();
  }
  void setMeanSeaLevelConditions(){
      p = p0;
      T = T0;
      a = a0;
      g = g0;
      density = density0;
  }
  void update(int altitude){
    h = altitude;
    if(h < 11000){ // meters, (36,089 ft)
      T = T0 - 6.5 * (float)h / 1000.0;
//    T = T0 - 1.98 * float(h) / 1000.0;  // in ft
      p = p0 * pow(1 - (0.0065 * h / (T0+273.15)), 5.2561 );
    }
    else{  // above the troposphere
      T = -56.5;  // C, or 216.65 K
      p = 226.32 * pow(NUMBER_E, -g*(h-11000)/(R*216.65));
    }
    density = p/(R*(T+273.15));
    a = 331 + ( 0.6 * T );
    g = g0 * pow( (float)radiusEarth/(radiusEarth+h), 2);
  }
  void printStats(int xPos, int yPos){
    text("speed of sound: " + a + " m/sec", xPos, yPos + 1*fontSize);
    text("gravity: " + g + " m/sec^2", xPos, yPos + 2*fontSize);
    text("altitude: " + h + " m", xPos, yPos + 3*fontSize);
    text("pressure: " + p + " hPa", xPos, yPos + 4*fontSize);
    text("real gas constant: " + R + " m^2/Ksec^2", xPos, yPos + 5*fontSize);
    text("temperature: " + T + " C", xPos, yPos + 6*fontSize);
    text("density: " + density + " units ??? kg/m^3", xPos, yPos + 7*fontSize);
  }

private
  float a0 = 340.294;
  float g0 = 9.80665; 
  float p0 = 1013.25;
  float T0 = 15; 
  float density0 = 1.225; 
}

class Balloon{
public
  StandardData data;
  float density;
  float volume;
  float position;
  float altitude;
private  
  float velocity;
  float acceleration;
  Balloon(){
    data = new StandardData();
    altitude = 0;
    velocity = 0;
    acceleration = 0;
    density = 0.001;
  }
  void update(){
    data.update(int(altitude));
    velocity = data.density - density;
    altitude += velocity * 2000;  // FAKE
  }
}

float NUMBER_E = 2.718281828;
int radiusEarth = 6371000; // meters
// graphics
color skyColor, spaceColor;
int fontSize = 12;
boolean mouseDown;
int screenAltitude = 20000;

StandardData mouseData, balloonData;
Balloon balloon;
  
void setup(){
  // graphics
  size(800,600);
  skyColor = color(10, 10, 20);
  spaceColor = color(0, 102, 153);
  // atmosphere
  mouseData = new StandardData();
  // balloon
  balloon = new Balloon();
}

void update(){
  balloon.update();
}

void draw() {
  update();
  background(0);
  noFill();
  strokeWeight(1);
  for (int i = 0; i <= height; i++) {
    float inter = map(i, 0, height, 0, 1);
    color c = lerpColor(skyColor, spaceColor, inter);
    stroke(c);
    line(0, i, width, i);
  } 
  if(mouseDown){
    stroke(255,255,255,10);
    line(mouseX,0,mouseX,height);
    stroke(255,255,255,100);
    line(0,mouseY,width,mouseY);
  }
  balloon.data.printStats(10, 10);
  if(mouseDown){
    fill(255, 255, 255, 180);
    mouseData.printStats(10, height-9*fontSize);
  }
  printScale();
  fill(255);
  color(255, 255, 255);
  stroke(0);
  strokeWeight(6);
  ellipse(width/2.0, height-height*balloon.altitude/(float)screenAltitude, 30, 30);
}

void printScale(){
  float spacer = (float)height/8.0;
  for(int i = 0; i < 8; i++){
    text(int(3.28084*(float)screenAltitude/8.0*i) + " ft", width-70, height-5-i*spacer);
  }
}
void mousePressed(){
  mouseDown = true;
  mouseDragged();
}
void mouseDragged(){
  mouseData.h = int(screenAltitude * (1.0-(float)mouseY/height));
  mouseData.update(mouseData.h);
}
void mouseReleased(){
  mouseDown = false;
}
