#ifndef _BINARY_TREE_HEADER_
#define _BINARY_TREE_HEADER_

#include <stdio.h>
#define COUNT 5

typedef struct _node_t {
	char *key;				// 8B | 0
	char *value;			// 8B | 8
	struct _node_t *izq;	// 8B | 16
	struct _node_t *der;	// 8B | 24
} node;						//	  | 32 <-

typedef struct _dicc_bt_t {
	node *root;				// 8B | 0
} dicc_bt;					//    | 8 <-

void print_tree(node *root, int space){
	// Base case
	if (root == NULL)
		return;
	// Increase distance between levels
	space += COUNT;

	// Process right child first
	print_tree(root->der, space);

	// Print current node after space
	// count
	//printf("\n");
	for (int i = COUNT; i < space; i++)
		printf(" ");
	printf("(%p) ", root);
	printf("%s (izq: %p, der: %p), %s \n", root->key, root->izq, root->der, root->value);

	// Process left child
	print_tree(root->izq, space);
}

#endif
