global _start

section .text
    _start:
		;Sume un numero con signo de 128 bits
		;almacenado en RDX:RAX con otro tambien
		;con signo de 128 bits almacenado en memoria,
		;apuntado por RSI; y almacene el resultado
		;en esa misma posicion de memoria.
		;Pensar como cambiaria su programa
		;para las diferentes operaciones aritmeticas.

		add rax, [rsi+64]
		jnc sumaAlta
		add rdx, 1				;si hay carry se lo sumo a rdx
	sumaAlta:
		add rdx, [rsi]
		mov [rsi+64], rax		;guardo las partes en [rsi]
		mov [rsi], rdx
