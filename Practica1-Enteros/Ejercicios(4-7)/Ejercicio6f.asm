section .data
	inc_mvb: DQ 0x8000000000000000

	global _start
section .text
    _start:
		;Divida un numero de 192 bits con signo
		;almacenado en RDX:RBX:RAX por 2^n
		;donde n es un entero sin signo menor que 95,
		;almacenado en RCX.

		;Valores para probar
		mov rax, 0x8000000000000001
		mov rbx, 0x8000000000000001
		mov rdx, 0x8000000000000001
		mov rcx, 0x1

		%define CF1 r8b
		%define CF2 r9b

	firstStep:
		sar rdx, 1				;rdx := rdx/2 (signed)
		jnc secondStep			;CF == 1?
		mov CF1, 0x1				;CF1 := 1
	secondStep:
		shr rbx, 1				;rbx := rbx/2 (unsigned)
		jnc checkCF1			;CF == 1?
		mov CF2, 0x1				;CF2 := 1
	checkCF1:
		cmp CF1, 0x0
		jz thirdStep			;CF1 == 1?
		or rbx, [inc_mvb]			;rbx[15]++
	thirdStep:
		shr rax, 1				;rax := rax/2 (unsigned)
		cmp CF2, 0x0
		jz final				;CF2 == 1?
		or rax, [inc_mvb]			;rax[15]++
	final:
		loop firstStep

	mov eax, 1
	int  0x80
