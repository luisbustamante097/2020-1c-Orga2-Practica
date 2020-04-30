#include <stdio.h>

extern unsigned int cantFactoresPrimos(unsigned long n);

int main(int argc, char const *argv[]){
	unsigned long n = 100;
	unsigned int res = cantFactoresPrimos(n);
	printf ("%d \n", res);
	return 0;
}
//
// unsigned cantFactoresPrimos(unsigned long n){
// 	unsigned int k = 1, d = 2;
// 	while(d*d <= n) {
// 		if (n % d == 0){
// 			k++;
// 			n = n/d;
// 		}
// 		else d++;
// 	}
// 	return k;
// }
