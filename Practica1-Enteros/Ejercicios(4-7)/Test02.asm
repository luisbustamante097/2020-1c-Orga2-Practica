global _start
section .text
  _start:
    mov rax, $
    add rax,19
    mov [eax], ax
    mov rbx, 0x666
    ;mov [eax], BYTE 2
