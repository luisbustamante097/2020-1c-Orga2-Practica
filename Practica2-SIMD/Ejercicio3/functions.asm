global MultiplicarVectores
global ProductoInterno

section .text
MultiplicarVectores:
		push rbp
		mov rbp, rsp
		
		;void MultiplicarVectores(short *A, short *B, int *Res, int dimension)
		;	rdi <- short *A
		;	rsi <- short *B
		;	rdx <- int *Res
		;	ecx <- int dimension
		
		%define A_ptr		rdi
		%define B_ptr		rsi
		%define Res_ptr		rdx
		%define dim			ecx
		
		shr dim, 3 ; ecx = dim/8  (porque en 16B entran 8 shorts)
		
	.ciclo:
			movdqu xmm0, [A_ptr]
			movdqu xmm1, xmm0
			movdqu xmm2, [B_ptr]
			
			;xmm0 = |x0|x1|x2|x3|x4|x5|x6|x7|
			;xmm1 = |x0|x1|x2|x3|x4|x5|x6|x7|
			;xmm2 = |y0|y1|y2|y3|y4|y5|y6|y7|
			
			;PMULLW xmm1, xmm2/m128
			pmullw xmm1, xmm2
			;xmm1 = |x0*y0[15:0]|...|x7*y7[15:0]|	
			movdqu xmm0, xmm1

			pmulhw xmm2, xmm0
			;xmm2 = |x0*y0[31:16]|...|x7*y7[31:16]|
			
			;PUNPCKxBW xmm1, xmm2/m128
			;		   (dest)  (source)
			punpcklwd xmm1, xmm2
			;xmm1 = |x0*y0|x1*y1|x2*y2|x3*y3|
			
			punpckhwd xmm0, xmm2
			;xmm0 = |x4*y4|x5*y5|x6*y6|x7*y7|
			
			movdqu [Res_ptr], xmm1
			lea rax, [Res_ptr + 16]
			movdqu [rax], xmm0
			
			
			lea A_ptr, [A_ptr + 16]
			lea B_ptr, [B_ptr + 16]
			lea Res_ptr, [Res_ptr + 32]

		loop .ciclo
		
		pop rbp
		ret

ProductoInterno:	
		push rbp
		mov rbp, rsp
		;int ProductoInterno(short *A, short *B, int dimension)
		;	rdi <- short *A
		;	rsi <- short *B
		;	rdx <- int dimension
		
		mov ecx, edx
		
		%define A_ptr		rdi
		%define B_ptr		rsi
		%define dim			ecx
		%define accum		eax
		
		xor accum, accum
		
		shr dim, 3 ; ecx = dim/8  (porque en 16B entran 8 shorts)
		;HINT: {v1,...,vn}x{w1,...,wn} = v1*w1 + ... + vn*wn
	.ciclo:
			movdqu xmm0, [A_ptr]
			movdqu xmm1, [B_ptr]
			;xmm0 = |x0|x1|x2|x3|x4|x5|x6|x7|
			;xmm1 = |y0|y1|y2|y3|y4|y5|y6|y7|

			;PMADDWD - Multiply and Add Packed Integers
			pmaddwd xmm0, xmm1
			;xmm0 = |x0*y0+x1*y1|...|...|x6*y6+x7*y7|
			;xmm0 = | S0 | S1 | S2 | S3 |
			
			;PHADDD - Packed Horizontal Add
			phaddd xmm0, xmm0
			;xmm0 = | S0+S1 | S2+S3 | S0+S1 | S2+S3 |
			phaddd xmm0, xmm0
			;xmm0 = |S0+S1+S2+S3|S0+S1+S2+S3|S0+S1+S2+S3|S0+S1+S2+S3|
			
			movd edx, xmm0
			
			add accum, edx
			
			lea A_ptr, [A_ptr + 16]
			lea B_ptr, [B_ptr + 16]
		loop .ciclo

		pop rbp
		ret
