# Enunciado
- Dado el sistema del ejercicio 1.
- Diseñar un servicio para el sistema que permita conocer la **cantidad de bytes** que una tarea tiene ocupados en su **pila de nivel tres**. El nuevo servicio se ocupará de determinar la cantidad de bytes que tiene ocupados en la pila **la otra tarea del par**, y retornar este valor. Por ejemplo, si la tarea B1 llama al servicio, el valor que este retornará, será la diferencia entre el puntero a la pila de la tarea B2 y la base de esta pila.

# Punto 1
- Explicar el diseño propuesto. Implementar en ASM/C la rutina de atención del servicio.

## Resolucion
El servicio bautizado `_cant_bytes_hermana` deberia funcionar de la siguiente forma:
 - localizo la entrada en la tss de la tarea hermana
 - localizo su `ebp` y su `esp`
 - el `esp` es de nivel 0, por lo que voy a buscar en la pila de nivel 0 el `esp` de nivel 3
 - una vez encontrado realizo la resta `ebp - esp`
 - retorno por registro `eax`

```c
//COPY PASTE DE LAS VARIABLES declaradas en el Ej1 que necesito
// Array de TSSs
tss tssArray [4]

// TAREAS:
#define A1  0
#define A2  1
#define B1  2
#define B2  3

//TIPOS:
#define A   0
#define B   1

uint16_t current_task;

void find_ebp_esp(uint32_t *esp_lvl0, uint32_t *ebp){
    //obtengo la id de la task hermana
    uint16_t hermana = current_task + (current_task%2==0)? 1 :(-1);
    
    //busco los datos en su TSS
    ebp = tssArray[hermana].ebp;
    esp_lvl0 = tssArray[hermana].esp;
    
    //el esp es de nivel 0 xq se guardo el estado de la tarea durante la ejecucion de la isr32
    // justo antes de hacer el popad  
}

```

```x86asm

_esp_lvl0:  dd 0x0
_ebp:       dd 0x0

global _cant_bytes_hermana
_cant_bytes_hermana:
    pushad
    
    push _esp_lvl0
    push _ebp
    call find_ebp_esp
    add esp, 8
    
    ;ahora busco en la pila de lvl0
    ; dado que yo hice la isr32, puedo asegurar que el estado
    ; de la pila es el siguiente:
    ; Pila de lvl0 en una isr luego de hacer PUSHAD:
    ; - |  EDI   |  <- esp 
    ;   |  ESI   |  <- esp + 1*4
    ;   |  EBP   |  <- esp + 2*4
    ;   |  ESP*  |  <- esp + 3*4
    ;   |  EBX   |  <- esp + 4*4
    ;   |  EDX   |  <- esp + 5*4   
    ;   |  ECX   |  <- esp + 6*4
    ;   |  EAX   |  <- esp + 7*4
    ;   ----------
    ;   |  EIP   |  <- esp + 8*4
    ;   |  CS    |  <- esp + 8*4 + 1*4
    ;   |  EFLAGS|  <- esp + 8*4 + 2*4
    ;   |  ESP   |  <- esp + 8*4 + 3*4  <----lo que necesito
    ;   |  SS    |  <- esp + 8*4 + 4*4
    ; + |  ...   |  <- ss0:esp0
    
    ;obtengo el esp de lvl3
    mov eax, [_esp_lvl0]
    mov ebx, [eax + 8*4 + 3*4]
    
    ;y listo, tengo guardado el ebp, y el esp de nivel 3 en ebx
    mov eax, [_ebp]
    sub eax, ebx
    
    ;retorno por eax la cantidad de bytes
    
    popad
    iret
```
