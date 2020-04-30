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
		%define _res	rdx
		%define i		rcx
		%define CF		r8
		xor CF, CF				;CF <- 0

		; x^y = 2^(y*log2(x))

		cmp x, 0
		jnz y_zero?				;caso x=0 -> res = 0
			mov QWORD [_res], 0
			mov	QWORD [_res + 8],0
			jmp end
	y_zero?:
		cmp y, 0				;caso y=0 -> res = 1
		jnz y_one?
			mov QWORD [_res], 1
			mov	QWORD [_res + 8], 0
			jmp end
	y_one?:
		cmp y, 1				;caso y=1 -> res = x
		jnz init
			mov [_res], x
			mov	QWORD [_res + 8], 0
			jmp end
	init:						;cc
		bsr rax, x				;rax <- log2(x) (no valido para x=0)
		mul y					;rax <- rax*y
		mov i, rax				;i <- rax

		;Trabajare con rbx:rax para operar
		mov rax, 2				;rax <- 2
		xor rbx, rbx			;rbx <- 0
	mult:
		sal rax, 1				;rax <- rax*2
		jnc nextStep			;CF == 1?
			mov CF, 0x1			;	CF <- 1
	nextStep:
		sal rbx, 1				;rbx := rbx*2
		cmp CF, 0x1
		jnz loopEnd?			;CF == 1?
			inc rbx				;	rbx++
	loopEnd?:
		loop mult
		mov [_res], rax			;guardo los resultados
		mov [_res + 8], rbx
	end:
		pop rbp
		ret
