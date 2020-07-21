char:   db 0x0

global _isr90
_isr90:
    pushad
    
    ; trato del leer del buffer    
    ;int get_key_from_buffer(char* a)
    mov eax, char
    push eax
    call get_key_from_buffer
    add esp, 4
    
    cmp al, 1
    je .in_ok
        ;no se obtuvo el caracter
        
        ;desalojo la tarea del scheduler con su idx de gdt
        str eax
        shr eax, 3
        push eax
        call remove_from_scheduler
        add esp, 4
        jmp .fin    
    
.in_ok:   
    push byte [char]
    call scan_code_a_ascii
    add esp, 4
.fin:
    popad
    iret
    
global _istKeyboard
_istKeyboard:
    pushad
    call pic_finish1
    
    ;leo del teclado
    in al, 0x60
    
    ;agrega la variable al buffer
    ;void add_key_to_buffer(char a)
    push al
    call add_key_to_buffer
    add esp, 4
    
    ;agrego de vuelta la tarea en espera al scheduler
    ;void add_to_scheduler(gdtindex i)
    push dword [task_wait_key]
    call add_to_scheduler
    add esp, 4
        
    popad
    iret