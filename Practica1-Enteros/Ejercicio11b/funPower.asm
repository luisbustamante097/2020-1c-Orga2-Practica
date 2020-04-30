global power

section .text
	power:
		push rbp
		mov [rsp], rbp

		;void power(long x, unsigned long y, superlong* resultado)
		;rdi <- x
		;rsi <- y
		;rdx <- &resultado

		%define x		rdi
		%define y		rsi

		mov rcx, rdx
		%define _res	rcx

		mov rbx, y
	ciclo:
		mov rax, x
		mul x

		dec rbx
		cmp rbx, 1
		jnz ciclo

		mov [_res], rax
		mov [_res + 8], rdx

		pop rbp
		ret
