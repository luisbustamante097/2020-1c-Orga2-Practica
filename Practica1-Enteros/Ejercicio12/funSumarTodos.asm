global sumarTodos

section .text
	sumarTodos:
		push rbp
		mov [rbp], rsp

		;extern long sumarTodos(long *v, unsigned short n)
		;rdi <- long *v
		;rsi <- unsigned short n

		%define _v	rdi
		%define n	rsi
		%define i	rbx

		xor rbx, rbx
		xor rax, rax

	.ciclo:
		add rax, [_v + i*8]

		inc i
		cmp i, n
		jne .ciclo


		pop rbp
		ret
