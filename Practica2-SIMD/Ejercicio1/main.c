// Sea el siguiente tipo de datos "dicc"(diccionario sobre arbol binario)
// para manejar claves y significados, se piden definir en
// lenguaje ensamblador las funciones que permitan obtener
// el significado de una palabra, agregar una nueva definicion,
// modificarla y eliminarla respectivamente.
// Pensar en el prototipo de las funciones y el manejo de punteros

#include <stdio.h>
#include <malloc.h>
#include <stdint.h>

void sumarVectores(char *A, char *B, char *Resultado, int dimension);

void printVector(char* ptr, uint16_t n, int8_t hex){
	printf("[");
	if (hex == 1){
		for (uint16_t i = 0; i<n; i++){
			printf("%x", ptr[i]);
			printf((i<n-1)? ", ":"]\n");
		}
	}else if (hex == 0){
		for (uint16_t i = 0; i<n; i++){
			printf("%c", ptr[i]);
			printf((i<n-1)? ", ":"]\n");
		}
	}
}

int main(int argc, char const *argv[]) {
	// creo un vector de 32B de chars
	uint16_t dim = 32;
	char* vector_1 = (char*)malloc(sizeof(char)*dim);
	char* vector_2 = (char*)malloc(sizeof(char)*dim);
	char* vector_res = (char*)malloc(sizeof(char)*dim);
	
	for (int i = 0; i<dim; i++){
		vector_1[i] = i;
	}
	printVector(vector_1, dim, 1);
	for (int i = 0; i<dim; i++){
		vector_2[i] = 2;
	}
	printVector(vector_2, dim, 1);
	
	sumarVectores(vector_1, vector_2, vector_res, dim);
	printVector(vector_res, dim, 1);
	
	free(vector_1);
	free(vector_2);
	free(vector_res);
	return 0;
}
