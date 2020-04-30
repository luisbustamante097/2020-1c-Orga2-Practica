global _start

section .text
    _start:
		;Multiplique un numero de 192 bits
		;almacenado en RDX:RBX:RAX por 2^n
		;donde n es un entero sin signo menor que 95,
		;almacenado en RCX.

		;Valores para probar
		mov rax, 0x8000000000000001
		mov rbx, 0x8000000000000001
		mov rdx, 0x8000000000000001
		mov rcx, 0x10

		%define CF1 r8b
		%define CF2 r9b

	firstStep:
		sal rax, 1				;rax := rax*2
		jnc secondStep			;CF == 1?
		mov CF1, 0x1				;CF1 := 1
	secondStep:
		sal rbx, 1				;rbx := rbx*2
		jnc checkCF1			;CF == 1?
		mov CF2, 0x1				;CF2 := 1
	checkCF1:
		cmp CF1, 0x0
		jz thirdStep			;CF1 == 1?
		inc rbx						;rbx++
	thirdStep:
		sal rdx, 1				;rdx := rdx*2
		cmp CF2, 0x0
		jz final				;CF2 == 1?
		inc rdx						;rdx++
	final:
		loop firstStep

	mov eax, 1
	int  0x80
