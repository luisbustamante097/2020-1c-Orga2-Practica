global sumarVectores

section .text
sumarVectores:
	push rbp
	mov rbp, rsp
	
	;void SumarVectores(char *A, char *B, char *Resultado, int dimension);
	; Puede asumir que la dimension de los vectores es de un tamaño multiplo 
	; de la cantidad de elementos que procesa simultaneamente.
	;	Dimension = 16B * k
	; 	rdi <- char *A
	; 	rsi <- char *B
	; 	rdx <- char *Resultado
	; 	ecx <- dimension

	;ecx = ecx/128  (128 = 16B) y (128= 2 << 7)
	shl ecx, 7
.ciclo:
		;MOVDQU xmm1, xmm2/m128
		movdqu xmm0, [rdi]		;xmm0 = |x0|...|xF|
		movdqu xmm1, [rsi]		;xmm1 = |y0|...|yF|
		
		paddb xmm0, xmm1		;xmm0 = |x0+y0|...|xF+yF|
		movdqu [rdx], xmm0
		
		lea rdi, [rdi + 16]
		lea rsi, [rsi + 16]
		lea rdx, [rdx + 16]
	
	loop .ciclo
	
	pop rbp
	ret