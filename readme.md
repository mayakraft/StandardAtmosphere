# standard atmosphere model

balloon launch simulation

``` processing
float a;  // speed of sound, m/sec
float g;  // acceleration of gravity m/sec^2
float p;  // pressure, (101325 N/m^2) or (1013.25 hPa)
float T;  // C (288.15 in K)  // K or C
float density;  // density, kg/m^3
```

# methods

``` processing
balloon = new Balloon();
balloon.update(altitude);
```