# international standard atmosphere

a model of atmosphere conditions over a wide range of altitudes (valid between sea level and +20,000 meters)

# input

```c
double  altitude        // meters
```

# get back

```c
double  temperature;    // celsius
double  pressure;       // psi
double  density;        // kg/m^3
double  gravity;        // m/sec^2
double  speed_of_sound; // m/sec
```

# methods

```c
// all at once
atmosphere atmosphereAtAltitude(double altitude);

// individual
double pressureAtAltitude(double altitude);
double densityAtAltitude(double altitude);
double temperatureAtAltitude(double altitude);
double gravityAtAltitude(double altitude);
double speedOfSoundAtAltitude(double altitude);
```

# example

type `make` then `make run`

```
Sea level: 0m
 - Temperature:(15.000 °C)
 - Pressure:(14.696 psi)
 - Density:(1.225 kg/m³)
 - Gravity:(9.807 m/s²)
 - Speed of sound:(340.000 m/s)

La Paz, Bolivia: 3,650m
 - Temperature:(-8.725 °C)
 - Pressure:(9.355 psi)
 - Density:(0.850 kg/m³)
 - Gravity:(9.795 m/s²)
 - Speed of sound:(325.765 m/s)

Mt. Everest: 8,850m
 - Temperature:(-42.525 °C)
 - Pressure:(4.559 psi)
 - Density:(0.475 kg/m³)
 - Gravity:(9.779 m/s²)
 - Speed of sound:(305.485 m/s)
```

# sources

[International Standard Atmosphere, Mustafa Cavcar](http://fisicaatmo.at.fcen.uba.ar/practicas/ISAweb.pdf)

wikipedia

# license

MIT