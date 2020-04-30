global imprimir_interrupciones
extern printf

section .data
formato_printf: db 'La interrupcion %d esta prendida', 10, 0
mascara_pic:	dq 0
i_aux:			db 0
section .text

imprimir_interrupciones:
	;-----armo el stackframe
	push rbp
	mov rbp, rsp

	; void void imprimir_interrupciones(char mascara_pic[16]);
	; mascara_pic -> rdi

	; muevo la mascara_pic a rax
	;mov rax, rdi
	mov [mascara_pic], rdi
	;%define mascara_pic rax		;direccion donde comienza mascara
	%define i			rcx		;contador
	%define valor_i		bl		;valor donde esta parado i

	mov i, 0
	ciclo:

		mov valor_i, BYTE [rax + i]
		cmp valor_i, BYTE 0x1
		jnz incr

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
		cmp i, 16
		jnz ciclo

	;-----restauro la pila a su estado original
	pop rbp
	ret
