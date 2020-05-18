#include <stdio.h>
#include <malloc.h>

typedef enum action_e {
	borrar=0,
	duplicar=1
} action;

typedef struct eslabon_t{
	char base;								//1	| 0
	struct eslabon_t* eslabon_pareja;		//8	| 1
	struct eslabon_t* eslabon_inferior;		//8	| 9
} __attribute__((__packed__)) eslabon;		//	| 17

eslabon* ordenarCadena(eslabon* primer_eslabon, enum action_e (*cmpBase)(char* base1, char* base2)){
	if (primer_eslabon == NULL){
		return NULL;
	}
	eslabon **padre_izq = &primer_eslabon;
	eslabon **padre_der = &primer_eslabon->eslabon_pareja;
	eslabon *actual_izq = primer_eslabon;
	eslabon *actual_der = primer_eslabon->eslabon_pareja;

	while (actual_izq != NULL){
		action accion = cmpBase(&actual_izq->base, &actual_der->base);
		if (accion == borrar){
			if (*padre_izq == primer_eslabon){
				primer_eslabon = actual_izq->eslabon_inferior;
				free(actual_izq);
				free(actual_der);
			}
			padre_izq = &actual_izq->eslabon_inferior;
			padre_der = &actual_der->eslabon_inferior;
			free(actual_izq);
			free(actual_der);
		}else if (accion==duplicar){
			eslabon *dup_eslabon_izq = (eslabon*) malloc(17);
			eslabon *dup_eslabon_der = (eslabon*) malloc(17);
			dup_eslabon_izq->base = actual_izq->base;
			dup_eslabon_izq->eslabon_pareja = dup_eslabon_der;
			dup_eslabon_izq->eslabon_inferior = actual_izq->eslabon_inferior;
			dup_eslabon_der->base = actual_der->base;
			dup_eslabon_der->eslabon_pareja = dup_eslabon_izq;
			dup_eslabon_der->eslabon_inferior = actual_der->eslabon_inferior;

			actual_izq->eslabon_inferior = dup_eslabon_izq;
			actual_der->eslabon_inferior = dup_eslabon_der;

			actual_izq = dup_eslabon_izq->eslabon_inferior;
			actual_der = dup_eslabon_der->eslabon_inferior;
		}

	}

	return primer_eslabon;
}
