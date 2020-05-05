global iesimo
global agregarAd
global borrarTodos
global buscarElemento
global agregarEnPos
global borrarPorPos

extern malloc
extern free

section .data:
	%define off_list_prim 0
	%define off_node_dato 0
	%define off_node_prox 8
	%define NULL 0

section .text
iesimo:
		push rbp
		mov [rsp],rbp
		push rbx
		push r12

		;extern long iesimo(list* l, unsigned long i);
		; rdi <- list* l
		; rsi <- unsigned long i

		mov rbx, rdi
		mov r12, rsi

		%define list_ptr	rbx
		%define i 			r12
		%define node_actual	rcx

		lea rcx, [list_ptr + off_list_prim]
		cmp QWORD [rcx], NULL
		je .not_found				;if (!list.empty)

		;node* actual = l->primero
		mov node_actual, [list_ptr + off_list_prim]
	.ciclo_inicio:
		cmp node_actual, NULL
		je .not_found
			cmp	i, 0
			jne .seguir_ciclo
				mov rax, [node_actual + off_node_dato]
				jmp .end
	.seguir_ciclo:
			dec i
			mov node_actual, [node_actual + off_node_prox]
			jmp .ciclo_inicio

	.not_found:
		mov rax, 0
	.end:
		pop r12
		pop rbx
		pop rbp
		ret
;-----------------------------------------------------------

;-----------------------------------------------------------
agregarAd:
		push rbp
		mov [rsp],rbp
		push rbx
		push r12

		;void agregarAd(list* l, long n){
		; rdi <- list* l
		; rsi <- long n

		mov rbx, rdi
		mov r12, rsi

		%define list_ptr		rbx
		%define n				r12
		%define new_node_ptr	rcx

		mov rdi, 16
		call malloc						;rax = (node*) malloc(16)
		mov new_node_ptr, rax			;new_node_ptr = rax

		mov [new_node_ptr + off_node_dato], n			;new_node_ptr->dato = n
		mov QWORD [new_node_ptr + off_node_prox], NULL	;new_node_ptr->prox = NULL

		lea rax, [list_ptr + off_list_prim]			;rax = &l->primero
		cmp QWORD [rax], NULL						;if (l->primero==NULL)
		jne .else
			mov [rax], new_node_ptr					;	l->primero = new_node_ptr
			jmp .end								;	break
	.else:
		mov rdx, [rax]								;rdx <- l->primero
		mov [rax], new_node_ptr						;l->primero = new_node_ptr
		mov [new_node_ptr + off_node_prox], rdx		;new_node_ptr->prox = rdx

		.end:
		pop r12
		pop rbx
		pop rbp
		ret
;-----------------------------------------------------------

;-----------------------------------------------------------
borrarTodos:
		push rbp
		mov [rsp],rbp
		push rbx
		push r12

		;extern long borrarTodos(list* l);
		; rdi <- list* l

		mov rbx, rdi

		%define list_ptr	rbx
		%define node_actual	r12

		lea rcx, [list_ptr + off_list_prim]
		cmp QWORD [rcx], NULL
		je .end							;if (!list.empty)

		;node* actual = l->primero
		mov node_actual, [list_ptr + off_list_prim]
	.ciclo_inicio:
		cmp node_actual, NULL
		je .end
			mov rdi, node_actual
			mov node_actual, [node_actual + off_node_prox]
			call free

			jmp .ciclo_inicio

	.end:
		mov QWORD [list_ptr + off_list_prim], NULL

		pop r12
		pop rbx
		pop rbp
		ret
;-----------------------------------------------------------

;-----------------------------------------------------------
buscarElemento:
		push rbp
		mov [rsp],rbp
		push rbx
		push r12
		push r13
		push r14

		;short int buscarElemento(list *l, long n);
		; 	rdi <- list* l
		;	rsi <- long n

		mov rbx, rdi
		mov r12, rsi

		%define list_ptr	rbx
		%define n			r12
		%define node_actual	r13

		lea rcx, [list_ptr + off_list_prim]
		cmp QWORD [rcx], NULL
		je .not_found						;if (!list.empty)

		mov node_actual, [list_ptr + off_list_prim]		;node* actual = l->primero
	.ciclo_inicio:
		cmp node_actual, NULL
		je .not_found
			mov rax, [node_actual + off_node_dato]
			cmp	rax, n
			jne .seguir_ciclo
				mov rax, 1
				jmp .end
	.seguir_ciclo:
			mov node_actual, [node_actual + off_node_prox]
			jmp .ciclo_inicio

	.not_found:
		mov rax, 0
	.end:

		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret
;-----------------------------------------------------------

;-----------------------------------------------------------
agregarEnPos:
		push rbp
		mov [rsp],rbp
		push rbx
		push r12
		push r13
		push r14

		;void agregarEnPos(list* l, unsigned long i, long n);
		; 	rdi <- list* l
		;	rsi <- unsigned long i
		;	rdx <- n

		mov rbx, rdi
		mov r12, rsi
		mov r13, rdx

		%define list_ptr				rbx
		%define pos						r12
		%define n						r13
		%define new_node_ptr			r14		; node* nodo_nuevo
		%define current_node_ptr		rdx		; node* nodo_actual
		%define previous_PROX_node_ptr	rsi		; node** nodo_anterior_prox
		%define i						rcx

		;--------------Si pos = 0 o lista vacia -> Llamo a agregarAd
		cmp pos, 0
		jne .not_pos0
			jmp .agAdelante
	.not_pos0:
		lea rcx, [list_ptr + off_list_prim]
		cmp QWORD [rcx], NULL
		jne .not_empty_not_pos_0
			jmp .agAdelante
		;------
	.agAdelante:
		;Llamo a agregarAdelante
			mov rdi, list_ptr
			mov rsi, n
			call agregarAd
			jmp .end
		;-----------------------------------------------
	.not_empty_not_pos_0:

		;---Reservo memoria para new_node
		mov rdi, 16
		call malloc						;rax = (node*) malloc(16)
		mov new_node_ptr, rax			;new_node_ptr = rax

		mov [new_node_ptr + off_node_dato], n			;new_node_ptr->dato = n
		mov QWORD [new_node_ptr + off_node_prox], NULL	;new_node_ptr->prox = NULL
		;---

		;---Inicializo
		xor rcx, rcx
		mov current_node_ptr, [list_ptr + off_list_prim]		;node* actual = l->primero
		lea previous_PROX_node_ptr, [list_ptr + off_list_prim]	;node** anterior = &l->primero
		;---
	.ciclo_inicio:
		cmp current_node_ptr, NULL
		je .fin_ciclo
			cmp	i, pos
			jne .seguir_ciclo

				;Estoy en el medio de la lista
				mov rax, current_node_ptr					;rax = actual
				mov [previous_PROX_node_ptr], new_node_ptr	;[anterior] = nodo_nuevo
				mov [new_node_ptr + off_node_prox], rax		;[nuevo->prox] = rax
				jmp .end

	.seguir_ciclo:
			inc i
			lea previous_PROX_node_ptr, [current_node_ptr + off_node_prox]	;anterior = &actual
			mov current_node_ptr, [current_node_ptr + off_node_prox]		;actual = actual->prox
			jmp .ciclo_inicio

	.fin_ciclo:
		cmp i, pos
		jne .end	; pos == list.length?
			;Agrego el nodo al final
			mov [previous_PROX_node_ptr], new_node_ptr	;[anterior] = nuevo
	.end:
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret
;-----------------------------------------------------------

;-----------------------------------------------------------
borrarPorPos:
		push rbp
		mov [rsp],rbp
		push rbx
		push r12
		push r13
		push r14

		;void borrarPorPos(list* l, unsigned long i);
		; 	rdi <- list* l
		;	rsi <- unsigned long i

		mov rbx, rdi
		mov r12, rsi

		%define list_ptr				rbx
		%define pos						r12
		%define current_node_ptr		r13		; node* nodo_actual
		%define previous_PROX_node_ptr	r14		; node** nodo_anterior_prox
		%define i						rcx


		;---Si la lista esta vacia
		lea rcx, [list_ptr + off_list_prim]
		cmp QWORD [rcx], NULL
		jne .not_empty
			jmp .end
		;---
	.not_empty:
		;---Inicializo
		xor rcx, rcx
		mov current_node_ptr, [list_ptr + off_list_prim]		;node* actual = l->primero
		lea previous_PROX_node_ptr, [list_ptr + off_list_prim]	;node** anterior = &l->primero
		;---

	.ciclo_inicio:
		cmp current_node_ptr, NULL
		je .end
			cmp	i, pos
			jne .seguir_ciclo

				;Estoy en el medio de la lista
				mov rdi, current_node_ptr					;rax = actual
				mov rdx, [current_node_ptr + off_node_prox]	;rdx = actual->prox
				mov [previous_PROX_node_ptr], rdx			;[anterior] = rdx
				call free
				jmp .end

	.seguir_ciclo:
			inc i
			lea previous_PROX_node_ptr, [current_node_ptr + off_node_prox]	;anterior = &actual
			mov current_node_ptr, [current_node_ptr + off_node_prox]		;actual = actual->prox
			jmp .ciclo_inicio

	.end:
		pop r14
		pop r13
		pop r12
		pop rbx
		pop rbp
		ret
