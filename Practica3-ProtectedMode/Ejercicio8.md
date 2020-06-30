# Ejercicio 8
## Compartir una pagina
Se desea tener una funcion que dados los CR3 de dos procesos genere una pagina de memoria fisica compartida entre dichos procesos.

La signatura debe ser `void sharedPage(int CR31,int CR32);`

Describa en lenguaje coloquial los pasos a seguir para completar dicha tarea. No es necesario indicarle a los procesos en que direccion virtual queda mapeada la pagina compartida.

_Opcional_: Escriba el codigo en C de la funcion. Cuenta con las funciones `getNextFreeFramePage()` que devuelve una direccion de memoria fisica libre para ubicar una pagina, y `getNextFreePageEntry(int CR3)` que devuelve la proxima direccion lineal cuyo _PageEntry_ se encuentra disponible.

# Solucion:
```c
void mmu_mapPage(int cr3, int lineal, int phy, int attrs);
// Funcion que a partir de un cr3, una dir lineal y una fisica con los atributos correspondientes
// realiza un mapeo valido de la dir lineal a la fisica

int getNextFreeFramePage();
// devuelve una dir de memoria fisica libre para ubicar una pagina

int getNextFreePageEntry(int CR3);
// devuelve la proxima direccion lineal cuyo pageEntry se encuentra disponible

void sharedPage(int CR3_1, int CR3_2){
    int fisicaCompartida = getNextFreeFramePage();
    int lineal_cr3_1 = getNextFreePageEntry(int CR3_1);
    int lineal_cr3_2 = getNextFreePageEntry(int CR3_2);
    
    int us = 0b00
    int rw = 0b01
    
    mmu_mapPage(cr3_1, lineal_cr3_1, fisicaCompartida, us|rw);
    mmu_mapPage(cr3_2, lineal_cr3_2, fisicaCompartida, us|rw);
    
}

```

## Para pensar:
- ¿Que riesgos existen en un sistema de paginacion con paginas compartidas?

Todos los riesgos posibles dado que cada que estemos cambiando de cr3, van a posibles escrituras en esa pagina compartida, los cuales no seran percibidos por el cambio del siguiente cr3.

- ¿Que permisos deberian tener las paginas compartidas segun su finalidad, codigo, datos y otros factores? Justifique.