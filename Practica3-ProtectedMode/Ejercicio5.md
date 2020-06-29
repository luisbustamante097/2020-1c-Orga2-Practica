# Ejercicio 5
## Resolver direcciones:
- Dado el siguiente esquema de segmentacion y paginacion:

### GDT
|Indice  |Base        |Limite      |DPL     |Tipo|
|--------|------------|------------|--------|----|
|1       |0x00000000  |0x7FFFFFFF  |00      |1100|
|2       |0x80000000  |0x5FFFFFFF  |11      |1001|
|3       |0x20000000  |0x00000FFF  |00      |1000|
|4       |0xC0000000  |0x0FFFFFFF  |11      |1101|

### Directorio de paginas
|Indice  |(dec)   |PT                   |
|--------|--------|---------------------|
|0x000   |0       |0x00000000           |
|···     |···     |···                  |
|0x07F   |127     |0x00000000           |
|0x080   |128     |pagedirectory1 || 3  |
|0x081   |129     |0x00000000           |
|···     |···     |···                  |
|0x2FF   |767     |0x00000000           |
|0x300   |768     |pagedirectory2 || 3  |
|0x301   |769     |0x00000000           |
|···     |···     |···                  |
|0x3FF   |1023    |0x000000002          |

### Tablas de paginas
```
      <Tabla de paginas 1>         //          <Tabla de paginas 2>
|Indice  |(dec)   |Base      |     //     |Indice  |(dec)   |Base      |
|--------|--------|----------|     //     |--------|--------|----------|
|0x000   |0       |0x5AA0A003|     //     |0x000   |0       |0x000AA003|
|0x001   |1       |0x5AA0B003|     //     |0x001   |1       |0x000AB003|
|0x002   |2       |0x5AA0C003|     //     |0x002   |2       |0x000AC003|
|0x003   |3       |0x5AA0D003|     //     |0x003   |3       |0x00000000|
|0x004   |4       |0x5AA0E003|     //     |···     |···     |···       |
|0x005   |5       |0x00000000|     //     |0x3FF   |1023    |0x00000000|
|···     |···     |···       |     //
|0x3FF   |1023    |0x00000000|     //
```

Resuelva las siguientes direcciones desde logica a fisica, pasando por la lineal y utilizandolas estructuras construidas en los items anteriores.
Indique si se produce un error de proteccion y en que unidad se genera.

```
    0x0008:0x2000171A   (Ejecucion  con CPL 00)
    0x0010:0x40002832   (Escritura  con CPL 11)
    0x0018:0x0000071A   (Lectura    con CPL 00)
    0x0020:0x00000001   (Lectura    con CPL 11)
```

# SOLUCION:

## Direccion 1:
```
Dir 1 = 0x0008:0x2000171A   (Ejecucion  con CPL 00)

# Logica -> Lineal
    Selector de segmento = 0x0008 >> 3 = 0x1 (gdtIndex=1)
    Corresponde a:
        |Indice  |Base        |Limite      |DPL     |Tipo|
        |1       |0x00000000  |0x7FFFFFFF  |00      |1100|
    
    Lineal = Base + offset = 0x0000000 + 0x2000171A = 0x2000171A
        *Limite?    0x2000171A <= 0x7FFFFFFF (o 0x2000171A < 0x80000000) --> OK!
        *Ejecucion? Tipo: 1100 = Execute Only (conforming)               --> OK! 
```

`LINEAL = 0x2000171A`
    
```

# Lineal -> Fisica
                
                |DIRECTORY ||  TABLE   | |   OFFSET   |
    0x2000171A: 0010 0000 0000 0000 0001 0111 0001 1010
                pdIndex = 00 1000 0000; ptIndex = 00 0000 0001; offset = 0111 0001 1010 (binary)
                pdIndex = 080         ; ptIndex = 001         ; offset = 71A            (hex)

    0x2000171A: pdIndex = 080; ptIndex = 001; offset = 71A
    
             |Indice  |(dec)   |PT                   |
    PDE ->   |0x080   |128     |pagedirectory1 || 3  |
                                     |
                                    PTE ->  |0x001   |1       |0x5AA0B003|
    
    Fisica = (0x5AA0B003 >> 12) << 12 + 0x71A = 0x5AA0B000 + 0x71A = 0x5AA0B71A
        *Ejecucion?     Atributo=0x3 --> U/S = 0; R/W = 1; Present = 1  --> OK!

```

`FISICA = 0x5AA0B71A`

<!-- ------------------------------------------------------------------------------------------------ -->

## Direccion 2:
```
Dir 2 = 0x0010:0x40002832   (Escritura  con CPL 11)

# Logica -> Lineal
    Selector de segmento = 0x0010 >> 3 = 0x2 (gdtIndex=2)
    Corresponde a:
        |Indice  |Base        |Limite      |DPL     |Tipo|
        |2       |0x80000000  |0x5FFFFFFF  |11      |1001|
    
    Lineal = Base + offset = 0x80000000 + 0x40002832 = 0xC0002832
        *Limite?    0x40002832 <= 0x5FFFFFFF        --> OK!
        *Ejecucion? Tipo: 1001 = Execute Only       --> OK!
```

`LINEAL = 0xC0002832`
    
```
# Lineal -> Fisica
                
                |DIRECTORY ||  TABLE   | |   OFFSET   |
    0xC0002832: 1100 0000 0000 0000 0010 1000 0011 0010
                pdIndex = 11 0000 0000; ptIndex = 00 0000 0010; offset = 1000 0011 0010 (binary)
                pdIndex = 300         ; ptIndex = 002         ; offset = 832            (hex)

    0xC0002832: pdIndex = 0x300; ptIndex = 0x002; offset = 0x832
    
             |Indice  |(dec)   |PT                   |
    PDE ->   |0x300   |768     |pagedirectory2 || 3  |
                                     |
                                    PTE ->  |0x002   |2       |0x000AC003|
    
    Fisica = (basePTE>>12)<<12 + offset = (0x000AC003 >> 12) << 12 + 0x832 = 0x000AC000 + 0x832 = 0x000AC832
        *Escritura?     Atributo=0x3 --> U/S = 0; R/W = 1; Present = 1 --> OK!

```

`FISICA = 0x000AC832`

<!-- ------------------------------------------------------------------------------------------------ -->

## Direccion 3:
```
Dir 3 = 0x0018:0x0000071A   (Lectura    con CPL 00)

# Logica -> Lineal
    Selector de segmento = 0x0018 >> 3 = 0x3 (gdtIndex=3)
    Corresponde a:
        |Indice  |Base        |Limite      |DPL     |Tipo|
        |3       |0x20000000  |0x00000FFF  |00      |1000|
    
    Lineal = Base + offset = 0x20000000 + 0x0000071A = 0x2000071A
        *Limite?    0x0000071A <= 0x00000FFF        --> OK!
        *Ejecucion? Tipo: 1000 = Execute Only       --> OK!
```

`LINEAL = 0x2000071A`
    
```
# Lineal -> Fisica
                
                |DIRECTORY ||  TABLE   | |   OFFSET   |
    0x2000071A: 0010 0000 0000 0000 0000 0111 0001 1010
                pdIndex = 00 1000 0000; ptIndex = 00 0000 0000; offset = 0111 0001 1010 (binary)
                pdIndex = 080         ; ptIndex = 000         ; offset = 71A            (hex)

    0x2000071A: pdIndex = 0x080; ptIndex = 0x000; offset = 0x71A
    
             |Indice  |(dec)   |PT                   |
    PDE ->   |0x080   |128     |pagedirectory1 || 3  |
                                     |
                                    PTE ->  |0x000   |0       |0x000AA003|
    
    Fisica = (basePTE>>12)<<12 + offset = (0x000AA003 >> 12) << 12 + 0x832 = 0x000AA000 + 0x71A = 0x000AA71A
        *Lectura?     Atributo=0x3 --> U/S = 0; R/W = 1; Present = 1 --> OK!

```

`FISICA = 0x000AA71A`

<!-- ------------------------------------------------------------------------------------------------ -->





## Direccion 4:
```
Dir 4 = 0x0020:0x00000001   (Lectura    con CPL 11)

# Logica -> Lineal
    Selector de segmento = 0x0020 >> 3 = 0x4 (gdtIndex=4)
    Corresponde a:
        |Indice  |Base        |Limite      |DPL     |Tipo|
        |4       |0xC0000000  |0x0FFFFFFF  |11      |1101|
    
    Lineal = Base + offset = 0xC0000000 + 0x00000001 = 0xC0000001
        *Limite?    0x00000001 <= 0x0FFFFFFF                --> OK!
        *Lectura? Tipo: 1101 = Execute-Only, conforming     --> ERROR!
            
            Se pide que tenga permiso de lectura pero el segmento solo permite Ejecucion
```

<!-- ------------------------------------------------------------------------------------------------ -->


# SOLUCION FINAL

- DIRECCION 1: `LOGICA = 0x0008:0x2000171A => LINEAL = 0x2000171A => FISICA = 0x5AA0B71A`  
- DIRECCION 2: `LOGICA = 0x0010:0x40002832 => LINEAL = 0xC0002832 => FISICA = 0x000AC832`  
- DIRECCION 3: `LOGICA = 0x0018:0x0000071A => LINEAL = 0x2000071A => FISICA = 0x000AA71A`  
- DIRECCION 4: `LOGICA = 0x0020:0x00000001 => ERROR en SEGMENTACION`  


## Para pensar:
- ¿Que diferencias hay entre las direcciones de memoria logica, lineal y fisica?

    - **Direccion Logica**: Es la que usa el programador, y seria la de mas alto nivel, en general se utiliza con un selector de segmento aunque este no siempre necesario ya que el selector `cs` estar implicito si ninguno es utilizado
    - **Direcion Lineal (virtual)**: Es la resultante de pasar la dir logica por la unidad de segmentacion, seria la que la cpu maneja internamente y esta no es visible al programador. Esta puede ser la fisica si la paginacion no esta activa
    - **Direccion Fisica**: Si no tenemos la paginacion activa la direccion lineal pasa a ser la direccion fisica, si tenemos paginacion la direccion fisica es el resultado de pasar la direccion lineal por la MMU. Esta direccion representa a la direccion real de la celda de memoria dentro de la memoria RAM.

- ¿Que chequeos hay que hacer al traducir una direccion? ¿Que errores pueden generar?

    - **Traducir de Logica a Lineal**: los chequeos que se hacen son con respecto al _limite_ y a los _permisos_, el offset de la dir logica debe ser menor que el valor que estipula el _limite_. En cuanto a los permisos, el descriptor de segmento debe tener los permisos que indica el selector para que se haga una correcta traduccion.
    - **Traducir de Lineal a Fisica**: para poder traducir bien se tiene que cumplir la existencia del _pdIndex_ y _ptIndex_ en cuanto a que deben existir entradas en la PD y PT correspondientes a esos indices. Ademas se tienen que respetar los permisos de U/S y R/W con respecto al uso que este teniendo la dir de memoria.