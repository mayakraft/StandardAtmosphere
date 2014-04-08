
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
  
  float lastAltitude;
  float velocityPrint;
  Balloon(){
    data = new StandardData();
    altitude = 0;
    velocity = 0;
    acceleration = 0;
    density = .0012;//225;//0.001;
  }
  void updateSecondElapsed(){
    velocityPrint = altitude - lastAltitude;
    lastAltitude = altitude;
  }
  void update(){
    data.update(int(altitude));
    velocity = data.density - density;
    velocity *= 2000;      // FAKE
    altitude += velocity;
  }
  void printStats(int xPos, int yPos){
    text("velocity: " + velocityPrint + " m/s", xPos, yPos + 8*fontSize);
  }
}

