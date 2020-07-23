# Ejercicio 17
 - El sistema operativo ExplodeOS es muy particular. En el corren concurrentemente 5 tareas en nivel usuario. Dichas tareas cuentan con funciones explosivas, no muy testeadas, que podrian corromper la memoria y hacerlas explotar. Para que todo funcione de forma segura, el sistema brinda una funcionalidad que permite correr una funcion en “modo resguardado” en el contexto de la tarea actual. Para esto, proveera un mecanismo mediante el cual la tarea le especifique al sistema la direccionn de la funcion a ejecutar, y este la ejecute en un ambiente aislado, para luego devolverle el control a la tarea original indicando en EAX si la funcion genero una excepcion o no. Para salir, la funcion llamara a la `syscall salir`. El sistema deber a permitir a la funcion leer y escribir una copia de la memoria de la tarea original (de manera que si la corrompe la tarea original no se vea afectada). Durante la ejecucion de una funcion explosiva se deshabilitara el scheduler.
 - Nota: Se cuenta con las siguientes funciones:

```c
unsigned int damepaginalibre()
// devuelve una pagina libre del area del kernel
unsigned int copiarmemoriausuario(unsigned int cr3)
// dado un cr3, devuelve una copia casi identica del mismo, en el cual todas las paginas de nivel usuario han sido copiadas a otra ubicacion fisica.
```

1. Detallar los campos relevantes de todas las estructuras involucradas en el sistema para administrar segmentacion, paginacion, tareas, interrupciones y privilegios. Instanciar las estructuras con datos y explicar su funcionamiento. Describir tanto el esquema de segmentacion como el de paginacion si es que lo utiliza. Explicar como se implementan los servicios del sistema.
2. Escribir en ASM/C el codigo de la rutina de atencion de interrupciones de reloj.
3. Escribir en ASM/C el codigo de la rutina de atencion de una excepcion y el codigo de la rutina de atencion de la `syscall salir`.
4. Escribir en ASM/C el codigo de la rutina de atencion del servicio del sistema.


# Ejercicio 1
```
GDT:
    Segmentacion Flat
    - Entradas:
        - Codigo lvl0   Base=0x0 |Lim=0xFFFFFFF |DPL=0 |G=1|Type=X/R
        - Codigo lvl3   Base=0x0 |Lim=0xFFFFFFF |DPL=3 |G=1|Type=X/R
        - Datos lvl0    Base=0x0 |Lim=0xFFFFFFF |DPL=0 |G=1|Type=W/R
        - Datos lvl3    Base=0x0 |Lim=0xFFFFFFF |DPL=3 |G=1|Type=W/R
        - 5 TSS tareas normales     DPL=0  
        - 5 TSS tareas peligrosas   DPL=0  
    
MMU:
    Identity mapping 0MB - 1MB de memoria para kernel |DPL=0|Type=W/R
    Tareas mapeadas apartir del 4MB
```
```c
//Variables:

uint16_t sel_TSSs[5];
uint16_t sel_TSS_explosive;

tss tssTasks[5];
tss tssTask_explode

uint8_t current_task = 0;
bool explosive_mode = false;
```

# Ejercicio 2

sched_task_offset:     dd 0x0
sched_task_selector:   dw 0x0

```x86asm
global _isr32

_reloj:
    pushad
    call pic_finish1
    
    call next_task
    
    cmp ax, 0
    je .end
        mov [sched_task_selector], ax
        jmp far sched_task_offset
    
.end:    
    popad
iret

```

```c
uint16_T next_task(){
    if (!explosive_mode){
        current_task = (current_task + 1)%5;
        return sel_TSSs[current_task];
    }
}
```

# Ejercicio 3

```x86asm
_excepcion:
    call bad_ending
    mov [sched_task_selector], ax
    jmp far sched_task_offset

code_bad:
    popad
    mov eax, 1
    iret
```

```c
void bad_ending(){
    TSSs[current_task].eip = (uint32_t) &code_bad;
    return sel_TSSs[current_task];
}

```

```x86asm
_salir:
    call good_ending
    mov [sched_task_selector], ax
    jmp far sched_task_offset

    
code_ok:
    popad
    mov eax, 0
    iret

```

```c
void good_ending(){
    explosive_mode = 0;
    tssTasks[current_task].cr3 = rcr3()
    tssTasks[current_task].eip = (uint32_t) &code_ok;
    return sel_TSSs[current_task];
    
}

```

# Ejercicio 4

```c
uint16_t run_explosive_mode(void* f, void* stack_lvl3) {
    //en esta funcion lo que voy a hacer es completar la tss
    // explosiva con la info de la tarea que llamo al servicio
    tssTask_explode.eip = (uint32_t) f;
    tssTask_explode.cs = idxCodeLvl3 << 3 | 3;
    tssTask_explode.gs = idxDataLvl3 << 3 | 3;
    tssTask_explode.fs = idxDataLvl3 << 3 | 3;
    tssTask_explode.es = idxDataLvl3 << 3 | 3;
    tssTask_explode.ds = idxDataLvl3 << 3 | 3;
    tssTask_explode.ss = idxDataLvl3 << 3 | 3;
    tssTask_explode.eflags = 0x202;
    tssTask_explode.esp = (uint32_t) stack_lvl3;
    tssTask_explode.ss0 = idxDataLvl0 << 3;
    tssTask_explode.esp0 = dame_pagina_libre()+0x1000;
    tssTask_explode.cr3 = copiar_memoria_usuario(rcr3())
    modoResguardado = 1;
    return sel_TSS_explosive;
    
}
```

```x86asm

_explosiveMode_:
    pushad
    ;supongo que el parametro de entrada de la syscall
    ; viene en eax
    
    
    ;Ahora trato de obtener la pila nivel 3 de la tarea que me llamo
    ; eso se traduce a buscar en la pila de nivel 0 en la posicion
    ; superior al pushad realizado
    ; el pushad subio el esp 8*4 lugares
    ; y el esp lvl3 quedo en 3*4 posiciones arriba
    
    lea ebx, [esp + 3*4 + 8*4]
    
    push ebx
    push eax
    call run_explosive_mode
    add esp, 8
    
    ;Luego de llamar a la funcion estoy listo para saltar
    mov [sched_task_selector], ax
    jmp far sched_task_offset
    
    popad
    iret
```