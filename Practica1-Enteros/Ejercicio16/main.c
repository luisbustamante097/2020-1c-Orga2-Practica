// Sea el siguiente tipo de datos "dicc"(diccionario sobre arbol binario)
// para manejar claves y significados, se piden definir en
// lenguaje ensamblador las funciones que permitan obtener
// el significado de una palabra, agregar una nueva definicion,
// modificarla y eliminarla respectivamente.
// Pensar en el prototipo de las funciones y el manejo de punteros

#include <stdio.h>
#include <stdlib.h>
#include <malloc.h>
#include "binary_tree.h"
//#include "c_functions.h"

#define MAX_LENGTH 30

void print_tree(node* root, int space);
void new_def(dicc_bt *dicc, char *key, char *value);
char* fetch_def(dicc_bt *dicc, char *key);
void change_def(dicc_bt *dicc, char *key, char *value);
void delete_def(dicc_bt *dicc, char *key);
void delete_all(dicc_bt *dicc);
int is_greater(char *key1, char *key2);
int is_equal(char *key1, char *key2);

int main(int argc, char const *argv[]) {
	int op = 1;
	dicc_bt* dicc = (dicc_bt*) malloc(8);
	dicc->root = NULL;
	while (op != 0){
		printf("---------------------------------------\n");
		printf("Operaciones: \n");
		printf("1) Agregar definicion \n");
		printf("2) Obtener definicion \n");
		printf("3) Modificar definicion \n");
		printf("4) Eliminar definicion \n");
		printf("5) Ver Arbol \n");
		printf("6) Borrar Todos\n");
		printf("0) SALIR \n");
		printf("Ingrese la operacion: ");
		scanf("%du\n", &op);

		switch (op) {
			case 1:{
				printf("Arbol original:\n");
				print_tree(dicc->root, 0);

				char* new_key = (char*) malloc(MAX_LENGTH);
				char* new_value = (char*) malloc(MAX_LENGTH);
				printf("\nNueva Clave: ");
				scanf("%s", new_key);
				printf("\nSignificado de Nueva Clave: ");
				scanf("%s", new_value);

				new_def(dicc, new_key, new_value);

				printf("Arbol nuevo:\n");
				print_tree(dicc->root, 0);
				break;
			}
			case 2:{
				char key[MAX_LENGTH];
				printf("\nDefinicion a buscar: ");
				scanf("%s", key);
				char* value_found = fetch_def(dicc, key);
				if (value_found != NULL){
					printf("El significado de '%s' es: %s\n", key, value_found);
				}else{
					printf("No se encontro la definicion buscada\n");
				}
				break;
			}
			// case 3:{
			// 	printf("Arbol original:\n");
			// 	print_tree(dicc->root, 0);
			//
			// 	char key[MAX_LENGTH];
			// 	char new_value[MAX_LENGTH];
			// 	printf("\nClave a modificar: ");
			// 	scanf("%s", key);
			// 	printf("\nNuevo significado de Clave: ");
			// 	scanf("%s", new_value);
			//
			// 	change_def(dicc, key, new_value);
			//
			// 	printf("Arbol nuevo:\n");
			// 	print_tree(dicc->root, 0);
			// 	break;
			// }
			// case 4:{
			// 	printf("Arbol original:\n");
			// 	print_tree(dicc->root, 0);
			//
			// 	char key[MAX_LENGTH];
			// 	printf("\nClave a Borrar ");
			// 	scanf("%s", key);
			//
			// 	delete_def(dicc, key);
			//
			// 	printf("Arbol nuevo:\n");
			// 	print_tree(dicc->root, 0);
			// 	break;
			// }
			case 5:{
				printf("------------------\n");
				printf("Arbol actual:\n");
				print_tree(dicc->root, 0);
				break;
			}
			case 6:{
				delete_all(dicc);
				printf("Todo fue borrado\n");
				break;
			}
			case 0:
				free(dicc);
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
	free(dicc);
	return 0;
}
