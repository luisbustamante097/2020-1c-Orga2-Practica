# Ejercicio 7
## Varias virtuales a una misma fisica
Se desea tener una funcion que dada una direccion de memoria correspondiente a la base del directorio de paginas, y una direccion fisica, devuelva un valor correspondiente a la cantidad de direcciones virtuales distintas con las cuales se puede acceder a dicha direccion.

La signatura debe ser `unsigned int cantidaddirecciones(unsigned int basedir, unsigned int fisica);`

Describa en lenguaje coloquial los pasos a seguir para completar dicha tarea.

*Opcional*: Escriba el codigo en C de la funcion.

# SOLUCION:

La idea seria pararse en la direccion base de la PD y empezar a recorrer cada una de las PDE, viendo si estas tienen el bit de presente, si es asi ingreso a la direccion de su PT correspondiente

Una vez dentro recorro toda la PT viendo si el bit de presente esta prendido y si la direccion base de la PTE es igual a `fisica>>12` ya que ese es el valor que tiene que tener la PTE para que la dir fisica este mapeada en esa PTE.

```c
unsigned int cantidaddirecciones(unsigned int basedir, unsigned int fisica){
    unsigned int res = 0;
    pde* PD = (pde*) basedir;
    for (int i=0; i<1024; i++){
        if (PD[i].p == 1){
            pte* PT_i = (pte*) (PD[i].page_base << 12);
            for (int j=0; j<1024; j++){
                if (PT_i[j].p == 1 && PT_i[j].page_base == (fisica>>12)){
                    res++;
                }
            }
        }
    }
    return res;
}
```

## Para pensar:
- ¿Como modificaria la funcion si se quieren considerar solo las direcciones que se puedan acceder en nivel Supervisor?
  
```c
unsigned int cantidaddirecciones(unsigned int basedir, unsigned int fisica){
    unsigned int res = 0;
    pde* PD = (pde*) basedir;
    for (int i=0; i<1024; i++){
        if (PD[i].p ==  && PD[i].us == 0){
            pte* PT_i = (pte*) (PD[i].page_base << 12);
            for (int j=0; j<1024; j++){
                if (PT_i[j].p == 1 && PT_i[j].us == 0 && PT_i[j].page_base == (fisica>>12)){
                    res++;
                }
            }
        }
    }
    return res;
}
```
  
- Si el valor devuelto por los llamados a las funciones anteriores con una determinada direccion fisica es 0, 
    ¿se  puede suponer que la pagina correspondiente es una pagina fisica libre? Justifique.
    
FALSO: la pagina correspondiente va a ser una pagina fisica libre solo para ese PD en especifico, puede existir un PD con dicha direccion mapeada, por lo que hace falsa la premisa.

**Nota:** Considerar que los marcos de pagina son de 4kb.