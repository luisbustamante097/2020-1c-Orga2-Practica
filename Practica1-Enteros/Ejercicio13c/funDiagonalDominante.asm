global diagonalDominante
section .data
	sizeofLong: DB 0x8

section .text
	diagonalDominante:
		push rbp
		mov [rsp], rbp
		push rbx
		push r12
		push r13
		push r14

		;extern int diagonalDominantes(long *M, unsigned short n);
		;di <- unsigned short n
		;rsi <- long *M

		%define n		rsi
		%define	_M		rdi
		%define i		rcx
		%define j		r12
		%define accum		r13		;accumalor
		%define m_i_i		r14		;auxiliar

		;--limpio parte alta de revdi
		movsx rsi, si
		;--inicializo
		xor i, i								;i <- 0
		xor rax, rax							;rax <- 0
		;-----------ciclo p.finCicloColsara recorrer matriz
	.cicloFilas:
		cmp i, n								;i < n ?
		je .finCiclo
			xor accum, accum
			xor j, j							;	j = 0
	.cicloCols:
				cmp j, n						;	j < n ?
				je .finCicloFilas
				;-----------
					;---[base + <j*8*n> + <i*8>]
					mov rax, n
					mul byte [sizeofLong]
					mul i
					lea rbx, [rax + j*8]
					mov rax, [_M + rbx]			;		rax <- m[i][j]
					;---
					;----Valor abs de rax
					mov rbx, rax
					neg rax
					cmovl rax, rbx ;if rax < 0, se restaura
					; ahora rax <- |m[i][j]|
					;----

					cmp i, j
					je 	.guardarM_i_i			;		i != j?
						add accum, rax			;			accum += rax
						jmp .finCicloCols
	.guardarM_i_i:	; else
					;guardo m[i][i]
						mov m_i_i, rax			; m_i_i <- m[i][i]
				;-----------
	.finCicloCols:
				inc j							;	j++
				jmp .cicloCols
	.finCicloFilas:
			cmp m_i_i, accum
			jge	.auxFinCicloFilas				;|m[i][i]| < accum ?
				xor eax, eax
				jmp .fin						;	return 0
	.auxFinCicloFilas:
			inc i								;i++
			jmp .cicloFilas
		;-----------ciclo para recorrer matriz
	.finCiclo:
		mov eax, 1							;return 1
	.fin:
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret
