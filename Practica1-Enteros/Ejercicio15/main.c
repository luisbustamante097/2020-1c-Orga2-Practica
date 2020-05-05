// Dado un nuevo tipo de datos llamado "lista" para manejar enteros con signo,
// cuya definicion en C es la siguiente:
	// typedef struct nodo_t {
	// 	long    dato;          /* dato del nodo (un entero) */
	// 	struct  nodo_t *prox;  /* puntero al siguiente */
	// } nodo;
	// typedef struct lista_t {
	// 	nodo*   primero;       /* puntero al primer nodo */
	// } lista;
// a) int iesimo(lista* l, unsigned long i):
// 	Escriba una funcion que dada una lista y un entero i devuelva el iesimo
// 	elemento de la lista.
// b) void agregarAd(lista* l, long n):
// 	Escriba una funcion que dada una lista y un entero n lo agregue
// 	al comienzo de la lista.
// c) Escribir las funciones en lenguaje ensamblador
// 	que permitan buscar un elemento en una lista,
// 	agregarlo en una posicion arbitraria y quitarlo respectivamente.
// 	Pensar en como debe ser el prototipo de cada una
// 	(atender al uso de punteros y las funciones malloc y free)

#include <stdio.h>
#include <stdlib.h>
#include "list.h"
#include <malloc.h>
//#include "c_functions.h"

extern long iesimo(list* l, unsigned long i);
extern void agregarAd(list* l, long n);
extern void borrarTodos(list* l);
extern short int buscarElemento(list *l, long n);
extern void agregarEnPos(list* l, unsigned long i, long n);
extern void borrarPorPos(list* l, unsigned long i);

int main(int argc, char const *argv[]) {
	int op = 1;
	list* lista = (list*) malloc(8);
	lista->primero = NULL;
	while (op != 0){
		printf("---------------------------------------\n");
		printf("Operaciones: \n");
		printf("1) Agregar Adelante \n");
		printf("2) Mostrar Lista \n");
		printf("3) Buscar Elemento \n");
		printf("4) Iesimo Elemento \n");
		printf("5) Agregar en posicion i \n");
		printf("6) Quitar de posicion i \n");
		printf("7) Borrar Todos\n");
		printf("0) SALIR \n");
		printf("Ingrese la operacion: ");
		scanf("%du\n", &op);

		switch (op) {
			case 1:{
				printf("Lista original:\n");
				printlist(lista);

				long nuevoNro;
				printf("\nNro a ingresar: ");
				scanf("%lu", &nuevoNro);

				agregarAd(lista, nuevoNro);

				printf("Lista nueva:\n");
				printlist(lista);
				break;
			}
			case 2:{
				printf("Lista actual:\n");
				printlist(lista);
				break;
			}
			case 3:{
				long nroBuscado;
				printf("\nNro a buscar: ");
				scanf("%lu", &nroBuscado);

				short int res = buscarElemento(lista, nroBuscado);
				printf("El numero %lu", nroBuscado);
				if (res == 0){
					printf(" NO fue encontrado \n");
				}else{
					printf(" SI fue encontrado \n");
				}
				break;
			}
			case 4:{
				unsigned long int i;
				printf("Ingrese la posicion del nodo: ");
				scanf("%lu", &i);
				long num  = iesimo(lista, i);
				printf("El nodo numero %lu es igual a: %ld \n", i, num);
				break;
			}
			case 5:{
				printf("Lista original:\n");
				printlist(lista);

				unsigned int i;
				long nuevoNro;
				printf("Ingrese el nro del nodo: ");
				scanf("%d", &i);
				printf("\nNro a ingresar: ");
				scanf("%lu", &nuevoNro);
				agregarEnPos(lista, i, nuevoNro);

				printf("Lista nueva:\n");
				printlist(lista);
				break;
			}
			case 6:{
				printf("Lista original:\n");
				printlist(lista);

				unsigned int i;
				printf("Ingrese el nro del nodo: ");
				scanf("%d", &i);
				borrarPorPos(lista, i);

				printf("Lista nueva:\n");
				printlist(lista);
				break;
			}
			case 7:{
				borrarTodos(lista);
				break;
			}
			case 0:
				free(lista);
				printf("-----SALIR----- \n");
				return 0;
			default:
				printf("-----SALIR----- \n");
				return 0;
		}
		printf("\n--------------------------- ");
		printf("\n Continuar?: ");
		scanf("%d", &op);
	}
	free(lista);
	return 0;
}
