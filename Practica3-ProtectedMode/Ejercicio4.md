# Ejercicio 4 
## Paginacion
- Escriba todas las entradas de las estructuras que se requieran para construir el siguiente esquema de paginacion, suponiendo que todas las entradas no mencionadas son nulas:

|Rango virtual               |Rango fisico             |
|----------------------------|-------------------------|
|`0x20000000 a 0x20004FFF`   |`0x5AA0A000 a 0x5AA0EFFF`|
|`0xC0000000 a 0xC0002FFF`   |`0x000AA000 a 0x000ACFFF`|

Todos los rangos incluyen el ultimo valor. Se deben setear los permisos para supervisor

```
RANGO 1:
    0x20000000: 0010 0000 0000 0000 0000 0000 0000 0000
                pdIndex = 00 1000 0000; ptIndex = 00 0000 0000; offset = 0000 0000 0000 (binary)
                pdIndex = 080         ; ptIndex = 000         ; offset = 000            (hex)
    0x20004FFF: 0010 0000 0000 0000 0100 1111 1111 1111
                pdIndex = 00 1000 0000; ptIndex = 00 0000 0100; offset = 1111 1111 1111 (binary)
                pdIndex = 080         ; ptIndex = 004         ; offset = FFF            (hex)

0x20000000 = pdIndex = 080; ptIndex = 000
0x20004FFF = pdIndex = 080; ptIndex = 004

<PT0>
------------------------------
000 |Dir Base: 0x5AA0A; U/S: 0
001 |Dir Base: 0x5AA0B; U/S: 0
002 |Dir Base: 0x5AA0C; U/S: 0
003 |Dir Base: 0x5AA0D; U/S: 0
004 |Dir Base: 0x5AA0E; U/S: 0
    |
... |
    |
3FF |



RANGO 2:
    0xC0000000: 1100 0000 0000 0000 0000 0000 0000 0000
                pdIndex = 11 0000 0000; ptIndex = 00 0000 0000; offset = 0000 0000 0000 (binary)
                pdIndex = 300         ; ptIndex = 000         ; offset = 000            (hex)
    0xC0002FFF: 1100 0000 0000 0000 0010 1111 1111 1111
                pdIndex = 11 0000 0000; ptIndex = 00 0000 0010; offset = 1111 1111 1111 (binary)
                pdIndex = 300         ; ptIndex = 002         ; offset = FFF            (hex)

0xC0000000 = pdIndex = 300; ptIndex = 000
0xC0002FFF = pdIndex = 300; ptIndex = 002

<PT1>
------------------------------
000 |Dir Base: 0x000AA; U/S: 0
001 |Dir Base: 0x000AB; U/S: 0
002 |Dir Base: 0x000AC; U/S: 0
    |
... |
    |
3FF |


```

### SOLUCION FINAL:
```
< PD >
----------------
000|   ...                              
...|                                 
080| PT0; U/S: 0                                 
...|                                   
300| PT1; U/S: 0                                
...|                                 
3FF|   ...        


< PT0 >                          //    <PT1>           
------------------------------   //    ------------------------------   
000 |Dir Base: 0x5AA0A; U/S: 0   //    000 |Dir Base: 0x000AA; U/S: 0                       
001 |Dir Base: 0x5AA0B; U/S: 0   //    001 |Dir Base: 0x000AB; U/S: 0                       
002 |Dir Base: 0x5AA0C; U/S: 0   //    002 |Dir Base: 0x000AC; U/S: 0                       
003 |Dir Base: 0x5AA0D; U/S: 0   //        |                       
004 |Dir Base: 0x5AA0E; U/S: 0   //    ... |                       
    |                            //        |    
... |                            //    3FF |    
    |                            //        
3FF |                            //        
                            

```




## Para pensar:
- Enumere toda la informacion que debe contener una entrada de un directorio o tabla de paginas.

(RESPUESTA EN MANUAL DE INTEL)

- Suponiendo que se construye un esquema de paginacion donde ninguna pagina utiliza identity mapping, ¿es posible activar paginacion bajo estas condiciones?