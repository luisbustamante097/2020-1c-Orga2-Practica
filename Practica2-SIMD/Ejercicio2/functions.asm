global InicializarVector
global DividirVectorPorPotenciaDeDos
global FiltrarMayores

section .text
InicializarVector:
	push rbp
	mov rbp, rsp
	
	;void InicializarVector(short *A, short valorInicial, int dimension);
	;Dimension = 16B * k
	; 	rdi <- short *A
	; 	si <- short valorInicial
	; 	edx <- int dimension
	
	xor rcx, rcx
	
.llenar:
	cmp ecx, 16
	je .next_step
		mov WORD [rdi + rcx], si
		add rcx, 2
		jmp .llenar
.next_step:		
	;[rdi] = |si|...|si|
	
	movdqu xmm0, [rdi]
	mov ecx, edx
	;ecx = ecx/8 y (8 = 2^3) (porque hay 8 shorts en 16B)
	shr ecx, 3
.ciclo:
		movdqu [rdi], xmm0

		lea rdi, [rdi + 16]
	loop .ciclo
	
	pop rbp
	ret

DividirVectorPorPotenciaDeDos:
	push rbp
	mov rbp, rsp
	;void DividirVectorPorPotenciaDeDos(int *A, int potencia, int dimension);
	;Dimension = 16B * k
	;	rdi <- int *A
	;	esi <- int potencia
	;	edx <- dimension
	
	mov ecx, edx
	pxor xmm1, xmm1
	
	;MOVD xmm, r/m32
	movd xmm1, esi
	
	shr rcx, 2		; rcx = n/4	(porque hay 4 int's en 16B)
	
.ciclo:	
		;levanto de memoria los 16B
		movdqu xmm0, [rdi]
		
		;shifteo lo que diga en esi
		;PSRLD xmm1, xmm2/m128
		psrld xmm0, xmm1
		
		;vuelco en memoria los 16B
		movdqu [rdi], xmm0
		
		lea rdi, [rdi + 16]
	
	loop .ciclo
	 

	pop rbp
	ret

FiltrarMayores:
	push rbp
	mov rbp, rsp
	
	;void FiltrarMayores(short *A, short umbral, int dimension)
	; Pone  en  unos  (0xF...F)  aquellos elementos del vector
	; cuyo valor sea mayor al umbral y en ceros (0x0...0)
	; aquellos que sean menores o iguales.
	; 	rdi <- short *A
	;	si <- short umbral
	;	edx <- int dimension
	
	mov ecx, edx
	
	pxor xmm1, xmm1
	pxor xmm2, xmm2
	
	mov ax, si			;temp
	movzx esi, si		;|xxxx|xxxx|0000|si  |
	shl esi, 16			;|xxxx|xxxx|si  |0000|
	mov si, ax			;|xxxx|xxxx|si  |si  |
	
	shl rsi, 16			;|xxxx|si  |si  |0000|
	mov si, ax			;|xxxx|si  |si  |si  |
	shl rsi, 16			;|si  |si  |si  |0000|
	mov si, ax			;|si  |si  |si  |si  |

	
	
	movq xmm1, rsi		;xmm1 = |0000|0000|0000|0000|si|si|si|si|
	movdqu xmm2, xmm1	;xmm2 = |0000|0000|0000|0000|si|si|si|si|
	;PSLLDQ xmm1, imm8 		;imm8 = Bytes
	pslldq xmm1, 8		;|si|si|si|si|0000|0000|0000|0000|
	por xmm1, xmm2		;|si|si|si|si|si|si|si|si|
	
	
	
	
	shr ecx, 3	; ecx = n/8
	
.ciclo:
		;levanto de memoria los 16B
		movdqu xmm0, [rdi]
		
		pcmpgtw xmm0, xmm1
		
		;vuelco en memoria los 16B
		movdqu [rdi], xmm0
		
		lea rdi, [rdi + 16]
	loop .ciclo
	
	
	pop rbp
	ret