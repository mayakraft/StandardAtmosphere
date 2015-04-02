// international standard atmosphere, good to 20,000 m
//
// pacific spaceflight, http://pacificspaceflight.com
// mit open source software license

#define EARTH_RADIUS 6371000.0   // meters
#define REAL_GAS_CONSTANT 287.04 // earth air, m^2/Ksec^2
#define E 2.71828182845904523536028747135266250
#define METERS_TO_FEET 3.28083989501312
#define HPA_TO_PSI 0.014503773773

// CONDITIONS AT ALTITUDE 0
#define SEA_LEVEL_PRESSURE 1013.25
#define SEA_LEVEL_TEMPERATURE 15
#define SEA_LEVEL_GRAVITY 9.80665
#define SEA_LEVEL_DENSITY 1.225
#define SEA_LEVEL_SPEED_OF_SOUND 340.294

#include <math.h>

typedef struct atmosphere atmosphere;
struct atmosphere{
    double  temperature;    // celsius (288.15 in K)
    double  pressure;       // psi  (101325 N/m^2) or (1013.25 hPa)
    double  density;        // kg/m^3
    double  gravity;        // m/sec^2
    double  speed_of_sound; // m/sec
};

// altitude in meters
atmosphere atmosphereAtAltitude(double altitude){
    struct atmosphere a;
    if(altitude < 0.0 || altitude > 20000.0) return a;   // calculations only valid between sea level and 20,000m
    a.gravity = SEA_LEVEL_GRAVITY * pow( EARTH_RADIUS / (EARTH_RADIUS+altitude), 2);
    if(altitude < 11000.0){ // meters, (36,089 ft)
        a.temperature = SEA_LEVEL_TEMPERATURE - 6.5 * altitude / 1000.0; // -= 1.98 * altitude / 1000.0; if using feet
        a.pressure = SEA_LEVEL_PRESSURE * pow(1 - (0.0065 * altitude / (SEA_LEVEL_TEMPERATURE+273.15)), 5.2561 );
    }
    else{  // above the troposphere
        a.temperature = -56.5;  // C, or 216.65 K
        a.pressure = 226.32 * pow(E, -a.gravity*(altitude-11000)/(REAL_GAS_CONSTANT*216.65));
    }
    a.density = a.pressure/(REAL_GAS_CONSTANT*(a.temperature+273.15))*100.0;
    a.speed_of_sound = 331 + ( 0.6 * a.temperature );
    a.pressure *= HPA_TO_PSI;
    return a;
}

// altitude in meters
double speedOfSoundAtAltitude(double altitude){
    if(altitude < 0.0 || altitude > 20000.0)
        return -1;
    else if(altitude < 11000.0)
        return 331 + ( 0.6 * (SEA_LEVEL_TEMPERATURE - 6.5 * altitude / 1000.0) );
    else
        return 331 + ( 0.6 * -56.5 );
}

// altitude in meters
double gravityAtAltitude(double altitude){
    return SEA_LEVEL_GRAVITY * pow( EARTH_RADIUS / (EARTH_RADIUS+altitude), 2);
}

// altitude in meters
double temperatureAtAltitude(double altitude){
    if(altitude < 0.0 || altitude > 20000.0)
        return -1;
    else if(altitude < 11000.0)
        return SEA_LEVEL_TEMPERATURE - 6.5 * altitude / 1000.0;
    else
        return -56.5;
}

// altitude in meters
double pressureAtAltitude(double altitude){
    if(altitude < 0.0 || altitude > 20000.0)
        return -1;
    else if(altitude < 11000.0)
        return SEA_LEVEL_PRESSURE * pow(1 - (0.0065 * altitude / ((SEA_LEVEL_TEMPERATURE-(6.5*altitude/1000.0) )+273.15)), 5.2561 ) * HPA_TO_PSI;
    else
        return 226.32 * pow(E, -(SEA_LEVEL_GRAVITY * pow( EARTH_RADIUS / (EARTH_RADIUS+altitude), 2))*(altitude-11000)/(REAL_GAS_CONSTANT*216.65)) * HPA_TO_PSI;
}

// altitude in meters
double densityAtAltitude(double altitude){
    double temperature = SEA_LEVEL_TEMPERATURE;
    double pressure = SEA_LEVEL_PRESSURE;
    double gravity = SEA_LEVEL_GRAVITY;
    if(altitude < 0.0 || altitude > 20000.0)
        return -1;
    else if(altitude < 11000.0){
        temperature -= 6.5 * altitude / 1000.0;
        pressure *= pow(1 - (0.0065 * altitude / (SEA_LEVEL_TEMPERATURE+273.15)), 5.2561 );
    }
    else{
        temperature = -56.5;
        pressure = 226.32 * pow(E, -gravity*(altitude-11000)/(REAL_GAS_CONSTANT*216.65));
    }
    return pressure/(REAL_GAS_CONSTANT*(temperature+273.15))*100.0;
}
