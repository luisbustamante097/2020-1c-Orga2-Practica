#include <stdio.h>
extern void imprimir_interrupciones(char mascara_pic);

int main(int argc, char const *argv[]){
    char mascara_pic = 0b01010010;
    imprimir_interrupciones(mascara_pic);
	return 0;
}


void imprimir_interrupciones(char mascara_pic){
	int i = 0;
	while (i<8) {
		if (mascara_pic & (0b1 << i)){
			printf("La interrupcion %d esta prendida \n", i);
		}
		i++;
	}
}
