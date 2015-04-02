#include <stdio.h>
#include "standard_atmosphere.c"

void printAtmosphere(atmosphere a){
    // omitting speed of sound, because I don't need it
    printf("Temp:(%.3f °C) Press:(%.3f psi) Dens:(%.3f kg/m^3) Grav:(%.3f m/s^2)", a.temperature, a.pressure, a.density, a.gravity);
}

int main(){
    atmosphere a;

    a = atmosphereAtAltitude(0);
    printf("\nSea level: 0m\n  ");
    printAtmosphere(a);

    a = atmosphereAtAltitude(3650);
    printf("\nLa Paz, Bolivia: 3,650m\n  ");
    printAtmosphere(a);

    a = atmosphereAtAltitude(8850);
    printf("\nMt. Everest: 8,850m\n  ");
    printAtmosphere(a);

    printf("\n\n");
}