global SumarErroresResiduales

section .rodata
ALIGN 16


section .text
SumarErroresResiduales:
	push rbp
	mov rbp, rsp
	;void SumarErroresResiduales(float *A, float *B, float* Res, int dimension)
	; rdi <- float *A
	; rsi <- float *B
	; rdx <- float *Res
	; ecx <- int dimension
	
	xor eax, eax
	xor r8d, r8d
	xor r9d, r9d
	shr ecx, 2			;ecx=dim/4 (porque en 16B entran 4 floats)
	
	pxor xmm15, xmm15
	
.ciclo:
	cmp r8d, ecx
	je .end
		movups xmm0, [rdi]
		movups xmm1, [rsi]
		; xmm0 = |A_f0|A_f1|A_f2|A_f3|
		; xmm1 = |B_f0|B_f1|B_f2|B_f3|
		
		addps xmm0, xmm1
		; xmm0 = |A_f0+B_f0|A_f1+B_f1|A_f2+B_f2|A_f3+B_f3|
		
		mulps xmm0, xmm0
		; xmm0 = |(A_f0+B_f0)^2|(A_f1+B_f1)^2|(A_f2+B_f2)^2|(A_f3+B_f3)^2|
		
		haddps xmm0, xmm0
		; xmm0 = |(A_f0+B_f0)^2+(A_f1+B_f1)^2|(A_f2+B_f2)^2+(A_f3+B_f3)^2|
		;		 |(A_f0+B_f0)^2+(A_f1+B_f1)^2|(A_f2+B_f2)^2+(A_f3+B_f3)^2|
		
		haddps xmm0, xmm0
		; xmm0 = "times 4 |(A_f0+B_f0)^2+(A_f1+B_f1)^2+(A_f2+B_f2)^2+(A_f3+B_f3)^2|"
		
		addps xmm15, xmm0 ;xmm15 = accum
		
		lea rdi, [rdi + 16]
		lea rsi, [rsi + 16]
		
		inc r8d
		jmp .ciclo
	
	.end:
	
	extractps eax, xmm15, 0x0
	mov [rdx], eax
	pop rbp
	ret