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

## Codigos de debug

```
x/Nuf ADDR
x/Nuf &variable
```
- N = Cantidad (bytes)
- u = Unidad b|h|w|g
	- b:byte, h:word, w:dword, g:qword
- f = Formato x|d|u|o|f|a
	- x:hex, d:decimal, u:unsigned decimal, o:octal, f:float,
	- a:direcciones, s:strings, i:instrucciones.

```
print var
```
Printea la variable seleccionada
```
watch
rwatch var
awatch var
```
Hace un breakpoint cuando la variable sea escrita (watch) ;leida (rwatch); leida y modificada (awatch)
