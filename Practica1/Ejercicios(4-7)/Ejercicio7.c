#include <stdio.h>
extern void imprimir_interrupciones(char mascara_pic);

int main(int argc, char const *argv[]){
    char mascara_pic = 0b01010010;
    imprimir_interrupciones(mascara_pic);
	return 0;
}
