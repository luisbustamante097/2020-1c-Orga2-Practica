//Compute x^y, cuyo prototipo sea:
//void power(long x, unsigned long y, superlong* resultado)
//Se puede asumir que el resultado de la operacion entra en 128 bits.

#include <stdio.h>

typedef struct superlong_t {
	long xl;
	long xh;
} superlong;

extern void power(long x, unsigned long y, superlong* resultado);

int main(int argc, char const *argv[]){
	//printf( "%lu", sizeof(long));
    long x = 0x8000000000000000;
	unsigned long y = 0x2;
	superlong resultado;
    power(x, y, &resultado);
	printf ("%ld %ld \n", resultado.xh, resultado.xl);
	return 0;
}
