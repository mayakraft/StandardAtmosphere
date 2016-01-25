#include <stdio.h>
#include "standard_atmosphere.h"

void printAtmosphere(atmosphere a){
    printf(" - Temperature:(%.3f °C)\n - Pressure:(%.3f psi)\n - Density:(%.3f kg/m³)\n - Gravity:(%.3f m/s²)\n - Speed of sound:(%.3f m/s)\n", a.temperature, a.pressure, a.density, a.gravity, a.speed_of_sound);
}

int main(){
    atmosphere a = atmosphereAtAltitude(0);
    printf("\nSea level: 0m\n");
    printAtmosphere(a);

    printf("\nLa Paz, Bolivia: 3,650m\n");
    printAtmosphere( atmosphereAtAltitude(3650) );

    printf("\nMt. Everest: 8,850m\n");
    printAtmosphere( atmosphereAtAltitude(8850) );
}