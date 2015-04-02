# international standard atmosphere

atmosphere data for an altitude in meters (range 0 to 20,000)

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
// composite
atmosphere atmosphereAtAltitude(double altitude);

// individual
double pressureAtAltitude(double altitude);
double densityAtAltitude(double altitude);
double temperatureAtAltitude(double altitude);
double gravityAtAltitude(double altitude);
double speedOfSoundAtAltitude(double altitude);
```

# example

type `make`

```c
Sea level: 0m
  Temp:(15.000 °C) Press:(14.696 psi) Dens:(1.225 kg/m^3) Grav:(9.807 m/s^2)
La Paz, Bolivia: 3,650m
  Temp:(-8.725 °C) Press:(9.355 psi) Dens:(0.850 kg/m^3) Grav:(9.795 m/s^2)
Mt. Everest: 8,850m
  Temp:(-42.525 °C) Press:(4.559 psi) Dens:(0.475 kg/m^3) Grav:(9.779 m/s^2)
```


# sources

[International Standard Atmosphere, Mustafa Cavcar](http://fisicaatmo.at.fcen.uba.ar/practicas/ISAweb.pdf)

various wikipedia pages

# license

MIT