;sume dos numeros de 128 bits con signo,
;cuyo prototipo sea:
;void suma(superlong* a, superlong* b, superlong* resultado)
;¿Cambia el codigo en lenguaje ensamblador si el prototipo
;de la suma es:
;void suma(unsignedsuperlong* a, unsignedsuperlong* b,unsignedsuperlong* resultado)?
;typedef struct superlong_t {
;	long x1;
;	long x2;
;} superlong;
;typedef struct unsignedsuperlong_t {
;	unsigned long x1;
;	unsigned long x2;
;} unsignedsuperlong;
global suma

section .text
	suma:
		;---------Armo stackframe
		push rbp
		mov [rsp], rbp

		;void suma(superlong* a, superlong* b, superlong* resultado)
		;rdi <- &a
		;	[rdi] 		= a.xl
		;	[rdi + 8] 	= a.xh
		;rsi <- &b
		;	[rsi] 		= b.xl
		;	[rsi + 8] 	= b.xh
		;rdx <- &resultado
		;	[rdx] 		= res.xl
		;	[rdx + 8] 	= res.xh

		%define a	rdi
		%define b	rsi
		%define res	rdx
		%define CF	rbx

		mov CF, 0x0				;inicializo CF

		mov rax, [a]			;rax <- a.xl
		add rax, [b]			;rax <- a.xl + b.xl
		jnc seguirSumando		;if CF==1
			mov rbx, 0x1			;	guardo carry en rbx
	seguirSumando:
		mov [res], rax			;res <- rax

		mov rax, [a+8]			;rax <- a.xh
		add rax, [b+8]			;rax <- a.xh + b.xh
		cmp rbx, 0x1
		jnz finish				;CF == 1?
			inc rax				;	inc LVB
	finish:
		lea rcx, [res + 8]		;guardo en rcx <- &res.xh
		mov [rcx], rax			;res.xh <- rax

		;--------Restauro pila
		pop rbp
		ret
