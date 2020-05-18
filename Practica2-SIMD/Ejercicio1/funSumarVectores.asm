global sumarVectores

section .text
sumarVectores:
	push rbp
	mov rbp, rsp
	
	;void SumarVectores(char *A, char *B, char *Resultado, int dimension);
	; Puede asumir que la dimension de los vectores es de un tamaño multiplo 
	; de la cantidad de elementos que procesa simultaneamente.
	; 	rdi <- char *A
	; 	rsi <- char *B
	; 	rdx <- char *Resultado
	; 	ecx <- dimension
	
	
	
	
	 
	
	pop rbp
	ret
	