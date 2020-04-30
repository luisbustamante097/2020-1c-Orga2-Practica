global _start

section .text
    _start:
    ;Escriba  una  secuencia  corta  de  instrucciones
    ;que  tome  el  dato  almacenado  en AX,
    ;ponga  en  1 los  4  bits  menos  significativos,
    ;ponga  en  cero  los  3  bits  mas significativos,
    ;invierta los bits 7, 8 y 9
    ;y almacene el resultado en BX.
	
        mov ax, 0xFF00
        or ax, 0x000F			; xxxx-xxxx-xxxx-1111
        and ax, 0x1FFF			; 000x-xxxx-xxxx-xxxx
        xor ax, 0x0280			; xxxx-xxii-ixxx-xxxx
		mov bx, ax
