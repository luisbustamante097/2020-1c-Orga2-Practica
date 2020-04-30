//
// sume dos numeros de 128 bits con signo,
// cuyo prototipo sea:
// void suma(superlong* a, superlong* b, superlong* resultado)
// ¿Cambia el codigo en lenguaje ensamblador si el prototipo
// de la suma es:
// void suma(unsignedsuperlong* a, unsignedsuperlong* b,unsignedsuperlong* resultado)?
// typedef struct superlong_t {
// 	long x1;
// 	long x2;
// } superlong;
// typedef struct unsignedsuperlong_t {
// 	unsigned long x1;
// 	unsigned long x2;
// } unsignedsuperlong;

#include <stdio.h>

typedef struct superlong_t {
	long xl;
	long xh;
} superlong;

// void suma(superlong* a, superlong* b, superlong* resultado){
// 	resultado->xl = a->xl + b->xl;
// 	resultado->xh = a->xh + b->xh;
// }
extern void suma(superlong* a, superlong* b, superlong* resultado);

int main(int argc, char const *argv[]){
	//printf( "%lu", sizeof(long));
    superlong a;
	a.xl = 0x8000000000000000;
	a.xh = 0x0000000000000001;
	superlong b;
	b.xl = 0x8000000000000000;
	b.xh = 0x0000000000000001;
	superlong resultado;
    suma(&a,&b,&resultado);
	printf ("%ld %ld \n", resultado.xh, resultado.xl);
	return 0;
}
