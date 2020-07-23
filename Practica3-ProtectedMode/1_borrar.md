# Enunciado
- Considerar un sistema en modo protegido con segmentación flat y paginación activa. Este ejecuta
concurrentemente dos pares de tareas denominadas A1, A2 y B1, B2. El área donde se encuentran el
código y los datos ocupa exactamente **64KB para cada tarea**, y adicionalmente cada una requiere al
menos **8KB para su pila**. Asimismo, cada **tarea comparte con su pareja una página de memoria física
de 4KB** que se encuentra mapeada en la misma posición virtual para ambas. Es decir, A1 comparte
una página con A2 y B1 con B2.

El sistema provee dos funcionalidades:
- `ApagarPar`: Permite a cualquier tarea marcar a las tareas del otro par para que dejen de ser
ejecutadas. Por ejemplo, si la tarea A1 llama al servicio, las tareas B1 y B2 dejarán de ser
ejecutadas. Como resultado, sólo las tareas A1 y A2 continuarán siendo ejecutadas por el sistema.
- `PrenderPar`: El servicio es el opuesto al anterior. Ahora el otro par comenzará a ser ejecutado.
Por ejemplo, si A2 llama al servicio, entonces B1 y B2 comenzarán a ejecutarse nuevamente.
Como resultado, todas las tareas serán ejecutadas por el sistema.
Si se llama a cualquiera de los servicios, y las tareas ya estaban apagadas o prendidas, el servicio no
realizará ninguna acción.

Si se llama a cualquiera de los servicios, y las tareas ya estaban apagadas o prendidas, el servicio no
realizará ninguna acción.

# Punto 1:
- Describir cómo se **ubicarían en memoria** las tareas. Enumerar para ello todos los **rangos de memoria física** que ocuparía cada parte de cada tarea, y del sistema. Además explicar como se
realiza el **mapeo sobre direcciones virtuales**, considerando que todas las tareas están compiladas para ejecutar desde la dirección virtual `0x13370000`. Detallar para las tareas A1 y A2 cómo los
rangos de memoria física mapean a direcciones virtuales mediante un esquema.

### MEMORIA FISICA:
SEGMENTACION FLAT

|Base      |Descripcion             |
|----------|------------------------|
|0x00000000| Memoria del kernel     |
|0x00400000| Tarea A1               |
|0x00410000| Tarea A2               |
|0x00420000| Tarea B1               |
|0x00430000| Tarea B2               |
|0x00440000| Pagina compartida de As|
|0x00441000| Pagina compartida de Bs|
|0x00442000| Pila Tarea A1          |
|0x00444000| Pila Tarea A2          |
|0x00446000| Pila Tarea B1          |
|0x00448000| Pila Tarea B2          |

### MEMORIA VIRTUAL:

- Todas las tareas mapean los primeros 4 MB para memoria del kernel con identity mapping
```
- Tarea A1: 
    0x00400000-0x0040FFFF --> 0x13370000-0x1337FFFF | R/W | User | P |
    0x00440000-0x00440FFF --> 0x00440000-0x00440FFF | R/W | User | P |
    0x00442000-0x00443FFF --> 0x00442000-0x00443FFF | R/W | User | P |

- Tarea A2: 
    0x00410000-0x0041FFFF --> 0x13370000-0x1337FFFF | R/W | User | P |
    0x00440000-0x00440FFF --> 0x00440000-0x00440FFF | R/W | User | P |
    0x00444000-0x00445FFF --> 0x00444000-0x00445FFF | R/W | User | P |
      
- Tarea B1: 
    0x00420000-0x0042FFFF --> 0x13370000-0x1337FFFF | R/W | User | P |
    0x00441000-0x00441FFF --> 0x00441000-0x00441FFF | R/W | User | P |
    0x00446000-0x00447FFF --> 0x00446000-0x00447FFF | R/W | User | P |

- Tarea B2: 
    0x00430000-0x0043FFFF --> 0x13370000-0x1337FFFF | R/W | User | P |
    0x00441000-0x00441FFF --> 0x00441000-0x00441FFF | R/W | User | P |
    0x00448000-0x00449FFF --> 0x00448000-0x00449FFF | R/W | User | P |
    
ESQUEMA:
 
    MEMORIA FISICA             //       MEMORIA VIRTUAL
0x00000000| KERNEL             //     0x00000000| KERNEL
0x00400000| Tarea A1------.    //
0x00410000| Tarea A2---.  |    //
...                    |  |    //
...                    |  |    //
...                    |  |    //
...                    |  |    //
...                    |  |    //   
...                    |  |    //
...                    |------ //----- 0x13370000| Area de tareas 

```

# Punto 2:
- Implementar en ASM/C la rutina de atención de interrupciones del reloj, teniendo en cuenta los servicios que debe soportar el sistema.

```c
// array de TSSs
tss tssArray [4]
// Las posiciones de las TSS en la GDT seran apartir del 8
uint16_t gdtTSSs_idx[4]

// TAREAS:
#define A1  0
#define A2  1
#define B1  2
#define B2  3

//TIPOS:
#define A   0
#define B   1

// Arreglo para saber si los tipos estan apagados
uint8_t tipo_apagado[2];

uint16_t current_task;

uint16_t nextTask(){
    current_task = (current_task + 1)%CANT_TAREAS;
    uint16_t type = (current_task >= B1) ? B : A;
    if (!tipo_apagado[type]){
        return current_task;
    }else{
        uint16_t siguiente = (type == B) ? A1 : B1;
        current_task = siguiente;
    }
    return current_task
}

```

```x86asm
offset:     dd 0x0
selector:   dw 0x0

global _isr32
_isr32:
    pushad
    ; avisamos al pic que se recibe la interrupcion
    call pic_finish1
    
    ; Obtengo el descriptor de segmento de la siguiente tarea
    call nextTask
    
    ; Verifico que el nextTask no es igual al task actual
    str bx
    cmp ax, bx
    je .fin
        mov WORD [selector], ax
        jmp FAR [offset]
.fin:
    popad
    iret
```

# Punto 3:
- Implementar en ASM/C la rutina de atención de los servicios del sistema. Indicar cómo completaría las entradas en la IDT para ApagarPar y PrenderPar.
```
INTERRUPCIONES e IDT:
    - Reloj
        + offset: &_isr32
        + SelSeg: idx_gdt_code_0 << 3
        + DPL: 0
        + Tipo: Interrupt Gate (0 1 1 1 0)
    - _apagarPar
        + offset: &_apagarPar
        + SelSeg: idx_gdt_code_0 << 3
        + DPL: 3
        + Tipo: Interrupt Gate (0 1 1 1 0)
    - _prenderPar
        + offset: &_prenderPar
        + SelSeg: idx_gdt_code_0 << 3
        + DPL: 3
        + Tipo: Interrupt Gate (0 1 1 1 0)
```

```x86asm

extern tipo_apagado

global _apagarPar
_apagarPar:
    pushad
    call ApagarPar

    popad
    iret
```

```c
void ApagarPar(){
    uint16_t reverse_type = (current_task >= B1) ? A : B;
    tipo_apagado[reverse_type] = 0;
}
```

```x86asm

global _prenderPar
_prenderPar:
    pushad
    call PrenderPar

    popad
    iret
```

```c
void PrenderPar(){
    uint16_t reverse_type = (current_task >= B1) ? A : B;
    tipo_apagado[reverse_type] = 1;
}
```
