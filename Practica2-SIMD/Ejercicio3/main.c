//a)void MultiplicarVectores(short *A, short *B, int *Res, int dimension)
//b)int ProductoInterno(short *A, short *B, int dimension)
//c)void SepararMaximosMinimos(char *A, char *B, int dimension)
// Deja en A los maximos y en B los minimos
// Es decir, para cada i, 
//  A[i] = max(A[i],B[i]) 
//  B[i] = min(A[i],B[i])
//d)void SumarRestarAlternado(int *A, int *B, int* Res, int dimension)
// Es decir, el Res tiene que seguir el siguiente patron:
//  Res = (A1+B1,A2−B2,A3+B3,A4−B4,...)

#include <stdio.h>
#include <malloc.h>
#include <stdint.h>
#include <assert.h>
#include <stdlib.h>

void MultiplicarVectores(short *A, short *B, int *Res, int dimension);
int ProductoInterno(short *A, short *B, int dimension);
void SepararMaximosMinimos(char *A, char *B, int dimension);
void SumarRestarAlternado(int *A, int *B, int* Res, int dimension);

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
	short* vec_short_A = (short*) malloc(sizeof(short)*dim);
	short* vec_short_B = (short*) malloc(sizeof(short)*dim);
	int* vec_int_Res = (int*) malloc(sizeof(int)*dim);
	
	for (int i=0; i<dim-1; i++){
		vec_short_A[i] = i;
	}
	for (int i=0; i<dim-1; i++){
		vec_short_B[i] = i % 4;
	}
	vec_short_A[dim-1] = 0x7FFF;
	vec_short_B[dim-1] = 2;			//0x7FFF * 0x2 = 0xFFFE
	
	
	printVector_short(vec_short_A, dim, 0);
	printVector_short(vec_short_B, dim, 0);
	
	MultiplicarVectores(vec_short_A, vec_short_B, vec_int_Res,dim);
	
	printVector_int(vec_int_Res, dim, 0);
	//assert(vec_int_Res[dim-1] == 32767*2);
	
	printf("\n--------------------------------------------------\n");
	
	dim = 32;
	//int ProductoInterno(short *A, short *B, int dimension);
	short* vec_short_A_2 = (short*) malloc(sizeof(short)*dim);
	short* vec_short_B_2 = (short*) malloc(sizeof(short)*dim);
	
	// {v1,...,vn}x{w1,...,wn} = v1*w1 + ... + vn*wn
	int upper = 20; //0x7FFF;
	int lower = 0;
	srand(1);
	for (int i = 0; i < dim; i++) {
		int num = (rand() % (upper - lower + 1)) + lower;
		vec_short_A_2[i] = num;
	}
	srand(2);
	for (int i = 0; i < dim; i++) {
		int num = (rand() % (upper - lower + 1)) + lower;
		vec_short_B_2[i] = num;
	}
	printVector_short(vec_short_A_2, dim, 0);
	printVector_short(vec_short_B_2, dim, 0);
	
	int accum = 0;
	for (int i = 0; i < dim; i++) {
		accum += vec_short_A_2[i] * vec_short_B_2[i]; 
	}
	int res_fun = ProductoInterno(vec_short_A_2, vec_short_B_2, dim);
	printf("ESPERADO = %d\n", accum);
	printf("RESULTADO = %d\n", res_fun);
	
	//assert(res_fun==accum);
	
	
	printf("\n--------------------------------------------------\n");
	free(vec_short_A);
	free(vec_short_B);
	free(vec_int_Res);
	
	free(vec_short_A_2);
	free(vec_short_B_2);
	return 0;
}
