#include <stdio.h>
extern void imprimir_interrupciones(char mascara_pic[16]);

int main(int argc, char const *argv[]){
    char mascara_pic[16] = {0,1,0,1,0,0,1,0};
    imprimir_interrupciones(mascara_pic);
	return 0;
}
