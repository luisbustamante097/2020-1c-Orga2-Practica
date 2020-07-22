# Ejercicio 15
- En el sistema operativo Orga2SO, cada tarea se ejecuta durante una cantidad de ticks determinada por la constante `QUANTUM`. Cada tarea puede estar en distintos estados: `CORRIENDO`, `DURMIENDO`, `DIFUNTA` o `LISTA` (para correr). Para llevar cuenta de esto, las tareas se mantienenen un arreglo donde se almacena el indice en la GDT donde se encuentra su descriptor de TSS, el estado de la misma y la cantidad de ticks por el cual la tarea va a estar dormida (0 si la tarea no esta dormida).
- Las tareas se ejecutan (solo se pueden ejecutar aquellas que estan en estado LISTA) en orden desde el principio del arreglo (y de manera ciclica). En caso de que ninguna tarea este en condiciones de ejecutarse se ejecuta la tarea IDLE.
- Las estructuras de datos utilizadas son la siguientes:

```c
typedef enum {
    CORRIENDO = 0,
    DURMIENDO = 1,
    DIFUNTA   = 2,
    LISTA     = 3
} estado_t;

typedef struct {
    estado_t estado;
    unsigned short indice_gdt;
    unsigned short despertar_en;
} __attribute__ ((__packed__)) tarea_t;

tarea_t tareas[CANT_TAREAS];

unsigned short indice_tarea_actual;
```

# Ejercicio a
 - Implementar en lenguaje ensamblador el codigo correspondiente al scheduler para que se ejecute en la interrupcion del timer tick.

# Ejercicio b
 - Se desea poder poner a dormir a una tarea mediante la interrupcion `0x60`. Implementar en lenguaje ensamblador el handler de la interrupcion, en `isr_Dormir`, recibiendo por `ax` la cantidad de ticks de reloj que la tarea va estar dormida. Al ser llamada la interrupcion,la tarea que la llamo se debe poner a dormir, y se debe pasar a ejecutar la siguiente tarea en estado `LISTA`.

# Ejercicio c
- Implementar en lenguaje ensamblador la interrupcion de teclado de modo que cada vez que se presione la tecla `Del` se mate a la tarea actual, es decir, se cambie su estado a `DIFUNTA` y se pase a ejecutar la proxima tarea disponible

# Aclaraciones
- El tamaño del tipo de datos `estado_t` es de 4 bytes.
- La tarea IDLE se encuentra en la posicion 0 del arreglo de tareas y no se puede matar.
- Se puede llamar a una funcion `proxima_tarea_lista` que devuelve en `ax` el indice de la proxima tarea en estado `LISTA`. Si no hay ninguna tarea en estado `LISTA`, esta funcion devuelve la tarea IDLE.
- Se puede llamar a una funcion `decrementar_tick` que decrementa el campo `despertar_en` de cada tarea en el arreglo `tareas` que este en estado `DURMIENDO`. En caso de que el campo `despertar_en` llegue a 0, esta funcion actualiza el campo `estado` a `LISTA`.
- El scan code de la tecla `Del` es `0x53`.
- Tener en cuenta que varias funcionalidades a implementar van a ser utilizadas en todos los items de este ejercicio.


```x86asm

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

```