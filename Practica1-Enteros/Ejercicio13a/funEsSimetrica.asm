global esSimetrica
section .data
	sizeofLong: DB 0x8

section .text
	esSimetrica:
		push rbp
		mov [rsp], rbp
		push rbx
		push r12

		;extern int esSimetrica(long *M, unsigned short n)
		;di <- unsigned short n
		;rsi <- long *M

		%define n		rsi
		%define	_M		rdi
		%define i		rcx
		%define j		r12

		;--limpio parte alta de rdi
		movsx rsi, si

		;--inicializo
		xor i, i								;i <- 0
		;xor j, j								;j <- 0
		xor rax, rax							;rax <- 0

	;-----------ciclo para recorrer matriz
	.cicloFilas:
			cmp i, n							;i < n ?
			je .fin

				mov j, i						;	j = i
	.cicloCols:
				cmp j, n						;	j < n ?
				je .finCicloFilas
				;-----------
				cmp j, i						;	j =! i ?
				je .finCicloCols

					;quiero M[i][j]
					;----calculo <i> * <sizeof(long)*|fila|>
					mov rax, n
					mul byte [sizeofLong]
					mul i
					;----calculo dir [<i*sizeof(long)*|fila|> + <j*sizeof(long)>]
					lea rbx, [rax + j*8]
					;----accedo a [base + <i*8*n> + <j*8>]
					mov r8, [_M + rbx]				;		r8 <- M[i][j]

					;quiero M[j][i]
					;----calculo <j> * <sizeof(long)*|col|>
					mov rax, n
					mul byte [sizeofLong]
					mul j
					;----calculo dir [<j*sizeof(long)*|col|> + <i*sizeof(long)>]
					lea rbx, [rax + i*8]
					;----accedo a [base + <j*8*n> + <i*8>]
					mov r9, [_M + rbx]				;		r9 <- M[j][i]

					cmp r8, r9						;		M[i][j] == M[j][i] ?
					je .finCicloCols
						xor eax ,eax
						jmp .finBreak		;			return 0!
				;-----------
	.finCicloCols:
				inc j							;	j++
				jmp .cicloCols
	.finCicloFilas:
			inc i								;i++
			jmp .cicloFilas
	;-----------ciclo para recorrer matriz
	.fin:
		mov eax, 1							;return 1
	.finBreak:
		pop r12
		pop rbx
		pop rbp
		ret
