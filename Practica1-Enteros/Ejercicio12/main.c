// Escribir una funcion en lenguaje ensamblador que,
// dado un vector v de numeros de 64 bits sin signo y
// de dimension n, calcule la suma de todos los elementos de v.
// Puede asumirse que esta suma no supera los 64 bits.
// El prototipo de la funci ́ones el siguiente:
// long sumarTodos(long *v, unsigned short n);

#include <stdio.h>

extern long sumarTodos(long *v, unsigned short n);
long sumarTodos_c(long *v, unsigned short n);

int main (){
	long vector[7] = {1,2,3,4,5,6,7};
	long res_c = sumarTodos_c(vector, 7);
	long res = sumarTodos(vector, 7);
	printf("Suma: %lu \nSuma en ASM: %lu \n", res_c, res);
	//printf("Suma: %lu \n", res_c);
	return 0;
}

long sumarTodos_c(long *v, unsigned short n){
	long res = 0;
	for (int i=0;i<n;i++){
		res = res + v[i];
	}
	return res;
}
