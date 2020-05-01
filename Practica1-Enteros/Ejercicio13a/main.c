// Se tiene una matriz M que almacena numeros de 64 bits con signo,
// cuya dimension es n × n (n de 16 bits sin signo).
// Escriba en lenguaje ensamblador:
// long esSimetrica(long *M, unsigned short n):
// Una funcion que indique si la matriz M es simetrica.

#include <stdio.h>

extern int esSimetrica(long *M, unsigned short n);
int esSimetrica_c(long *M, unsigned short n);

int main (){
	short int n = 3;
	long int sim_matrix[3][3] ={{15	,10	,11},
								{10	,15	,12},
								{11	,12	,15}};
	long int not_sim_matrix[3][3] ={{1	,0	,10},
									{0	,1	,0},
									{15	,0	,1}};
	int res_c_sim = esSimetrica_c((long*) sim_matrix,n);
	int res_c_not_sim = esSimetrica_c((long*) not_sim_matrix,n);
	int res_sim = esSimetrica((long*) sim_matrix,n);
	int res_not_sim = esSimetrica((long*) not_sim_matrix,n);

	//printf("Suma: %lu \nSuma en ASM: %lu \n", res_c, res);
	printf("Sim es simetrica?: %d \n", res_c_sim ? 1 : 0);
	printf("NoSim es simetrica?: %d \n", res_c_not_sim ? 1 : 0);
	printf("_ASM_Sim es simetrica?: %d \n", res_sim ? 1 : 0);
	printf("_ASM_NoSim es simetrica?: %d \n", res_not_sim ? 1 : 0);
	return 0;
}

int esSimetrica_c(long *M, unsigned short n){
	long (*matrix)[n] = (long (*)[n]) M;
	int res = 1;
	for (int i=0;i<n;i++){
		for (int j = i; j < n; j++) {
			if (i!=j && matrix[i][j] != matrix[j][i]){
				res = 0;
			}
		}
	}

	return res;
}
