# Enunciado
- Como se mencionó en el ejercicio 1, cada tarea comparte una página con la otra tarea de su par. Es decir, si A1 escribe un dato en esta página, A2 podrá leerlo o modificarlo, ya que fisicamente corresponden a la misma página.
- Se pide diseñar un servicio para el sistema que permita detectar cuando una tarea altero el contenido de su página compartida. **El nuevo servicio permitirá a una tarea, determinar si la otra tarea del par escribió en la página compartida**. Adicionalmente, cada vez que se llame al servicio, **se indicará sí entre los llamados, la página fue modificada.**
- Por ejemplo, si la tarea A1 escribe en la página compartida, y luego la tarea A2 llama al servicio. El mismo retornará indicando verdadero, ya que la página fue escrita. Ahora, si inmediatamente, la tarea A2 vuelve a llamar al servicio, el mismo retornará falso, ya que entre los dos llamados al servicio, la tarea A1 no escribió en la página compartida.

# Punto 1
Explicar el diseño propuesto. Implementar en ASM/C la rutina de atención del servicio.

## Resolucion

La rutina `_dirty_page` se encargara de avisar a la tarea que lo use si, la pagina compartida fue usada por su tarea hermana. Ademas el uso de este servicio tiene memoria en la respuestas.

Los pasos a seguir van a ser:
- Obtener el cr3 de la tarea hermana, desde su TSS
- Buscar la PD y PT que corresponde a la pagina compartida
- Verificar si el bit de Dirty esta prendido
  - SI es que lo está, lo vamos a apagar y vamos a devolver por eax un 1
  - SI NO, vamos a devolver por eax un 0

La justificacion de que esto funciona es debido a que el proposito del bit `dirty` en la PTE es de activarse cuando alguien hace una escritura en la pagina que representa esta PTE
OBS: con respecto al paso 1, primero pense que podia utilizar el CR3 de la tarea actual pero me di cuenta que el bit dirty estaria apagado porque justamente representa al mapeo de la tarea que llama al servicio. Por lo que necesariamente se debe utilizar el CR3 de la tarea hermana

<details>
  <summary>Estructura usada de PDE y PTE en C</summary>
  
  ```c
  typedef struct str_page_dir_entry
  {
    uint8_t present:1;
    uint8_t read_write:1;
    uint8_t user_supervisor:1;
    uint8_t page_write_through:1;
    uint8_t page_cache_disable:1;
    uint8_t accesed:1;
    uint8_t x:1;
    uint8_t page_size:1;
    uint8_t ignored:1;
    uint8_t available:3;
    uint32_t page_table_base:20;
  }__attribute((__packed__)) page_dir_entry;
  
  typedef struct str_page_table_entry
  {
    uint8_t present:1;
    uint8_t read_write:1;
    uint8_t user_supervisor:1;
    uint8_t page_write_through:1;
    uint8_t page_cache_disable:1;
    uint8_t accesed:1;
    uint8_t dirty:1;
    uint8_t x:1;
    uint8_t global:1;
    uint8_t available:3;
    uint32_t physical_address_base:20;
  }__attribute((__packed__)) page_table_entry;
  ```
</details>


```c
//COPY PASTE DE LAS VARIABLES declaradas en el Ej1 que necesito

// TAREAS:
#define A1  0
#define A2  1
#define B1  2
#define B2  3

//TIPOS:
#define A   0
#define B   1

// Array de TSSs
tss tssArray [4]

uint16_t current_task;

uint8_t is_dirty_page(){
    //Obtengo el cr3 de la tarea hermana
    // Primero obtengo la id de la task hermana
    uint16_t hermana = current_task + (current_task%2==0)? 1 :(-1);
    
    //Ahora obtengo el cr3 de la tarea hermana
    uint32_t cr3_hermana = tssArray[hermana].cr3;
    
    //casteo el cr3 adecuadamente a una PD
    page_dir_entry* pd = (page_dir_entry*) ((cr3_hermana)&~0xFFF);
    uint32_t* pde_idx;
    uint32_t* pte_idx;
    
    //Obtengo los indices para acceder a la PDE y a la PTE correspondiente
    obtener_pde_pte(pde_idx, pte_idx);
    
    page_table_entry* pt = (page_table_entry*) &(pd[*pde_idx].page_table_base);
    //si esta en dirty
    if (pt[*pte_idx]->dirty == 1){
        // lo reinicio
        pt[pte_idx]->dirty = 0;
        //y devuelvo 1
        return 1;
    }
    // si estaba en 0 retorno 0
    return 0;
}

void obtener_pde_pte(uint32_t *pde_idx, uint32_t *pte_idx){
    uint32_t virtual = 0x13370000; 
    // valor dado como el lugar donde se ejecutan las tareas en el enunciado del Ejercicio 1
    // DIR Virtual = | 31 ... 22 | 21 ... 12 | 11 ... 0 | 
    uint32_t directoryIdx = virtual >> 22;
    uint32_t tableIdx = (virtual >> 12) & 0x3FF;
    
    *pde_idx = directoryIdx;
    *pte_idx = tableIdx;
}
```

```x86asm

global _dirty_page
_dirty_page:
    pushad
    
    call is_dirty_page
    ;supongo que el retorno es por eax
    
    popad
    iret

```
