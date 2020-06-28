# Ejercicio 2
## Segmentacion en modo protegido
- Sea la siguiente GDT:

|Indice|Entrada GDT       |
|------|------------------|
|0h    |NULL              |
|1h    |Dir. Base = 71230h|
|2h    |Dir. Base = 72230h|
|...   |                  |
|Ah    |Dir. Base = 7A230h|
|Bh    |Dir. Base = 7B230h|

1. En modo protegido, calcular la direccion fisica indicada por 0058:0000FFEC.
Recordar que los ultimos tres bits del selector de segmento estan reservados y por lo tanto no son utilizados para indexar la GDT.
```
Indice de la GDT <= 0058 >> 3 = 0101 1000 >> 3 = 0b1011 = 0xB
Existe indice 0xB en la GDT? Si!

Direccion fisica <= (dir base) + (offset) = 0x7B230 + 0x0FFEC = 0x0008B21C
Limite: ya que no esta explicito el limite supongo que la dir esta dentro del limite
```


2.  ¿Y si la direccion fuera 0059:0000FFEC?

Indice de la GDT <= 0059 >> 3 = 0101 1001 >> 3 = 0b1011 = 0xB
Existe indice 0xB en la GDT? Si!
La direccion fisica seria exactamente la misma que antes, solo que en este caso el GPL es el que cambio

- ¿Cual es el mecanismo general para calcular cualquier direccion fisica en modo protegido(sin paginacion)?
    
    Direccion fisica <= (dir base) + (offset) <--- y ademas chequear que el offset este dentro del limite de la entrada de la GDT

- ¿Cual es el tamaño maximo de un segmento? ¿Para que sirve el bit G? ¿Que pasaria sino lo tuviera?
    
    - Tamaño max de un segmento con G=1: 4GiB - 1B
        ya que el limite puede estar en `0xFFFFF` desde la base 0x0, por lo que el ultimo byte accesible sera `0xFFFFFFFF` (4GiB - 1B)
    - Tamaño max de un segmento con G=0: 1MiB - 1B
        ya que el limite va a estar en `0xFFFFF` desde la base 0x0, por lo que el ultimo byte accesible sera el `0xFFFFF` (1MiB - 1B)
        
    El byte de granualaridad permite que se pueda tener un espacio direccionable mayor a 1MiB, si no lo tuvieramos,
    como lo es modo real, solo se podria acceder hasta el 1MiB de la RAM.
    