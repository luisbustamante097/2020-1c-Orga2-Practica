# Ejercicio 3
## Tabla de descriptores
- Describa como completaria las primeras entradas de la GDT respetando las siguientes caracteristicas de los segmentos:

|Nro |Comienzo   |Tamaño      |Uso         |Atributos              |
|----|-----------|------------|------------|-----------------------|  
|1   |0 Gb       |2 Gb        |codigo      |No Lectura   / nivel 0 |
|2   |2 Gb       |1.5 Gb      |datos       |Escritura    / nivel 3 |
|3   |512 Mb     |4 Kb        |datos       |No Escritura / nivel 0 |
|4   |3 Gb       |256 Mb      |codigo      |Lectura      / nivel 3 |

Indique los valores base y limite en hexadecimal. Dibuje los segmentos indicando como se solapan.

```
SEGMENTO 1
    - BASE:     0x00000000
    - LIMITE:       tengo en cuenta que 2GiB= 2^31-1 => 2GiB = 0b1000 0000 0000 0000 0000 0000 0000 0000 - 0b1
                    (0x80000000 - 0x1)>>12 = 0x7FFFFFFF>>12 
            =>  0x7FFFF
SEGMENTO 2:
    - BASE:     0x80000000
    - LIMITE:       tengo en cuenta que 1.5GiB = 1GiB + 0.5GiB = 1GiB + 512MiB = 2^30 + 2^29
                    => 1.5GiB = 0b0110 0000 0000 0000 0000 0000 0000 0000 - 0b1
                    (0x60000000 - 0x1)>>12 = 0x5FFFFFFF>>12
            =>  0x5FFFF

SEGMENTO 3:
    - BASE:         tengo en cuenta que 512MiB = 2^29 => 2GiB = 0b0010 0000 0000 0000 0000 0000 0000 0000
            =>  0x20000000
                    
    - LIMITE:       (OBS: sin apagar la granularidad)
            =>  0x00000

SEGMENTO 4:
    - BASE:         tengo en cuenta que 3GiB = 2GiB + 1GiB = 2^31 + 2^30 = 0b1100 0000 0000 0000 0000 0000 0000 0000
            =>  0xC0000000
    - LIMITE:       tengo en cuenta que 256MiB = 2^28 => 256MiB = 0b0001 0000 0000 0000 0000 0000 0000 0000 - 0b1
                    (0x10000000 - 0x1)>>12 = 0x0FFFFFFF>>12
            =>  0x0FFFF


|...        |INICIAL        |FINAL(Exc)     |
|-----------|---------------|---------------|
|SEGMENTO 1 |0x00000000     |0x80000000     |
|SEGMENTO 2 |0x80000000     |0xE0000000     |
|SEGMENTO 3 |0x20000000     |0x20001000     |
|SEGMENTO 4 |0xC0000000     |0xD0000000     |



0x00000000|-----------------------|                  
          |                       |                      
          |                       |             
    ...   |                       |                        
          |                       \                    
          |                        |=======> SEGMENTO 1
0x20000000|-----====> SEGMENTO 3  /                    
0x20001000|----/                  |                      
          |                       |                                             
          |                       |                                             
    ...   |                       |                                             
          |                       |                                             
          |                       |                                             
0x80000000|-----------------------+------|                             
          |                              |                              
          |                              |                              
    ...   |                              |                              
          |                              |                              
          |                              \                              
0xC0000000|-----|                         |=======> SEGMENTO 2      
          |     \                        /                              
    ...   |      |====> SEGMENTO 4       |                              
          |     /                        |                              
0xD0000000|-----|                        |                              
          |                              |                              
    ...   |                              |                              
          |                              |                              
0xE0000000|------------------------------|                              
          |                                                             
    ...   |                                                             
          |                                                             
0xFFFFFFFF|                                                             

            
```

Para pensar:
- ¿Que problemas podria llegar a traer el solapamiento de segmentos?

El solapamiento de segmentos tiene el problema de que podrian estar solapandose segmentos con distintos permisos
Por ejemplo el Segmento 3 (Only-Read) esta dentro del Segmento1 (Only-Execute), el cual puede llevar a problemas de proteccion
Tambien podria pasar que algun segmento anidado tenga distinto nivel de proteccion.

- ¿Que logro la segmentacion que no se podia hacer con otros mecanismos?

La segmentacion logro dar un sistema para que el sistema operativo de segmentos de memoria ajustables a lo que se necesita
en sistemas donde la memoria RAM era escasa, la paginacion no era un medio facil de aplicar para sistema de esta indole.