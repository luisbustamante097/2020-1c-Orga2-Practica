# GDB Useful Commands

### Setear Output a HEX
```
#(to hex)
set output-radix 16

#(to dec)
set output-radix 10
```

### Formateo de Output

```
gdb> x /Nuf ADDR
gdb> x /Nuf &variable
```
- N = Cantidad (bytes)
- u = Unidad b | h | w | g
	- b: byte 
	- h: word
	- w: dword
	- g: qword
- f = Formato x | d | u | o | f | a
	- x: hex, d: decimal, u: unsigned decimal, o: octal, f: float,
	- a: direcciones, s: strings, i: instrucciones.

### Printea la variable seleccionada
```
print var
p $(reg)
						|x0|x1|x2|...					   ...|xD|xE|xF|
p $xmm0.v16_int8		|10|32|45|67|98|ba|dc|fe|10|32|45|67|98|ba|dc|fe|
	   .v8_int16		| 3210| 6754| ba98| fedc| 3210| 6754| ba98| fedc|
	   .v4_int32		|  76543210 | fedcba98  | 76543210  | fedcba98  |
	   .v2_int64		|    fedcba9876543210   |   fedcba9876543210    |
	   .uint128 		|       0xfedcba9876543210fedcba9876543210      |
	   .v4_float	
	   .v2_double

```
<details>
  <summary>Example</summary>

```
{
    v4_float = {[0x0] = 0xffffffff, [0x1] = 0x0, [0x2] = 0xffffffff, [0x3] = 0x0}, 
    v2_double = {[0x0] = 0x8000000000000000, [0x1] = 0x8000000000000000}, 
    v16_int8 = {[0x0] = 0x10, [0x1] = 0x32, [0x2] = 0x54, [0x3] = 0x76, [0x4] = 0x98, [0x5] = 0xba, [0x6] = 0xdc, [0x7] = 0xfe, [0x8] = 0x10, [0x9] = 0x32, [0xa] = 0x54, [0xb] = 0x76, [0xc] = 0x98, [0xd] = 0xba, [0xe] = 0xdc, [0xf] = 0xfe}, 
    v8_int16 = {[0x0] = 0x3210, [0x1] = 0x7654, [0x2] = 0xba98, [0x3] = 0xfedc, [0x4] = 0x3210, [0x5] = 0x7654, [0x6] = 0xba98, [0x7] = 0xfedc}, 
    v4_int32 = {[0x0] = 0x76543210, [0x1] = 0xfedcba98, [0x2] = 0x76543210, [0x3] = 0xfedcba98}, 
    v2_int64 = {[0x0] = 0xfedcba9876543210, [0x1] = 0xfedcba9876543210}, 
    uint128 = 0xfedcba9876543210fedcba9876543210
}
```
</details>

### Watchpoints
Hace un breakpoint cuando la variable sea escrita (watch) ;leida (rwatch); leida y modificada (awatch)
```
watch var 		(write)
rwatch var		(read)
awatch var		(w/r)
```
Borrar watchpoints
```
info watchpoints
delete (N)
```

### GDB Dashboard
```
# MENU DE AYUDA
help dashboard

# USAR TABLA DE MEMORIA
dashboard memory watch (dir) (lenght)
dashboard memory unwatch (dir)
```
