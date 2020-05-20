// Sea el siguiente tipo de datos "dicc"(diccionario sobre arbol binario)
// para manejar claves y significados, se piden definir en
// lenguaje ensamblador las funciones que permitan obtener
// el significado de una palabra, agregar una nueva definicion,
// modificarla y eliminarla respectivamente.
// Pensar en el prototipo de las funciones y el manejo de punteros

#include <stdio.h>
#include <malloc.h>
#include <stdint.h>

void InicializarVector(short *A, short valorInicial, int dimension);
void DividirVectorPorPotenciaDeDos(int *A, int potencia, int dimension);
void FiltrarMayores(short *A, short umbral, int dimension);
// Pone  en  unos  (0xF...F)  aquellos elementos del vector cuyo valor sea mayor al umbral y en ceros (0x0...0) aquellos que sean menores o iguales.

void printVector_short(short* ptr, uint16_t n, int8_t hex){
	printf("[");
	if (hex == 1){
		for (uint16_t i = 0; i<n; i++){
			printf("%x", ptr[i]);
			printf((i<n-1)? ", ":"]\n");
		}
	}else if (hex == 0){
		for (uint16_t i = 0; i<n; i++){
			printf("%hd", ptr[i]);
			printf((i<n-1)? ", ":"]\n");
		}
	}
}

void printVector_int(int* ptr, uint16_t n, int8_t hex){
	printf("[");
	if (hex == 1){
		for (uint16_t i = 0; i<n; i++){
			printf("%x", ptr[i]);
			printf((i<n-1)? ", ":"]\n");
		}
	}else if (hex == 0){
		for (uint16_t i = 0; i<n; i++){
			printf("%i", ptr[i]);
			printf((i<n-1)? ", ":"]\n");
		}
	}
}

int main(int argc, char const *argv[]) {
	// PUNTO 1
	int dim = 32;
	short* vector_short_1 = (short*) malloc(sizeof(short)*dim);
	short val_inicial = 1;
	InicializarVector(vector_short_1, val_inicial, dim);
	printVector_short(vector_short_1, dim, 0);
	
	printf("\n--------------------------------------\n");
	// PUNTO 2
	dim = 32;
	int* vector_int = (int*) malloc(sizeof(int)*dim);
	for (int i = 0; i < dim; i++) {
		vector_int[i] = i;
	}
	printVector_int(vector_int, dim, 1);
	int potencia = 2;
	DividirVectorPorPotenciaDeDos(vector_int, potencia, dim);
	printVector_int(vector_int, dim, 1);

	printf("\n--------------------------------------\n");
	// PUNTO 3
	short* vector_short_2 = (short*) malloc(sizeof(short)*32);
	for (int i = 0; i < dim; i++) {
		vector_short_2[i] = i%8;
	}
	printVector_short(vector_short_2, dim, 0);
	int umbral = 3;
	FiltrarMayores(vector_short_2, umbral, dim);
	printVector_short(vector_short_2, dim, 0);
	
	
	free(vector_short_2);
	free(vector_int);
	free(vector_short_1);
	return 0;
}
