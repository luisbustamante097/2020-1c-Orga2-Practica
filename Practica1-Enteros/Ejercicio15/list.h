#ifndef _LISTA_HEADER_
#define _LISTA_HEADER_

#include <stdio.h>

typedef struct node_t {
	long dato;  			// 8B	|	0
	struct node_t *prox;  	// 8B	|	8
} node;						//		|	16

typedef struct list_t {
	node *primero;   		// 8B	|	0
} list;						// 		|	8

void printlist(list* list){
	node* actual = list->primero;
	printf("Primero: %p\n", actual);
	int i=0;
	while(actual!=NULL){
		printf("(%p) nodo %d: (%ld, %p) \n",actual, i, actual->dato, actual->prox);
		actual = actual->prox;
		i++;
	}
}

#endif
