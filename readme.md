# standard atmosphere model

* pressure
* temperature
* air density
* gravity
* speed of sound

at any altitude < 60,000 ft

# methods

``` processing
//StandardData
update(float altitude);  // get data at altitude
```

# balloons

balloon flight simulator

``` processing
// uncontrolled ascent-rate
Balloon();
balloon.update();

// controlled ascent-rate
HotAirBalloon();
hotAirBalloon.setVelocity(v);
```

# controls

`p` pop balloon, begin fall to -55m/s terminal velocity

`q` reset

`△` `▽` increase/decrease hot-air ascent