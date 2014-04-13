
class HotAirBalloon{
public
boolean popped;
  float acceleration;
  float velocity;
  StandardData data;
  float position;
  float altitude;
private  
  float lastAltitude;
  float velocityPrint;
  HotAirBalloon(){
    data = new StandardData();
    popped = false;
    altitude = 0;
    velocity = 0;
    acceleration = 0;
    lastAltitude = altitude;
  }
  void setVelocity(float v){
    velocity = v;
  }
  void updateSecondElapsed(){
    velocityPrint = altitude - lastAltitude;
    lastAltitude = altitude;
  }
  void update(int fps){  // frames per second
    data.update(altitude);
//    velocity = data.density - density;
    velocity += acceleration / fps;
    if(velocity < -55) velocity = -55;
      altitude += velocity / fps;
  }
  void logStats(int xPos, int yPos){
    data.printStats(xPos, yPos);
    if(velocity < 0){
      text("velocity: ", xPos, yPos + 7*fontSize);
      fill(255,255,0);
      text((int(velocity*10)/10.0) + " m/s  " + (int(velocity*3.2808*10)/10.0) + "ft/s", xPos + 4*fontSize, yPos + 7*fontSize);
    }
    else
      text("velocity: " + (int(velocity*10)/10.0) + " m/s  " + (int(velocity*3.2808*10)/10.0) + "ft/s", xPos, yPos + 7*fontSize);
  }
}

