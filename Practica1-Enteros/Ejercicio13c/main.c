// Se tiene una matriz M que almacena numeros de 64 bits con signo,
// cuya dimension es n × n (n de 16 bits sin signo).
// Escriba en lenguaje ensamblador:
// long diagonalDominante(long *M, unsigned short n)
// Una funcion que indique si la matriz M es diagonal dominante.
// Formalmente, se dice que la matriz M de dimension n×n
// es diagonal dominante cuando se satisface,
// |m[i][i]| >= sum{j=1 to n with j!=i} |m[i][j]| \forall {i= 1. . . n}

#include <stdio.h>
#include <math.h>

extern int diagonalDominante(long *M, unsigned short n);
int diagonalDominante_c(long *M, unsigned short n);

int main (){
	short int n = 3;
	long int matrix_diag_dom[3][3] ={	{-9	,7	,-1	},
										{5	,10	,4	},
										{3	,-8	,-11}};
	long int matrix_not_diag_dom[3][3] ={	{10	,11	,-2	},
											{-5	,11	,15	},
											{12	,5	,-10}};
	int res_diag_dom_c_ = diagonalDominante_c((long*) matrix_diag_dom, n);
	int res_not_diag_dom_c = diagonalDominante_c((long*) matrix_not_diag_dom, n);
	int res_diag_dom = diagonalDominante((long*) matrix_diag_dom, n);
	int res_not_diag_dom = diagonalDominante((long*) matrix_not_diag_dom, n);

	printf("Suma de diagonales iguales?: %d \n", res_diag_dom_c_ ? 1 : 0);
	printf("Suma de diagonales No iguales?: %d \n", res_not_diag_dom_c ? 1 : 0);
	printf("_ASM_Suma de diagonales iguales?: %d \n", res_diag_dom ? 1 : 0);
	printf("_ASM_Suma de diagonales No iguales?: %d \n", res_not_diag_dom ? 1 : 0);
	return 0;
}

int diagonalDominante_c(long *M, unsigned short n){
	long (*matrix)[n] = (long (*)[n]) M;
	unsigned long aux_abs = 0;
	long aux = 0;
	for (int i=0;i<n;i++){
		unsigned long a = 0;
		for (int j=0;j<n;j++){
			if (i!=j){
				aux = matrix[i][j];
				aux_abs = ( aux < 0 ? 0-aux : aux);
				a += aux_abs;
			}
		}
		aux = matrix[i][i];
		aux_abs = ( aux < 0 ? 0-aux : aux);
		if (aux_abs < a){
			return 0;
		}
	}

	return 1;
}
