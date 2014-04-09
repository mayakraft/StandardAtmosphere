
class HotAirBalloon{
public
  float velocity;
  StandardData data;
  float position;
  float altitude;
private  
  float lastAltitude;
  float velocityPrint;
  HotAirBalloon(){
    data = new StandardData();
    altitude = 0;
    velocity = 0;
    lastAltitude = altitude;
  }
  void updateSecondElapsed(){
    velocityPrint = altitude - lastAltitude;
    lastAltitude = altitude;
  }
  void update(int fps){  // frames per second
    data.update(altitude);
//    velocity = data.density - density;
    altitude += velocity / fps;
  }
  void logStats(int xPos, int yPos){
    data.printStats(xPos, yPos);
    text("velocity: " + (int(velocity*10)/10.0) + " m/s  " + (int(velocity*3.2808*10)/10.0) + "ft/s", xPos, yPos + 7*fontSize);
  }
}

