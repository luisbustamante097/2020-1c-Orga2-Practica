//void Intercalar(char *A, char *B, char *vectorResultado, int dimension)

#include <stdio.h>
#include <malloc.h>
#include <stdint.h>
#include <assert.h>
#include <stdlib.h>

extern void Intercalar(char *A, char *B, char *vectorResultado, int dimension);

void printVector_char(char* ptr, uint16_t n, int8_t hex){
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
	char* vec_char_A = (char*) malloc(sizeof(char)*dim);
	char* vec_char_B = (char*) malloc(sizeof(char)*dim);
	char* vec_char_Res = (char*) malloc(sizeof(char)*2*dim);
	char* vec_char_Res_Esperado = (char*) malloc(sizeof(char)*2*dim);
	
	
	int upper = 50;
	int lower = 0;
	srand(1);
	for (int i = 0; i < dim; i++) {
		char num = (rand() % (upper - lower + 1)) + lower;
		vec_char_A[i] = num;
	}
	
	srand(2);
	for (int i = 0; i < dim; i++) {
		char num = (rand() % (upper - lower + 1)) + lower;
		vec_char_B[i] = num;
	}
	
	printVector_char(vec_char_A, dim, 1);
	printVector_char(vec_char_B, dim, 1);
	
	for (int i = 0; i < 2*dim; i++) {
		vec_char_Res_Esperado[i]=(i%2 == 0 ? vec_char_A[i/2] : vec_char_B[i/2]);
	}
	
	Intercalar(vec_char_A, vec_char_B, vec_char_Res, dim);
	
	
	printf("ESPERADO = \n");
	printVector_char(vec_char_Res_Esperado, 2*dim, 1);
	printf("RESULTADO = \n");
	printVector_char(vec_char_Res, 2*dim, 1);
	
	free(vec_char_A);
	free(vec_char_B);
	free(vec_char_Res);
	free(vec_char_Res_Esperado);
	
	return 0;
}
