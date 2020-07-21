
# Ejercicio 9
## Programar un handler de interrupcion
 - Se cuenta con un sistema operativo basico al cual se le desea agregar una llamada al sistema para poder obtener la tecla presionada por el usuario. Solo en el momento de ser presionada la tecla sera capturada por el sistema, pasando solo el caracter ascii al programa que lo solicite.
 - La interrupcion se la quiere implementar a traves de la `interrupt gate numero90(dame_tecla_presionada)`.
 - La tarea que la llama obtiene la tecla que presiono el usuario en el registro al.
 - En caso de que el usuario no haya presionado ninguna tecla, la tarea se queda a la espera de que lo haga, es decir, la interrupcion no retorna hasta que haya una tecla para devolver. Para ello, se marca como "a la espera de una tecla" y se pone a correr la proxima tarea disponible en el sistema.

###  Ejercicio a
- Describir la entrada en la IDT para esta nueva interrupcion, la misma se debe poder acceder desde el anillo de protecci ́on 3.

```
IDT 90: dame_tecla_presionada
    Tipo: Interrupt Gate (0 1 1 1 0)
    Segmento: Code_lvl_0
    Offset: (uint32_t) _isr90
    DPL: 3  (user)
    P = 1
```
###  Ejercicio b
 - Programar en Assembler la interrupcion dame_tecla_presionada.

```x86asm
char:   db 0x0

global _isr90
_isr90:
    pushad
    
    ; trato del leer del buffer    
    ;int get_key_from_buffer(char* a)
    mov eax, char
    push eax
    call get_key_from_buffer
    add esp, 4
    
    cmp al, 1
    je .in_ok
        ;no se obtuvo el caracter
        
        ;desalojo la tarea del scheduler con su idx de gdt
        str eax
        shr eax, 3
        push eax
        call remove_from_scheduler
        add esp, 4
        jmp .fin    
    
.in_ok:   
    push byte [char]
    call scan_code_a_ascii
    add esp, 4
.fin:
    popad
    iret
```

###  Ejercicio c
 - Programar en Assembler el handler de la interrupcion de teclado.
```x86asm
global _istKeyboard
_istKeyboard:
    pushad
    call pic_finish1
    
    ;leo del teclado
    in al, 0x60
    
    ;agrega la variable al buffer
    ;void add_key_to_buffer(char a)
    push al
    call add_key_to_buffer
    add esp, 4
    
    ;agrego de vuelta la tarea en espera al scheduler
    ;void add_to_scheduler(gdtindex i)
    push dword [task_wait_key]
    call add_to_scheduler
    add esp, 4
        
    popad
    iret
```

Se cuenta con las siguientes funciones y variables:

```c
int task_wait_key
// Variable que indica el indice en la gdt que corresponde a la tarea a la espera de una tecla.
// De ser nula no hay tarea en espera.

void add_to_scheduler(gdtindex i)
// Agrega la tarea indicada por el indice en la gdt al scheduler.

void remove_from_scheduler(gdtindex i)
// Quita la tarea indicada por el indice en la gdt del scheduler.

int get_key_from_buffer(char* a)
// Toma una tecla del buffer de teclado y la escribe en "a". Si no hay tecla en el buffer retorna 0 y 1 en caso contrario.

void add_key_to_buffer(char a)
// Agrega una tecla al buffer pasada por parametro

unsigned short next_task()
// Retorna el selector de segmento de la TSS de la proxima tarea a ejecutar

char scan_code_a_ascii(char scancode)
// Retorna el ascii del scancode pasado por parametro.

```