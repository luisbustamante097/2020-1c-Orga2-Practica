global imprimir_interrupciones
extern printf

section .data
formato_printf: db 'La interrupcion %d esta prendida', 10, 0
mascara_pic:	db 0
i_aux:			db 0
section .text

imprimir_interrupciones:
	;-----armo el stackframe
	push rbp
	mov rbp, rsp

	; void void imprimir_interrupciones(char mascara_pic[16]);
	; mascara_pic -> rdi

	mov [mascara_pic], di
	%define i			rcx		;contador
	%define valor_i		bl		;valor donde esta parado i

	mov i, 0
	ciclo:
		mov valor_i, BYTE 1					; siempre lo inicializo en 1
		shl valor_i, cl						; shifteoLeft i-veces al 1
		and valor_i, [mascara_pic]			; lo verifico con AND

		jz incr

		;preparo para llamar a imprimir por printf
		mov rsi, i
		mov rdi, formato_printf

		;guardo el estado de rax y rcx
		mov al, 0				;limpio al para llamar printf
		mov [i_aux], cl
		;
		call printf
		;recupero el estado
		mov rax, [mascara_pic]
		mov cl, [i_aux]
		;----------

	incr:
		inc i
		cmp i, 8
		jnz ciclo

	;-----restauro la pila a su estado original
	pop rbp
	ret
