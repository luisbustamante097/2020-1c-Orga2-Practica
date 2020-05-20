# ORGA II

## Compilar para debug

```sh
gcc -g main.c -o main
```

## Llamar a funciones ASM desde C

1- Ensamblar codigo ASM:

```sh
nasm -f elf64 funcion.asm -o funcion.o
```

2- Compilar y linkear el codigo C:

```sh
gcc -o ejec -g programa.c funcion.o
```

(Si uso funcion ASM desde C que llama a printf)
(si no debuguea bien asm)
```sh
nasm -f elf64 -g -F DWARF fun.asm
gcc -no-pie -o ejec -m64 -g main.c fun.o
```

## Llamar a funciones c desde ASM

1- Ensamblar codigo ASM:

```sh
nasm -f elf64 main.asm -o main.o
```

2- Compilar codigo C en un objeto

```sh
gcc -no-pie -c -m64 funcion.c -o funcion.o
```
3- Usar gcc como linker de ambos archivos objeto

```sh
gcc -no-pie -o ejec -m64 main.o funcion.o
```

## Valgrind
```sh
valgrind --leak-check=full --show-leak-kinds=all -v ./holamundo
```