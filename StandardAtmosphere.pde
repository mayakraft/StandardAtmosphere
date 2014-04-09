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

// graphics
color skyColor, spaceColor;
int fontSize = 18;
boolean mouseDown;
int screenAltitude = 20000;
// animation
int lastSecond, currentSecond;
int lastFrameCount;
int fps; // frames per second, required for velocity calculations

StandardData mouseData;
//Balloon balloon;
HotAirBalloon balloon;
  
void setup(){
  frameRate(15);
  // graphics
  size(800,600);
  textSize(fontSize);
  skyColor = color(10, 10, 20);
  spaceColor = color(0, 102, 153);
  // atmosphere
  mouseData = new StandardData();
  // balloon
  balloon = new HotAirBalloon();
}

void update(){
  currentSecond = second();
  if(lastSecond != currentSecond){
    lastSecond = currentSecond;
    fps = (frameCount-lastFrameCount);
//    println("Frames: " + fps + "/sec");
    lastFrameCount = frameCount;
    balloon.updateSecondElapsed();
  }
  balloon.update(fps);
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
  printScale();
  balloon.logStats(10, 10);
  if(mouseDown){
    fill(255, 255, 255, 180);
    mouseData.printStats(10, height-8*fontSize);
  }
  fill(255);
  color(255, 255, 255);
  stroke(0);
  strokeWeight(6);
  ellipse(width/2.0, height-height*balloon.altitude/(float)screenAltitude, 30, 30);
}

void printScale(){
  float spacer = (float)height/8.0;
  for(int i = 0; i < 8; i++){
    text(int(3.28084*(float)screenAltitude/8.0*i) + " ft", width-fontSize*5, height-5-i*spacer);
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
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      balloon.velocity+=.1;
    } else if (keyCode == DOWN) {
      balloon.velocity-=.1;
    } 
  }
}
