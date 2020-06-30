# Ejercicio 6
## Generar tablas de traducciones
- Considerando la siguiente tabla de traducciones de direcciones por segmentacion y paginacion. De ser posible, dar un conjunto de descriptores de segmento, directorio de paginas y tablas de paginas que cumplan con todas las traducciones **simultaneamente**. Detallar los campos de todas las estructuras involucradas. Ademas indicar desde que segmento de codigo se esta ejecutando cada acceso, si la traduccion es con identity mapping y en el caso que alguna traduccion no sea posible indicar por que.
  
|Logica             |Lineal      |Fisica      |Caracteristicas|
|-------------------|------------|------------|---------------|
|0x10B:0x09344FFA   |0x0A334FFA  |0x00DAAFFA  |Datos  Nivel 3, Solo lectura ; Accion: Lectura de 4 bytes, como nivel 3|
|0x110:0x009A3124   |0x016A3124  |0x016A3124  |Codigo Nivel 3 ; Accion: Lectura de 2 bytes, como nivel 0|
|0x110:0x00034FFA   |0x00D34FFA  |0x00FAAFFA  |Codigo Nivel 0, Segmento Conforming ; Accion: Ejecucion de 5 bytes, como nivel 0|
|0x198:0x0031300E   |0x003F1DEE  |0xF5612DEE  |Datos  Nivel 0 ; Accion: Escritura de 4 bytes, como nivel 0|

# Direccion 1:

`|0x10B:0x09344FFA   |0x0A334FFA  |0x00DAAFFA  |Datos  Nivel 3, Solo lectura ; Accion: Lectura de 4 bytes, como nivel 3|`

## Logica -> Lineal (Segmentacion)
```
LOGICA:   0x10B:0x09344FFA    (Datos  Nivel 3, Solo lectura ; Accion: Lectura de 4 bytes, como nivel 3)

Selector de Segmento: (0x10B >> 3) = 0x21 --> (gdtIndex=33)

Debo pasar a la dir LINEAL 0x0A334FFA:
* Base?: Puedo calcular la base del descriptor como LINEAL - OFFSET = 0x0A334FFA-0x09344FFA = 0x00FF0000
    --> BASE = 0x00FF0000
    
* Limite?: Debo hacer una lectura de 4 bytes 
    --> debo considerar las direcciones 0x09344FFA...0x09344FFE
    Todas caen dentro de la misma pagina, por lo que puedo darles una sola pagina de 4KiB
    --> LIMITE = 0x00000
    --> G = 1
    
* DPL?: Nivel 3 (segun enunciado)
    --> DPL = 0b11

* Tipo?: Datos/Solo Lectura (segun enunciado)
    --> Tipo = 0b0000
```

## Lineal -> Fisica (Paginacion)
```
LINEAL: 0x0A334FFA

Debo pasar a la dir FISICA: 0x00DAAFFA
* Primero debo verificar que los ultimos 12 bits de ambas direccciones sean iguales --> OK!
* Todas caen dentro de la misma pagina?     --> OK!
    --> siginifica que puedo darle una sola pagina de 4KiB

* Ahora calculo el pdIndex, ptIndex y offset: 

                |DIRECTORY ||  TABLE   | |   OFFSET   |
    0x0A334FFA: 0000 1010 0011 0011 0100 1111 1111 1010
                pdIndex = 00 0010 1000; ptIndex = 11 0011 0100; offset = 1111 1111 1010 (binary)
                pdIndex = 028         ; ptIndex = 334         ; offset = FFA            (hex)

    0x0A334FFA: pdIndex = 0x028; ptIndex = 0x334; offset = 0xFFA

* PDE:
    + Indice:   0x028
    + PT:       PT_0   --> Le asigno la primer PT
    + U/S:      1 (User)
    + R/W:      0 (Read only)
    + Present:  1
    + Los demas atributos se setean en 0 (El address se setea en la dir correspondiente)
    
* PT_0:
    + Indice:   0x0
    ...
    + Indice:   0x334
        + Page-frame addr: (dirFisica>>12)<<12 = 0x00DAA
        + U/S:      1 (User)
        + R/W:      0 (Read only)
        + Present:  1
        + Los demas atributos se setean en 0
    ...    
    + Indice:   0x3FF
```

<!-- ------------------------------------------------------------------------------------------------ -->


# Direccion 2:

`|0x110:0x009A3124   |0x016A3124  |0x016A3124  |Codigo Nivel 3 ; Accion: Lectura de 2 bytes, como nivel 0|`

## Logica -> Lineal (Segmentacion)
```
LOGICA:   0x110:0x009A3124    (Codigo Nivel 3 ; Accion: Lectura de 2 bytes, como nivel 0)

Selector de Segmento: (0x110 >> 3) = 0x22 --> (gdtIndex=34)

Debo pasar a la dir LINEAL 0x016A3124:
* Base?: Puedo calcular la base del descriptor como LINEAL - OFFSET = 0x016A3124-0x009A3124 = 0x00D00000
    --> BASE = 0x00D00000
    
* Limite?: Debo hacer una lectura de 2 bytes 
    --> debo considerar las direcciones 0x009A3124...0x009A3125
    Todas caen dentro de la misma pagina, por lo que puedo darles una sola pagina de 4KiB
    --> LIMITE = 0x00000
    --> G = 1
    
* DPL?: Nivel 3 (segun enunciado)
    --> DPL = 0b11

* Tipo?: Codigo/Lectura (segun enunciado)
    --> Tipo = 0b1010
```

## Lineal -> Fisica (Paginacion)
```
LINEAL: 0x016A3124

Debo pasar a la dir FISICA: 0x016A3124
* Primero debo verificar que los ultimos 12 bits de ambas direccciones sean iguales --> OK!
* Todas caen dentro de la misma pagina?     --> OK!
    --> siginifica que puedo darle una sola pagina de 4KiB

* Ahora calculo el pdIndex, ptIndex y offset: 

                |DIRECTORY ||  TABLE   | |   OFFSET   |
    0x016A3124: 0000 0001 0110 1010 0011 0001 0010 0100
                pdIndex = 00 0000 0101; ptIndex = 10 1010 0011; offset = 0001 0010 0100 (binary)
                pdIndex = 005         ; ptIndex = 2A3         ; offset = 124            (hex)

    0x016A3124: pdIndex = 0x005; ptIndex = 0x2A3; offset = 0x124

* PDE:
    + Indice:   0x005
    + PT:       PT_1   --> Le asigno la segunda PT
    + U/S:      0 (Supervisor)
    + R/W:      0 (Read only)
    + Present:  1
    + Los demas atributos se setean en 0 (El address se setea en la dir correspondiente)
    
* PT_1:
    + Indice:   0x0
    ...
    + Indice:   0x2A3
        + Page-frame addr: (dirFisica>>12)<<12 = 0x016A3
        + U/S:      0 (Supervisor)
        + R/W:      0 (Read only)
        + Present:  1
        + Los demas atributos se setean en 0
    ...    
    + Indice:   0x3FF
```

# Direccion 3:

`|0x110:0x00034FFA   |0x00D34FFA  |0x00FAAFFA  |Codigo Nivel 0, Segmento Conforming ; Accion: Ejecucion de 5 bytes, como nivel 0|`

## Logica -> Lineal (Segmentacion)
```
LOGICA:   0x110:0x00034FFA    (Codigo Nivel 0, Segmento Conforming ; Accion: Ejecucion de 5 bytes, como nivel 0)

Selector de Segmento: (0x110 >> 3) = 0x22 --> (gdtIndex=34)

Debo pasar a la dir LINEAL 0x00D34FFA:
* Base?: Puedo calcular la base del descriptor como LINEAL - OFFSET = 0x00D34FFA-0x00034FFA = 0x00D00000
    --> BASE = 0x00D00000
    
* COMPROBACION DE ENTRADA a la GDT: Tenemos la direccion 2 y 3 con referencia al mismo descriptor de segmento
    En ambos casos la base requerida para las direcciones son iguales, por lo que no tenemos ningun problema --> OK!
    
* Limite?: Debo hacer una lectura de 5 bytes 
    --> debo considerar las direcciones 0x00D34FFA...0x00D34FFE
    Todas caen dentro de la misma pagina, por lo que puedo darles una sola pagina de 4KiB
    --> LIMITE = 0x00000
    --> G = 1
    
* DPL?: Nivel 3 (para poder ejecutar la lectura de la dir 2)
    --> DPL = 0b11

* Tipo?: Codigo/Ejecucion-Conforming (segun enunciado) (Ademas debo considerar el seteo para la dir 2 que comparte la misma entrada)
    --> Tipo = 0b1110   (Execute-Read, Conforming)
```

## Lineal -> Fisica (Paginacion)
```
LINEAL: 0x00D34FFA

Debo pasar a la dir FISICA: 0x00FAAFFA
* Primero debo verificar que los ultimos 12 bits de ambas direccciones sean iguales --> OK!
* Todas caen dentro de la misma pagina?     --> OK!
    --> siginifica que puedo darle una sola pagina de 4KiB

* Ahora calculo el pdIndex, ptIndex y offset: 

                |DIRECTORY ||  TABLE   | |   OFFSET   |
    0x00D34FFA: 0000 0000 1101 0011 0100 1111 1111 1010
                pdIndex = 00 0000 0011; ptIndex = 01 0011 0100; offset = 1111 1111 1010 (binary)
                pdIndex = 003         ; ptIndex = 134         ; offset = FFA            (hex)

    0x00D34FFA: pdIndex = 0x003; ptIndex = 0x134; offset = 0xFFA

* PDE:
    + Indice:   0x003
    + PT:       PT_2   --> Le asigno la tercer PT
    + U/S:      0 (Supervisor)
    + R/W:      0 (Read only)
    + Present:  1
    + Los demas atributos se setean en 0 (El address se setea en la dir correspondiente)
    
* PT_2:
    + Indice:   0x0
    ...
    + Indice:   0x134
        + Page-frame addr: (dirFisica>>12)<<12 = 0x00FAA
        + U/S:      0 (Supervisor)
        + R/W:      0 (Read only)
        + Present:  1
        + Los demas atributos se setean en 0
    ...    
    + Indice:   0x3FF
```

# Direccion 4:

`|0x198:0x0031300E   |0x003F1DEE  |0xF5612DEE  |Datos  Nivel 0 ; Accion: Escritura de 4 bytes, como nivel 0|`

## Logica -> Lineal (Segmentacion)
```
LOGICA:   0x198:0x0031300E    (Datos  Nivel 0 ; Accion: Escritura de 4 bytes, como nivel 0)

Selector de Segmento: (0x198 >> 3) = 0x33 --> (gdtIndex=51)

Debo pasar a la dir LINEAL 0x003F1DEE:
* Base?: Puedo calcular la base del descriptor como LINEAL - OFFSET = 0x003F1DEE-0x0031300E = 0x000DEDE0
    --> BASE = 0x000DEDE0
    
* Limite?: Debo hacer una lectura de 4 bytes 
    --> debo considerar las direcciones 0x003F1DEE...0x003F1DF1
    Todas caen dentro de la misma pagina, por lo que puedo darles una sola pagina de 4KiB
    --> LIMITE = 0x00000
    --> G = 1
    
* DPL?: Nivel 0 (segun enunciado)
    --> DPL = 0b00

* Tipo?: Datos/Escritura (segun enunciado)
    --> Tipo = 0b0010
```

## Lineal -> Fisica (Paginacion)
```
LINEAL: 0x003F1DEE

Debo pasar a la dir FISICA: 0xF5612DEE
* Primero debo verificar que los ultimos 12 bits de ambas direccciones sean iguales --> OK!
* Todas caen dentro de la misma pagina?     --> OK!
    --> siginifica que puedo darle una sola pagina de 4KiB

* Ahora calculo el pdIndex, ptIndex y offset: 

                |DIRECTORY ||  TABLE   | |   OFFSET   |
    0x003F1DEE: 0000 0000 0011 1111 0001 1101 1110 1110
                pdIndex = 00 0000 0000; ptIndex = 11 1111 0001; offset = 1101 1110 1110 (binary)
                pdIndex = 000         ; ptIndex = 3F1         ; offset = DEE            (hex)

    0x003F1DEE: pdIndex = 0x000; ptIndex = 0x3F1; offset = 0xDEE

* PDE:
    + Indice:   0x000
    + PT:       PT_3   --> Le asigno la cuarta PT
    + U/S:      0 (Supervisor)
    + R/W:      1 (Write/read)
    + Present:  1
    + Los demas atributos se setean en 0 (El address se setea en la dir correspondiente)
    
* PT_3:
    + Indice:   0x0
    ...
    + Indice:   0x3F1
        + Page-frame addr: (dirFisica>>12)<<12 = 0xF5612
        + U/S:      0 (Supervisor)
        + R/W:      1 (Write/read)
        + Present:  1
        + Los demas atributos se setean en 0
    ...    
    + Indice:   0x3FF
```

# Solucion Final

`OBS: La columnda "dir" se refiere al nro de direccion del enunciado que hace uso de esa entrada`

## GDT
|Indice |(dec)|Base        |Limite   |DPL     |Tipo|G|...|Dir    |
|-------|-----|------------|---------|--------|----|-|---|-------|
|0x0    |0    |0x0         |         |        |    | |   |       |
|...    |     |...         |...      |..      |... |.|   |       |
|0x21   |33   |0x00FF0000  |0x00000  |11      |0000|1|   |`1`    |
|0x22   |34   |0x00D00000  |0x00000  |11      |1110|1|   |`2 y 3`|
|...    |     |...         |...      |..      |... |.|   |       |
|0x33   |51   |0x000DEDE0  |0x00000  |00      |1110|1|   |`4`    |
|...    |     |...         |...      |..      |... |.|   |       |

## Directorio de paginas
|Indice  |(dec)|PT        |U/S|R/W|P|...|Dir|
|--------|-----|----------|---|---|-|---|---|
|0x000   |0    |PT_3      |0  |1  |1|   |`4`|
|···     |···  |···       |   |   | |   |   |
|0x003   |3    |PT_2      |0  |0  |1|   |`3`|
|···     |···  |···       |   |   | |   |   |
|0x005   |5    |PT_1      |0  |0  |1|   |`2`|
|···     |···  |···       |   |   | |   |   |
|0x028   |40   |PT_0      |1  |0  |1|   |`1`|   
|···     |···  |···       |   |   | |   |   |
|0x3FF   |1023 |0x0       |   |   | |   |   |

## Tablas de paginas

### PT_0                             
|Indice  |(dec)|Base      |U/S|R/W|P|
|--------|-----|----------|---|---|-|
|0x000   |0    |0x0       |   |   | |
|···     |···  |···       |   |   | |
|0x334   |820  |0x00DAA   |1  |0  |1|
|···     |···  |···       |   |   | |
|0x3FF   |1023 |0x0       |   |   | |

### PT_1             
|Indice  |(dec)|Base      |U/S|R/W|P|
|--------|-----|----------|---|---|-|
|0x000   |0    |0x0       |   |   | |
|···     |···  |···       |   |   | |
|0x2A3   |675  |0x016A3   |0  |0  |1|
|···     |···  |···       |   |   | |
|0x3FF   |1023 |0x0       |   |   | |

`OBS: La PTE 0x2A3 esta mapeada con Identity mapping`

### PT_2             
|Indice  |(dec)|Base      |U/S|R/W|P|
|--------|-----|----------|---|---|-|
|0x000   |0    |0x0       |   |   | |
|···     |···  |···       |   |   | |
|0x134   |308  |0x00FAA   |0  |0  |1|
|···     |···  |···       |   |   | |
|0x3FF   |1023 |0x0       |   |   | |

### PT_3             
|Indice  |(dec)|Base      |U/S|R/W|P|
|--------|-----|----------|---|---|-|
|0x000   |0    |0x0       |   |   | |
|···     |···  |···       |   |   | |
|0x3F1   |1009 |0xF5612   |0  |1  |1|
|···     |···  |···       |   |   | |
|0x3FF   |1023 |0x0       |   |   | |