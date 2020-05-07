global new_def
global fetch_def
global change_def
global delete_def
global delete_all
global is_greater
global is_equal


extern malloc
extern free

section .data:
	%define off_dicc_root 	0
	%define off_node_key 	0
	%define off_node_value 	8
	%define off_node_izq 	16
	%define off_node_der 	24
	%define sizeof_char	1
	%define sizeof_node 32
	%define NULL 		0

section .text
is_greater:
		push rbp
		mov [rsp],rbp
		push rbx
		push r12
		push r13
		push r14
		;int is_greater(char *key1, char *key2)
		;	rdi <- char *key1
		;	rsi <- char *key2

		mov rbx, rdi
		mov r12, rsi
		xor r13, r13
		xor r14, r14

		%define char1_ptr		rbx
		%define char2_ptr		r12
		%define actual_char1	r13b
		%define actual_char2	r14b

	.ciclo:
		mov actual_char1, BYTE [char1_ptr]
		mov actual_char2, BYTE [char2_ptr]
		cmp actual_char1, NULL
		je .b_greater_a
		cmp actual_char2, NULL
		je .a_greater_b

			cmp actual_char1, actual_char2
			jg .a_greater_b
			je .equal_char
			jng .b_greater_a
	.equal_char:
			inc char1_ptr
			inc char2_ptr
			jmp .ciclo

	.a_greater_b:
		mov rax, 1
		jmp .end
	.b_greater_a:
		mov rax, 0
		jmp .end

	.end:
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret
;---------------------------------------------------------------

;---------------------------------------------------------------
is_equal:
		push rbp
		mov [rsp],rbp
		push rbx
		push r12
		push r13
		push r14
		;int is_equal(char *key1, char *key2)
		;	rdi <- char *key1
		;	rsi <- char *key2

		mov rbx, rdi
		mov r12, rsi
		xor r13, r13
		xor r14, r14

		%define char1_ptr		rbx
		%define char2_ptr		r12
		%define actual_char1	r13b
		%define actual_char2	r14b

		;Inicializo
		xor cl, cl
		xor dl, dl
	.ciclo:
		mov actual_char1, BYTE [char1_ptr]
		mov actual_char2, BYTE [char2_ptr]
		cmp actual_char1, actual_char2
		jne .not_equal
		cmp actual_char1, NULL
		je .is_equal

			inc char1_ptr
			inc char2_ptr
			jmp .ciclo

	.is_equal:
		mov rax, 1
		jmp .end
	.not_equal:
		mov rax, 0
		jmp .end

	.end:
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret
;---------------------------------------------------------------

;---------------------------------------------------------------
new_def:
		push rbp
		mov [rsp],rbp
		push rbx
		push r12
		push r13
		push r14

		;void new_def(dicc_arb_bin *dicc, char *key, char *value)
		; 	rdi <- dicc_arb_bin *dicc
		;	rsi <- char *key
		;	rdx <- char *value

		mov rbx, rdi
		mov r12, rsi	;temp
		mov r13, rdx	;temp

		%define dicc_ptr				rbx		; dicc_arb_bin *dicc
		%define current_node_ptr		r12		; node *actual
		%define parent_node_ptr			r13		; node *padre
		%define new_node_ptr			r14		; node *nuevo

		;---creo el nuevo nodo
		mov rdi, sizeof_node
		call malloc
		mov new_node_ptr, rax
		mov [new_node_ptr + off_node_key], r12
		mov [new_node_ptr + off_node_value], r13
		mov QWORD [new_node_ptr + off_node_izq], NULL
		mov QWORD [new_node_ptr + off_node_der], NULL
		;---

		;---Inicializo variables
		lea parent_node_ptr, [dicc_ptr + off_dicc_root]
		mov current_node_ptr, [dicc_ptr + off_dicc_root]
		;---
	.loop_bt:
		cmp current_node_ptr, NULL
		jne	.continue_loop
			mov [parent_node_ptr], new_node_ptr
			jmp .end
	.continue_loop:
			;--- *actual->key > *nuevo->key ?
			mov rdi, [current_node_ptr + off_node_key]
			mov rsi, [new_node_ptr + off_node_key]
			call is_greater	; nuevo < actual ?
			cmp rax, 1
			je .left_branch		; nuevo < actual
			jmp .right_branch	; nuevo >= actual
	.left_branch:
			lea parent_node_ptr, [current_node_ptr + off_node_izq]
			mov current_node_ptr, [current_node_ptr + off_node_izq]
			jmp .loop_bt
	.right_branch:
			lea parent_node_ptr, [current_node_ptr + off_node_der]
			mov current_node_ptr, [current_node_ptr + off_node_der]
			jmp .loop_bt

	.end:
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret
;---------------------------------------------------------------

;---------------------------------------------------------------
fetch_def:
		push rbp
		mov [rsp],rbp
		push rbx
		push r12
		push r13
		push r14

		;char* fetch_def(dicc_bt *dicc, char *key);
		; 	rdi <- dicc_bt *dicc
		;	rsi <- char *key

		mov rbx, rdi
		mov r14, rsi

		%define dicc_ptr				rbx		; dicc_arb_bin *dicc
		%define current_node_ptr		r12		; node *actual
		%define parent_node_ptr			r13		; node *padre
		%define key_ptr					r14		; char *key

		;---Inicializo variables
		lea parent_node_ptr, [dicc_ptr + off_dicc_root]
		mov current_node_ptr, [dicc_ptr + off_dicc_root]
		;---
	.loop_bt:
		cmp current_node_ptr, NULL
		jne	.not_empty
			mov rax, NULL
			jmp .end
	.not_empty:
		mov rdi, [current_node_ptr + off_node_key]
		mov rsi, key_ptr
		call is_equal
		cmp rax, 1
		jne .continue_loop
			;lo encontre
			mov rax, [current_node_ptr + off_node_value]
			jmp .end
	.continue_loop:
			;--- *actual->key > key ?
			mov rdi, [current_node_ptr + off_node_key]
			mov rsi, key_ptr
			call is_greater	; key < actual ?
			cmp rax, 1
			je .left_branch		; nuevo < actual
			jmp .right_branch	; nuevo >= actual
	.left_branch:
			lea parent_node_ptr, [current_node_ptr + off_node_izq]
			mov current_node_ptr, [current_node_ptr + off_node_izq]
			jmp .loop_bt
	.right_branch:
			lea parent_node_ptr, [current_node_ptr + off_node_der]
			mov current_node_ptr, [current_node_ptr + off_node_der]
			jmp .loop_bt

	.end:
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret
;---------------------------------------------------------------

;---------------------------------------------------------------
delete_all:
		push rbp
		mov [rsp],rbp
		push rbx
		push r12
		push r13
		push r14
		;void delete_all(dicc_bt *dicc)
		;	rdi <- dicc_bt *dicc

		mov rbx, rdi

		%define parent_node_ptr		rbx
		%define current_node_ptr	r12
		;---Verifico que el arbol no sea vacio
		cmp parent_node_ptr, NULL
		je .end
		;--
		;---Inicializo variables
		mov current_node_ptr, [parent_node_ptr]
		;---
		cmp current_node_ptr, NULL
		jne .rec
			mov rdi, [parent_node_ptr]
			call free
			jmp .end
	.rec:	;else
			mov rdi, [current_node_ptr + off_node_izq]
			call delete_all
			mov rdi, [current_node_ptr + off_node_der]
			call delete_all

			mov rdi, [parent_node_ptr]
			call free


		.end:
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret
