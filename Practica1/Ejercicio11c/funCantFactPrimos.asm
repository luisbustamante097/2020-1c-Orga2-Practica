global cantFactoresPrimos

section .text
	cantFactoresPrimos:

		push rbp
		mov [rsp], rbp

		;unsigned int cantFactoresPrimos(unsigned long n)
		;rdi <- n

		%define	n	rdi
		%define k	rcx
		%define d	rbx

		mov k, 1
		mov d, 2

	ciclo:
		mov rax, d				;rax <- d
		mul d					;rax <- d*d
		cmp rax, n
		jg fin					;d*d <= n?
			mov rax, n			;rax <- d
			div d				;rax <- n/d | rdx <- n%d
			cmp rdx, 0
			jne else			;n%d == 0 ?
				inc k				;k++
				mov n, rax			;n <- n/d
				jmp ciclo
	else:
			inc d				;d++
			jmp ciclo
	fin:
		mov rax, k				;devuelvo k por rax

		pop rbp
		ret
