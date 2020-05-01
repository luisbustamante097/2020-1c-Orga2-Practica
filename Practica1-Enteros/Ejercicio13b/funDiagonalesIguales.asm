global diagonalesIguales
section .data
	sizeofLong: DB 0x8

section .text
	diagonalesIguales:
		push rbp
		mov [rsp], rbp
		push rbx
		push r12
		push r13
		push r14

		;extern int diagonalesIguales(long *M, unsigned short n);
		;di <- unsigned short n
		;rsi <- long *M

		%define n		rsi
		%define	_M		rdi
		%define i		rcx
		%define j		r12

		%define maind		r13		;main_diag
		%define revd		r14		;reverse_diag

		;--limpio parte alta de revdi
		movsx rsi, si

		;--inicializo
		xor i, i								;i <- 0
		mov j, n
		dec j									;j <- n-1
		xor rax, rax							;rax <- 0
		xor maind, maind						;maind <- 0
		xor revd, revd							;revd <- 0

	;-----------ciclo para recorrer matriz
	.ciclo:
			cmp i, n							;i < n ?
			je .finCiclo
			;-----------
			;----calculo <i> * <sizeof(long)*|fila|>
			mov rax, n
			mul byte [sizeofLong]
			mul i
			;----calculo offset [<i*8*|fila|> + <i*8>]
			lea rbx, [rax + i*8]
			;----accedo a [base + <i*8*n> + <i*8>]
			mov r8, [_M + rbx]					;		r8 <- M[i][i]
			;----sumo main_diag
			add maind, r8						;		maind += M[i][i]

			;----ya tengo el offset de i en rax
			;----calculo offset [<i*8*|fila|> + <j*8>]
			lea rbx, [rax + j*8]
			;----accedo a [base + <i*8*n> + <j*8>]
			mov r9, [_M + rbx]					;		r9 <- M[i][j]
			;----sumo main_diag
			add revd, r9						;		revd += M[i][j]
			dec j								;j--
			;-----------
			inc i								;i++
			jmp .ciclo
	;-----------ciclo para recorrer matriz
	.finCiclo:
		cmp maind, revd
		je .true
			mov eax, 0
			jmp .fin
	.true:
		mov eax, 1
	.fin:
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret
