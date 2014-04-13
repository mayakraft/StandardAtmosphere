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

int retinaScale = 1; // 2

// graphics
color skyColor, spaceColor;
int fontSize = 18;
boolean mouseDown;
int screenAltitude = 20000;
// animation
boolean pause;
int lastSecond, currentSecond;
int lastFrameCount;
long elapsedSeconds;
long MET0 = 0;
long MET = 0;
boolean METimer = false;
int fps; // calculated last second's frames per second, required for velocity calculations

// recording
float DATA_FREQ = 10; // 10 seconds between data points
int NUM_DATA = int(60*60*3/DATA_FREQ);  // (seconds) * (minutes) * numHours
float[] altitudeData = new float[NUM_DATA];
int dataIndex = 0;

StandardData mouseData;
//Balloon balloon;
HotAirBalloon balloon;
  
void setup(){
  // animation
  frameRate(15);
  pause = true;
  // graphics
  if(retinaScale > 1){
    // Apple retina screen support
    size(800,600, "processing.core.PGraphicsRetina2D");
    hint(ENABLE_RETINA_PIXELS); // improve rendering quality with pixel operations
  }
  else{
    size(800,600);
  }
  textSize(fontSize*retinaScale);
  skyColor = color(10, 10, 20);
  spaceColor = color(0, 102, 153);
  // atmosphere
  mouseData = new StandardData();
  // balloon
  dataIndex = 0;
  balloon = new HotAirBalloon();
}

void setupAnimation(){
  dataIndex = 0;
  balloon = new HotAirBalloon();
  pause = true;
  elapsedSeconds = 0;
  MET = 0;
  MET0 = 0;
  METimer = false;
}

void update(){
  currentSecond = second();
  if(lastSecond != currentSecond){
    lastSecond = currentSecond;
    // timers
    if(!pause) elapsedSeconds++;
    if(METimer) MET++;
    fps = (frameCount-lastFrameCount);
//    println("Frames: " + fps + "/sec");
    lastFrameCount = frameCount;
    balloon.updateSecondElapsed();
    altitudeData[dataIndex%NUM_DATA] = balloon.altitude;
    if(dataIndex != int(elapsedSeconds/DATA_FREQ)){
      dataIndex = int(elapsedSeconds/DATA_FREQ);
      altitudeData[dataIndex%NUM_DATA] = balloon.altitude;
//      println(pause + " " + elapsedSeconds + " " + dataIndex + " " + altitudeData[dataIndex]);
    }
  }
  balloon.update(fps);
    if(balloon.altitude < 0){
      balloon.altitude = 0;
      balloon.velocity = 0;
      balloon.acceleration = 0;
      pause = true;
    }
}

void draw() {
  update();
  background(0);
  noFill();
  strokeWeight(1);
  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 0, 1);
    color c = lerpColor(skyColor, spaceColor, inter);
    stroke(c);
    line(0, i, width, i);
  } 
  stroke(0,150, 50);
  line(0,height-1,width,height-1);
  if(mouseDown){
//    stroke(255,255,255,10);
//    line(mouseX,0,mouseX,height);
    stroke(255,255,255,100);
    line(0,mouseY,width,mouseY);
  }
  printScale();
  balloon.logStats(fontSize, fontSize);
  if(METimer) fill(0, 102, 153);
  else fill(0, 102, 153, 100);
  printTime(int(MET+MET0), width-6*fontSize*2, 40);
  if(!pause) fill(255);
  else fill(255, 100);
  printTime(int(elapsedSeconds), width*.5-2.5*fontSize*2, 40);
  fill(255, 150);
  printETA();
  if(mouseDown){
    fill(255, 255, 255, 180);
    mouseData.printStats(10, height-8*fontSize);
  }
  fill(255);
  color(255, 255, 255);
  stroke(255);
  strokeWeight(1);
  for(int i = 0; i < dataIndex; i++){
    line(width*.1+width*.8*((float)i/NUM_DATA), 
         height-height*altitudeData[i%NUM_DATA]/(float)screenAltitude,
         width*.1+width*.8*((float)(i+1)/NUM_DATA), 
         height-height*altitudeData[(i+1)%NUM_DATA]/(float)screenAltitude);
  }
  line(width*.5-24, height-height*balloon.altitude/(float)screenAltitude,
       width*.5+24, height-height*balloon.altitude/(float)screenAltitude);
  stroke(0);
  if(!balloon.popped){
    strokeWeight(6);
    ellipse(width*.1+width*.8*((float)dataIndex/NUM_DATA), height-height*balloon.altitude/(float)screenAltitude, 30, 30);
  }
  else{
    strokeWeight(3);
    ellipse(width*.1+width*.8*((float)dataIndex/NUM_DATA), height-height*balloon.altitude/(float)screenAltitude, 8, 8);
  }
}
void printTime(int sec, float xPos, float yPos){
  String ss = "";
  String sm = "";
  String sh = "";
  textSize(fontSize*retinaScale*2);
  int _seconds = int(sec % 60);
  int _minutes = int(sec/60.0);
  int _hours = int(sec/3600.0);
  if(_seconds < 10) ss = "0";
  if(_minutes < 10) sm = "0";
  if(_hours < 10) sh = "0";
  text(sh + _hours + " : " + sm + _minutes + " : " + ss + _seconds, xPos, yPos);
  textSize(fontSize*retinaScale);
}
void printScale(){
  float spacer = (float)height/8.0;
  stroke(255, 255, 255, 50);
  strokeWeight(1);
  for(int i = 0; i < 8; i++){
    text(int((float)screenAltitude/8.0*i) + "m  ("+ int(3.28084*(float)screenAltitude/8.0*i) + "ft)", width-fontSize*10, height-5-i*spacer);
    //20000
    line(0,height-i*spacer-1,
         width,height-i*spacer-1 );
    stroke(255, 50);
    for(int j = 1; j < 5; j++){
//      if(j%5 == 0) stroke(255, 100);
      line(width*.5-24, height-i*spacer - j*(spacer/5.0)-1,
           width*.5+24, height-i*spacer - j*(spacer/5.0)-1);
    }
  }
}
void printETA(){
  float spacer = (float)height/8.0;
  String ss, sm;
  if(balloon.velocity > 0.01){
    for(int i = 0; i < 8; i++){
      float target = int((float)screenAltitude/8.0*i);
      if(target > balloon.altitude){
        sm = "";
        ss = "";
        int _min = int(((target-balloon.altitude)/balloon.velocity)/60.0);
        int _sec = int(((target-balloon.altitude)/balloon.velocity)%60);
        if(_min < 10) sm = "0";
        if(_sec < 10) ss = "0";
        text("(" + sm + _min + ":" + ss + _sec + ")", 
              width-17*fontSize, height-5-i*spacer);
      }
    }
  }
  else if(balloon.velocity < -.01){
    for(int i = 0; i < 8; i++){
      float target = int((float)screenAltitude/8.0*i);
      if(target < balloon.altitude)
      text("(" + -int((balloon.altitude-target)/balloon.velocity/6.0)/10.0 + " min)", width-17*fontSize, height-5-i*spacer);
    }
  }
}
void mousePressed(){
  mouseDown = true;
  mouseDragged();
}
void mouseDragged(){
  mouseData.h = int(screenAltitude * (1.0-(float)(mouseY+1)/height));
  mouseData.update(mouseData.h);
}
void mouseReleased(){
  mouseDown = false;
}
void keyPressed() {
  if (key == CODED && !balloon.popped) {
    if (keyCode == UP) {
      if(pause) pause = !pause;
      balloon.velocity+=.1;
    } else if (keyCode == DOWN) {
      balloon.velocity-=.1;
    } 
  }
  if(key == 'p' || key == 'P'){
    balloon.popped = true;
    balloon.acceleration = -9.8;
  }
  if(key == 'q' || key == 'Q'){
//    mouseData = new StandardData();
    // balloon
    setupAnimation();
  }    
  if(key == ' '){
    if(!METimer){
      METimer = true;
      MET0+=MET;
      MET = 0;
    }
    else if(METimer){
      METimer = false;
    }
  }
}
