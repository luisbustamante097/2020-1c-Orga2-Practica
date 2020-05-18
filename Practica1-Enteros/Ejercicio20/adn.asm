global ordenarCadena
section .data
	%define off_base				0
	%define off_eslabon_pareja		1
	%define off_eslabon_inferior	9
	%define sizeof_eslabon			17

section .text
ordenarCadena:
	push rbp
	mov [rsp], rbp
	push rbx
	push r12

	;eslabon* ordenarCadena(eslabon* primer_eslabon, enum action_e (*cmpBase)(char* base1, char* base2)){
	; rdi = eslabon* primer_eslabon
	; rsi = &cmpBase

	%define first	%rbx
	%define

	pop r12
	pop rbx
	pop rbp
	ret
