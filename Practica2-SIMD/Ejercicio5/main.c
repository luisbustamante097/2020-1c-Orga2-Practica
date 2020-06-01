#include <stdio.h>
#include <malloc.h>
#include <stdint.h>
#include <assert.h>
#include <stdlib.h>

extern void SumarErroresResiduales(float *A, float *B, float* Res, int dimension);

void printVector_float(float* ptr, uint16_t n){
	printf("[");
	for (uint16_t i = 0; i<n; i++){
		printf("%f", ptr[i]);
		printf((i<n-1)? ", ":"]\n");
	}
}

int main(int argc, char const *argv[]) {
	// PUNTO 1
	int dim = 32;
	float* vec_float_A = (float*) malloc(sizeof(float)*dim);
	float* vec_float_B = (float*) malloc(sizeof(float)*dim);
	// float* vec_float_Res = (float*) malloc(sizeof(float)*dim);
	// float* vec_float_Res_Esperado = (float*) malloc(sizeof(float)*dim);
	
	int upper = 10;
	srand(1);
	for (int i = 0; i < dim; i++) {
		float num = (float)rand()/(float)(RAND_MAX/upper);
		vec_float_A[i] = num;
	}
	
	srand(2);
	for (int i = 0; i < dim; i++) {
		float num = (float)rand()/(float)(RAND_MAX/upper);
		vec_float_B[i] = num;
	}
	
	printVector_float(vec_float_A, dim);
	printVector_float(vec_float_B, dim);
	
	float accum_esperado = 0.0;
	for (int i = 0; i < dim; i++) {
		accum_esperado += (vec_float_A[i]+ vec_float_B[i]) * (vec_float_A[i]+ vec_float_B[i]);
	}
	float* res = (float*) malloc(sizeof(float));;
	// *res = 0.0;
	SumarErroresResiduales(vec_float_A, vec_float_B, res, dim);
	
	printf("ESPERADO  = %f \n", accum_esperado);
	printf("RESULTADO = %f \n", *res);
	
	free(vec_float_A);
	free(vec_float_B);
	free(res);
	// free(vec_float_Res);
	// free(vec_float_Res_Esperado);
	
	return 0;
}
