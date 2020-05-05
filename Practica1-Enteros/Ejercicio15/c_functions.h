#include "list.h"
#include <malloc.h>

long iesimo(list* l, unsigned long i){
	if (l->primero==NULL){
		return 0;
	}
	node* actual = l->primero;
	while (actual!= NULL) {
		if (i == 0){
			return actual->dato;
		}
		i--;
		actual = actual->prox;
	}
	return 0;
}

void agregarAd(list* l, long n){
	node* nodo_nuevo = (node*) malloc(16);
	nodo_nuevo->dato = n;
	nodo_nuevo->prox = NULL;
	if (l->primero==NULL){
		l->primero = nodo_nuevo;
	} else{
		node* nodo_primero = l->primero;
		l->primero = nodo_nuevo;
		nodo_nuevo->prox = nodo_primero;
	}
}
