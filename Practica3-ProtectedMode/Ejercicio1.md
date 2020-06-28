# Ejercicio 1
## Segmentacion en modo real
- En modo real, calcular la direccion fisica indicada por 8123:FFEC

La direccion 0x8123 debe ser shifteada 16 bits, y sumada al offset 0xFFEC
    direccion fisica = 0x81230 + 0xFFEC = 0x9121C
    
- ¿Cual es el mecanismo general para calcular cualquier direccion fisica en modo real?
Para calcular las direcciones fisicas en modo real se debe sumar el selector de segmento shifteado 16 bits a izq mas el offset correspondiente

- ¿Que pudo haber motivado utilizar este mecanismo en lugar de usar direcciones lineales directamente?
Esto permitia acceder a mas de los 64 KiB de memoria que se podian direccionar con 16 bits, ya que si tenias una memoria RAM superior a 64KiB no ibas a poder acceder a las direcciones superiores a los 64KiB. Con este mecanismo se podia acceder hasta a 1MiB de la RAM, e incluso un poco mas con la linea A20.
