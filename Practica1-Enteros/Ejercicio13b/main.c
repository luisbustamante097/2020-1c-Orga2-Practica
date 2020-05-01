// Se tiene una matriz M que almacena numeros de 64 bits con signo,
// cuya dimension es n × n (n de 16 bits sin signo).
// Escriba en lenguaje ensamblador:
// long diagonalesIguales(long *M, unsigned short n):
// Una funcion que indique si la suma de los elementos de la diagonal
// principal es igual a la suma de elementos de la diagonal traspuesta.

#include <stdio.h>

extern int diagonalesIguales(long *M, unsigned short n);
int diagonalesIguales_c(long *M, unsigned short n);

int main (){
	short int n = 3;
	long int matrix_diag_eq[3][3] ={{10	,5	,10	},
									{5	,11	,5	},
									{10	,5	,10	}};
	long int matrix_not_diag_eq[3][3] ={{10	,5	,15	},
										{5	,11	,5	},
										{12	,5	,10	}};
	int res_diag_eq_c_ = diagonalesIguales_c((long*) matrix_diag_eq, n);
	int res_not_diag_eq_c = diagonalesIguales_c((long*) matrix_not_diag_eq, n);
	int res_diag_eq = diagonalesIguales((long*) matrix_diag_eq, n);
	int res_not_diag_eq = diagonalesIguales((long*) matrix_not_diag_eq, n);

	//printf("Suma: %lu \nSuma en ASM: %lu \n", res_c, res);
	printf("Suma de diagonales iguales?: %d \n", res_diag_eq_c_ ? 1 : 0);
	printf("Suma de diagonales No iguales?: %d \n", res_not_diag_eq_c ? 1 : 0);
	printf("_ASM_Suma de diagonales iguales?: %d \n", res_diag_eq ? 1 : 0);
	printf("_ASM_Suma de diagonales No iguales?: %d \n", res_not_diag_eq ? 1 : 0);
	return 0;
}

int diagonalesIguales_c(long *M, unsigned short n){
	long (*matrix)[n] = (long (*)[n]) M;
	long main_diag = 0;
	long reverse_diag = 0;
	int j = n-1;
	for (int i=0;i<n;i++){
		main_diag += matrix[i][i];
		reverse_diag += matrix[i][j];
		j--;
	}

	return main_diag == reverse_diag;
}
