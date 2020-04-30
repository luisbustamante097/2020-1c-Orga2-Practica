global _start

section .text
    _start:
	;Sume un numero con signo de 32 bits almacenado en EAX
	;con otro tambien con signo de 64 bits,
	;almacenado en memoria apuntado por RSI
	;y almacene el resultado en esa misma posicion de memoria.

	mov rbx, 0x00000000FFFFFFFF		; me aseguro que la parte
	and rax, rbx					; alta de rax este limpia

	add rax, [rsi]		; sumo la parte baja de rax, o sea eax
	mov [rsi], eax
	; no se puede probar
