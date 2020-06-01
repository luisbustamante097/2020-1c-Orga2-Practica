global Intercalar

section .rodata
ALIGN 16
mask_intercalar_l: DB 0x00,0xFF,0x01,0xFF,0x02,0xFF,0x03,0xFF,0x04,0xFF,0x05,0xFF,0x06,0xFF,0x07,0xFF
mask_intercalar_h: DB 0x08,0xFF,0x09,0xFF,0x0A,0xFF,0x0B,0xFF,0x0C,0xFF,0x0D,0xFF,0x0E,0xFF,0x0F,0xFF

mask_first_byte_FF: DB -1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

section .text
Intercalar:
	push rbp
	mov rbp, rsp
	;void Intercalar(char *A, char *B, char *vectorResultado, int dimension)
	; rdi <- char *A
	; rsi <- char *B
	; rdx <- char *vectorResultado
	; ecx <- int dimension
	
	xor eax, eax
	shr ecx, 4			;ecx=dim/16 (porque en 16B entran 16 chars)
	
	movdqu xmm2, [mask_intercalar_l]
	movdqu xmm3, [mask_intercalar_h]
	
	movdqu xmm4, [mask_first_byte_FF]
	
.ciclo:
	cmp eax, ecx
	je .end
		movdqu xmm0, [rdi]
		movdqu xmm1, [rsi]
		
		movdqu xmm15, xmm0
		
		pshufb xmm0, xmm2
		pshufb xmm15, xmm3
		
		psLldq xmm2, 1
		psLldq xmm3, 1
		
		por xmm2, xmm4
		por xmm3, xmm4
		
		movdqu xmm14, xmm1
		
		pshufb xmm1, xmm2
		pshufb xmm14, xmm3
		
		por xmm0, xmm1
		por xmm15, xmm14
		
		movdqu [rdx], xmm0
		lea rdx, [rdx + 16]
		movdqu [rdx], xmm15
		
		
		lea rdi, [rdi + 16]
		lea rsi, [rsi + 16]
		lea rdx, [rdx + 16]
		
		inc eax
		jmp .ciclo
	
	.end:
	pop rbp
	ret