extern tareas
extern indice_tarea_actual  ;uint16_t

extern proxima_tarea_lista
; void proxima_tarea_lista();
extern decrementar_tick
; uint16_t decrementar_tick();

dormida: dw 0x0
difunta: dw 0x0

sched_task_offset:     dd 0x0
sched_task_selector:   dw 0x0

selector

%define off_estado          0
%define off_indice_gdt      4
%define off_despertar_en    6
%define sizeof_tarea_t      8

%define CANT_TAREAS         10

%define CORRIENDO   0
%define DURMIENDO   1
%define DIFUNTA     2
%define LISTA       3

; uint16_t schedNextTask ();
global schedNextTask
.schedNextTask:
    pushad
    
    ; verifico si fue el salto a idle luego de dormir o matar una tarea
    cmp WORD [indice_tarea_actual], 0
    jne .continue
        cmp WORD [dormida], 0
            je .difunta?
                ;reemplazo el indice actual por el de la tarea dormida
                ; suponiendo que tiene efecto sobre la funcion proxima_tarea_lista
                mov ax, [dormida]
                mov [indice_tarea_actual], ax
                mov [dormida], 0
                jmp .continue
.difunta?:
        cmp WORD [difunta], 0
            je .continue
                mov ax, [difunta]
                mov [indice_tarea_actual], ax
                mov [difunta], 0
              
.continue:
    
    ;actualizo el estado de todas las tareas
    call decrementar_tick
    
    ;obtengo la task actual
    mov ax, [indice_tarea_actual]
    inc ax
    
    ; verifico no haber llegado al final del arreglo de tareas
    ; eax==CANT_TAREAS?
    cmp ax, CANT_TAREAS
    jne .change_current
        ;vuelvo al inicio
        mov ax, 0    
.change_current:
    call proxima_tarea_lista
    
    ;actualizo variable
    mov [indice_tarea_actual], ax
    
    popad
    ret
    
global isr_Dormir
isr_Dormir:
    pushad
    
    ;in --> ax = cant de ticks para dormir
    ; tarea a dormir = tarea actual
    
    ;obtengo el struct de la tarea actual
    mov ebx, [tareas + indice_tarea_actual*sizeof_tarea_t]
    mov ecx, ebx
    ;me posiciono en "despertar_en"
    lea ebx, [ebx + off_despertar_en]
    
    ;modifico despertar_en
    mov WORD [ebx], ax
    
    ;modifico estado
    lea ecx, [ecx + off_estado]
    mov DWORD [ecx], DURMIENDO
    
    ;guardo el indice para poder resolver la siguiente tarea en el scheduler
    mov eax, [indice_tarea_actual]
    mov [dormida], eax
    
    ; salto a la tarea idle
    mov [sched_task_selector], 0    ; 0 =idx tarea idle
    jmp FAR [sched_task_offset]
    
    popad
    iret

global _isr33
_isr33:
    pushad
    call pic_finish1

    in al, 0x60
    
    cmp al, 0x53
    jne .end
        ;obtengo el struct de la tarea actual
        mov eax, [tareas + indice_tarea_actual*sizeof_tarea_t]
        ;me posiciono en "estado"
        lea eax, [eax + off_estado]
        mov DWORD [eax], DIFUNTA
        
        ;guardo el indice para poder resolver la siguiente tarea en el scheduler
        mov eax, [indice_tarea_actual]
        mov [difunta], eax
        
        ; salto a la tarea idle
        mov [sched_task_selector], 0    ; 0 =idx tarea idle
        jmp FAR [sched_task_offset]
    
.end:
    popad
    iret